--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local dxLibary = exports['dxLibary']
local anim = exports['dmta_base_anim']
local cpicker = exports['cpicker']
local gridlist = exports['gridlist']
local noti = exports['dmta_base_notifications']

local sw,sh = guiGetScreenSize()
local baseX = 1920
local scale = 1
local minScale = 2
if sw < baseX then
    scale = math.min(minScale, baseX/sw)
end

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

function rgb2hex(r,g,b) 
    return string.format('#%02X%02X%02X', r,g,b) 
end

function hex2rgb(hex)
    hex = hex:gsub('#','')
    return tonumber('0x'..hex:sub(1,2)), tonumber('0x'..hex:sub(3,4)), tonumber('0x'..hex:sub(5,6))
end

local salon = {}

function salon:Load()
    self['open_gui-fnc'] = function(...) self:OpenGui(...) end
    self['render_fnc'] = function() self:Render() end
    self['clicked_fnc'] = function(...) self:Clicked(...) end
    self['_render_fnc'] = function() self:TestDriveTime_Render() end
    self['test_drive_time-fnc'] = function(type, time) if type == true then addEventHandler('onClientRender', root, self['_render_fnc']) self['time'] = time self['time_tick'] = getTickCount() else removeEventHandler('onClientRender', root, self['_render_fnc']) end end
    self['render_buy-fnc'] = function() self:RenderBuy() end
    self['clicked_buy-fnc'] = function(...) self:ClickedBuy(...) end

    self['info'] = {}
    self['time'] = 0
    self['time_tick'] = getTickCount()
    
    self['color_1'] = {255,255,255}
    self['color_2'] = {255,255,255}
	self['step'] = 1

    addEvent('OpenGui', true)
    addEventHandler('OpenGui', resourceRoot, self['open_gui-fnc'])

    addEvent('TestDrive:Time', true)
    addEventHandler('TestDrive:Time', resourceRoot, self['test_drive_time-fnc'])
end

function mathTime(time)
	if math.floor(time/60) > 0 then
		return math.floor(time/60)..'m '..time - (math.floor(time/60)*60)..'s'
	else
		return time - (math.floor(time/60)*60)..'s'
	end
end

function salon:TestDriveTime_Render()
    if (getTickCount()-self['time_tick']) > 1000 then
        self['time'] = self['time'] - 1
        self['time_tick'] = getTickCount()
    end

    if self['time'] < 1 then
        triggerServerEvent('Stop:TestRide', resourceRoot)
        removeEventHandler('onClientRender', root, self['_render_fnc'])
        return
    end

    dxLibary:dxLibary_createWindow(766/scale, 10/scale, 388/scale, 64/scale, tocolor(0, 0, 0, 222), false)
    dxLibary:dxLibary_shadowText('Jazda próbna', 766/scale, 20/scale, 1154/scale, 39/scale, tocolor(255, 255, 255, 255), 5, 'default', 'center', 'center', false, false, false, false, false)
    dxLibary:dxLibary_shadowText('Pozostały czas: '..mathTime(self['time']), 766/scale, 39/scale, 1154/scale, 74/scale, tocolor(255, 255, 255, 255), 2, 'default', 'center', 'center', false, false, false, false, false)  
end

local tick_buy = getTickCount()
local lived_buy = false
local type_buy = 'join'

local color_1 = {255,255,255}
local color_2 = {255,255,255}

