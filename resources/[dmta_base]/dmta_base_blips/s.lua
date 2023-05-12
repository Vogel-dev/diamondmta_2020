--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local blips = {}

function createBlipAttachedVehicle(id)
	triggerClientEvent(root, 'createBlipAttachedVehicle', resourceRoot, id)
end
--[[
addEventHandler('onResourceStart', resourceRoot, function()
	for i,v in ipairs(getElementsByType('player')) do
		if not blips[v] then
			blips[v] = createBlipAttachedTo(v, 55, 98, 111, 255, 255)
			setBlipVisibleDistance(blips[v], 500)
		end
	end
end)

addEventHandler('onPlayerQuit', root, function()
	if blips[source] and isElement(blips[source]) then
		destroyElement(blips[source])
		blips[source] = false
	end
end)

addEventHandler('onPlayerSpawn', root, function()
	if not blips[source] then
		blips[source] = createBlipAttachedTo(source, 55, 98, 111, 255, 255)
		setBlipVisibleDistance(blips[source], 500)
	end
end)
--]]