--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local sw,sh = guiGetScreenSize()
local zoom = 1920/sw
local w,h = 650,400
local screen = dxCreateScreenSource(w/zoom, h/zoom)

function render()
    dxDrawImage(sw-700/zoom, sh/2-h/2/zoom, w/zoom, h/zoom, screen, -10, 0, 0, tocolor(255, 255, 255, 222), false)
end

addEvent("fotka:starego", true)
addEventHandler("fotka:starego", resourceRoot, function()
	addEventHandler("onClientRender", root, render)
	dxUpdateScreenSource(screen)
	--playSound(":fotoradary/radar.wav")
	setTimer(function()
			removeEventHandler("onClientRender", root, render)
	end, 5000, 1)
end)

--replace

local txd = engineLoadTXD('models/suszarka.txd')
engineImportTXD(txd, 372)

local dff = engineLoadDFF('models/suszarka.dff', 372)
engineReplaceModel(dff, 372)

--

local dxLibary = exports.dxLibary

local interaction = {}

function isMouseIn(x, y, w, h)
	if not isCursorShowing() then return end

	local pos = {getCursorPosition()}
	pos[1],pos[2] = (pos[1]*sw),(pos[2]*sh)

	if pos[1] >= x and pos[1] <= (x+w) and pos[2] >= y and pos[2] <= (y+h) then
		return true
	end
	return false
end

function isEventHandlerAdded(eventName, rootName, fnc)
	if type(eventName) == 'string' and isElement(rootName) and type(fnc) == 'function' then
	  local eventHandlers = getEventHandlers(eventName, rootName)
	  if type(eventHandlers) == 'table' and #eventHandlers > 0 then
		for i,v in ipairs(eventHandlers) do
		  if v == fnc then
			return true
		  end
		end
	  end
	end
	return false
end

function isPedAiming()
	if getPedTask(localPlayer, 'secondary', 0) == 'TASK_SIMPLE_USE_GUN' then
		return true
	end
	return false
end

function getMax()
	local max = false
	for i,v in pairs(getElementsByType("colshape", resourceRoot)) do
		if(isElementWithinColShape(localPlayer, v))then
			local m = getElementData(v, "zone:suszarka") or 50
			max = m
			break
		end
	end
	return max
end

function interaction:Mouse() 
	if self['vehicle'] then 
		if(getElementData(localPlayer, "rank:duty"))then
			triggerServerEvent('interaction:admin', resourceRoot, self['vehicle'], self['selected_option']) 
		else
			local vx, vy, vz = getElementVelocity(self['vehicle'])
			local actual_speed = math.sqrt(vx^2+vy^2+vz^2)*190
			local max = getMax()
			if(max)then
				if(tonumber(actual_speed) > tonumber(max))then
					triggerServerEvent('mandat', resourceRoot, self['vehicle'])
				else
					outputChatBox("Minimum "..max.."km/h!")
				end
			end
		end
	end 
end

function interaction:Load()
	self['options'] = {
		'Napraw pojazd',
		'Obróć pojazd',
		'Oddaj do przechowalni',
		'Przenieś do siebie',
		'Przenieś do pojazdu',
		'Zatankuj pojazd'	
	}

	self['vehicle'] = false
	self['selected_option'] = 1

	self['render_fnc'] = function() self:Render() end
	self['mouse_fnc'] = function() self:Mouse() end
	self['switch_fnc'] = function(...) self:GetWeapon(...) end
	self['scroll_fnc'] = function(...) self:Scroll(...) end

	addEventHandler('onClientPlayerWeaponSwitch', root, self['switch_fnc'])
end

function interaction:GetWeapon(pW, cW)
	if getPedWeapon(localPlayer, cW) == 32 and not isEventHandlerAdded('onClientRender', root, self['render_fnc']) and not getElementData(localPlayer, 'user:line') then
		if(getElementData(localPlayer, "rank:duty"))then
			self['options'] = {
				'Napraw pojazd',
				'Obróć pojazd',
				'Oddaj do przechowalni',
				'Przenieś do siebie',
				'Przenieś do pojazdu',
				'Zatankuj pojazd'	
			}

			bindKey('mouse1', 'down', self['mouse_fnc'])
			bindKey('mouse_wheel_up', 'down', self['scroll_fnc'])
			bindKey('mouse_wheel_down', 'down', self['scroll_fnc'])
			addEventHandler('onClientRender', root, self['render_fnc'])
		elseif(getElementData(localPlayer, "user:faction") == "SAPD")then
			self['options'] = {
				'Wystaw mandat',
			}

			bindKey('mouse1', 'down', self['mouse_fnc'])
			bindKey('mouse_wheel_up', 'down', self['scroll_fnc'])
			bindKey('mouse_wheel_down', 'down', self['scroll_fnc'])
			addEventHandler('onClientRender', root, self['render_fnc'])
		end
	elseif getPedWeapon(localPlayer, cW) ~= 32 and isEventHandlerAdded('onClientRender', root, self['render_fnc']) then
		unbindKey('mouse1', 'down', self['mouse_fnc'])		
		unbindKey('mouse_wheel_up', 'down', self['scroll_fnc'])
		unbindKey('mouse_wheel_down', 'down', self['scroll_fnc'])
		removeEventHandler('onClientRender', root, self['render_fnc'])	
	end
