--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local lokalizacje = {
{296.47784423828,-37.925994873047,1001.515625},
}

for i,v in ipairs(lokalizacje) do
	marker = createMarker(v[1], v[2], v[3]-.95, "cylinder", 1, 93, 138, 168, 50)
	setElementInterior(marker, 1)
	setElementData(marker, 'marker:icon', 'brak')
end

addEvent("daj:bron2", true)
addEventHandler("daj:bron2", root, function(nazwa)
	local text_log = getPlayerName(source)..' zakupił broń - '..nazwa..''
	exports['dmta_base_duty']:addLogs('lic', text_log, source, 'GUN/BUY')

	exports["dmta_base_connect"]:query("INSERT INTO db_items SET dbid=?, nick=?, nazwa=?", getElementData(source, "user:dbid"), getPlayerName(source), nazwa)
end)
