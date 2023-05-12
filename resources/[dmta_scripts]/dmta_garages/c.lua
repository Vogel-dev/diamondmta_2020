--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local dxLibary = exports.dxLibary
local opv = exports.object_preview

local sw,sh = guiGetScreenSize()
local baseX = 1920
local scale = 1
local minScale = 2
if sw < baseX then
    scale = math.min(minScale, baseX/sw)
end

local garages = {}

function isMouseIn(x, y, w, h)
	if not isCursorShowing() then return end

	local pos = {getCursorPosition()}
	pos[1],pos[2] = (pos[1]*sw),(pos[2]*sh)

	if pos[1] >= x and pos[1] <= (x+w) and pos[2] >= y and pos[2] <= (y+h) then
		return true
	end
	return false
end

function garages:Load()
    self['vehicle_list-fnc'] = function(vehicles) self:GetVehicles(vehicles) end
    self['render_fnc'] = function() self:Render() end
    self['clicked_fnc'] = function(button, state) self:Clicked(button, state) end 
    self['load_vehicle-fnc'] = function(vehicle) self:LoadVehicle(vehicle) end
    self['rotation_vehicle-fnc'] = function(_, _, x) self:VehicleRotation(x) end
    self['scroll_fnc'] = function(key, state) self:Scroll(key, state) end

    self['vehicles_list'] = false
    self['vehicle'] = false
    self['vehicle_object'] = false
    self['selected_vehicle'] = 1
    self['rot'] = 0
    self['min_row'] = 1
    self['max_row'] = 10

    addEvent('Garages:GetVehicles', true)
    addEventHandler('Garages:GetVehicles', resourceRoot, self['vehicle_list-fnc'])

    addEvent('LoadVehicle', true)
    addEventHandler('LoadVehicle', resourceRoot, self['load_vehicle-fnc'])
end

function garages:Render()
    dxLibary:dxLibary_createWindow(689/scale, 365/scale, 543/scale, 350/scale)
    dxLibary:dxLibary_createWindow(547/scale, 349/scale, 136/scale, 383/scale, tocolor(15, 15, 15, 235), false)

    local x = 0
    for i,v in ipairs(self['vehicles_list']) do
        if self['max_row'] >= i and self['min_row'] <= i then
            x = x + 1

            local sY = 37/scale * (x - 1)
            if i == self['selected_vehicle'] then
                dxLibary:dxLibary_createButtonAlpha(getVehicleNameFromModel(v['model']), 557/scale, 359/scale + sY, 116/scale, 30/scale, 1, 235, true)
            else
                dxLibary:dxLibary_createButtonAlpha(getVehicleNameFromModel(v['model']), 557/scale, 359/scale + sY, 116/scale, 30/scale, 1, 235, false)
            end
        end
    end

    dxLibary:dxLibary_shadowText2('Wybierz pojazd', 549/scale, 306/scale, 679/scale, 349/scale, tocolor(255, 255, 255, 255), 4, 'default', 'center', 'center', false, false, false, false, false)
    
    local index = self['vehicles_list'][self['selected_vehicle']]
    dxLibary:dxLibary_text('Informacje dt. pojazdu:\nID pojazdu: '..index['id']..'\nModel: '..getVehicleNameFromModel(index['model'])..'\nPojemność: '..index['engine']..'dm³\nWłaściciel: '..index['ownerName']..'\nOstatni kierowca: '..index['lastDriver'], 1046/scale + 1, 335/scale + 1, 1222/scale + 1, 644/scale + 1, tocolor(0, 0, 0, 255), 1, 'default', 'center', 'center', false, false, false, true, false)
    dxLibary:dxLibary_text('#939393Informacje dt. pojazdu:\n#ffffffID pojazdu: #69bceb'..index['id']..'#ffffff\nModel: #69bceb'..getVehicleNameFromModel(index['model'])..'#ffffff\nPojemność: #69bceb'..index['engine']..'dm³#ffffff\nWłaściciel: #69bceb'..index['ownerName']..'#ffffff\nOstatni kierowca: #69bceb'..index['lastDriver'], 1046/scale, 335/scale, 1222/scale, 644/scale, tocolor(255, 255, 255, 255), 1, 'default', 'center', 'center', false, false, false, true, false)
    
    dxLibary:dxLibary_createButton('Wyjmij pojazd', 1056/scale, 602/scale, 156/scale, 43/scale, tocolor(255, 255, 255, 255), false)
    dxLibary:dxLibary_createButton('Zamknij panel', 1056/scale, 652/scale, 156/scale, 43/scale, tocolor(255, 255, 255, 255), false)

	opv:setRotation(self['vehicle_object'], -5, 0, self['rot'])
