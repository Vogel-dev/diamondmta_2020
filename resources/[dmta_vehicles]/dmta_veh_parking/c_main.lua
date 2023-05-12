--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

dxLibary = exports['dxLibary']
noti = exports['dmta_base_notifications']
opv = exports['object_preview']

local sw,sh = guiGetScreenSize()
local baseX = 1920
local scale = 1
local minScale = 2
if sw < baseX then
    scale = math.min(minScale, baseX/sw)
end

local przecho = {
	vehicle = false,
	selected_vehicle = false,
	pojazdy = {},
	object = false,
	row = 1,
	rot = 0
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

function formatMoney(money)
	while true do
		money, i = string.gsub(money, '^(-?%d+)(%d%d%d)', '%1,%2')
		if i == 0 then
			break
		end
	end
	return money
end

local start = 0

local function gui()
	dxDrawRectangle(0, 0, 1920, 1080, tocolor(15, 15, 15, 200), false)
    dxLibary:dxLibary_createWindow(689/scale, 365/scale, 543/scale, 350/scale)
	dxLibary:dxLibary_createWindow(547/scale, 349/scale, 136/scale, 383/scale, tocolor(15, 15, 15, 235), false)
	
	if start == 0 and getKeyState('mouse1') then
		local _X_ = getCursorPosition()
		start = _X_ * sw
	elseif start ~= 0 and not getKeyState('mouse1') then
		start = 0
	end

    dxLibary:dxLibary_shadowText2('Wybierz pojazd', 549/scale, 306/scale, 679/scale, 349/scale, tocolor(255, 255, 255, 255), 4, 'default', 'center', 'center', false, false, false, false, false)
    
	local index = przecho['pojazdy'][przecho['selected_vehicle']]

    local x = 0
    for i,v in ipairs(przecho['pojazdy']) do
        if (przecho['row'] + 9) >= i and przecho['row'] <= i then
            x = x + 1

			local sY = 37/scale * (x - 1)
			if i == przecho['selected_vehicle'] then
				dxLibary:dxLibary_createButtonAlpha(getVehicleNameFromModel(v['model']), 557/scale, 359/scale + sY, 116/scale, 30/scale, 1, 235, true)
			else
				dxLibary:dxLibary_createButtonAlpha(getVehicleNameFromModel(v['model']), 557/scale, 359/scale + sY, 116/scale, 30/scale, 1, 235, false)
			end
        end
	end
	
    if #przecho['pojazdy'] > 10 then
        local r = 36.3/scale * 10
        dxDrawRectangle(676.5/scale, 359/scale, 3/scale, r, tocolor(30, 30, 30, 235), false)
        dxDrawRectangle(676.5/scale, (359/scale + r / #przecho['pojazdy'] * (przecho['row']-1)), 3/scale, (r / #przecho['pojazdy'] * 10), tocolor(0, 100, 255, 235), false)
    end

    --dxLibary:dxLibary_text('Informacje dt. pojazdu:\nID pojazdu: '..index['id']..'\nModel: '..getVehicleNameFromModel(index['model'])..'\nPojemność: '..index['engine']..'dm³\nWłaściciel: '..index['ownerName']..'\nOstatni kierowca: '..index['lastDriver']..'\nWstawienie: '..string.sub(index['parking_takedate'], 1, 10)..'\nOpłata: '..formatMoney(index['parking_cost'])..'$', 1046/scale + 1, 335/scale + 1, 1222/scale + 1, 644/scale + 1, tocolor(0, 0, 0, 255), 1, 'default', 'center', 'center', false, false, false, true, false)
	--dxLibary:dxLibary_text('#939393Informacje dt. pojazdu:\n#ffffffID pojazdu: #69bceb'..index['id']..'#ffffff\nModel: #69bceb'..getVehicleNameFromModel(index['model'])..'#ffffff\nPojemność: #69bceb'..index['engine']..'dm³#ffffff\nWłaściciel: #69bceb'..index['ownerName']..'#ffffff\nOstatni kierowca: #69bceb'..index['lastDriver']..'#ffffff\nWstawienie: #69bceb'..string.sub(index['parking_takedate'], 1, 10)..'#ffffff\nOpłata: #69bceb'..formatMoney(index['parking_cost'])..'$', 1046/scale, 335/scale, 1222/scale, 644/scale, tocolor(255, 255, 255, 255), 1, 'default', 'center', 'center', false, false, false, true, false)
	
	dxLibary:dxLibary_text('Informacje dt. pojazdu:\nID pojazdu: '..index['id']..'\nModel: '..getVehicleNameFromModel(index['model'])..'\nWłaściciel: '..index['ownerName']..'\nOstatni kierowca: '..index['lastDriver']..'\nWstawienie: '..string.sub(index['parking_takedate'], 1, 10)..'\nOpłata: '..formatMoney(index['parking_cost'])..'$', 1046/scale + 1, 335/scale + 1, 1222/scale + 1, 644/scale + 1, tocolor(0, 0, 0, 255), 1, 'default', 'center', 'center', false, false, false, true, false)
	dxLibary:dxLibary_text('#939393Informacje dt. pojazdu:\n#ffffffID pojazdu: #69bceb'..index['id']..'#ffffff\nModel: #69bceb'..getVehicleNameFromModel(index['model'])..'#ffffff\nWłaściciel: #69bceb'..index['ownerName']..'#ffffff\nOstatni kierowca: #69bceb'..index['lastDriver']..'#ffffff\nWstawienie: #69bceb'..string.sub(index['parking_takedate'], 1, 10)..'#ffffff\nOpłata: #69bceb'..formatMoney(index['parking_cost'])..'$', 1046/scale, 335/scale, 1222/scale, 644/scale, tocolor(255, 255, 255, 255), 1, 'default', 'center', 'center', false, false, false, true, false)
    

    dxLibary:dxLibary_createButton('Wyjmij pojazd', 1056/scale, 602/scale, 156/scale, 43/scale, tocolor(255, 255, 255, 255), false)
    dxLibary:dxLibary_createButton('Zamknij panel', 1056/scale, 652/scale, 156/scale, 43/scale, tocolor(255, 255, 255, 255), false)

	opv:setRotation(przecho['object'], -5, 0, przecho['rot'])
end

local function clicked(btn,state)
	if btn ~= 'state' and state ~= 'down' then return end

	local x = 0
	for i,v in ipairs(przecho['pojazdy']) do
		if (przecho['row'] + 9) >= i and przecho['row'] <= i then
			x = x + 1

			local sY = 37/scale * (x-1)
			if isMouseIn(557/scale, 359/scale + sY, 116/scale, 30/scale) then
				przecho['selected_vehicle'] = i
				triggerServerEvent('selectParkingVehicle', resourceRoot, localPlayer, v['id'])
				break
			end
		end
	end

	if isMouseIn(1056/scale, 652/scale, 156/scale, 43/scale) then
		removeEventHandler('onClientRender', root, gui)
		triggerServerEvent('destroyParkingVehicle', resourceRoot, localPlayer)
		setElementFrozen(localPlayer, false)
		showChat(true)
		showPlayerHudComponent('all', false)
		showCursor(false)
		setElementData(localPlayer, 'pokaz:hud', true)
		removeEventHandler('onClientClick', root, clicked)
		removeEventHandler('onClientCursorMove', root, mouse_rot)
		setElementData(localPlayer, 'grey_shader', 0)
		opv:destroyObjectPreview(przecho['object'])
		unbindKey('mouse_wheel_down', 'down', mouse_wheel_down)
		unbindKey('mouse_wheel_up', 'down', mouse_wheel_up)
	elseif isMouseIn(1056/scale, 602/scale, 156/scale, 43/scale) then
		for i,v in ipairs(przecho['pojazdy']) do
			if i == przecho['selected_vehicle'] then
				if getPlayerMoney(localPlayer) >= v['parking_cost'] then
					triggerServerEvent('wyjmij:auto', resourceRoot, localPlayer, v['id'], v['parking_cost'])
				else
					noti:addNotification('Nie posiadasz wystarczających funduszy na wyjęcie pojazdu.', 'error')
					return
				end
				break
			end
		end

		removeEventHandler('onClientRender', root, gui)
		triggerServerEvent('destroyParkingVehicle', resourceRoot, localPlayer)
		setElementFrozen(localPlayer, false)
		showChat(true)
		showPlayerHudComponent('all', false)
		showCursor(false)
		setElementData(localPlayer, 'pokaz:hud', true)
		removeEventHandler('onClientClick', root, clicked)
		removeEventHandler('onClientCursorMove', root, mouse_rot)
		setElementData(localPlayer, 'grey_shader', 0)
		opv:destroyObjectPreview(przecho['object'])
		unbindKey('mouse_wheel_down', 'down', mouse_wheel_down)
		unbindKey('mouse_wheel_up', 'down', mouse_wheel_up)
	end
end

function mouse_wheel_up()
	przecho['row'] = math.max(przecho['row'] - 1, 1)
end

function mouse_wheel_down()
	przecho['row'] = math.min(przecho['row'] + 1, (#przecho['pojazdy'] - 9))
end

addEvent('lista:aut', true)
addEventHandler('lista:aut', resourceRoot, function(query, veh)
	if query == '_' then
		przecho['vehicle'] = veh
		setElementAlpha(przecho['vehicle'], 255)

		przecho['object'] = opv:createObjectPreview(przecho['vehicle'], 0, 0, 0, 0.5, 0.5, 1, 1, true, true, true)
		opv:setProjection(przecho['object'], 698/scale, 372/scale, 333/scale, 333/scale, false, true)
		przecho['rot'] = 160
		return
	end

	przecho['pojazdy'] = {}
	przecho['row'] = 1

	triggerServerEvent('createParkingVehicle', resourceRoot, query, localPlayer)
	addEventHandler('onClientRender', root, gui)

	for i,v in ipairs(query) do
		table.insert(przecho['pojazdy'], v)
	end

	przecho['selected_vehicle'] = 1

	setElementFrozen(localPlayer, true)
	showChat(false)
	showPlayerHudComponent('all', false)
	showCursor(true)
	setElementData(localPlayer, 'pokaz:hud', false)
	addEventHandler('onClientClick', root, clicked)
	addEventHandler('onClientCursorMove', root, mouse_rot)
	setElementData(localPlayer, 'grey_shader', 1)
	bindKey('mouse_wheel_down', 'down', mouse_wheel_down)
	bindKey('mouse_wheel_up', 'down', mouse_wheel_up)
end)

function mouse_rot(_, _, x)
	if not getKeyState('mouse1') or not isCursorShowing() then return end

	if isMouseIn(698/scale, 372/scale, 333/scale, 333/scale) then
		if start < x then
			przecho['rot'] = przecho['rot'] + 2
		elseif start > x then
			przecho['rot'] = przecho['rot'] - 2
		end
	end
end