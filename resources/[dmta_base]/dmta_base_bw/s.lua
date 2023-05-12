--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

addEvent('bw:koniec', true)
addEventHandler('bw:koniec', resourceRoot, function()
	local x,y,z = getElementPosition(client)
	local dim, int, skin = getElementDimension(client), getElementInterior(client), getElementModel(client)
	
	spawnPlayer(client, x, y, z, 0, skin, int, dim)
	setElementHealth(client, 5)
end)