end

function garages:Clicked(button, state)
    if button ~= 'left' or state ~= 'down' then return end

    local x = 0
    for i,v in ipairs(self['vehicles_list']) do
        if self['max_row'] >= i and self['min_row'] <= i then
            x = x + 1

            local sY = 37/scale * (x - 1)
            if isMouseIn(557/scale, 359/scale + sY, 116/scale, 30/scale) then
                self['selected_vehicle'] = i
                triggerServerEvent('CreateVehicle', resourceRoot, localPlayer, v['id'])
            end
        end
    end

    if isMouseIn(1056/scale, 652/scale, 156/scale, 43/scale) then
        removeEventHandler('onClientRender', root, self['render_fnc'])
        removeEventHandler('onClientClick', root, self['clicked_fnc'])
        removeEventHandler('onClientCursorMove', root, self['rotation_vehicle-fnc'])

        unbindKey('mouse_wheel_up', 'both', self['scroll_fnc'])
        unbindKey('mouse_wheel_down', 'both', self['scroll_fnc'])

        triggerServerEvent('DestroyVehicle', resourceRoot, localPlayer)

        setElementFrozen(localPlayer, false)
        showChat(true)
        showCursor(false)
        setElementData(localPlayer, 'pokaz:hud', true)
        setElementData(localPlayer, 'grey_shader', 0)
    elseif isMouseIn(1056/scale, 602/scale, 156/scale, 43/scale) then
        local id = self['vehicles_list'][self['selected_vehicle']]['id']
        triggerServerEvent('GetVehicle', resourceRoot, localPlayer, id)

        removeEventHandler('onClientRender', root, self['render_fnc'])
        removeEventHandler('onClientClick', root, self['clicked_fnc'])
        removeEventHandler('onClientCursorMove', root, self['rotation_vehicle-fnc'])

        unbindKey('mouse_wheel_up', 'both', self['scroll_fnc'])
        unbindKey('mouse_wheel_down', 'both', self['scroll_fnc'])

        triggerServerEvent('DestroyVehicle', resourceRoot, localPlayer)

        setElementFrozen(localPlayer, false)
        showChat(true)
        showCursor(false)
        setElementData(localPlayer, 'pokaz:hud', true)
        setElementData(localPlayer, 'grey_shader', 0)
    end
end

function garages:LoadVehicle(vehicle)
    self['vehicle'] = vehicle
    self['vehicle_object'] = opv:createObjectPreview(self['vehicle'], 0, 0, 0, 0.5, 0.5, 1, 1, true, true, true)
    opv:setProjection(self['vehicle_object'], 698/scale, 372/scale, 333/scale, 333/scale, false, true)
    self['rot'] = 160
end

function garages:GetVehicles(vehicles)
    addEventHandler('onClientRender', root, self['render_fnc'])
    addEventHandler('onClientClick', root, self['clicked_fnc'])
    addEventHandler('onClientCursorMove', root, self['rotation_vehicle-fnc'])
    bindKey('mouse_wheel_up', 'both', self['scroll_fnc'])
    bindKey('mouse_wheel_down', 'both', self['scroll_fnc'])

    self['selected_vehicle'] = 1
    self['vehicles_list'] = vehicles
    self['min_row'] = 1
    self['max_row'] = 10

	setElementFrozen(localPlayer, true)
	showChat(false)
	showCursor(true)
	setElementData(localPlayer, 'pokaz:hud', false)
    setElementData(localPlayer, 'grey_shader', 1)
    
    triggerServerEvent('CreateVehicle', resourceRoot, localPlayer, vehicles[1]['id'])
end

function garages:VehicleRotation(x)
    if not getKeyState('mouse1') or not isCursorShowing() then return end

    if isMouseIn(698/scale, 372/scale, 333/scale, 333/scale) then
        if x > (863/scale) then
            self['rot'] = self['rot'] + 1
        elseif x < (863/scale) then
            self['rot'] = self['rot'] - 1
        end
    end
end

function garages:Scroll(key, state)
    if key == 'mouse_wheel_up' then
      if self['min_row'] > 1 then
        self['min_row'] = self['min_row'] - 1
        self['max_row'] = self['max_row'] - 1
      end
    elseif key == 'mouse_wheel_down' then
      if ((#self['vehicles_list'] >= self['max_row'] and self['max_row']) or #self['vehicles_list']) ~= #self['vehicles_list'] then
        self['min_row'] = self['min_row'] + 1
        self['max_row'] = self['max_row'] + 1
      end
    end
  end

addEventHandler('onClientResourceStart', resourceRoot, function()
    garages:Load()
end)