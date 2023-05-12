--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local lokalizacje = {
{1396.9621582031,-1623.0202636719,13.546875},
{1415.3684082031,-1617.56640625,13.539485931396},
{1415.3688964844,-1614.5979003906,13.539485931396},
{1415.8504638672,-1608.8666992188,13.546875},
{1390.3050537109,-1610.5260009766,13.546875},
{1380.5469970703,-1612.9812011719,13.546875},
{1706.1486816406,-1798.1573486328,13.519854545593},
}

for i,v in ipairs(lokalizacje) do
	marker = createMarker(v[1], v[2], v[3]-.95, "cylinder", 1.3, 93, 137, 186, 50)
	setElementData(marker, "marker:icon", 'food')
end

addEvent("daj:fastfoody", true)
addEventHandler("daj:fastfoody", root, function(nazwa)
	exports["dmta_base_connect"]:query("INSERT INTO db_items SET dbid=?, nick=?, nazwa=?", getElementData(source, "user:dbid"), getPlayerName(source), nazwa)
end)

addEvent("zabierz:hajs-food1", true)
addEventHandler("zabierz:hajs-food1", root, function(ilosc)
	takePlayerMoney(source, ilosc)
end)

addEvent("dodaj:hajs", true)
addEventHandler("dodaj:hajs", root, function(ilosc)
	givePlayerMoney(source, ilosc)
end)
