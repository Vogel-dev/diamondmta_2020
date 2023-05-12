--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local dxLibary = exports['dxLibary']
local opv = exports['object_preview']
local anim = exports.dmta_base_anim

local start = 0

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

local skins = {}

function getTableRowsPairs(table)
	local x = 0
	for i,v in pairs(table) do
		x = x + 1
	end
	return x
end

local glowa = 0
local koszulka = 0
local spodnie = 0
local buty = 0

function skins:Load()
	self['skiny'] = {
		['Skiny męskie'] = {
      1, 2, 7, 14, 15, 16, 17, 19, 20, 21, 26, 27, 28, 29, 30, 32, 33, 34, 35, 36, 37, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 57, 58, 59, 60, 61, 62, 66, 67, 68, 70, 71, 72, 73, 78, 79, 80, 81, 82, 83, 84, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 112, 113, 114, 115, 116, 117, 118, 120, 121, 122, 123, 124, 125, 126, 127, 128, 132, 133, 134, 135, 136, 137, 142, 143, 144, 146, 147, 153, 154, 155, 156, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 170, 171, 173, 174, 175, 176, 177, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 200, 202, 203, 204, 206, 209, 210, 212, 213, 217, 220, 221, 222, 223, 227, 228, 229, 230, 234, 235, 236, 239, 240, 241, 242, 247, 248, 249, 250, 293
    },
		['Skiny żeńskie'] = {
      9, 10, 11, 12, 13, 31, 38, 39, 40, 41, 53, 54, 55, 56, 63, 64, 69, 75, 76, 77, 85, 87, 88, 89, 90, 91, 92, 93, 129, 130, 131, 138, 139, 140, 141, 145, 148, 150, 151, 152, 157, 169, 172, 178, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 201, 205, 207, 211, 214, 215, 216, 218, 219, 224, 225, 226, 231, 232, 233, 237, 238, 243, 244, 245, 246, 251, 256, 257, 263},
		['Skiny premium'] = {
			261, 270, 271, 272, 286, 287, 288, 290, 291, 300, 310, 311
		},
	}

	self['actual_skin'] = 1

	self['row'] = 1

	self['ped'] = false
	self['object'] = false

    self['arrow_txd'] = dxLibary:createTexture(':dmta_base_skinshop/images/arrow.png', 'dxt5', false, 'clamp')

	self['selected_page'] = false

	self['show_gui-fnc'] = function() self:ToggleGui() end
	self['render_fnc'] = function() self:Render() end
	self['clicked_fnc'] = function(button, keyState) self:Clicked(button, keyState) end
	self['scroll_fnc'] = function(key, keyState) self:Scroll(key, keyState) end
	self['key_cancel-fnc'] = function(button, press) self:KeyCancel(button, press) end
	self['rot_mouse-fnc'] = function(...) self:MouseRot(...) end

	addEvent('showGui', true)
	addEventHandler('showGui', resourceRoot, self['show_gui-fnc'])
end

function image(x, y, w, h, image, rot, a)
  if isMouseIn(x, y, w, h) and a == 255 then
    dxDrawImage(x, y, w, h, image, rot, 0, 0, tocolor(105, 188, 235, 200), false)
  else
    dxDrawImage(x, y, w, h, image, rot, 0, 0, tocolor(105, 188, 235, a), false)
  end
end

function skins:ToggleGui()
	setElementFrozen(localPlayer, true)

	showChat(false)
	showCursor(true)

	setElementData(localPlayer, 'pokaz:hud', false)
	setElementData(localPlayer, 'grey_shader', 1)

	addEventHandler('onClientRender', root, self['render_fnc'])
	addEventHandler('onClientClick', root, self['clicked_fnc'])
	addEventHandler('onClientKey', root, self['key_cancel-fnc'])
	addEventHandler('onClientCursorMove', root, self['rot_mouse-fnc'])

	bindKey('mouse_wheel_up', 'both', self['scroll_fnc'])
	bindKey('mouse_wheel_down', 'both', self['scroll_fnc'])

	self.lived = false
	self.type = 'join'
	self.tick = getTickCount()

	self['actual_skin'] = 0
	self['selected_page'] = false
	self['row'] = 1
	self['rot'] = 160

	for k,_ in pairs(self['skiny']) do
		for i,v in ipairs(self['skiny'][k]) do
			if v == getElementModel(localPlayer) then
				self['actual_skin'] = v
			end
		end
	end

  self['ped'] = createPed(self['actual_skin'], 2394.1474609375,-1731.9320068359,1070.4281005859)
  setElementInterior(self['ped'], 1)

  local w,h = 700/scale,700/scale
  self['object'] = opv:createObjectPreview(self['ped'], 0, 0, 0, (sw/2) - 50/scale, (sh/2) - (h/2), w, h, false, true, true)
