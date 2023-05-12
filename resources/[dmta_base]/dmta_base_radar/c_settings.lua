--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

blip_legend_page = 1

playerX, playerY, playerZ = 0, 0, 0
mapOffsetX, mapOffsetY, mapIsMoving = 0, 0, false

last_location = ''
location_tick = getTickCount()
location_back = false
a = 1

last_location2 = ''
location2_tick = getTickCount()
location2_back = false
a2 = 1

mapMoved = false
second_selected_blip = false
second_selected_blip_tick = getTickCount()

dxLibary = exports['dxLibary']

anim_tick = getTickCount()
anim_type = 'join'
endz = false

sw,sh = guiGetScreenSize()
baseX = 1920
scale = 1
minScale = 2
if sw < baseX then
    scale = math.min(minScale, baseX/sw)
end

radarSettings = {
	['mapTexture'] = 'images/map.png',
	['mapTextureSize'] = 3072,
	['mapWaterColor'] = {0, 0, 0},
	['alpha'] = 255,

	['arrow'] = dxLibary:createTexture(':dmta_base_radar/blips/arrow.png', 'dxt5', false, 'clamp'),
	['arrow1'] = dxLibary:createTexture(':dmta_base_radar/images/arrow.png', 'dxt5', false, 'clamp'),
	['radarBackground'] = dxLibary:createTexture(':dmta_base_radar/images/radar.png', 'dxt5', false, 'clamp'),
	['mapBackground'] = dxLibary:createTexture(':dmta_base_radar/images/radar2.png', 'dxt5', false, 'clamp'),
}

function center(y)
	return (sh / 2) - (y / 2)
end

Minimap = {
	['Width'] = 400/scale,
	['Height'] = 250/scale,
	['PosX'] = 25/scale,
	['PosY'] = sh-(270/scale),
	['WaterColor'] = radarSettings['mapWaterColor'],
	['IsVisible'] = false,
	['TextureSize'] = radarSettings['mapTextureSize'],
	['NormalTargetSize'] = 300/scale,
	['BiggerTargetSize'] = 600/scale,
	['MapTarget'] = dxCreateRenderTarget(600/scale, 600/scale, true),
	['RenderTarget'] = dxCreateRenderTarget(300/scale * 3, 300/scale * 3, true),
	['MapTexture'] = dxCreateTexture(radarSettings['mapTexture'], 'dxt5', false, 'clamp'),
	['CurrentZoom'] = 1,
	['MaximumZoom'] = 2,
	['MinimumZoom'] = 1,
	['Size'] = 750,
	['Alpha'] = radarSettings['alpha'],
	['MapUnit'] = radarSettings['mapTextureSize'] / 6000,
}

dxSetTextureEdge(Minimap['MapTexture'], 'border', tocolor(Minimap['WaterColor'][1], Minimap['WaterColor'][2], Minimap['WaterColor'][3]))

Bigmap = {
	['Width'] = 1173/scale,
	['Height'] = 677/scale,
	['PosX'] = 373/scale,
	['PosY'] = center(830/scale),
	['IsVisible'] = false,
	['CurrentZoom'] = 0.75,
	['MinimumZoom'] = 0.75,
	['MaximumZoom'] = 2,
}

function isMouseIn(x, y, w, h)
	if not isCursorShowing() then return end

	local pos = {getCursorPosition()}
	pos[1],pos[2] = (pos[1]*sw),(pos[2]*sh)

	if pos[1] >= x and pos[1] <= (x+w) and pos[2] >= y and pos[2] <= (y+h) then
		return true
	end
	return false
end

