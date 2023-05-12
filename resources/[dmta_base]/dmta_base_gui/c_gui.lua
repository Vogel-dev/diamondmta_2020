--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local sw, sh = guiGetScreenSize()
local scale = Vector2(sw < 1920 and math.min(2, 1920 / sw) or 1, sh < 1080 and math.min(2, 1080 / sh) or 1)

local dxLibary = exports.dxLibary

local tick = getTickCount()
local dots = ''

local icons = {
	--['premium'] = dxLibary:createTexture(':dmta_base_gui/images/premium.png'),
	--['afk'] = dxLibary:createTexture(':dmta_base_gui/images/afk.png'),
	--['writing'] = dxLibary:createTexture(':dmta_base_gui/images/writing.png'),
	['mute'] = dxLibary:createTexture(':dmta_base_gui/images/mute.png'),
}

function insertItems(player)
	local items = {}

	--if getElementData(player, 'user:premium') then
		--table.insert(items, 'premium')
	--end

	--if getElementData(player, 'user:afk') or getElementData(player, '_user:afk') then
		--table.insert(items, 'afk')
	--end

	--if getElementData(player, 'user:writing') then
		--table.insert(items, 'writing')
	--end

	if getElementData(player, 'user:mute') then
		table.insert(items, 'mute')
	end

	return items
end

local stream = {}

addCommandHandler('clearchat', function()
	for i = 1,125 do
		outputChatBox(' ')
	end
end)

