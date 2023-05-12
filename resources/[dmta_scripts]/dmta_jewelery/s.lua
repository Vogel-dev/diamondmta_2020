--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local lokalizacje = {
{2474.9899902344,-1618.5672607422,18089.1953125},
}

for i,v in ipairs(lokalizacje) do
	marker = createMarker(v[1], v[2], v[3]-.95, "cylinder", 1, 105, 188, 235, 50)
	setElementInterior(marker, 1)
	setElementDimension(marker, 0)
	setElementData(marker, 'marker:icon', 'brak')
end

addEvent("daj:zegarek", true)
addEventHandler("daj:zegarek", root, function(nazwa)
	local text_log = getPlayerName(source)..' zakupił zegarek - '..nazwa..''
	exports['dmta_base_duty']:addLogs('illegal', text_log, source, 'WATCH/BUY')

	exports["dmta_base_connect"]:query("INSERT INTO db_items SET dbid=?, nick=?, nazwa=?", getElementData(source, "user:dbid"), getPlayerName(source), nazwa)
end)
