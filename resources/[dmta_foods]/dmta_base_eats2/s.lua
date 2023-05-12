--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local lokalizacje = {
	{1416.7344970703,-1629.927734375,13.546875},
	{1406.3616943359,-1606.4444580078,13.546875},
	{1405.0889892578,-1623.2711181641,13.546875},
	{1402.0390625,-1623.1617431641,13.546875},
	{1390.3312988281,-1625.5062255859,13.546875},
	{1375.2430419922,-1600.4127197266,13.546875},
}

for i,v in ipairs(lokalizacje) do
	marker = createMarker(v[1], v[2], v[3]-.95, "cylinder", 1.3, 93, 137, 186, 50)
	setElementData(marker, "marker:icon", 'food')
end

addEvent("daj:fastfoody2", true)
addEventHandler("daj:fastfoody2", root, function(nazwa)
	exports["dmta_base_connect"]:query("INSERT INTO db_items SET dbid=?, nick=?, nazwa=?", getElementData(source, "user:dbid"), getPlayerName(source), nazwa)
end)

addEvent("zabierz:hajs-food2", true)
addEventHandler("zabierz:hajs-food2", root, function(ilosc)
	takePlayerMoney(source, ilosc)
end)