function salon:Render()
	if type_buy == 'join' then
		a,lived_buy = anim:animation(tick_buy, 0, 255, 500, 'Linear')
		a2 = anim:animation(tick_buy, 0, 230, 500, 'Linear')
	elseif type_buy == 'quit' then
		a,lived_buy = anim:animation(tick_buy, 255, 0, 250, 'Linear')
		a2 = anim:animation(tick_buy, 230, 0, 250, 'Linear')
		
		if not lived_buy then
			removeEventHandler('onClientRender', root, self['render_fnc'])
		end
	end
	dxDrawRectangle(0, 0, 1920, 1080, tocolor(15, 15, 15, 200), false)
	
	self['info']['tank'] = self['info']['tank'] == nil and 25 or self['info']['tank']
	
    dxLibary:dxLibary_createWindowAlpha(738/scale, 330/scale, 444/scale, 421/scale, a)
    dxLibary:dxLibary_text('#69bcebKupno pojazdu', 811/scale, 340/scale, 1109/scale, 381/scale, tocolor(255, 255, 255, a), 5, 'default', 'center', 'top', false, false, false, true, false)

    dxLibary:dxLibary_createButtonAlpha('Kup pojazd', 765/scale, 678/scale, 188/scale, 47/scale, 1, a2)
    dxLibary:dxLibary_createButtonAlpha('Jazda testowa', 974/scale, 678/scale, 188/scale, 47/scale, 1, a2)
	
   	local info = '- Model: #69bceb'..self['info']['name']..'#ffffff\n- Cena: #69bceb'..formatMoney(self['info']['cost'])..'$#ffffff\n- Przebieg: #69bceb'..string.format('%.1f', self['info']['distance'])..'km#ffffff\n- Bak: #69bceb'..self['info']['tank']..'L#ffffff\n- Pojemność silnika: #69bceb'..self['info']['engine']..'dm³#ffffff\n- Rodzaj silnika: #69bceb'..self['info']['type']..'#ffffff\n- Instalacja LPG:#69bceb '..self['info']['lpg']..'#ffffff\n- Napęd: #69bceb'..self['info']['driveType']..'#ffffff\n- Kolor 1: '..rgb2hex(unpack(self['color_1']))..'█#ffffff\n- Kolor 2: '..rgb2hex(unpack(self['color_2']))..'█'
	
	if self['info']['salon'] then
		dxLibary:dxLibary_createButtonAlpha('Dostosuj', 874/scale, 625/scale, 172/scale, 35/scale, 1, a2)
		dxLibary:dxLibary_text('#939393Informacje dot. pojazdu:#ffffff\n'..info, 748/scale, 330/scale, 1172/scale, 668/scale, tocolor(255, 255, 255, a), 1, 'default', 'center', 'center', false, false, false, true, false)
	else
		dxLibary:dxLibary_text('#939393Informacje dot. pojazdu:#ffffff\n'..info, 748/scale, 380/scale, 1172/scale, 668/scale, tocolor(255, 255, 255, a), 1, 'default', 'center', 'center', false, false, false, true, false)	
	end

    local x,y,w,h = dxLibary:dxLibary_formatTextPosition(1156/scale, 334/scale, 21/scale, 21/scale)
    if isMouseIn(1156/scale, 334/scale, 21/scale, 21/scale) then
		dxLibary:dxLibary_text('X', x, y, w, h, tocolor(255, 0, 0, a), 5, 'default', 'center', 'center', false, false, false, false, false)
	else
		dxLibary:dxLibary_text('X', x, y, w, h, tocolor(150, 150, 150, a), 5, 'default', 'center', 'center', false, false, false, false, false)
	end
end

function salon:RenderBuy()
	dxDrawRectangle(0, 0, 1920, 1080, tocolor(15, 15, 15, 200), false)
	if self['step'] == 1 then
		dxLibary:dxLibary_createWindow(738/scale, 330/scale, 444/scale, 421/scale, a)
		dxLibary:dxLibary_text('#69bcebZmiana koloru pojazdu', 811/scale, 340/scale, 1109/scale, 381/scale, tocolor(255, 255, 255, a), 5, 'default', 'center', 'top', false, false, false, true, false)
		
        dxLibary:dxLibary_createButton('Zastosuj\nkolor 1', 1068/scale, 410/scale, 91/scale, 50/scale, tocolor(255, 255, 255, 255), false)
        dxLibary:dxLibary_createButton('Zastosuj\nkolor 2', 1068/scale, 470/scale, 91/scale, 50/scale, tocolor(255, 255, 255, 255), false)
		
		dxLibary:dxLibary_text('Kolor 1:', 1020/scale, 565/scale, 1162/scale, 574/scale, tocolor(255, 255, 255, 255), 1.00, 'default', 'center', 'center', false, false, false, false, false)
		dxLibary:dxLibary_text('Kolor 2:', 1120/scale, 565/scale, 1162/scale, 574/scale, tocolor(255, 255, 255, 255), 1.00, 'default', 'center', 'center', false, false, false, false, false)
		
        dxDrawRectangle(1070/scale, 584/scale, 40/scale, 40/scale, tocolor(unpack(color_1)), false)
        dxDrawRectangle(1120/scale, 584/scale, 40/scale, 40/scale, tocolor(unpack(color_2)), false)

		dxLibary:dxLibary_createButton('Dalej', 765/scale, 678/scale, 188/scale, 47/scale, 1, a2)
		dxLibary:dxLibary_createButton('Cofnij', 974/scale, 678/scale, 188/scale, 47/scale, 1, a2)
	elseif self['step'] == 2 then
		dxLibary:dxLibary_createWindow(738/scale, 330/scale, 444/scale, 421/scale, a)
		dxLibary:dxLibary_text('#69bcebZmiana pojemności', 811/scale, 340/scale, 1109/scale, 381/scale, tocolor(255, 255, 255, a), 5, 'default', 'center', 'top', false, false, false, true, false)
		
		dxLibary:dxLibary_createButton('Dalej', 765/scale, 678/scale, 188/scale, 47/scale, 1, a2)
		dxLibary:dxLibary_createButton('Cofnij', 974/scale, 678/scale, 188/scale, 47/scale, 1, a2)
	elseif self['step'] == 3 then
		dxLibary:dxLibary_createWindow(738/scale, 330/scale, 444/scale, 421/scale, a)
		dxLibary:dxLibary_text('#69bcebZmiana butli paliwa', 811/scale, 340/scale, 1109/scale, 381/scale, tocolor(255, 255, 255, a), 5, 'default', 'center', 'top', false, false, false, true, false)
		
		dxLibary:dxLibary_createButton('Dalej', 765/scale, 678/scale, 188/scale, 47/scale, 1, a2)
		dxLibary:dxLibary_createButton('Cofnij', 974/scale, 678/scale, 188/scale, 47/scale, 1, a2)	
	elseif self['step'] == 4 then
		dxLibary:dxLibary_createWindow(738/scale, 330/scale, 444/scale, 421/scale, a)
		dxLibary:dxLibary_text('#69bcebZmiana napędu', 811/scale, 340/scale, 1109/scale, 381/scale, tocolor(255, 255, 255, a), 5, 'default', 'center', 'top', false, false, false, true, false)
		
		dxLibary:dxLibary_createButton('Zaakceptuj', 765/scale, 678/scale, 188/scale, 47/scale, 1, a2)
		dxLibary:dxLibary_createButton('Cofnij', 974/scale, 678/scale, 188/scale, 47/scale, 1, a2)
	end
