--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local sw,sh = guiGetScreenSize()
local baseX = 1920
local scale = 1
local minScale = 2
if sw < baseX then
    scale = math.min(minScale, baseX/sw)
end

local dxLibary = exports.dxLibary

function isMouseIn(x, y, w, h)
	if not isCursorShowing() then return end

	local pos = {getCursorPosition()}
	pos[1],pos[2] = (pos[1]*sw),(pos[2]*sh)

	if pos[1] >= x and pos[1] <= (x+w) and pos[2] >= y and pos[2] <= (y+h) then
		return true
	end
	return false
end

function gui()
	dxDrawRectangle(0, 0, 1920, 1080, tocolor(15, 15, 15, 200), false)
  	dxLibary:dxLibary_createWindow(710/scale - 50/scale, 319/scale, 501/scale + 100/scale, 435/scale, false)

  	local x,y,w,h = dxLibary:dxLibary_formatTextPosition(1230/scale, 325/scale, 24/scale, 24/scale)
    if isMouseIn(1230/scale, 325/scale, 24/scale, 24/scale) then
		dxLibary:dxLibary_text('X', x, y, w, h, tocolor(255, 0, 0, a), 5, 'default', 'center', 'center', false, false, false, false, false)
	else
		dxLibary:dxLibary_text('X', x, y, w, h, tocolor(150, 150, 150, a), 5, 'default', 'center', 'center', false, false, false, false, false)
	end

  	dxLibary:dxLibary_text('#69bcebDiamond BANK', 710/scale, 310/scale, 1211/scale, 378/scale, tocolor(255, 255, 255, 255), 8, 'default', 'center', 'center', false, false, false, true, false)
 	dxLibary:dxLibary_text('Historia transakcji', 858/scale, 358/scale, 1062/scale, 390/scale, tocolor(255, 255, 255, 255), 3, 'default', 'center', 'top', false, false, false, false, false)
end

addEvent('lista:przelewow', true)
addEventHandler('lista:przelewow', resourceRoot, function(q)
	local t = {}
	for i,v in ipairs(q) do
		table.insert(t, {text=v['text'],type=v['type'],date=v['date']})
	end

	addEventHandler('onClientRender', root, gui)
	addEventHandler('onClientClick', root, clicked)

	showCursor(true)
	showChat(false)
	setElementData(localPlayer, 'grey_shader', 1)
	setElementData(localPlayer, 'pokaz:hud', false)
	setElementFrozen(localPlayer, true)

	exports['gridlist']:dxLibary_createGridlist('WESTBANK-PRZELEWY1', {{name='Typ',height=0}, {name='Gotówka',height=170}, {name='Data',height=200}}, 8, 750/scale - 50/scale, 415/scale, 420/scale + 100/scale)
	for i,v in ipairs(t) do
		exports['gridlist']:dxLibary_addGridlistItem('WESTBANK-PRZELEWY1', {v['type'], v['text'], string.sub(v['date'], 1, 16)})
	end
end)

function clicked(btn, state)
	if btn ~= 'state' and state ~= 'down' then return end

	if isMouseIn(1230/scale, 325/scale, 24/scale, 24/scale) then
		removeEventHandler('onClientClick', root, clicked)
		removeEventHandler('onClientRender', root, gui)
		setElementFrozen(localPlayer, false)
		showCursor(false)
		showChat(true)
		setElementData(localPlayer, 'grey_shader', 0)
		setElementData(localPlayer, 'pokaz:hud', true)
		exports['gridlist']:dxLibary_destroyGridlist('WESTBANK-PRZELEWY1')
	end
end

addEventHandler('onClientResourceStop', resourceRoot, function()
	exports['gridlist']:dxLibary_destroyGridlist('WESTBANK-PRZELEWY1')
end)
