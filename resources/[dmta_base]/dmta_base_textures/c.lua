--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

-- Async:setDebug(true)
Async:setPriority(50, 0)

local dxLibary = exports.dxLibary

local sw,sh = guiGetScreenSize()
local baseX = 1920
local scale = 1
local minScale = 2
if sw < baseX then
    scale = math.min(minScale, baseX/sw)
end

local teksturki = {}
local showed = false
local shader = {}
local wybrana_teksturka = 234
local page = 1
local selected_txd = 0

local obiekty_podmieniane = {
	[8594] = true,
	[8593] = true,
	[8087] = true,
	[8086] = true,
	[8085] = true,
	[8084] = true,
	[8083] = true,
	[8082] = true,
	[8595] = true,
	[8081] = true,
	[1649] = true,
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

function create_shader(element, texture_id)
	texture_id = tonumber(texture_id) or wybrana_teksturka

	if not teksturki[texture_id] then
		local path = texture_id > 207 and 'walls/'..texture_id..'.jpg' or texture_id < 208 and 'floors/'..texture_id..'.jpg'
		teksturki[texture_id] = dxCreateTexture(fileExists(path) and path or 'floors/'..wybrana_teksturka..'.jpg', 'dxt5', false, 'clamp')
	end

	if not shader[element] then
		shader[element] = dxCreateShader('shaders/shader.fx')
	end

	dxSetShaderValue(shader[element], 'shader', teksturki[texture_id])

	engineApplyShaderToWorldTexture(shader[element], 'a', element)
	engineApplyShaderToWorldTexture(shader[element], 'b', element)
	engineApplyShaderToWorldTexture(shader[element], 'pan', element)

	setElementData(element, 'selected', texture_id)
end

function loadTextures()
	Async:foreach(getElementsByType('object'), function(v)
		if obiekty_podmieniane[getElementModel(v)] and getElementDimension(v) == 0 and getElementInterior(v) == 0 then
	    	local d = getElementData(v, 'selected') or wybrana_teksturka
	    	create_shader(v, d)
	   	end
	end)
end

function gui()
	exports['dxLibary']:dxLibary_createWindow(1420/scale, 322/scale, 300/scale, 293/scale, tocolor(0, 0, 0, 200), false)
	exports['dxLibary']:dxLibary_text('Wybierz teksture oraz\nkliknij na obiekt, aby zastosować.', 1430/scale, 343/scale, 1708/scale, 377/scale, tocolor(105, 188, 235, 255), 3, 'default', 'center', 'center', false, false, false, false, false)

	local x = 0
	for i = page, (page + 12) do
		local path = i > 207 and 'walls/'..i..'.jpg' or i < 208 and 'floors/'..i..'.jpg'
		if fileExists(path) then
			x = x + 1

			local sX = 0
			local sY = 70/scale * (x - 1)

			if x >= 5 and x <= 8 then
				sX = 70/scale
				sY = 70/scale * (x - 5)
			elseif x >= 8 and x <= 12 then
				sX = (70 * 2)/scale
				sY = 70/scale * (x - 9)
			end

			dxDrawImage(1435/scale + sY, 400/scale + sX, 60/scale, 60/scale, path, 0, 0, 0, tocolor(255, 255, 255, 255), false)

			if selected_txd == i then
				dxDrawRectangle(1435/scale + sY, 400/scale + sX, 60/scale, 60/scale, tocolor(0, 0, 0, 100), false)
				dxLibary:dxLibary_text((i <= 207 and 'Ściana' or 'Podłoga')..'\n(ID: '..i..')', 1435/scale + sY, 400/scale + sX, 60/scale + 1435/scale + sY, 60/scale + 400/scale + sX, tocolor(255, 255, 255, 255), 2, 'default', 'center', 'center', false, false, false, false, false)
			end
		end
	end
end

function scroll_up()
	if isMouseIn(1420/scale, 322/scale, 300/scale, 293/scale) then
		page = math.max(page - 4, 1)
	end
end

function scroll_down()
	if isMouseIn(1420/scale, 322/scale, 300/scale, 293/scale) then
		page = math.min(page + 4, 321 - 8)
	end
end

function click_element(button, state, _, _, _, _, _, obj)
	if obj and button == 'left' and state =='down' and getElementType(obj) == 'object' and showed == true and obiekty_podmieniane[getElementModel(obj)] and selected_txd ~= 0 and not isMouseIn(1420/scale, 322/scale, 300/scale, 293/scale) then
	  	triggerServerEvent('replace:texture', resourceRoot, obj, selected_txd)
	end
end

function click_mouse(btn, state)
	if btn ~= 'left' or state ~= 'down' then return end

	local x = 0
	for i = page, (page + 12) do
		local path = i > 207 and 'walls/'..i..'.jpg' or i < 208 and 'floors/'..i..'.jpg'
		if fileExists(path) then
			x = x + 1

			local sX = 0
			local sY = 70/scale * (x - 1)

			if x >= 5 and x <= 8 then
				sX = 70/scale
				sY = 70/scale * (x - 5)
			elseif x >= 8 and x <= 12 then
				sX = (70 * 2)/scale
				sY = 70/scale * (x - 9)
			end

			if isMouseIn(1435/scale + sY, 400/scale + sX, 60/scale, 60/scale) then
				selected_txd = i
			end
		end
	end
end

bindKey('F3', 'down', function()
	if getElementData(localPlayer, 'rank:duty') and getElementData(localPlayer, 'rank:duty') > 3 then
		if not showed then
			showed = true
			addEventHandler('onClientRender', root, gui)
			addEventHandler('onClientClick', root, click_mouse)
			addEventHandler('onClientClick', root, click_element)
			bindKey('mouse_wheel_down', 'down', scroll_down)
			bindKey('mouse_wheel_up', 'down', scroll_up)
			showCursor(true, false)
		else
			showed = false
			removeEventHandler('onClientRender', root, gui)
			removeEventHandler('onClientClick', root, click_mouse)
			removeEventHandler('onClientClick', root, click_element)
			unbindKey('mouse_wheel_down', 'down', scroll_down)
			unbindKey('mouse_wheel_up', 'down', scroll_up)
			showCursor(false)
		end
	end
end)

function loadTexturesWithDistance(distance)
	local myPos = {getElementPosition(localPlayer)}
	for i,v in pairs(getElementsWithinRange(myPos[1], myPos[2], myPos[3], distance, "object")) do
		local txd = getElementData(v, 'selected') or wybrana_teksturka
		create_shader(v, txd)
	end
	--[[Async:foreach(getElementsByType('object'), function(v)
		if obiekty_podmieniane[getElementModel(v)] and getElementDimension(v) == getElementDimension(localPlayer) and getElementInterior(v) == getElementInterior(localPlayer) then
			local objPos = {getElementPosition(v)}
			local dist = getDistanceBetweenPoints3D(myPos[1], myPos[2], myPos[3], objPos[1], objPos[2], objPos[3])
			if dist < distance then
				local txd = getElementData(v, 'selected') or wybrana_teksturka
				create_shader(v, txd)
			end
		end
	end)]]
end

addEvent('replace:texture', true)
addEventHandler('replace:texture', resourceRoot, function(o, selected)
	if not o or not selected then return end

	create_shader(o, selected)
end)