addEventHandler('onClientRender', root, function()
	--setTime(18, 0)

	if not getElementData(localPlayer, 'user:logged') then return end

	--dynamiczne daty

	local data_money = getElementData(localPlayer, 'user:money') or 0
	if getElementData(localPlayer, 'user:logged') and (data_money ~= getPlayerMoney(localPlayer)) then
		setElementData(localPlayer, 'user:money', getPlayerMoney(localPlayer))
	end

	--

	if not isPlayerHudComponentVisible('crosshair') then
		setPlayerHudComponentVisible('crosshair', true)
	end

	--anty afk
	getAFK()
	--anty dm
	getDM()
	--foods and drinks
	getFood()
	--nametags

	if getElementData(localPlayer, 'pokaz:hud') then
		--nametags
		for i,v in ipairs(getElementsByType('player', root, true)) do
			local x,y,z = getPedBonePosition(v, 5)
			local sx,sy = getScreenFromWorldPosition(x, y, z + 0.35)
			local _sy = sy
			local _sx = sx
			local rx,ry,rz = getCameraMatrix()
			local distance = getDistanceBetweenPoints3D(rx, ry, rz, x, y, z)

			if (x ~= 0 or y ~= 0 or x ~= 0) and sx and sy and distance <= 15 and v ~= root and getElementAlpha(v) > 0 and isLineOfSightClear(rx, ry, rz, x, y, z, false, false, false) and getElementDimension(v) == getElementDimension(localPlayer) and getElementInterior(v) == getElementInterior(localPlayer) and not getElementData(localPlayer, 'user:nametagsDisable') then
				local id = getElementData(v, 'user:id') or 0
				local type = getElementData(v, 'user:type')
				local mess = getElementData(v, 'last:mess')
				local writing = getElementData(v, 'user:writing')
				local afk = getElementData(v, 'user:afk')
				local roleplay = getElementData(v, 'user:roleplay')
				local org = getElementData(v, 'user:oname')

				local hex = '#8d8d8d'
				if getElementData(v, 'rank:duty') and getElementData(v, 'rank:duty') == 1 then
					hex = '#006400'
				elseif getElementData(v, 'rank:duty') and getElementData(v, 'rank:duty') == 2 then
					hex = '#f28600'
				elseif getElementData(v, 'rank:duty') and getElementData(v, 'rank:duty') == 3 then
					hex = '#ff0000'
				elseif getElementData(v, 'rank:duty') and getElementData(v, 'rank:duty') == 4 then
					hex = '#960000'
				elseif getElementData(v, 'user:premium') then
					hex = '#69bceb'
				end

				local hex2 = '#c9c8c8'
				if getElementData(v, 'user:premium') then
					hex2 = '#69bceb'
				end

				if type then
					sy = sy - 15

					dxLibary:dxLibary_text(type, sx + 1, sy + 1 - 38, sx + 1, sy + 1, tocolor(0, 0, 0, 222), 1, 'default', 'center', 'center', false, false, false, true)
					dxLibary:dxLibary_text(hex..type, sx, sy - 38, sx, sy, tocolor(255, 255, 255, 222), 1, 'default', 'center', 'center', false, false, false, true)
				end

				if writing then
					--sy = sy - 15

					dxLibary:dxLibary_text('Mówi...', sx + 1, sy + 1 + 72, sx + 1, sy + 1, tocolor(0, 0, 0, 222), 1, 'default', 'center', 'center', false, false, false, true)
					dxLibary:dxLibary_text('Mówi...', sx, sy + 72, sx, sy, tocolor(150, 150, 150, 222), 1, 'default', 'center', 'center', false, false, false, true)
				end
				
				if afk then
					--sy = sy - 15

					dxLibary:dxLibary_text('AFK', sx + 1, sy + 1 - 66, sx + 1, sy + 1, tocolor(0, 0, 0, 222), 1, 'default', 'center', 'center', false, false, false, true)
					dxLibary:dxLibary_text('AFK', sx, sy - 66, sx, sy, tocolor(80, 114, 167, 222), 1, 'default', 'center', 'center', false, false, false, true)
				end

				if org then
					if getKeyState( "lalt" ) == true or getKeyState( "ralt" ) == true then
					--sy = sy - 15

					dxLibary:dxLibary_text(org, sx + 1, sy + 1 - 111, sx + 1, sy + 1, tocolor(0, 0, 0, 222), 1, 'default', 'center', 'center', false, false, false, true)
					dxLibary:dxLibary_text(org, sx, sy - 111, sx, sy, tocolor(134, 1, 17, 222), 1, 'default', 'center', 'center', false, false, false, true)
				end
			end
				
				if roleplay == 1 then
					--sy = sy - 15

					dxLibary:dxLibary_text('RolePlay', sx + 1, sy + 1 + 36, sx + 1, sy + 1, tocolor(0, 0, 0, 222), 1, 'default', 'center', 'center', false, false, false, true)
					dxLibary:dxLibary_text('RolePlay', sx, sy + 36, sx, sy, tocolor(124, 185, 232, 222), 1, 'default', 'center', 'center', false, false, false, true)
				end

					if getElementData(v, 'kominiarka') == true then
						dxLibary:dxLibary_text('['..id..'] #0d0d0dZamaskowana osoba #'..string.format('%02d', string.sub(getElementData(v, 'user:dbid'), 1, 2))..''..string.sub(getPlayerSerial(v), 1, 3)..'', sx+1, sy+1, sx+1, sy+1, tocolor(0, 0, 0, 222), 2, 'default', 'center', 'center', false, false, false, true)
						dxLibary:dxLibary_text(''..hex2..'['..hex..''..id..''..hex2..'] #565656Zamaskowana osoba #'..string.format('%02d', string.sub(getElementData(v, 'user:dbid'), 1, 2))..''..string.sub(getPlayerSerial(v), 1, 3)..'', sx, sy, sx, sy, tocolor(255, 255, 255, 222), 2, 'default', 'center', 'center', false, false, false, true)						
					else
						dxLibary:dxLibary_text('['..id..'] '..getPlayerName(v)..'', sx+1, sy+1, sx+1, sy+1, tocolor(0, 0, 0, 222), 2, 'default', 'center', 'center', false, false, false, true)
						dxLibary:dxLibary_text(''..hex2..'['..hex..''..id..''..hex2..']#c9c8c8 '..getPlayerName(v)..'', sx, sy, sx, sy, tocolor(255, 255, 255, 222), 2, 'default', 'center', 'center', false, false, false, true)
					end

				local items = insertItems(v)
				local pos = {_sx - 16/scale.x, sy - 78/scale.y, 32/scale.x, 32/scale.y}
				if #items == 1 then
					dxDrawImage(pos[1], pos[2], pos[3], pos[4], icons[items[1]])

					_sy = sy - 95
				elseif #items == 2 then
					dxDrawImage(pos[1] + 18/scale.x, pos[2], pos[3], pos[4], icons[items[1]])
					dxDrawImage(pos[1] - 18/scale.x, pos[2], pos[3], pos[4], icons[items[2]])

					_sy = sy - 95
				elseif #items == 3 then
					dxDrawImage(pos[1] - 35/scale.x, pos[2], pos[3], pos[4], icons[items[1]])
					dxDrawImage(pos[1], pos[2], pos[3], pos[4], icons[items[2]])
					dxDrawImage(pos[1] + 35/scale.x, pos[2], pos[3], pos[4], icons[items[3]])

					_sy = sy - 95
				elseif #items == 4 then
					dxDrawImage(pos[1] + 18/scale.x, pos[2], pos[3], pos[4], icons[items[1]])
					dxDrawImage(pos[1] - 18/scale.x, pos[2], pos[3], pos[4], icons[items[2]])
					dxDrawImage(pos[1] + 55/scale.x, pos[2], pos[3], pos[4], icons[items[3]])
					dxDrawImage(pos[1] - 55/scale.x, pos[2], pos[3], pos[4], icons[items[4]])
				else
					_sy = sy - 10
				end

				if mess then
					dxLibary:dxLibary_text(mess[1], sx + 1.5 + 1, _sy + 1 - 62 + 1, sx + 1, sy + 1, tocolor(0, 0, 0, 255), 1, 'default', 'center', 'center', false, false, false, true)
					dxLibary:dxLibary_text('#8d8d8d'..mess[1], sx + 1.5, _sy + 1 - 62, sx, sy, tocolor(255, 255, 255, 255), 1, 'default', 'center', 'center', false, false, false, true)
				end
			end
		end
		--ped nametags
		for i,v in ipairs(getElementsByType('ped', root, true)) do
			local x,y,z = getPedBonePosition(v, 5)
			local sx,sy = getScreenFromWorldPosition(x, y, z+0.4)
			local txt = getElementData(v, 'text') or ''
			local rx,ry,rz = getCameraMatrix()
			local distance = getDistanceBetweenPoints3D(rx, ry, rz, x, y, z)
			if (x ~= 0 or y ~= 0 or x ~= 0) and sx and sy and distance <= 15 and isLineOfSightClear(rx, ry, rz, x, y, z, false, false, false) and getElementDimension(v) == getElementDimension(localPlayer) and getElementInterior(v) == getElementInterior(localPlayer) then
				local type = getElementData(v, 'user:type') or ''
				local hex = getElementData(v, 'user:hex') or '#8d8d8d'

				dxLibary:dxLibary_text(txt, sx+1, sy+1, sx+1, sy+1, tocolor(0, 0, 0, 222), 2, 'default', 'center', 'center', false, false, false, true)
				dxLibary:dxLibary_text('#8d8d8d'..txt, sx, sy, sx, sy, tocolor(255, 255, 255, 222), 2, 'default', 'center', 'center', false, false, false, true)

				dxLibary:dxLibary_text(type, sx + 1, sy + 1 - 35, sx + 1, sy + 1, tocolor(0, 0, 0, 222), 1, 'default', 'center', 'center', false, false, false, true)
				dxLibary:dxLibary_text(hex..type, sx, sy - 35, sx, sy, tocolor(255, 255, 255, 222), 1, 'default', 'center', 'center', false, false, false, true)
			end
		end
		for _,v in ipairs(getElementsByType("vehicle")) do
			local x1x, y1x, z1x = getElementPosition(v)
			local x2x, y2x, z2x = getElementPosition(localPlayer)
			local dist = getDistanceBetweenPoints3D(x1x,y1x,z1x, x2x,y2x,z2x)
			if dist < 7 then
				local sx,sy = getScreenFromWorldPosition(x1x, y1x, z1x)
				if sx and sy then
				  local text = getElementData(v, "nametag") or ""
				  dxLibary:dxLibary_text(text, sx+1, sy+1, sx+1, sy+1, tocolor(0, 0, 0, 255), 1, 'default', "center", "center")
				  dxLibary:dxLibary_text(text, sx, sy, sx, sy, tocolor(150, 150, 150, 255), 1, 'default', "center", "center")
					 end
			  end
		  end
		--3d text
		for i,v in ipairs(getElementsByType('text', root, true)) do
			local x,y,z = getElementPosition(v)
			local txt = getElementData(v, 'text') or ''
			local sx,sy = getScreenFromWorldPosition(x, y, z)
			local rx,ry,rz = getCameraMatrix()
			local distance = getDistanceBetweenPoints3D(rx, ry, rz, x, y, z)
			if (x ~= 0 or y ~= 0 or x ~= 0) and sx and sy and distance <= 15 and isLineOfSightClear(rx, ry, rz, x, y, z, false, false, false) and getElementDimension(v) == getElementDimension(localPlayer) and getElementInterior(v) == getElementInterior(localPlayer) then
				dxLibary:dxLibary_text(txt, sx+1, sy+1, sx+1, sy+1, tocolor(0, 0, 0, 222), 2, 'default', 'center', 'center', false, false, false, true)
				dxLibary:dxLibary_text(txt, sx, sy, sx, sy, tocolor(255, 255, 255, 222), 2, 'default', 'center', 'center', false, false, false, true)
			end
		end
		--vehicle streamer
		--uwaga: streamer dziala na razie tylko na pojazdy zamrozone - czyli nie ma jeszcze synchronizacji :)
		--[[local pPos = {getElementPosition(localPlayer)}
		for i,v in ipairs(getElementsByType('vehicle')) do
			local vPos = {getElementPosition(v)}
			local vRot = {getElementRotation(v)}
			local distance = getDistanceBetweenPoints3D(pPos[1], pPos[2], pPos[3], vPos[1], vPos[2], vPos[3])
			if distance > 10 and getElementData(v, 'stream') and not stream[v] then
				local veh = createElement('streamVehicle')
				setElementData(veh, 'veh', v)
				setElementData(veh, 'rot', vRot)
				setElementData(veh, 'frozen', isElementFrozen(v))
				setElementPosition(veh, unpack(vPos))
				setElementFrozen(v, true)
				setElementPosition(v, 0, 0, -15000)
				stream[v] = veh
			end
		end

		for i,v in ipairs(getElementsByType('streamVehicle')) do
			local pos = {getElementPosition(v)}
			local distance = getDistanceBetweenPoints3D(pPos[1], pPos[2], pos[3], pos[1], pos[2], pos[3])
			if distance < 10 then
				local veh = getElementData(v, 'veh')
				if veh and isElement(veh) then
					local rot = getElementData(v, 'rot') or {0,0,0}
					setElementData(veh, 'streaming', false)
					setElementPosition(veh, unpack(pos))
					setElementRotation(veh, unpack(rot))

					local frozen = getElementData(v, 'frozen')
					setTimer(function()
						setElementFrozen(veh, frozen)
					end, 500, 1)

					stream[veh] = false
				end
				destroyElement(v)
			end
		end]]
 	end

	--pisze
	
	if isChatBoxInputActive() and not getElementData(localPlayer, 'user:writing') then
		setElementData(localPlayer, 'user:writing', true)

		if not isPedInVehicle(localPlayer) then
			--triggerServerEvent('Player:SetAnimation', getRootElement(), localPlayer, 'GANGS', 'prtial_gngtlkH', -1, true, false)
		end
	elseif not isChatBoxInputActive() and getElementData(localPlayer, 'user:writing') then
		setElementData(localPlayer, 'user:writing', false)
		--triggerServerEvent('Player:SetAnimation', getRootElement(), localPlayer, false)
	end
end)

--cmd to show

local gui = false

addCommandHandler('showgui', function(_, shader)
	if getElementData(localPlayer, 'bw:time') or not getElementData(localPlayer, 'user:logged') then return end

	shader = tonumber(shader) or 0

	if getElementData(localPlayer, 'pokaz:hud') and not gui then
		gui = true
		showChat(false)
		setElementData(localPlayer, 'grey_shader', shader)
		setElementData(localPlayer, 'pokaz:hud', false)
		showPlayerHudComponent('radar', false)
	elseif not getElementData(localPlayer, 'pokaz:hud') and gui then
		gui = false
		showChat(true)
		setElementData(localPlayer, 'grey_shader', 0)
		setElementData(localPlayer, 'pokaz:hud', true)
		showPlayerHudComponent('radar', true)
	end
end)

--

addEventHandler('onClientResourceStart', root, function()
	setPlayerNametagShowing(root, false)
end)
