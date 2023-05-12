--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local noti = exports.dmta_base_notifications
local dxLibary = exports.dxLibary

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

local object = nil

class 'editor'
{
	cursor = nil,
	attach = nil,
	moveX = 0,
	moveY = 0,

	destroy = nil,

	changingPosition = nil,
	changingRotation = nil,

	changingPositionX = nil,
	changingPositionY = nil,
	changingPositionZ = nil,

	changingRotationX = nil,
	changingRotationY = nil,
	changingRotationZ = nil,

	fncs = nil,

	lastPos = {},
	lastRot = {},

	load = function(self)
		self.acceptTexture = dxLibary:createTexture(':dmta_tool_objects/images/accept.png')
		self.cancelTexture = dxLibary:createTexture(':dmta_tool_objects/images/cancel.png')
		self.positionTexture = dxLibary:createTexture(':dmta_tool_objects/images/position.png')
		self.rotationTexture = dxLibary:createTexture(':dmta_tool_objects/images/rotation.png')
		self.attachTexture = dxLibary:createTexture(':dmta_tool_objects/images/attach.png')
		self.backTexture = dxLibary:createTexture(':dmta_tool_objects/images/back.png')

		self.key_fnc = function(...) self:onKey(...) end
	end,

	__init__ = function(self, id, x, y, z, int, dim)
		if not self.fncs then
			self.render_fnc = function() self:onRender() end
			self.click_fnc = function(...) self:onClick(...) end
			self.move_fnc = function(...) self:onMove(...) end
			self.fncs = true
		end

		object = createObject(id, x, y, z)
		if object and isElement(object) then
			setElementDimension(object, (dim or 0))
			setElementInterior(object, (int or 0))
			setElementCollisionsEnabled(object, false)

			addEventHandler('onClientRender', root, self.render_fnc)
			addEventHandler('onClientClick', root, self.click_fnc)
			addEventHandler('onClientCursorMove', root, self.move_fnc)

			self.attach = nil

			self.moveX = 0
			self.moveY = 0

			self.destroy = nil

			self.changingPosition = nil
			self.changingRotation = nil

			self.changingPositionX = nil
			self.changingPositionY = nil
			self.changingPositionZ = nil

			self.changingRotationX = nil
			self.changingRotationY = nil
			self.changingRotationZ = nil

			self.lastPos = {getElementPosition(object)}
			self.lastRot = {getElementRotation(object)}
		else
			noti:addNotification('Obiekt o podanym id, nie istnieje.', 'error')
		end
	end,

	onObjectClick = function(self, button, state, _, _, _, _, _, element)
		if button == 'left' and state == 'down' and self.cursor and element and isElement(element) and getElementType(element) == 'object' and getElementData(element, 'object:editor') and not object then
			if not self.fncs then
				self.render_fnc = function() self:onRender() end
				self.click_fnc = function(...) self:onClick(...) end
				self.move_fnc = function(...) self:onMove(...) end
				self.fncs = true
			end

			addEventHandler('onClientRender', root, self.render_fnc)
			addEventHandler('onClientClick', root, self.click_fnc)
			addEventHandler('onClientCursorMove', root, self.move_fnc)

			object = element

			self.attach = nil

			self.moveX = 0
			self.moveY = 0

			self.changingPosition = nil
			self.changingRotation = nil

			self.changingPositionX = nil
			self.changingPositionY = nil
			self.changingPositionZ = nil

			self.changingRotationX = nil
			self.changingRotationY = nil
			self.changingRotationZ = nil
			self.destroy = getElementData(element, 'object:editor')

			self.lastPos = {getElementPosition(object)}
			self.lastRot = {getElementRotation(object)}
		end
	end,

	customImage = function(self, x, y, w, h, image, value)
		if not x or not y or not w or not h or not image then return end

		if isMouseIn(x, y, w, h) then
			dxDrawImage(x, y, w, h, image, 0, 0, 0, tocolor(255, 255, 255, 175), false)

			if value and getKeyState('mouse1') and not self[value] then
				self[value] = true
			end
		else
			dxDrawImage(x, y, w, h, image, 0, 0, 0, tocolor(255, 255, 255, 255), false)

			if value and not getKeyState('mouse1') and self[value] then
				self[value] = nil
			end
		end
	end,

