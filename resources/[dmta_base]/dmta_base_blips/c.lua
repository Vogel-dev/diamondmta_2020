--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local dxLibary = exports['dxLibary']
local blips = {}
local blipTexture = dxLibary:createTexture(':dmta_base_blips/images/target.png', 'dxt5', false, 'clamp')
local w,h = 35, 35

addEvent('createBlipAttachedVehicle', true)

addEventHandler('onClientRender', root, function()
	for i,v in ipairs(getElementsByType('blip')) do
		if getBlipIcon(v) == 41 then
			local x,y,z = getElementPosition(v)
			local sx,sy = getScreenFromWorldPosition(x, y, z)
			local rx,ry,rz = getElementPosition(localPlayer)
			local distance = getDistanceBetweenPoints3D(rx, ry, rz, x, y, z)

			if sx and sy and distance > 20 then
				dxDrawImage(sx-(w/2), sy-40, w, h, blipTexture)
				dxLibary:dxLibary_shadowText2(math.floor(distance)..'m', sx, sy, sx, sy, tocolor(255, 255, 255, 255), 0, 'default', 'center', 'center', false, false, false, false, false)
			end
		end
	end
end)

function createBlipAttachedVehicle(id)
	for i,v in ipairs(getElementsByType('vehicle')) do
		if getElementData(v, 'vehicle:id') and tonumber(getElementData(v, 'vehicle:id')) == tonumber(id) then
			local owner = getElementData(v, 'vehicle:ownerName')
			if not blips[v] and owner and owner == getPlayerName(localPlayer) then
				blips[v] = createBlipAttachedTo(v, 0, 1, 105, 188, 235, 255, 1, 9999)
				setBlipVisibleDistance(blips[v], 500)
			elseif blips[v] and isElement(blips[v]) and owner and owner ~= getPlayerName(localPlayer) then
				destroyElement(blips[v])
				blips[v] = false
			end
			break
		end
	end
end
addEventHandler('createBlipAttachedVehicle', resourceRoot, createBlipAttachedVehicle)

addEventHandler('onClientElementDestroy', root, function()
	if source and isElement(source) and getElementType(source) == 'vehicle' and blips[source] then
		destroyElement(blips[source])
		blips[source] = false
	end
end)