--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local lokalizacje = {
	{2495.484375,-1686.4556884766,21912.048828125},
	{2490.9858398438,-1686.5501708984,21912.048828125},
	{2485.5087890625,-1686.8607177734,21912.048828125},
}

for i,v in ipairs(lokalizacje) do
	marker = createMarker(v[1], v[2], v[3]-.95, "cylinder", 1, 105, 188, 235, 50)
	setElementInterior(marker, 1)
	setElementDimension(marker, 0)
	setElementData(marker, 'marker:icon', 'brak')
end

addEvent("daj:telefon", true)
addEventHandler("daj:telefon", root, function(nazwa)
	local text_log = getPlayerName(source)..' zakupił telefon - '..nazwa..''
	exports['dmta_base_duty']:addLogs('illegal', text_log, source, 'WATCH/BUY')

	exports["dmta_base_connect"]:query("INSERT INTO db_items SET dbid=?, nick=?, nazwa=?", getElementData(source, "user:dbid"), getPlayerName(source), nazwa)
end)