	onRender = function(self)
		if not object or object and not isElement(object) then
			removeEventHandler('onClientRender', root, self.render_fnc)
			removeEventHandler('onClientClick', root, self.click_fnc)
			removeEventHandler('onClientCursorMove', root, self.move_fnc)

			object = nil
			return
		end

		if getElementDimension(object) == getElementDimension(localPlayer) and getElementInterior(object) == getElementInterior(localPlayer) then
			local pos = {getElementPosition(object)}
			local pos_1 = {getPositionFromElementOffset(object, 2, 0, 0)}
			local pos_2 = {getPositionFromElementOffset(object, 0, 2, 0)}
			local pos_3 = {getPositionFromElementOffset(object, 0, 0, 2)}

			dxLineOnWorldFromScreenPosition(pos[1], pos[2], pos[3], pos_1[1], pos_1[2], pos_1[3], tocolor(0, 0, 255, 255))
			dxLineOnWorldFromScreenPosition(pos[1], pos[2], pos[3], pos_2[1], pos_2[2], pos_2[3], tocolor(0, 255, 0, 255))
			dxLineOnWorldFromScreenPosition(pos[1], pos[2], pos[3], pos_3[1], pos_3[2], pos_3[3], tocolor(255, 0, 0, 255))

			if self.cursor and isCursorShowing() then
				local cursor = {getCursorPosition()}
				cursor[1], cursor[2] = cursor[1] * sw, cursor[2] * sh

				local sX, sY = getScreenFromWorldPosition(pos[1], pos[2], pos[3])
				if sX and sY then
					if self.changingPosition then
						if self.changingPositionX and (self.changingPositionY or self.changingPositionZ) then
							self.changingPositionZ = nil
							self.changingPositionY = nil
						elseif self.changingPositionY and (self.changingPositionX or self.changingPositionZ) then
							self.changingPositionX = nil
							self.changingPositionZ = nil
						elseif self.changingPositionZ and (self.changingPositionY or self.changingPositionX) then
							self.changingPositionX = nil
							self.changingPositionY = nil
						end

						local sX_x, sX_y = getScreenFromWorldPosition(pos_1[1], pos_1[2], pos_1[3])
						local sY_x, sY_y = getScreenFromWorldPosition(pos_2[1], pos_2[2], pos_2[3])
						local sZ_x, sZ_y = getScreenFromWorldPosition(pos_3[1], pos_3[2], pos_3[3])

						if sX_x and sX_y then
							self:customImage(sX_x, sX_y, 64/scale, 64/scale, self.positionTexture, 'changingPositionX')
							dxLibary:dxLibary_shadowText2('Pozycja X', sX_x, sX_y, 64/scale + sX_x, 64/scale + sX_y + (100/scale), tocolor(255, 255, 255, 255), 1, 'default', 'center', 'center', false)
						end

						if sY_x and sY_y then
							self:customImage(sY_x, sY_y, 64/scale, 64/scale, self.positionTexture, 'changingPositionY')
							dxLibary:dxLibary_shadowText2('Pozycja Y', sY_x, sY_y, 64/scale + sY_x, 64/scale + sY_y + (100/scale), tocolor(255, 255, 255, 255), 1, 'default', 'center', 'center', false)
						end

						if sZ_x and sZ_y then
							self:customImage(sZ_x, sZ_y, 64/scale, 64/scale, self.positionTexture, 'changingPositionZ')
							dxLibary:dxLibary_shadowText2('Pozycja Z', sZ_x, sZ_y, 64/scale + sZ_x, 64/scale + sZ_y + (100/scale), tocolor(255, 255, 255, 255), 1, 'default', 'center', 'center', false)
						end

						self:customImage(sX, sY, 64/scale, 64/scale, self.backTexture)
						dxLibary:dxLibary_shadowText2('Cofnij', sX, sY, 64/scale + sX, 64/scale + sY + (100/scale), tocolor(255, 255, 255, 255), 1, 'default', 'center', 'center', false)
					elseif self.changingRotation then
						if self.changingRotationX and (self.changingRotationY or self.changingRotationZ) then
							self.changingRotationZ = nil
							self.changingRotationY = nil
						elseif self.changingRotationY and (self.changingRotationX or self.changingRotationZ) then
							self.changingRotationX = nil
							self.changingRotationZ = nil
						elseif self.changingRotationZ and (self.changingRotationY or self.changingRotationX) then
							self.changingRotationX = nil
							self.changingRotationY = nil
						end