end

function colorPicker()
	cpicker:createCPicker(770/scale, 400/scale, 209/scale, 187/scale)
end

function listEngine(default)
	gridlist:dxLibary_createGridlist('SALONY-POJEMNOSC1', {{name='Pojemność silnika',height=0}, {name='Cena',height=150}}, 6, 765/scale, 420/scale, 390/scale)
	gridlist:dxLibary_addGridlistItem('SALONY-POJEMNOSC1', {'1.6dm³', '0$'})
	gridlist:dxLibary_addGridlistItem('SALONY-POJEMNOSC1', {'1.8dm³', '25,000$'})
	gridlist:dxLibary_addGridlistItem('SALONY-POJEMNOSC1', {'2.0dm³', '50,000$'})
	gridlist:dxLibary_addGridlistItem('SALONY-POJEMNOSC1', {'2.2dm³', '75,000$'})
	gridlist:dxLibary_addGridlistItem('SALONY-POJEMNOSC1', {'2.4dm³', '100,000$'})
	gridlist:dxLibary_addGridlistItem('SALONY-POJEMNOSC1', {'2.6dm³', '125,000$'})
	gridlist:dxLibary_addGridlistItem('SALONY-POJEMNOSC1', {'2.8dm³', '150,000$'})
	gridlist:dxLibary_addGridlistItem('SALONY-POJEMNOSC1', {'3.0dm³', '200,000$'})
end

function listBak()
	gridlist:dxLibary_createGridlist('SALONY-BUTLE1', {{name='Pojemność',height=0}, {name='Cena',height=150}}, 6, 765/scale, 420/scale, 390/scale)
	gridlist:dxLibary_addGridlistItem('SALONY-BUTLE1', {'25 litrów', '0$'})
	gridlist:dxLibary_addGridlistItem('SALONY-BUTLE1', {'50 litrów', '25,000$'})
	gridlist:dxLibary_addGridlistItem('SALONY-BUTLE1', {'75 litrów', '50,000$'})
end

local info = {}

local types = {
	['awd'] = 50000,
	['fwd'] = 10000,
	['rwd'] = 25000,
}

function listTypes(default)
	gridlist:dxLibary_createGridlist('SALONY-TYPES1', {{name='Typ',height=0}, {name='Cena',height=150}}, 6, 765/scale, 420/scale, 390/scale)
	
	local list = types
	if list[default] then
		list[default] = 0
	end
	
	for i,v in pairs(list) do	
		gridlist:dxLibary_addGridlistItem('SALONY-TYPES1', {i, formatMoney(v)..'$'})
	end
