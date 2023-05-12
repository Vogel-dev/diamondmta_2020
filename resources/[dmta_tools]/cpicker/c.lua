--[[
Skrypt został edytowany przez:
   -Asper (nezymr69@gmail.com).

Na potrzeby serwera:
   -WestRPG (2018).
]]

local dxLibary = exports.dxLibary

local sw,sh = guiGetScreenSize()
local baseX = 1920
local scale = 1
local minScale = 2
if sw < baseX then
    scale = math.min(minScale, baseX/sw)
end

local colorPicker = {}
local sv,h,cursor = dxLibary:createTexture(':cpicker/images/sv.png'),dxLibary:createTexture(':cpicker/images/h.png'),dxLibary:createTexture(':cpicker/images/cursor.png')

function colorPicker:create(x, y)
  self.color = {}
  self.color.h, self.color.s, self.color.v, self.color.r, self.color.g, self.color.b, self.color.hex = 0, 1, 1, 255, 0, 0, '#FF0000'
  self.color.white = tocolor(255,255,255,255)
  self.color.black = tocolor(0,0,0,255)
  self.color.current = {255,0,0}
  self.color.huecurrent = tocolor(255,0,0,255)

  self.gui = {}
  self.gui.snaptreshold = 0.02

  self.created = true

  self.gui.svmap = guiCreateStaticImage(x, y, 256/scale, 256/scale, 'images/blank.png', false)
  self.gui.hbar = guiCreateStaticImage(x + 256/scale + 10/scale, y, 10/scale, 256/scale, 'images/blank.png', false)

  guiSetAlpha(self.gui.svmap, 0)
  guiSetAlpha(self.gui.hbar, 0)

  self.handlers = {}
  self.handlers.mouseDown = function() self:mouseDown() end
  self.handlers.mouseSnap = function() self:mouseSnap() end
  self.handlers.mouseUp = function(b,s) self:mouseUp(b,s) end
  self.handlers.mouseMove = function(x,y) self:mouseMove(x,y) end
  self.handlers.render = function() self:render() end
  self.handlers.pickColor = function() self:pickColor() end

  addEventHandler('onClientGUIMouseDown', self.gui.svmap, self.handlers.mouseDown, false)
  addEventHandler('onClientMouseLeave', self.gui.svmap, self.handlers.mouseSnap, false)
  addEventHandler('onClientMouseMove', self.gui.svmap, self.handlers.mouseMove, false)
  addEventHandler('onClientGUIMouseDown', self.gui.hbar, self.handlers.mouseDown, false)
  addEventHandler('onClientMouseMove', self.gui.hbar, self.handlers.mouseMove, false)
  addEventHandler('onClientClick', resourceRoot, self.handlers.mouseUp)
  addEventHandler('onClientGUIMouseUp', resourceRoot, self.handlers.mouseUp)
  addEventHandler('onClientRender', root, self.handlers.render)
end

function colorPicker:render()
  local x256 = 256/scale
  local x,y = guiGetPosition(self.gui.svmap, false)
  dxDrawRectangle(x, y, 256/scale, 256/scale, self.color.huecurrent, true)
  dxDrawImage(x, y, 256/scale, 256/scale, sv, 0, 0, 0, self.color.white, true)
  dxDrawImage(x - (60/scale) + math.floor(x256*self.color.s), y - (60/scale) + (x256-math.floor(x256*self.color.v)), 125/scale, 125/scale, cursor, 0, 0, 0, tocolor(0, 0, 0), true)

  local x,y = guiGetPosition(self.gui.hbar, false)
  dxDrawImage(x, y, 10/scale, 256/scale, h, 0, 0, 0, self.color.white, true)
  dxDrawRectangle(x + (15/scale), y + (x256-math.floor(x256*self.color.h)) - 2/scale, 13/scale, 2/scale, tocolor(222, 222, 222), true)
end

function colorPicker:mouseDown()
  if source == self.gui.svmap or source == self.gui.hbar then
    self.gui.track = source
    local cx, cy = getCursorPosition()
    self:mouseMove(sw*cx, sh*cy)
  end