end

function interaction:Scroll(key, keyState) 
	if key == 'mouse_wheel_up' then 
		self['selected_option'] = (self['selected_option'] > 1 and self['selected_option'] - 1 or #self['options'])
	elseif key == 'mouse_wheel_down' then 
		self['selected_option'] = (self['selected_option'] < #self['options'] and self['selected_option'] + 1 or 1)
	end 
end 

function interaction:Render()
	if isPedAiming() and getPlayerTarget(localPlayer) and getElementType(getPlayerTarget(localPlayer)) == 'vehicle' then
		self['vehicle'] = getPlayerTarget(localPlayer)
	else
		self['vehicle'] = false
	end

	if self['vehicle'] and isElement(self['vehicle']) then
		if(getElementData(localPlayer, "rank:duty"))then
			local id = getElementData(self['vehicle'], 'vehicle:id') or 0
			local name = getVehicleName(self['vehicle'])

			local poj = getElementData(self['vehicle'], 'vehicle:engine') or '1.6'
			poj = string.format('%.1f', poj)

			local fuel = getElementData(self['vehicle'], 'vehicle:fuel') or 25
			local gas = getElementData(self['vehicle'], 'vehicle:gas') or 25
			local bak = getElementData(self['vehicle'], 'vehicle:bak') or 25
			fuel = math.floor(fuel)
			gas = math.floor(gas)

			local distance = getElementData(self['vehicle'], 'vehicle:distance') or 0
			distance = string.format('%.1f', distance)

			local type = getElementData(self['vehicle'], 'vehicle:type') or 'Benzyna'

			local owner = getElementData(self['vehicle'], 'vehicle:ownerName') or '?'
			local last_driver = getElementData(self['vehicle'], 'vehicle:lastDriver') or 'brak'

			local fuel_text = 'Paliwo: #69bceb'..fuel..'/'..bak..'L'

			if type == 'LPG' then
				fuel_text = 'Paliwo: #69bceb'..fuel..'/'..bak..'L #929292|#ffffff Gaz: #69bceb'..gas..'/'..bak..'L'
			end

			dxLibary:dxLibary_createWindow(731/zoom, 7/zoom, 458/zoom, 140/zoom)
			dxLibary:dxLibary_text('Panel zarządzania pojazdem', 730/zoom, 6/zoom, 1188/zoom, 40/zoom, tocolor(255, 255, 255, 255), 5, 'default', 'center', 'center', false, false, false, false, false)
			dxLibary:dxLibary_text('ID: #69bceb'..id..' #929292|#ffffff Model: #69bceb'..name..' #929292|#ffffff Typ paliwa: #69bceb'..type..'#ffffff\nPrzebieg: #69bceb'..distance..'km #929292|#ffffff '..fuel_text..'#ffffff\nOstatni kierowca: #69bceb'..last_driver..' #929292|#ffffff Właściciel: #69bceb'..owner, 687/zoom, 14/zoom, 1232/zoom, 126/zoom, tocolor(255, 255, 255, 255), 1, 'default', 'center', 'center', false, false, false, true, false)
			dxLibary:dxLibary_text('#69bcebWybrana opcja:#929292 '..self['options'][self['selected_option']], 730/zoom, 100/zoom, 1188/zoom, 150/zoom, tocolor(255, 255, 255, 255), 3, 'default', 'center', 'center', false, false, false, true, false)
		elseif(getElementData(localPlayer, "user:faction") == "SAPD")then
			local vx, vy, vz = getElementVelocity(self['vehicle'])
			local actual_speed = math.sqrt(vx^2+vy^2+vz^2)*190
			local max = getMax() and getMax().."km/h" or "brak"
		
			dxLibary:dxLibary_createWindow(731/zoom, 7/zoom, 458/zoom, 140/zoom)
			dxLibary:dxLibary_text('Suszarka policji', 730/zoom, 6/zoom, 1188/zoom, 40/zoom, tocolor(255, 255, 255, 255), 5, 'default', 'center', 'center', false, false, false, false, false)
			dxLibary:dxLibary_text('Minimalna prędkość: '..max..'\nAktualna prędkość: '..math.floor(actual_speed).."km/h", 687/zoom, 14/zoom, 1232/zoom, 126/zoom, tocolor(255, 255, 255, 255), 1, 'default', 'center', 'center', false, false, false, true, false)
			dxLibary:dxLibary_text('#69bcebWybrana opcja:#929292 '..self['options'][self['selected_option']], 730/zoom, 100/zoom, 1188/zoom, 150/zoom, tocolor(255, 255, 255, 255), 3, 'default', 'center', 'center', false, false, false, true, false)
		end
	end
end

addEventHandler('onClientResourceStart', resourceRoot, function()
	interaction:Load()
end)