end

function skins:Render()
	dxDrawRectangle(0, 0, 1920, 1080, tocolor(15, 15, 15, 200), false)
	if self.type == 'join' then
		a,self.lived = anim:animation(self.tick, 0, 255, 500, 'Linear')
		a2 = anim:animation(self.tick, 0, 235, 500, 'Linear')
		a3 = anim:animation(self.tick, 0, 100, 500, 'Linear')
	elseif self.type == 'quit' then
		a,self.lived = anim:animation(self.tick, 255, 0, 250, 'Linear')
		a2 = anim:animation(self.tick, 235, 0, 250, 'Linear')
		a3 = anim:animation(self.tick, 100, 0, 250, 'Linear')

		if not self.lived then
        	removeEventHandler('onClientRender', root, self['render_fnc'])
		end
	end

	if start == 0 and getKeyState('mouse1') then
		local _X_ = getCursorPosition()
		start = _X_ * sw
	elseif start ~= 0 and not getKeyState('mouse1') then
		start = 0
	end

 	dxLibary:dxLibary_text('#69bcebKlawiszologia:#ffffff\nUżyj klawisza ENTER aby zaakceptować wybór.\nUżyj klawisza ESC aby anulować wybór.', 649/scale, 0/scale, 1272/scale, 100/scale, tocolor(255, 255, 255, a), 3, 'default', 'center', 'center', false, false, false, true, false)

  if self.selected_page then
    local w,h = 700/scale,700/scale
    opv:setProjection(self['object'], (sw/2) - 50/scale, (sh/2) - (h/2), w, h, false, true)

		dxDrawImage(340/scale, 528/scale, 55/scale, 55/scale, self.arrow_txd, 0, 0, 0, tocolor(105, 188, 235, a), false)

		local y = -150/scale

		dxLibary:dxLibary_createWindowAlpha(400/scale, 355/scale + (y / 2), 278/scale, 394/scale - y, a)
		dxLibary:dxLibary_text('Wybierz skin', 450/scale, 390/scale + (y/1.5), 278/scale + 350/scale, 30/scale + 382/scale + (y/1.5), tocolor(105, 188, 235, a), 3, 'default', 'center', 'center', false, false, false, true, false)

		if(#self['skiny'][self['selected_page']] > 15)then
			local r = 32.8/scale * 15
			dxDrawRectangle(673/scale, 320/scale, 3/scale, r, tocolor(30, 30, 30, a2), false)
			dxDrawRectangle(673/scale, (320/scale + r / #self['skiny'][self['selected_page']] * (self['row']-1)), 3/scale, (r / #self['skiny'][self['selected_page']] * 15), tocolor(105, 188, 235, a2), false)
		end

		local x = 0
		for i,v in ipairs(self['skiny'][self['selected_page']]) do
			if (self['row']+14) >= i and self['row'] <= i then
				x = x + 1

				local sY = 33/scale * (x - 1)

				if self['actual_skin'] == v then
					dxLibary:dxLibary_createButtonAlpha('ID '..v, 410/scale, 395/scale + sY + (y / 2), 260/scale, 30/scale, 1, a2, true)
				else
					dxLibary:dxLibary_createButtonAlpha('ID '..v, 410/scale, 395/scale + sY + (y / 2), 260/scale, 30/scale, 1, a2, false)
				end
			end
		end
	end

	dxLibary:dxLibary_createWindowAlpha(50/scale, 475/scale, 278/scale, 170/scale, a)
	dxLibary:dxLibary_text('Wybierz typ', 50/scale, 200/scale, 278/scale + 50/scale, 394/scale + 400/scale, tocolor(105, 188, 235, a), 3, 'default', 'center', 'center', false, false, false, true, false)

	local x = 0
	for i,v in pairs(self['skiny']) do
		x = x + 1

		local sY = 40/scale * (x - 1)

		if self['selected_page'] == i then
			dxLibary:dxLibary_createButtonAlpha(i, 59/scale, 518/scale + sY, 260/scale, 35/scale, 1, a2, true)
		else
			dxLibary:dxLibary_createButtonAlpha(i, 59/scale, 518/scale + sY, 260/scale, 35/scale, 1, a2, false)
		end
	end

  local rot = self.rot
	opv:setRotation(self['object'], -5, 0, rot)
end

function skins:Scroll(key, keyState)
  if key == 'mouse_wheel_up' then
    if self['row'] > 1 then
      self['row'] = self['row'] - 1
    end
  elseif key == 'mouse_wheel_down' then
    if #self['skiny'][self['selected_page']] > (self['row']+14) then
      self['row'] = self['row'] + 1
    end
  end
end

function skins:MouseRot(_, _, x)
	if not getKeyState('mouse1') or not isCursorShowing() or self.selected_page and self.selected_page == 'Skiny premium' then return end

	if isMouseIn(810/scale, 195/scale, 930/scale, 759/scale) then
		if start < x then
			self['rot'] = self['rot'] + 2
		elseif start > x then
			self['rot'] = self['rot'] - 2
		end
	end
end

function skins:Clicked(button, state)
	if button ~= 'state' and state ~= 'down' then return end

	if self['selected_page'] then
		local y = -150/scale
		local x = 0
		for i,v in ipairs(self['skiny'][self['selected_page']]) do
			if (self['row']+14) >= i and self['row'] <= i then
				x = x + 1

				local sY = 33/scale * (x - 1)
				if isMouseIn(400/scale, 395/scale + sY + (y / 2), 278/scale, 30/scale) then
					self['actual_skin'] = v
					setElementModel(self['ped'], v)
				end
			end
		end
	end

	local x = 0
	local y = 65/scale * getTableRowsPairs(self['skiny'])
	for i,v in pairs(self['skiny']) do
		x = x + 1

		local sY = 40/scale * (x - 1)
		if isMouseIn(59/scale, 518/scale + sY, 260/scale, 35/scale) then
			if self['selected_page'] == i then
				self['selected_page'] = false
			else
				if i == 'Skiny premium' and not getElementData(localPlayer, 'user:premium') then
					exports['dmta_base_notifications']:addNotification('Nie posiadasz konta premium.', 'error')
				else
					self['selected_page'] = i
					self['row'] = 1
				end
			end
		end
	end
end

function skins:KeyCancel(button, press)
	if press then
		if button == 'escape' then
			setElementFrozen(localPlayer, false)

			showChat(true)
			showCursor(false)

			setElementData(localPlayer, 'pokaz:hud', true)
			setElementData(localPlayer, 'grey_shader', 0)

			removeEventHandler('onClientClick', root, self['clicked_fnc'])
			removeEventHandler('onClientKey', root, self['key_cancel-fnc'])
			removeEventHandler('onClientCursorMove', root, self['rot_mouse-fnc'])

			unbindKey('mouse_wheel_up', 'both', self['scroll_fnc'])
			unbindKey('mouse_wheel_down', 'both', self['scroll_fnc'])

			destroyElement(self['ped'])
			destroyElement(self['object'])

			self['ped'] = false
			self['object'] = false

			self.type = 'quit'
			self.tick = getTickCount()

			cancelEvent()
		elseif button == 'enter' then
			triggerServerEvent('changeSkin', resourceRoot, getElementModel(self['ped']))

			setElementFrozen(localPlayer, false)

			showChat(true)
			showCursor(false)

			setElementData(localPlayer, 'pokaz:hud', true)
			setElementData(localPlayer, 'grey_shader', 0)

			removeEventHandler('onClientClick', root, self['clicked_fnc'])
			removeEventHandler('onClientKey', root, self['key_cancel-fnc'])
			removeEventHandler('onClientCursorMove', root, self['rot_mouse-fnc'])

			unbindKey('mouse_wheel_up', 'both', self['scroll_fnc'])
			unbindKey('mouse_wheel_down', 'both', self['scroll_fnc'])

			destroyElement(self['ped'])
			destroyElement(self['object'])

			self['ped'] = false
			self['object'] = false

			self.type = 'quit'
			self.tick = getTickCount()
		end
	end
end

addEventHandler('onClientResourceStart', resourceRoot, function()
	skins:Load()
end)