end

function colorPicker:mouseUp(button, state)
  if not state or state ~= 'down' then
    if self.gui.track then
      triggerEvent('onColorPickerChange', root, self.id, self.color.hex, self.color.r, self.color.g, self.color.b)
    end

    self.gui.track = false
  end
end

function colorPicker:mouseMove(x,y)
  if self.gui.track and source == self.gui.track then
    local gx,gy = guiGetPosition(self.gui.svmap, false)
    local x255 = 255/scale
    if source == self.gui.svmap then
      local offsetx, offsety = x - gx, y - gy
      self.color.s = offsetx/x255
      self.color.v = (x255-offsety)/x255
    elseif source == self.gui.hbar then
      local offset = y - gy
      self.color.h = (x255-offset)/x255
    end

    self:updateColor()
  end
end

function colorPicker:mouseSnap()
  if self.gui.track and source == self.gui.track then
    if self.color.s < self.gui.snaptreshold or self.color.s > 1-self.gui.snaptreshold then self.color.s = math.round(self.color.s) end
    if self.color.v < self.gui.snaptreshold or self.color.v > 1-self.gui.snaptreshold then self.color.v = math.round(self.color.v) end
    self:updateColor()
  end
end

function colorPicker:updateColor()
  self.color.r, self.color.g, self.color.b = hsv2rgb(self.color.h, self.color.s, self.color.v)
  self.color.current = {self.color.r, self.color.g, self.color.b}
  self.color.huecurrent = tocolor(hsv2rgb(self.color.h, 1, 1))
  self.color.hex = string.format('#%02X%02X%02X', self.color.r, self.color.g, self.color.b)
end

function colorPicker:pickColor()
  triggerEvent('onColorPickerOK', root, self.id, self.color.hex, self.color.r, self.color.g, self.color.b)
  self:destroy()
end

function hsv2rgb(h, s, v)
  local r, g, b
  local i = math.floor(h * 6)
  local f = h * 6 - i
  local p = v * (1 - s)
  local q = v * (1 - f * s)
  local t = v * (1 - (1 - f) * s)
  local switch = i % 6
  if switch == 0 then
    r = v g = t b = p
  elseif switch == 1 then
    r = q g = v b = p
  elseif switch == 2 then
    r = p g = v b = t
  elseif switch == 3 then
    r = p g = q b = v
  elseif switch == 4 then
    r = t g = p b = v
  elseif switch == 5 then
    r = v g = p b = q
  end
  return math.floor(r*255), math.floor(g*255), math.floor(b*255)
end

function math.round(v)
  return math.floor(v+0.5)
end

addEvent('onColorPickerOK', true)
addEvent('onColorPickerChange', true)

function createCPicker(x, y, w, h)
  colorPicker:create(x, y, w, h)
end

function destroyCPicker()
  if not colorPicker.created then return end

  removeEventHandler('onClientGUIMouseDown', colorPicker.gui.svmap, colorPicker.handlers.mouseDown, false)
  removeEventHandler('onClientMouseLeave', colorPicker.gui.svmap, colorPicker.handlers.mouseSnap, false)
  removeEventHandler('onClientMouseMove', colorPicker.gui.svmap, colorPicker.handlers.mouseMove, false)
  removeEventHandler('onClientGUIMouseDown', colorPicker.gui.hbar, colorPicker.handlers.mouseDown, false)
  removeEventHandler('onClientMouseMove', colorPicker.gui.hbar, colorPicker.handlers.mouseMove, false)
  removeEventHandler('onClientClick', resourceRoot, colorPicker.handlers.mouseUp)
  removeEventHandler('onClientGUIMouseUp', resourceRoot, colorPicker.handlers.mouseUp)
  removeEventHandler('onClientRender', root, colorPicker.handlers.render)

  destroyElement(colorPicker.gui.svmap)
  destroyElement(colorPicker.gui.hbar)

  colorPicker.created = false
end

function getCPickerSelectedColor()
  if colorPicker.created then
    return unpack(colorPicker.color.current)
  end
  return 255,255,255
end
