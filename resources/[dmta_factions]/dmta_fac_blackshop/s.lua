--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local lokalizacje = {
{-1301.8232421875,504.82559204102,11.1953125},
}

for i,v in ipairs(lokalizacje) do
	marker = createMarker(v[1], v[2], v[3]-.95, "cylinder", 1, 174, 12, 0, 50)
	setElementInterior(marker, 0)
	setElementDimension(marker, 0)
	setElementData(marker, 'marker:icon', 'gun')
end

addEvent("daj:bron1", true)
addEventHandler("daj:bron1", root, function(nazwa)
	local text_log = getPlayerName(source)..' zakupił broń - '..nazwa..''
	exports['dmta_base_duty']:addLogs('illegal', text_log, source, 'GUN/BUY')

	exports["dmta_base_connect"]:query("INSERT INTO db_items SET dbid=?, nick=?, nazwa=?", getElementData(source, "user:dbid"), getPlayerName(source), nazwa)
end)
