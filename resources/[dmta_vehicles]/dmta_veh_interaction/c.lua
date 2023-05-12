--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local dxLibary = exports['dxLibary']

local sw,sh = guiGetScreenSize()
local baseX = 1920
local scale = 1
local minScale = 2
if sw < baseX then
    scale = math.min(minScale, baseX/sw)
end

local selected = 1
local tick = getTickCount()
local interaction = {}
local rot_1 = 0
local rot_2 = 0
local last = 0

local tick_int = getTickCount()
local int = false
local type = 'join'

local images = {
  ['car'] = dxLibary:createTexture(':dmta_veh_interaction/images/car.png', 'dxt5', false, 'clamp'),
  ['engine'] = dxLibary:createTexture(':dmta_veh_interaction/images/engine.png', 'dxt5', false, 'clamp'),
  ['handbrake'] = dxLibary:createTexture(':dmta_veh_interaction/images/handbrake.png', 'dxt5', false, 'clamp'),
  ['kropka'] = dxLibary:createTexture(':dmta_veh_interaction/images/kropka.png', 'dxt5', false, 'clamp'),
  ['kropka2'] = dxLibary:createTexture(':dmta_veh_interaction/images/kropka2.png', 'dxt5', false, 'clamp'),
  ['leave'] = dxLibary:createTexture(':dmta_veh_interaction/images/leave.png', 'dxt5', false, 'clamp'),
  ['light'] = dxLibary:createTexture(':dmta_veh_interaction/images/light.png', 'dxt5', false, 'clamp'),
  ['lock'] = dxLibary:createTexture(':dmta_veh_interaction/images/lock.png', 'dxt5', false, 'clamp'),
  ['settings'] = dxLibary:createTexture(':dmta_veh_interaction/images/settings.png', 'dxt5', false, 'clamp'),
  ['rectangle'] = dxLibary:createTexture(':dmta_veh_interaction/images/rectangle.png', 'dxt5', false, 'clamp'),
  ['reload'] = dxLibary:createTexture(':dmta_veh_interaction/images/reload.png', 'dxt5', false, 'clamp'),
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

local selected_option = {
  function(veh, option, trigger)
    if trigger then
      if option == 1 then
        return 'switchLIGHT'
      elseif option == 2 then
        return 'switchENGINE'
      elseif option == 3 then
        return 'switchHANDBRAKE'
      elseif option == 4 then
        return 'kickOCCUPANTS'
      elseif option == 5 then
        return 'changeLOCKED'
      elseif option == 7 then
        return 'changeTYPE'
      end
    else
      if option == 1 then
        return getVehicleOverrideLights(veh) == 1 and 'Odpal lampy' or 'Zgaś lampy'
      elseif option == 2 then
        return getVehicleEngineState(veh) == true and 'Zgaś silnik' or 'Odpal silnik'
      elseif option == 3 then
        return getElementData(veh, 'vehicle:handbrake') and 'Spuść ręczny' or 'Zaciągnij ręczny'
      elseif option == 4 then
        return 'Wysadź pasażerów'
      elseif option == 5 then
        return isVehicleLocked(veh) == true and 'Otwórz zamek' or 'Zamknij zamek'
      elseif option == 6 then
        return 'Więcej opcji'
      elseif option == 7 then
        return getElementData(veh, 'vehicle:actualType') == 'LPG' and 'Przełącz na benzyne' or 'Przełącz na gaz'
      end
    end
  end
}

bindKey('lshift', 'both', function(_, state)
	local veh = getPedOccupiedVehicle(localPlayer)
	if not veh then return end

	if getVehicleController(veh) ~= localPlayer then return end
  if getVehicleName(veh) == 'Bike' or getVehicleName(veh) == 'BMX' or getVehicleName(veh) == 'Mountain Bike' then return end

  if state == 'up' then
    if selected == 6 then
      if not int then
        addEventHandler('onClientRender', root, gui)
        addEventHandler('onClientClick', root, clicked)
        addEventHandler('onClientKey', root, key)
        setElementData(localPlayer, 'grey_shader', 2)
        showCursor(true, false)
        tick_int = getTickCount()
        type = 'join'
      end
    else
      triggerServerEvent(selected_option[1](veh, selected, true), resourceRoot, veh)
    end

    removeEventHandler('onClientRender', root, guiInter)
    unbindKey('arrow_r', 'down', down)
    unbindKey('mouse_wheel_down', 'down', down)
    unbindKey('arrow_l', 'down', up)
    unbindKey('mouse_wheel_up', 'down', up)
	elseif state == 'down' and not isCursorShowing() then
		addEventHandler('onClientRender', root, guiInter)
    selected = 1
    tick = getTickCount()
    last = 0
    bindKey('arrow_r', 'down', down)
    bindKey('mouse_wheel_down', 'down', down)
    bindKey('arrow_l', 'down', up)
    bindKey('mouse_wheel_up', 'down', up)
	end
end)

function image(x, y, w, h, img, id)
  if selected == id then
    dxDrawImage(x, y, w, h, img, rot_1, 0, 0, tocolor(105, 188, 235, 255), true)
  else
    local rot = 0
    if last == id then rot = rot_2 end
    dxDrawImage(x, y, w, h, img, rot, 0, 0, tocolor(100, 100, 100, 255), true)
  end
end

function guiInter()
	local v = getPedOccupiedVehicle(localPlayer)
	if not v then
    removeEventHandler('onClientRender', root, guiInter)
    unbindKey('arrow_r', 'down', down)
    unbindKey('mouse_wheel_down', 'down', down)
    unbindKey('arrow_l', 'down', up)
    unbindKey('mouse_wheel_up', 'down', up)
		return
  end

  rot_1 = interpolateBetween(0, 0, 0, -5, 0, 0, (getTickCount()-tick)/100, 'Linear')
  rot_2 = interpolateBetween(-5, 0, 0, 0, 0, 0, (getTickCount()-tick)/100, 'Linear')
  dxDrawRectangle(0, 0, 1920, 1080, tocolor(15, 15, 15, 200), false)
  dxDrawImage(400/scale, 430/scale, 1120/scale, 205/scale, images['rectangle'], 0, 0, 0, tocolor(10, 10, 10, 235), true)
  dxDrawRectangle(730/scale, 550/scale, 455/scale, 1/scale, tocolor(105, 188, 235, 255), true)

  local x = (960/scale) - (32/scale)
  local y = (540/scale) - (82/scale)
  if getElementData(v, 'vehicle:type') == 'LPG' then
    image(x, y, 64/scale, 64/scale, images['leave'], 4)
    image(x + 300/scale, y, 64/scale, 64/scale, images['reload'], 7)
    image(x + 200/scale,y, 64/scale, 64/scale, images['settings'], 6)
    image(x - 100/scale, y, 64/scale, 64/scale, images['handbrake'], 3)
    image(x + 100/scale, y, 64/scale, 64/scale, images['lock'], 5)
    image(x - 200/scale, y, 64/scale, 64/scale, images['engine'], 2)
    image(x - 300/scale, y, 64/scale, 64/scale, images['light'], 1)
  else
    if selected == 7 then
      selected = 6
    end

    image(x + 56/scale, y, 64/scale, 64/scale, images['leave'], 4)
    image(x + 275/scale, y, 64/scale, 64/scale, images['settings'], 6)
    image(x - 56/scale, y, 64/scale, 64/scale, images['handbrake'], 3)
    image(x + 164/scale, y, 64/scale, 64/scale, images['lock'], 5)
    image(x - 164/scale, y, 64/scale, 64/scale, images['engine'], 2)
    image(x - 275/scale, y, 64/scale, 64/scale, images['light'], 1)
  end

  dxLibary:dxLibary_text('Wybrana opcja:\n'..selected_option[1](v, selected), 812/scale + 1, 550/scale + 1, 297/scale + 812/scale + 1, 50/scale + 586/scale + 1, tocolor(0, 0, 0, 255), 5, 'default', 'center', 'center', false, false, true, true)
  dxLibary:dxLibary_text('#69bcebWybrana opcja:#ffffff\n'..selected_option[1](v, selected), 812/scale, 550/scale, 297/scale + 812/scale, 50/scale + 586/scale, tocolor(255, 255, 255, 255), 5, 'default', 'center', 'center', false, false, true, true)
end

function gui()
	local v = getPedOccupiedVehicle(localPlayer)
	if not v then
    setElementData(localPlayer, 'grey_shader', 0)
    tick_int = getTickCount()
    type = 'quit'
    showCursor(false)
		return
	end

  if type == 'join' then
    a = interpolateBetween(0, 0, 0, 255, 0, 0, (getTickCount()-tick_int)/500, 'Linear')

    if a == 255 then
        int = false
    else
        int = true
    end
  elseif type == 'quit' then
    a = interpolateBetween(255, 0, 0, 0, 0, 0, (getTickCount()-tick_int)/500, 'Linear')

    if a == 0 then
        int = false

        removeEventHandler('onClientRender', root, gui)
        removeEventHandler('onClientClick', root, clicked)
        removeEventHandler('onClientKey', root, key)
    else
        int = true
    end
  end
  dxDrawRectangle(0, 0, 1920, 1080, tocolor(15, 15, 15, 200), false)
  dxLibary:dxLibary_text('Informacja:\nAby zamknąć kliknij dowolny klawisz.', 649/scale + 1, 0/scale + 1, 1272/scale + 1, 100/scale + 1, tocolor(0, 0, 0, a), 3, 'default', 'center', 'center', false, false, true, true, false)
  dxLibary:dxLibary_text('#69bcebInformacja:#ffffff\nAby zamknąć kliknij dowolny klawisz.', 649/scale, 0/scale, 1272/scale, 100/scale, tocolor(255, 255, 255, a), 3, 'default', 'center', 'center', false, false, true, true, false)

	dxDrawImage(sw-(1264/scale), sh-(864/scale), 650/scale, 650/scale, images['car'], 0, 0, 0, tocolor(105, 188, 235, a), true)

	if getVehicleDoorOpenRatio(v, 0) == 0 then -- maska
		dxImage(sw-(964/scale), sh-(864/scale), 40/scale, 40/scale, images['kropka'], a)
	else
		dxImage(sw-(964/scale), sh-(864/scale), 40/scale, 40/scale, images['kropka2'], a)
	end

	if getVehicleDoorOpenRatio(v, 1) == 0 then -- bagaznik
		dxImage(sw-(964/scale), sh-(250/scale), 40/scale, 40/scale, images['kropka'], a)
	else
		dxImage(sw-(964/scale), sh-(250/scale), 40/scale, 40/scale, images['kropka2'], a)
	end

	if getVehicleDoorOpenRatio(v, 2) == 0 then -- lewo przod
		dxImage(sw-(1125/scale), sh-(564/scale), 40/scale, 40/scale, images['kropka'], a)
	else
		dxImage(sw-(1125/scale), sh-(564/scale), 40/scale, 40/scale, images['kropka2'], a)
	end

	if getVehicleDoorOpenRatio(v, 3) == 0 then -- prawo przod
		dxImage(sw-(790/scale), sh-(564/scale), 40/scale, 40/scale, images['kropka'], a)
	else
		dxImage(sw-(790/scale), sh-(564/scale), 40/scale, 40/scale, images['kropka2'], a)
	end

	if getVehicleMaxPassengers(v) == 3 then
		if getVehicleDoorOpenRatio(v, 4) == 0 then -- lewy tyl
			dxImage(sw-(1125/scale), sh-(500/scale), 40/scale, 40/scale, images['kropka'], a)
		else
			dxImage(sw-(1125/scale), sh-(500/scale), 40/scale, 40/scale, images['kropka2'], a)
		end

		if getVehicleDoorOpenRatio(v, 5) == 0 then -- prawy tyl
			dxImage(sw-(790/scale), sh-(500/scale), 40/scale, 40/scale, images['kropka'], a)
		else
			dxImage(sw-(790/scale), sh-(500/scale), 40/scale, 40/scale, images['kropka2'], a)
		end
  end
end

function dxImage(x, y, w, h, img, a)
	if isMouseIn(x, y, w, h) and not int then
		dxDrawImage(x, y, w, h, img, 0, 0, 0, tocolor(255, 255, 255, 200), true)
	else
		dxDrawImage(x, y, w, h, img, 0, 0, 0, tocolor(255, 255, 255, a), true)
	end
end

function key(button, press)
  if button ~= 'mouse1' and button ~= 'mouse2' and press and not int then
    setElementData(localPlayer, 'grey_shader', 0)
    tick_int = getTickCount()
    type = 'quit'
    showCursor(false)
  end
end

function clicked(btn, state)
	if btn ~= 'state' and state ~= 'down' then return end

	local v = getPedOccupiedVehicle(localPlayer)
	if not v then return end

	if isMouseIn(sw-(964/scale), sh-(864/scale), 40/scale, 40/scale) then
		triggerServerEvent('wiecejOpcji', resourceRoot, v, 1)
	elseif isMouseIn(sw-(964/scale), sh-(250/scale), 40/scale, 40/scale) then
		triggerServerEvent('wiecejOpcji', resourceRoot, v, 2)
	elseif isMouseIn(sw-(1125/scale), sh-(564/scale), 40/scale, 40/scale) then
		triggerServerEvent('wiecejOpcji', resourceRoot, v, 3)
  elseif isMouseIn(sw-(790/scale), sh-(564/scale), 40/scale, 40/scale) then
    triggerServerEvent('wiecejOpcji', resourceRoot, v, 4)
	elseif isMouseIn(sw-(1125/scale), sh-(500/scale), 40/scale, 40/scale) and getVehicleMaxPassengers(v) == 3 then
		triggerServerEvent('wiecejOpcji', resourceRoot, v, 5)
	elseif isMouseIn(sw-(790/scale), sh-(500/scale), 40/scale, 40/scale) and getVehicleMaxPassengers(v) == 3 then
		triggerServerEvent('wiecejOpcji', resourceRoot, v, 6)
	end
end

function up()
  last = selected
  tick = getTickCount()
  selected = math.max(selected - 1, 1)
end

function down()
  local v = getPedOccupiedVehicle(localPlayer)
  local max = getElementData(v, 'vehicle:type') == 'LPG' and 7 or 6

  last = selected
  tick = getTickCount()
  selected = math.min(selected + 1, max)
end