						local sX_x, sX_y = getScreenFromWorldPosition(pos_1[1], pos_1[2], pos_1[3])
						local sY_x, sY_y = getScreenFromWorldPosition(pos_2[1], pos_2[2], pos_2[3])
						local sZ_x, sZ_y = getScreenFromWorldPosition(pos_3[1], pos_3[2], pos_3[3])

						if sX_x and sX_y then
							self:customImage(sX_x, sX_y, 64/scale, 64/scale, self.rotationTexture, 'changingRotationX')
							dxLibary:dxLibary_shadowText2('Rotacja X', sX_x, sX_y, 64/scale + sX_x, 64/scale + sX_y + (100/scale), tocolor(255, 255, 255, 255), 1, 'default', 'center', 'center', false)
						end

						if sY_x and sY_y then
							self:customImage(sY_x, sY_y, 64/scale, 64/scale, self.rotationTexture, 'changingRotationY')
							dxLibary:dxLibary_shadowText2('Rotacja Y', sY_x, sY_y, 64/scale + sY_x, 64/scale + sY_y + (100/scale), tocolor(255, 255, 255, 255), 1, 'default', 'center', 'center', false)
						end

						if sZ_x and sZ_y then
							self:customImage(sZ_x, sZ_y, 64/scale, 64/scale, self.rotationTexture, 'changingRotationZ')
							dxLibary:dxLibary_shadowText2('Rotacja Z', sZ_x, sZ_y, 64/scale + sZ_x, 64/scale + sZ_y + (100/scale), tocolor(255, 255, 255, 255), 1, 'default', 'center', 'center', false)
						end

						self:customImage(sX, sY, 64/scale, 64/scale, self.backTexture)
						dxLibary:dxLibary_shadowText2('Cofnij', sX, sY, 64/scale + sX, 64/scale + sY + (100/scale), tocolor(255, 255, 255, 255), 1, 'default', 'center', 'center', false)
					else
						self:customImage(sX, sY, 64/scale, 64/scale, self.positionTexture)
						dxLibary:dxLibary_shadowText2('Pozycja', sX, sY, 64/scale + sX, 64/scale + sY + (100/scale), tocolor(255, 255, 255, 255), 1, 'default', 'center', 'center', false)

						self:customImage(sX + (425/scale), sY, 64/scale, 64/scale, self.cancelTexture)
						dxLibary:dxLibary_shadowText2('Usuń', sX + (425/scale), sY, 64/scale + sX + (425/scale), 64/scale + sY + (100/scale), tocolor(255, 255, 255, 255), 1, 'default', 'center', 'center', false)

						self:customImage(sX + (340/scale), sY, 64/scale, 64/scale, self.backTexture)
						dxLibary:dxLibary_shadowText2('Anuluj', sX + (340/scale), sY, 64/scale + sX + (340/scale), 64/scale + sY + (100/scale), tocolor(255, 255, 255, 255), 1, 'default', 'center', 'center', false)

						self:customImage(sX + (255/scale), sY, 64/scale, 64/scale, self.acceptTexture)
						dxLibary:dxLibary_shadowText2('Zapisz', sX + (255/scale), sY, 64/scale + sX + (255/scale), 64/scale + sY + (100/scale), tocolor(255, 255, 255, 255), 1, 'default', 'center', 'center', false)

						self:customImage(sX + (170/scale), sY, 64/scale, 64/scale, self.attachTexture)
						dxLibary:dxLibary_shadowText2((self.attach and 'Odczep' or 'Przyczep'), sX + (170/scale), sY, 64/scale + sX + (170/scale), 64/scale + sY + (100/scale), tocolor(255, 255, 255, 255), 1, 'default', 'center', 'center', false)

						self:customImage(sX + (85/scale), sY, 64/scale, 64/scale, self.rotationTexture)
						dxLibary:dxLibary_shadowText2('Rotacja', sX + (85/scale), sY, 64/scale + sX + (85/scale), 64/scale + sY  + (100/scale), tocolor(255, 255, 255, 255), 1, 'default', 'center', 'center', false)
					end
				end
			end
		end
	end,

	onKey = function(self, key, state)
		if key == 'mouse2' and state and getElementData(localPlayer, 'user:objects', true) then
			if self.cursor then
				showCursor(false)
				self.cursor = nil
			else
				showCursor(true, false)
				self.cursor = true
			end
		end
	end,

