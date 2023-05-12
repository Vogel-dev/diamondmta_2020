--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local sw,sh = guiGetScreenSize()
local baseX = 1920
local scale = 1
local minScale = 2
if sw < baseX then
    scale = math.min(minScale, baseX/sw)
end

local developer = {
	x,y,z = 0,0,0,
	speed = 0.2,
}

addCommandHandler('posi', function()
    if getElementData(localPlayer, 'rank:duty') > 2 then

	local player = getPedOccupiedVehicle(localPlayer) and getPedOccupiedVehicle(localPlayer) or localPlayer
	if getElementData(player, 'developer_mode') == 1 then
		removeEventHandler('onClientRender', root, render)
		setElementData(player, 'developer_mode', 0)
		setElementFrozen(player, false)
		setElementCollisionsEnabled(player, true)
	else
		addEventHandler('onClientRender', root, render)
		setElementData(player, 'developer_mode', 1)
		setElementFrozen(player, true)
		developer['x'],developer['y'],developer['z'] = getElementPosition(player)
		setElementCollisionsEnabled(player, false)
	end
end
end)

function render()
	local player = getPedOccupiedVehicle(localPlayer) and getPedOccupiedVehicle(localPlayer) or localPlayer

	local x,y,z = getElementPosition(player)
	x,y,z = string.format('%.2f', x),string.format('%.2f', y),string.format('%.2f', z)

    local c_x,c_y,c_z,c2_x,c2_y,c2_z = getCameraMatrix()
    c2_x,c2_y,c2_z = c2_x-c_x,c2_y-c_y,c2_z-c_z
    local m = developer['speed']/math.sqrt(c2_x*c2_x+c2_y*c2_y)

    if getKeyState('lctrl') then
    	developer['speed'] = 10
    elseif getKeyState('lalt') then
    	developer['speed'] = 0.03
    else
    	developer['speed'] =0.21
    end

    c2_x,c2_y = c2_x*m,c2_y*m

    if getKeyState('w') then
    	developer['x'],developer['y'] = developer['x']+c2_x,developer['y']+c2_y
    end
    if getKeyState('s') then
    	developer['x'],developer['y'] = developer['x']-c2_x,developer['y']-c2_y
    end
    if getKeyState('a') then
    	developer['x'],developer['y'] = developer['x']-c2_y,developer['y']+c2_x
    end
    if getKeyState('d') then
    	developer['x'],developer['y'] = developer['x']+c2_y,developer['y']-c2_x
    end
    if getKeyState('space') then
    	developer['z'] = developer['z']+developer['speed']
    end
    if getKeyState('lshift') then
    	developer['z'] = developer['z']-developer['speed']
    end

    setElementPosition(player, developer['x'], developer['y'], developer['z'])
    setElementRotation(player, 0, 0, getElementType(player) == 'player' and getPedCameraRotation(localPlayer) or -getPedCameraRotation(localPlayer))
end