end

function salon:ClickedBuy(button, state)
    if button ~= 'left' or state ~= 'down' then return end

	if isMouseIn(765/scale, 678/scale, 188/scale, 47/scale) then
		if self['step'] == 4 then
			if gridlist:dxLibary_checkSelectedItem('SALONY-TYPES1') then
				info['driveType'] = gridlist:dxLibary_gridlistGetSelectedItemText('SALONY-TYPES1', 1)
				info['driveType:Cost'] = gridlist:dxLibary_gridlistGetSelectedItemText('SALONY-TYPES1', 2)
				
				addEventHandler('onClientRender', root, self['render_fnc'])
				addEventHandler('onClientClick', root, self['clicked_fnc'])
				removeEventHandler('onClientRender', root, self['render_buy-fnc'])
				removeEventHandler('onClientClick', root, self['clicked_buy-fnc'])	
				gridlist:dxLibary_destroyGridlist('SALONY-TYPES1')
				
				self['info']['driveType'] = info['driveType']
				self['info']['engine'] = info['engine']
				self['info']['tank'] = info['tank']
				self['color_1'] = color_1
				self['color_2'] = color_2
				
				local drive_cost = string.gsub(string.sub(info['driveType:Cost'], 1, string.len(info['driveType:Cost'])-1), ',', '')
				local engine_cost = string.gsub(string.sub(info['engine:Cost'], 1, string.len(info['engine:Cost'])-1), ',', '')
				local tank_cost = string.gsub(string.sub(info['tank:Cost'], 1, string.len(info['tank:Cost'])-1), ',', '')
				self['info']['cost'] = self['info']['cost'] + drive_cost + engine_cost + tank_cost
				
				info = {}
			else
				noti:addNotification('Najpierw wybierz rodzaj napędu.', 'error')
			end
			return
		elseif self['step'] == 1 then
			cpicker:destroyCPicker()
			listEngine(self['info']['last']['engine'])
		elseif self['step'] == 2 then
			if gridlist:dxLibary_checkSelectedItem('SALONY-POJEMNOSC1') then
				info['engine'] = string.sub(gridlist:dxLibary_gridlistGetSelectedItemText('SALONY-POJEMNOSC1', 1), 1, 3)
				info['engine:Cost'] = gridlist:dxLibary_gridlistGetSelectedItemText('SALONY-POJEMNOSC1', 2)
				gridlist:dxLibary_destroyGridlist('SALONY-POJEMNOSC1')
				listBak()
			else
				noti:addNotification('Najpierw wybierz pojemność silnika.', 'error')
				return
			end
		elseif self['step'] == 3 then
			if gridlist:dxLibary_checkSelectedItem('SALONY-BUTLE1') then
				info['tank'] = string.sub(gridlist:dxLibary_gridlistGetSelectedItemText('SALONY-BUTLE1', 1), 1, 2)
				info['tank:Cost'] = gridlist:dxLibary_gridlistGetSelectedItemText('SALONY-BUTLE1', 2)
				gridlist:dxLibary_destroyGridlist('SALONY-BUTLE1')
				listTypes(self['info']['last']['driveType'])
			else
				noti:addNotification('Najpierw wybierz pojemność butli paliwa.', 'error')
				return
			end
		end
			
		self['step'] = self['step'] + 1
	elseif isMouseIn(1068/scale, 410/scale, 91/scale, 50/scale) and self['step'] == 1 then
		color_1 = {cpicker:getCPickerSelectedColor()}
	elseif isMouseIn(1068/scale, 470/scale, 91/scale, 50/scale) and self['step'] == 1 then
		color_2 = {cpicker:getCPickerSelectedColor()}
	elseif isMouseIn(974/scale, 678/scale, 188/scale, 47/scale) then
		if self['step'] == 1 then
			addEventHandler('onClientRender', root, self['render_fnc'])
			addEventHandler('onClientClick', root, self['clicked_fnc'])
			removeEventHandler('onClientRender', root, self['render_buy-fnc'])
			removeEventHandler('onClientClick', root, self['clicked_buy-fnc'])		
			cpicker:destroyCPicker()
		else
			if self['step'] == 2 then
				gridlist:dxLibary_destroyGridlist('SALONY-POJEMNOSC1')
			elseif self['step'] == 3 then
				gridlist:dxLibary_destroyGridlist('SALONY-BUTLE1')
			end
			
			self['step'] = self['step'] - 1
			
			if self['step'] == 1 then
				colorPicker()
				gridlist:dxLibary_destroyGridlist('SALONY-POJEMNOSC1')	
			elseif self['step'] == 2 then
				listEngine(self['info']['last']['engine'])
			elseif self['step'] == 3 then
				gridlist:dxLibary_destroyGridlist('SALONY-TYPES1')
				listBak()
			elseif self['step'] == 4 then
				listTypes(self['info']['last']['driveType'])
			end
		end
	end