	onClick = function(self, button, state)
		if not object or object and not isElement(object) or not self.cursor then return end

		local pos = {getElementPosition(object)}
		local sX, sY = getScreenFromWorldPosition(pos[1], pos[2], pos[3])

		if button ~= 'left' or state ~= 'down' or not sX or not sY then return end

		if isMouseIn(sX, sY, 64/scale, 64/scale) and not self.changingPosition and not self.changingRotation then
			self.changingPosition = true
		elseif isMouseIn(sX, sY, 64/scale, 64/scale) and (self.changingRotation or self.changingPosition) then
			self.changingRotation = nil
			self.changingPosition = nil
		elseif isMouseIn(sX + (85/scale), sY, 64/scale, 64/scale) and not self.changingPosition and not self.changingRotation then
			self.changingRotation = true
		elseif isMouseIn(sX + (170/scale), sY, 64/scale, 64/scale) and not self.changingPosition and not self.changingRotation then
			if self.attach then
				detachElements(object, localPlayer)
				self.attach = nil
			else
				attachElements(object, localPlayer, 1, 0, 0)
				self.attach = true
			end
		elseif isMouseIn(sX + (255/scale), sY, 64/scale, 64/scale) and not self.changingPosition and not self.changingRotation then
			if self.attach then
				noti:addNotification('Aby zapisać, puść element.', 'info')
				return
			end

			local id = getElementModel(object)
			local x, y, z = getElementPosition(object)
			local rx, ry, rz = getElementRotation(object)
			triggerServerEvent('save:object', resourceRoot, id, x, y, z, rx, ry, rz, self.destroy)

			self.destroy = nil

			removeEventHandler('onClientRender', root, self.render_fnc)
			removeEventHandler('onClientClick', root, self.click_fnc)
			removeEventHandler('onClientCursorMove', root, self.move_fnc)

			if object and isElement(object) then
				destroyElement(object)
				object = nil
			end

			if self.cursor then
				self.cursor = nil
				showCursor(false)
			end
		elseif isMouseIn(sX + (340/scale), sY, 64/scale, 64/scale) and not self.changingPosition and not self.changingRotation and not self.attach then
			if self.cursor then
				self.cursor = nil
				showCursor(false)
			end

			if self.destroy then
				local id = getElementModel(object)
				local x, y, z = unpack(self.lastPos)
				local rx, ry, rz = unpack(self.lastRot)
				triggerServerEvent('save:object', resourceRoot, id, x, y, z, rx, ry, rz, self.destroy)

				self.destroy = nil
				object = nil
			else
				setElementPosition(object, unpack(self.lastPos))
				setElementRotation(object, unpack(self.lastRot))
				return
			end

			removeEventHandler('onClientRender', root, self.render_fnc)
			removeEventHandler('onClientClick', root, self.click_fnc)
			removeEventHandler('onClientCursorMove', root, self.move_fnc)
		elseif isMouseIn(sX + (425/scale), sY, 64/scale, 64/scale) and not self.changingPosition and not self.changingRotation and not self.attach then
			removeEventHandler('onClientRender', root, self.render_fnc)
			removeEventHandler('onClientClick', root, self.click_fnc)
			removeEventHandler('onClientCursorMove', root, self.move_fnc)

			if object and isElement(object) then
				if self.destroy then
					triggerServerEvent('destroy:object', resourceRoot, self.destroy)
					self.destroy = nil
					object = nil
				else
					destroyElement(object)
					object = nil
				end
			end

			if self.cursor then
				self.cursor = nil
				showCursor(false)
			end
		end
	end,

	onMove = function(self, _, _, absoluteX, absoluteY, x, y)
		if not isCursorShowing() or not getKeyState('mouse1') or not object or object and not isElement(object) then return end

		local pos = {getElementPosition(object)}
		local rot = {getElementRotation(object)}
    if not last then last = pos[3] end

		local value = 0.025
    local depth = 4.5
    local pos_1 = {getPositionFromElementOffset(object, 2, 0, 0)}
    local pos_2 = {getPositionFromElementOffset(object, 0, 2, 0)}
    local pos_3 = {getPositionFromElementOffset(object, 0, 0, 2)}
    local w_1,w_2,w_3 = (pos[1] - pos_1[1]), (pos[2] - pos_2[2]), (pos[3] - pos_3[3])