function toggleBigmap(state, toggle)
	if Bigmap['IsVisible'] ~= true and state == true and getElementData(localPlayer, 'pokaz:hud') and getElementInterior(localPlayer) == 0 and getElementDimension(localPlayer) == 0 then
		Bigmap['IsVisible'] = true

		addEventHandler('onClientRender', root, Bigmap_Render)
		addEventHandler('onClientClick', root, Bigmap_Clicked)
		addEventHandler('onClientKey', root, Bigmap_Key)
		playSoundFrontEnd(1)

		showCursor(true, false)
		showChat(false)

		setElementData(localPlayer, 'pokaz:hud', false)
		showPlayerHudComponent('radar', false)
		setElementData(localPlayer, 'player:blackwhite', true)

		anim_tick = getTickCount()
		anim_type = 'join'
	elseif Bigmap['IsVisible'] == true and state == false then
		if not toggle then
			Bigmap['IsVisible'] = false
			mapMoved = false
			mapOffsetX, mapOffsetY, mapIsMoving = 0, 0, false

			removeEventHandler('onClientRender', root, Bigmap_Render)
			removeEventHandler('onClientClick', root, Bigmap_Clicked)
			removeEventHandler('onClientKey', root, Bigmap_Key)
			playSoundFrontEnd(2)
		else
			anim_tick = getTickCount()
			anim_type = 'quit'
			showCursor(false)
			setElementData(localPlayer, 'player:blackwhite', false)
			setElementData(localPlayer, 'pokaz:hud', true)
			showPlayerHudComponent('radar', true)
			showChat(true)
		end
	end
end
--[[
function toggleMinimap(state)
	if Minimap['IsVisible'] ~= true and state == true then
		Minimap['IsVisible'] = true
		addEventHandler('onClientRender', root, Minimap_Render)
		addEventHandler('onClientKey', root, Minimap_Key)
	elseif Minimap['IsVisible'] == true and state == false then
		Minimap['IsVisible'] = false
		removeEventHandler('onClientRender', root, Minimap_Render)
		removeEventHandler('onClientKey', root, Minimap_Key)
	end
end--]]

function dxDrawBorder(x, y, w, h, color)
    local size = 3

    dxDrawRectangle(x - size, y, size, h, color)
    dxDrawRectangle(x + w, y, size, h, color)
    dxDrawRectangle(x - size, y - size, w + (size * 2), size, color)
    dxDrawRectangle(x - size, y + h, w + (size * 2), size, color)
end

function doesCollide(x1, y1, w1, h1, x2, y2, w2, h2)
	local horizontal = (x1 < x2) ~= (x1 + w1 < x2) or (x1 > x2) ~= (x1 > x2 + w2)
	local vertical = (y1 < y2) ~= (y1 + h1 < y2) or (y1 > y2) ~= (y1 > y2 + h2)

	return (horizontal and vertical)
end

function getPointFromDistanceRotation(x, y, dist, angle)
	local a = math.rad(90 - angle)
	local dx = math.cos(a) * dist
	local dy = math.sin(a) * dist

	return x + dx, y + dy
end

function getRotation()
	local cameraX, cameraY, _, rotateX, rotateY = getCameraMatrix()
	local camRotation = getVectorRotation(cameraX, cameraY, rotateX, rotateY)

	return camRotation
end

function getVectorRotation(X, Y, X2, Y2)
	local rotation = 6.2831853071796 - math.atan2(X2 - X, Y2 - Y) % 6.2831853071796

	return -rotation
end

function getMapFromWorldPosition(worldX, worldY)
	local centerX, centerY = (Bigmap['PosX'] + (Bigmap['Width'] / 2)), (Bigmap['PosY'] + (Bigmap['Height'] / 2))
	local mapLeftFrame = centerX - ((playerX - worldX) / Bigmap['CurrentZoom'] * Minimap['MapUnit'])
	local mapRightFrame = centerX + ((worldX - playerX) / Bigmap['CurrentZoom'] * Minimap['MapUnit'])
	local mapTopFrame = centerY - ((worldY - playerY) / Bigmap['CurrentZoom'] * Minimap['MapUnit'])
	local mapBottomFrame = centerY + ((playerY - worldY) / Bigmap['CurrentZoom'] * Minimap['MapUnit'])

	centerX = math.max(mapLeftFrame, math.min(mapRightFrame, centerX))
	centerY = math.max(mapTopFrame, math.min(mapBottomFrame, centerY))

	return centerX, centerY
end

function getWorldFromMapPosition(mapX, mapY)
	local worldX = playerX + ((mapX * ((Bigmap['Width'] * Bigmap['CurrentZoom']) * 2)) - (Bigmap['Width'] * Bigmap['CurrentZoom']))
	local worldY = playerY + ((mapY * ((Bigmap['Height'] * Bigmap['CurrentZoom']) * 2)) - (Bigmap['Height'] * Bigmap['CurrentZoom'])) * -1

	return worldX, worldY
end
