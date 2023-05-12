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

local textures = {
  ['info'] = dxLibary:createTexture(':dmta_base_notifications/images/info.png', 'dxt5', false, 'clamp'),
  ['success'] = dxLibary:createTexture(':dmta_base_notifications/images/success.png', 'dxt5', false, 'clamp'),
  ['error'] = dxLibary:createTexture(':dmta_base_notifications/images/error.png', 'dxt5', false, 'clamp'),

  ['pasek_1'] = dxLibary:createTexture(':dmta_base_notifications/images/pasek_1.png', 'dxt5', false, 'clamp'),
  ['pasek_2'] = dxLibary:createTexture(':dmta_base_notifications/images/pasek_2.png', 'dxt5', false, 'clamp'),
  ['pasek_3'] = dxLibary:createTexture(':dmta_base_notifications/images/pasek_3.png', 'dxt5', false, 'clamp'),
}

local notifications = {}
local tick = getTickCount()

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

function addNotification(text, type)
	if #notifications >= 3 then
		table.remove(notifications, 1)
	end
  
	table.insert(notifications, {text, getTickCount(), false, toType(type)})

  if not isEventHandlerAdded('onClientRender', root, gui) then
    addEventHandler('onClientRender', root, gui)
  end
end

function toType(type)
	if type == 'info' then
		return {textures['pasek_2'], textures['info']}
	elseif type == 'error' then
		return {textures['pasek_3'], textures['error']}
	elseif type == 'success' then
		return {textures['pasek_1'], textures['success']}
	end
	return {textures['pasek_1'], textures['success']}
end

addEvent('addNotification', true)
addEventHandler('addNotification', resourceRoot, function(text, type)
	addNotification(text, type)
end)

function gui()
  if #notifications < 1 then
    removeEventHandler('onClientRender', root, gui)
  end

	for i,v in ipairs(notifications) do
		local sx = 70/scale * i

		if (getTickCount()-v[2]) > 6000 and v[3] ~= true then
			v[2] = getTickCount()
			v[3] = true
		end

    local pasek,img = unpack(v[4])
    local x1 = sh-(920/scale)
		if v[3] ~= true then
      local a1 = interpolateBetween(0, 0, 0, 255, 235, 0, (getTickCount()-v[2])/500, 'Linear')
      local y1 = interpolateBetween(sw, sw, 0, sw-(390/scale), 0, 0, (getTickCount()-v[2])/500, 'Linear')

      dxDrawImage(y1, x1 + sx, 385/scale, 60/scale, pasek, 0, 0, 0, tocolor(255, 255, 255, a1), false)
      dxDrawImage(y1 + 8/scale, x1 + 8/scale + sx, 45/scale, 45/scale, img, 0, 0, 0, tocolor(255, 255, 255, a1), false)
      dxLibary:dxLibary_text(v[1], y1 + 75/scale, x1 + sx, 355/scale + y1, 60/scale + x1 + sx, tocolor(255, 255, 255, a1), 2, 'default', 'left', 'center', false, true, false, false, false)
		else
      local a1 = interpolateBetween(255, 235, 0, 0, 0, 0, (getTickCount()-v[2])/500, 'Linear')
      local y1 = interpolateBetween(sw-(390/scale), 0, 0, sw, 0, 0, (getTickCount()-v[2])/500, 'Linear')

      local c = sw-(500/scale)
      dxDrawImage(y1, x1 + sx, 385/scale, 60/scale, pasek, 0, 0, 0, tocolor(255, 255, 255, a1), false)
      dxDrawImage(y1 + 8, x1 + 8/scale + sx, 45/scale, 45/scale, img, 0, 0, 0, tocolor(255, 255, 255, a1), false)
      dxLibary:dxLibary_text(v[1], y1 + 75/scale, x1 + sx, 355/scale + y1, 60/scale + x1 + sx, tocolor(255, 255, 255, a1), 2, 'default', 'left', 'center', false, true, false, false, false)

      if (getTickCount()-v[2]) > 500 then
				table.remove(notifications, i)
			end
    end
  end
end