		if self.changingPositionX then
      local x, y, z = getWorldFromScreenPosition(absoluteX, absoluteY, depth)
			setElementPosition(object, x + w_1, pos[2], pos[3])
		elseif self.changingPositionY then
      local x, y, z = getWorldFromScreenPosition(absoluteX, absoluteY, depth)
			setElementPosition(object, pos[1], y + w_2, pos[3])
		elseif self.changingPositionZ then
      local x, y, z = getWorldFromScreenPosition(absoluteX, absoluteY, depth)
			setElementPosition(object, pos[1], pos[2], z + w_3)
		elseif self.changingRotationX then
			value = value * 50
			rot = {rot[1] + (y > self.moveY and -value or value), rot[2], rot[3]}
			setElementRotation(object, unpack(rot))
			self.moveX, self.moveY = x, y
		elseif self.changingRotationY then
			value = value * 50
			rot = {rot[1], rot[2] + (x > self.moveX and -value or value), rot[3]}
			setElementRotation(object, unpack(rot))
			self.moveX, self.moveY = x, y
		elseif self.changingRotationZ then
			value = value * 50
			rot = {rot[1], rot[2], rot[3] + (x > self.moveX and -value or value)}
			setElementRotation(object, unpack(rot))
			self.moveX, self.moveY = x, y
		end
	end,
}


addCommandHandler('obj', function()
	if getElementData(localPlayer, 'rank:duty') >= 4 then
		if getElementData(localPlayer, 'user:objects') then
			noti:addNotification('Rysowanie objektów wyłączone.', 'success')
			setElementData(localPlayer, 'user:objects', false)
		else
			noti:addNotification('Rysowanie objektów właczone.', 'success')
			setElementData(localPlayer, 'user:objects', true)
		end
	end
end)

addCommandHandler('oc', function(_, id)
	if getElementData(localPlayer, 'user:objects', true) then
		local int,dim = getElementInterior(localPlayer), getElementDimension(localPlayer)
		local x,y,z = getElementPosition(localPlayer)
		editor(id, x, y, z, int, dim)
	end
end)

addEventHandler('onClientResourceStart', resourceRoot, function()
	editor:load()

	local click_fnc = function(...) editor:onObjectClick(...) end
	addEventHandler('onClientClick', root, click_fnc)
	addEventHandler('onClientKey', root, editor.key_fnc)
end)

function getElementMatrix(element)
    local rx, ry, rz = getElementRotation(element, "ZXY")
    rx, ry, rz = math.rad(rx), math.rad(ry), math.rad(rz)
    local matrix = {}
    matrix[1] = {}
    matrix[1][1] = math.cos(rz)*math.cos(ry) - math.sin(rz)*math.sin(rx)*math.sin(ry)
    matrix[1][2] = math.cos(ry)*math.sin(rz) + math.cos(rz)*math.sin(rx)*math.sin(ry)
    matrix[1][3] = -math.cos(rx)*math.sin(ry)
    matrix[1][4] = 1

    matrix[2] = {}
    matrix[2][1] = -math.cos(rx)*math.sin(rz)
    matrix[2][2] = math.cos(rz)*math.cos(rx)
    matrix[2][3] = math.sin(rx)
    matrix[2][4] = 1

    matrix[3] = {}
    matrix[3][1] = math.cos(rz)*math.sin(ry) + math.cos(ry)*math.sin(rz)*math.sin(rx)
    matrix[3][2] = math.sin(rz)*math.sin(ry) - math.cos(rz)*math.cos(ry)*math.sin(rx)
    matrix[3][3] = math.cos(rx)*math.cos(ry)
    matrix[3][4] = 1

    matrix[4] = {}
    matrix[4][1], matrix[4][2], matrix[4][3] = getElementPosition(element)
    matrix[4][4] = 1

    return matrix
end

function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix ( element )
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z
end

function dxLineOnWorldFromScreenPosition(startX, startY, startZ, endX, endY, endZ, color)
	startX, startY = getScreenFromWorldPosition(startX, startY, startZ, 10)
	endX, endY = getScreenFromWorldPosition(endX, endY, endZ, 10)

	if startX and startY and endX and endY and color then
		dxDrawLine(startX, startY, endX, endY, color, 1, false)
	end
end