end

function salon:Clicked(button, state)
    if button ~= 'left' or state ~= 'down' or lived_buy then return end

    if isMouseIn(1156/scale, 334/scale, 21/scale, 21/scale) then
        removeEventHandler('onClientClick', root, self['clicked_fnc'])
        showCursor(false)
        setElementData(localPlayer, 'pokaz:hud', true)
        setElementData(localPlayer, 'grey_shader', 0)
        showChat(true)
		tick_buy = getTickCount()
		type_buy = 'quit'
    elseif isMouseIn(974/scale, 678/scale, 188/scale, 47/scale) then
        triggerServerEvent('TestRide', resourceRoot, self['info'])
        removeEventHandler('onClientClick', root, self['clicked_fnc'])
        showCursor(false)
        setElementData(localPlayer, 'pokaz:hud', true)
        setElementData(localPlayer, 'grey_shader', 0)
        showChat(true)
		tick_buy = getTickCount()
		type_buy = 'quit'
    elseif isMouseIn(765/scale, 678/scale, 188/scale, 47/scale) then
        if getPlayerMoney(localPlayer) >= self['info']['cost'] then
        	triggerServerEvent('BuyVehicle', resourceRoot, self['info'], {self['color_1'][1], self['color_1'][2], self['color_1'][3], self['color_2'][1], self['color_2'][2], self['color_2'][3]})
            removeEventHandler('onClientClick', root, self['clicked_fnc'])
            showCursor(false)
            setElementData(localPlayer, 'pokaz:hud', true)
            setElementData(localPlayer, 'grey_shader', 0)
            showChat(true)
			tick_buy = getTickCount()
			type_buy = 'quit'
        else
            noti:addNotification('Nie posiadasz wystarczających funduszy na zakup tego pojazdu.', 'error')
        end
	elseif isMouseIn(874/scale, 625/scale, 172/scale, 35/scale) and self['info']['salon'] then
		self['step'] = 1
		colorPicker()
		removeEventHandler('onClientRender', root, self['render_fnc'])
        removeEventHandler('onClientClick', root, self['clicked_fnc'])
        addEventHandler('onClientRender', root, self['render_buy-fnc'])
        addEventHandler('onClientClick', root, self['clicked_buy-fnc'])
    end
end

function salon:OpenGui(v, color)
    if not v then return end
	if lived_buy then return end
	
	local r1,g1,b1,r2,g2,b2 = unpack(color)
	color_1 = {r1,g1,b1}
	color_2 = {r2,g2,b2}
	self['color_1'] = color_1
	self['color_2'] = color_2

    addEventHandler('onClientRender', root, self['render_fnc'])
    addEventHandler('onClientClick', root, self['clicked_fnc'])
    showCursor(true)
    setElementData(localPlayer, 'pokaz:hud', false)
    setElementData(localPlayer, 'grey_shader', 1)
    showChat(false)
	
	tick_buy = getTickCount()
	lived_buy = false
	type_buy = 'join'
    
    self['info'] = v
	
	self['info']['last'] = {
		engine=v['engine'],
		driveType=v['driveType'],
	}
end

addEvent('gui:off', true)
addEventHandler('gui:off', resourceRoot, function(id)
	if salon['info'] and salon['info']['id'] and salon['info']['id'] == id then
	    removeEventHandler('onClientClick', root, salon['clicked_fnc'])
        showCursor(false)
        setElementData(localPlayer, 'pokaz:hud', true)
        setElementData(localPlayer, 'grey_shader', 0)
        showChat(true)
		tick_buy = getTickCount()
		type_buy = 'quit'		
	end
end)

addEventHandler('onClientResourceStart', resourceRoot, function()
    salon:Load()
end)

addEventHandler('onClientResourceStop', resourceRoot, function()
    gridlist:dxLibary_destroyGridlist('SALONY-POJEMNOSC1')
	gridlist:dxLibary_destroyGridlist('SALONY-BUTLE1')
	gridlist:dxLibary_destroyGridlist('SALONY-TYPES1')
	cpicker:destroyCPicker()
end)