--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

toggleControl('radar', false)

addEventHandler('onClientKey', root, function(key, state)
	if state and key == 'F11' then
		if endz then return end
		toggleBigmap(not Bigmap['IsVisible'], 'ye')
	end
end)

function Bigmap_Key(key, state)
	if state and key == 'mouse_wheel_down' then
		Bigmap['CurrentZoom'] = math.min(Bigmap['CurrentZoom'] + 0.25, Bigmap['MaximumZoom'])
	elseif state and key == 'mouse_wheel_up' then
		Bigmap['CurrentZoom'] = math.max(Bigmap['CurrentZoom'] - 0.25, Bigmap['MinimumZoom'])
	end
end

function Bigmap_Clicked(btn, state, cursorX, cursorY)
	if btn ~= 'state' and state ~= 'down' then return end

	if isMouseIn(Bigmap['PosX'], Bigmap['PosY'], Bigmap['Width'], Bigmap['Height']) then
		mapOffsetX = cursorX * Bigmap['CurrentZoom'] + playerX
		mapOffsetY = cursorY * Bigmap['CurrentZoom'] - playerY
		mapIsMoving = true
		mapMoved = true
	elseif isMouseIn(1461/scale, center(-615/scale), 64/scale, 64/scale) then
		blip_legend_page = math.min(blip_legend_page + 1, #replaceBlips - 3)
		playSoundFrontEnd(20)
	elseif isMouseIn(400/scale, center(-615/scale), 64/scale, 64/scale) then
		blip_legend_page = math.max(blip_legend_page - 1, 1)
		playSoundFrontEnd(20)
	end

	local k = 0
	for i,v in ipairs(replaceBlips) do
		if (blip_legend_page + 3) >= i and blip_legend_page <= i then
			k = k + 1

			local x = 262/scale * (k - 1)
			if isMouseIn(528/scale + x, center(-594/scale), 64/scale, 64/scale) and v[4] then
				local rnd = math.random(1,#v[3])
				if v[4][rnd] and isElement(v[4][rnd]) then
					second_selected_blip = v[4][rnd]
					playerX, playerY = getElementPosition(v[4][rnd])
					mapMoved = true
					second_selected_blip_tick = getTickCount()
				end
			end
		end
	end
end

function Bigmap_Render()
	if getElementDimension(localPlayer) ~= 0 or getElementInterior(localPlayer) ~= 0 then
		toggleBigmap(false)
	end

	if anim_type == 'join' then
		a = interpolateBetween(0, 0, 0, 255, 0, 0, (getTickCount()-anim_tick)/500, 'Linear')

        if a == 255 then
			endz = false
        else
			endz = true
        end
	elseif anim_type == 'quit' then
		a = interpolateBetween(255, 0, 0, 0, 0, 0, (getTickCount()-anim_tick)/250, 'Linear')

		if a == 0 then
			toggleBigmap(false)
			endz = false
		else
			endz = true
		end
	end

	local absoluteX, absoluteY = 0, 0

	if isCursorShowing() then
		local cursorX, cursorY = getCursorPosition()
		local mapX, mapY = getWorldFromMapPosition(cursorX, cursorY)

		absoluteX = cursorX * sw
		absoluteY = cursorY * sh

		if getKeyState('mouse1') and mapIsMoving == true and isMouseIn(Bigmap['PosX'], Bigmap['PosY'], Bigmap['Width'], Bigmap['Height']) then
			playerX = -(absoluteX * Bigmap['CurrentZoom'] - mapOffsetX)
			playerY = absoluteY * Bigmap['CurrentZoom'] - mapOffsetY

			playerX = math.max(-3000, math.min(3000, playerX))
			playerY = math.max(-3000, math.min(3000, playerY))
		else
			if not mapMoved then
				playerX, playerY = getElementPosition(localPlayer)
			end
		end
	end

	local playerRotation = getPedRotation(localPlayer)
	local mapX = (((3000 + playerX) * Minimap['MapUnit']) - (Bigmap['Width'] / 2) * Bigmap['CurrentZoom'])
	local mapY = (((3000 - playerY) * Minimap['MapUnit']) - (Bigmap['Height'] / 2) * Bigmap['CurrentZoom'])
	local mapWidth, mapHeight = Bigmap['Width'] * Bigmap['CurrentZoom'], Bigmap['Height'] * Bigmap['CurrentZoom']

	dxDrawBorder(Bigmap['PosX'], Bigmap['PosY'], Bigmap['Width'], Bigmap['Height'], tocolor(15, 15, 15, a), false)

	dxDrawImageSection(Bigmap['PosX'], Bigmap['PosY'], Bigmap['Width'], Bigmap['Height'], mapX, mapY, mapWidth, mapHeight, Minimap['MapTexture'], 0, 0, 0, tocolor(255, 255, 255, a), false)
	
	dxDrawImage(Bigmap['PosX'], Bigmap['PosY'], Bigmap['Width'], Bigmap['Height'], radarSettings['mapBackground'], 0, 0, 0, tocolor(255, 255, 255, a), false)

	blipsRender(a)

	--[[for _, area in ipairs(getElementsByType('radararea')) do
		local areaX, areaY = getElementPosition(area)
		local areaWidth, areaHeight = getRadarAreaSize(area)
		local areaR, areaG, areaB, areaA = getRadarAreaColor(area)

		if (isRadarAreaFlashing(area)) then
			areaA = areaA * math.abs(getTickCount() % 1000 - 500) / 500
		end

		local areaX, areaY = getMapFromWorldPosition(areaX, areaY + areaHeight)
		local areaWidth, areaHeight = areaWidth / Bigmap['CurrentZoom'] * Minimap['MapUnit'], areaHeight / Bigmap['CurrentZoom'] * Minimap['MapUnit']

		if (areaX < Bigmap['PosX']) then
			areaWidth = areaWidth - math.abs((Bigmap['PosX']) - (areaX))
			areaX = areaX + math.abs((Bigmap['PosX']) - (areaX))
		end

		if (areaX + areaWidth > Bigmap['PosX'] + Bigmap['Width']) then
			areaWidth = areaWidth - math.abs((Bigmap['PosX'] + Bigmap['Width']) - (areaX + areaWidth))
		end

		if (areaX > Bigmap['PosX'] + Bigmap['Width']) then
			areaWidth = areaWidth + math.abs((Bigmap['PosX'] + Bigmap['Width']) - (areaX))
			areaX = areaX - math.abs((Bigmap['PosX'] + Bigmap['Width']) - (areaX))
		end

		if (areaX + areaWidth < Bigmap['PosX']) then
			areaWidth = areaWidth + math.abs((Bigmap['PosX']) - (areaX + areaWidth))
			areaX = areaX - math.abs((Bigmap['PosX']) - (areaX + areaWidth))
		end

		if (areaY < Bigmap['PosY']) then
			areaHeight = areaHeight - math.abs((Bigmap['PosY']) - (areaY))
			areaY = areaY + math.abs((Bigmap['PosY']) - (areaY))
		end

		if (areaY + areaHeight > Bigmap['PosY'] + Bigmap['Height']) then
			areaHeight = areaHeight - math.abs((Bigmap['PosY'] + Bigmap['Height']) - (areaY + areaHeight))
		end

		if (areaY + areaHeight < Bigmap['PosY']) then
			areaHeight = areaHeight + math.abs((Bigmap['PosY']) - (areaY + areaHeight))
			areaY = areaY - math.abs((Bigmap['PosY']) - (areaY + areaHeight))
		end

		if (areaY > Bigmap['PosY'] + Bigmap['Height']) then
			areaHeight = areaHeight + math.abs((Bigmap['PosY'] + Bigmap['Height']) - (areaY))
			areaY = areaY - math.abs((Bigmap['PosY'] + Bigmap['Height']) - (areaY))
		end

		dxDrawRectangle(areaX, areaY, areaWidth, areaHeight, tocolor(areaR, areaG, areaB, areaA), false)
	end]]

	local size_30 = 30/scale
	local size_18 = 18/scale

	for _, blip in ipairs(getElementsByType('blip')) do
		local blipX, blipY, blipZ = getElementPosition(blip)
		local blipDistance = getDistanceBetweenPoints2D(blipX, blipY, playerX, playerY)

		if (localPlayer ~= getElementAttachedTo(blip)) then
			local blipSettings = {
				['color'] = getBlipIcon(blip) == 0 and {getBlipColor(blip)} or {255, 255, 255, 255},
				['icon'] = getBlipIcon(blip),
				['size'] = getBlipIcon(blip) == 0 and (30/scale / 2) * getBlipSize(blip) or 30/scale
			}

			local centerX, centerY = (Bigmap['PosX'] + (Bigmap['Width'] / 2)), (Bigmap['PosY'] + (Bigmap['Height'] / 2))
			local leftFrame = (centerX - Bigmap['Width'] / 2) + (size_30 / 2)
			local rightFrame = (centerX + Bigmap['Width'] / 2) - (size_30 / 2)
			local topFrame = (centerY - Bigmap['Height'] / 2) + (size_30 / 2)
			local bottomFrame = (centerY + Bigmap['Height'] / 2) - (size_30 / 2)
			local blipX, blipY = getMapFromWorldPosition(blipX, blipY)

			centerX = math.max(leftFrame, math.min(rightFrame, blipX))
			centerY = math.max(topFrame, math.min(bottomFrame, blipY))

			if second_selected_blip and second_selected_blip == blip then
				local r,g,b = interpolateBetween(105, 188, 235, 55, 98, 125, (getTickCount() - second_selected_blip_tick) / 1500, 'SineCurve')
				blipSettings['color'] = {r, g, b}

				if (getTickCount() - second_selected_blip_tick) > 300000 then
					second_selected_blip = false
				end
			end

			local zoom = (Bigmap['CurrentZoom'] + 0.25) * 1.05
			if blipDistance <= (1000 * zoom) then
				local currentBlip = findBlipTexture(blipSettings['icon'])
				dxDrawImage(centerX - (blipSettings['size'] / 2), centerY - (blipSettings['size'] / 2), blipSettings['size'], blipSettings['size'], currentBlip, 0, 0, 0, tocolor(blipSettings['color'][1], blipSettings['color'][2], blipSettings['color'][3], a))
			end
		end
	end

	local localX, localY, localZ = getElementPosition(localPlayer)
	local blipX, blipY = getMapFromWorldPosition(localX, localY)

	if (blipX >= Bigmap['PosX'] and blipX <= Bigmap['PosX'] + Bigmap['Width']) then
		if (blipY >= Bigmap['PosY'] and blipY <= Bigmap['PosY'] + Bigmap['Height']) then
			dxDrawImage(blipX - (size_18 / 2), blipY - (size_18 / 2), size_18, size_18, radarSettings['arrow'], 360 - playerRotation, 0, 0, tocolor(255, 255, 255, a), false)
		end
	end
end

function Minimap_Key(key, state)
	if state and key == 'z' and not getElementData(localPlayer, 'user:writing') and not isCursorShowing() then
		Minimap['CurrentZoom'] = math.min(Minimap['CurrentZoom'] + 0.25, Minimap['MaximumZoom'])
	elseif state and key == 'x' and not getElementData(localPlayer, 'user:writing') and not isCursorShowing() then
		Minimap['CurrentZoom'] = math.max(Minimap['CurrentZoom'] - 0.25, Minimap['MinimumZoom'])
	end
end

function get()
    local settings = getElementData(localPlayer, 'settings') or {}
    local showed = #settings < 1 and true or false
    for i,v in ipairs(settings) do
        if v['name'] == 'Pokaż HUD' and v['state'] == 1 then
            showed = true
            break
        end
    end
    return showed
end

function Minimap_Render()
	if getElementDimension(localPlayer) ~= 0 or getElementInterior(localPlayer) ~= 0 or not get() then return end

	playerX, playerY = getElementPosition(localPlayer)

	local playerRotation = getPedRotation(localPlayer)
	local playerMapX, playerMapY = (3000 + playerX) / 6000 * Minimap['TextureSize'], (3000 - playerY) / 6000 * Minimap['TextureSize']
	local streamDistance, pRotation = Minimap['Size'], getRotation()
	local mapRadius = streamDistance / 6000 * Minimap['TextureSize'] * Minimap['CurrentZoom']
	local mapX, mapY, mapWidth, mapHeight = playerMapX - mapRadius, playerMapY - mapRadius, mapRadius * 2, mapRadius * 2

	dxSetRenderTarget(Minimap['MapTarget'], true)

	dxDrawRectangle(0, 0, Minimap['BiggerTargetSize'], Minimap['BiggerTargetSize'], tocolor(Minimap['WaterColor'][1], Minimap['WaterColor'][2], Minimap['WaterColor'][3], Minimap['Alpha']), false)
	dxDrawImageSection(0, 0, Minimap['BiggerTargetSize'], Minimap['BiggerTargetSize'], mapX, mapY, mapWidth, mapHeight, Minimap['MapTexture'], 0, 0, 0, tocolor(255, 255, 255, Minimap['Alpha']), false)

	dxSetRenderTarget()

	--[[for _, area in ipairs(getElementsByType('radararea')) do
		local areaX, areaY = getElementPosition(area)
		local areaWidth, areaHeight = getRadarAreaSize(area)
		local areaMapX, areaMapY, areaMapWidth, areaMapHeight = (3000 + areaX) / 6000 * Minimap['TextureSize'], (3000 - areaY) / 6000 * Minimap['TextureSize'], areaWidth / 6000 * Minimap['TextureSize'], -(areaHeight / 6000 * Minimap['TextureSize'])

		if (doesCollide(playerMapX - mapRadius, playerMapY - mapRadius, mapRadius * 2, mapRadius * 2, areaMapX, areaMapY, areaMapWidth, areaMapHeight)) then
			local areaR, areaG, areaB, areaA = getRadarAreaColor(area)

			if (isRadarAreaFlashing(area)) then
				areaA = areaA * math.abs(getTickCount() % 1000 - 500) / 500
			end

			local mapRatio = Minimap['BiggerTargetSize'] / (mapRadius * 2)
			local areaMapX, areaMapY, areaMapWidth, areaMapHeight = (areaMapX - (playerMapX - mapRadius)) * mapRatio, (areaMapY - (playerMapY - mapRadius)) * mapRatio, areaMapWidth * mapRatio, areaMapHeight * mapRatio

			dxDrawRectangle(areaMapX, areaMapY, areaMapWidth, areaMapHeight, tocolor(areaR, areaG, areaB, areaA), false)
		end
	end]]

	dxSetRenderTarget(Minimap['RenderTarget'], true)

	dxDrawImage(Minimap['NormalTargetSize'] / 2, Minimap['NormalTargetSize'] / 2, Minimap['BiggerTargetSize'], Minimap['BiggerTargetSize'], Minimap['MapTarget'], math.deg(-pRotation), 0, 0, tocolor(255, 255, 255, 255), false)

	for _, blip in ipairs(getElementsByType('blip')) do
		local blipX, blipY, blipZ = getElementPosition(blip)

		if (localPlayer ~= getElementAttachedTo(blip) and getElementInterior(localPlayer) == getElementInterior(blip) and getElementDimension(localPlayer) == getElementDimension(blip)) then
			local blipDistance = getDistanceBetweenPoints2D(blipX, blipY, playerX, playerY)
			local blipRotation = math.deg(-getVectorRotation(playerX, playerY, blipX, blipY) - (-pRotation)) - 180
			local blipRadius = math.min((blipDistance / (streamDistance * Minimap['CurrentZoom'])) * Minimap['NormalTargetSize'], Minimap['NormalTargetSize'])
			local distanceX, distanceY = getPointFromDistanceRotation(0, 0, blipRadius, blipRotation)

			local blipSettings = {
				['color'] = getBlipIcon(blip) == 0 and {getBlipColor(blip)} or {255, 255, 255, 255},
				['icon'] = getBlipIcon(blip),
				['size'] = getBlipIcon(blip) == 0 and (30/scale / 2) * getBlipSize(blip) or 30/scale
			}

			if second_selected_blip and second_selected_blip == blip then
				local r,g,b = interpolateBetween(105, 188, 235, 55, 98, 125, (getTickCount() - second_selected_blip_tick) / 1500, 'SineCurve')
				blipSettings['color'] = {r, g, b}

				if (getTickCount() - second_selected_blip_tick) > 300000 then
					second_selected_blip = false
				end
			end

			local blipX, blipY = Minimap['NormalTargetSize'] * 1.5 + (distanceX - ((blipSettings['size']) / 2)), Minimap['NormalTargetSize'] * 1.5 + (distanceY - ((blipSettings['size']) / 2))
			local calculatedX, calculatedY = ((Minimap['PosX'] + (Minimap['Width'] / 2)) - ((blipSettings['size']) / 2)) + (blipX - (Minimap['NormalTargetSize'] * 1.5) + ((blipSettings['size']) / 2)), (((Minimap['PosY'] + (Minimap['Height'] / 2)) - ((30/scale) / 2)) + (blipY - (Minimap['NormalTargetSize'] * 1.5) + ((30/scale) / 2)))

			local currentBlip = findBlipTexture(blipSettings['icon'])

			if blipDistance <= (getBlipVisibleDistance(blip) or 0) or second_selected_blip and second_selected_blip == blip then
				blipX = math.max(blipX + (Minimap.PosX - calculatedX), math.min(blipX + (Minimap.PosX + Minimap.Width - blipSettings['size'] - calculatedX), blipX))
				blipY = math.max(blipY + (Minimap.PosY - calculatedY), math.min(blipY + (Minimap.PosY + Minimap.Height - blipSettings['size']- calculatedY), blipY))
			end

			dxDrawImage(blipX, blipY, blipSettings['size'], blipSettings['size'], currentBlip, 0, 0, 0, tocolor(blipSettings['color'][1], blipSettings['color'][2], blipSettings['color'][3], blipSettings['color'][4]), false)
		end
	end

	dxSetRenderTarget()

	dxDrawImageSection(Minimap['PosX'], Minimap['PosY'], Minimap['Width'], Minimap['Height'], Minimap['NormalTargetSize'] / 2 + (Minimap['BiggerTargetSize'] / 2) - (Minimap['Width'] / 2), Minimap['NormalTargetSize'] / 2 + (Minimap['BiggerTargetSize'] / 2) - (Minimap['Height'] / 2), Minimap['Width'], Minimap['Height'], Minimap['RenderTarget'], 0, -90, 0, tocolor(255, 255, 255, 255))
	dxDrawImage((Minimap['PosX'] + (Minimap['Width'] / 2)) - ((18/scale)/2), (Minimap['PosY'] + (Minimap['Height'] / 2)) - ((18/scale)/2), 18/scale, 18/scale, radarSettings['arrow'], math.deg(-pRotation) - playerRotation)

	getZone()

	dxDrawImage(Minimap['PosX'], Minimap['PosY'], Minimap['Width'], Minimap['Height'], radarSettings['radarBackground'])
end
--[[
addEventHandler('onClientElementDataChange', root, function(data)
	if data ~= 'pokaz:hud' and source ~= localPlayer then return end
	toggleMinimap(getElementData(localPlayer, 'pokaz:hud'))
end)

toggleMinimap(getElementData(localPlayer, 'pokaz:hud'))--]]
