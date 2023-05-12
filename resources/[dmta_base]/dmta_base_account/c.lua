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

local noti = exports['dmta_base_notifications']
local editbox = exports['editbox']
local tick = getTickCount()

function isMouseIn(x, y, w, h)
	if not isCursorShowing() then return end

	local pos = {getCursorPosition()}
	pos[1],pos[2] = (pos[1]*sw),(pos[2]*sh)

	if pos[1] >= x and pos[1] <= (x+w) and pos[2] >= y and pos[2] <= (y+h) then
		return true
	end
	return false
end

local wymagania = [[
- Ukończenie 18 roku życia.
- Posiadanie amerykańskiego obywatelstwa.
]]

function gui()
	dxDrawRectangle(0, 0, 1920, 1080, tocolor(15, 15, 15, 200), false)
  exports['dxLibary']:dxLibary_createWindow(710/scale, 319/scale, 501/scale, 442/scale, false)
  exports['dxLibary']:dxLibary_text('#69bcebDiamond BANK', 710/scale, 319/scale, 1211/scale, 378/scale, tocolor(255, 255, 255, 255), 8, 'default', 'center', 'center', false, false, false, true, false)
  exports['dxLibary']:dxLibary_text('Zakładanie konta bankowego', 858/scale, 367/scale, 1062/scale, 390/scale, tocolor(255, 255, 255, 255), 3, 'default', 'center', 'top', false, false, false, false, false)
  exports['dxLibary']:dxLibary_text('#69bcebWymagania:#ffffff\n'..wymagania, 720/scale, 490/scale, 1201/scale, 649/scale, tocolor(255, 255, 255, 255), 1, 'default', 'center', 'top', false, false, false, true, false)
  exports['dxLibary']:dxLibary_createButton('Załóż konto bankowe', 730/scale, 697/scale, 190/scale, 46/scale, tocolor(255, 255, 255, 255), false)
  exports['dxLibary']:dxLibary_createButton('Anuluj', 1001/scale, 697/scale, 190/scale, 46/scale, tocolor(255, 255, 255, 255), false)
  exports['dxLibary']:dxLibary_text('Jeśli spełniasz poniższe wymiagania\noraz wprowadziłeś swoje dane\nmożesz założyć swoje konto bankowe.', 720/scale, 400/scale, 1201/scale, 475/scale, tocolor(255, 255, 255, 255), 1, 'default', 'center', 'center', false, false, false, true, false)
end

addEvent('konto:bankowe', true)
addEventHandler('konto:bankowe', resourceRoot, function()
	addEventHandler('onClientRender', root, gui)
	addEventHandler('onClientClick', root, clicked)

	showCursor(true)
	showChat(false)
	setElementData(localPlayer, 'grey_shader', 1)
	setElementData(localPlayer, 'pokaz:hud', false)
	setElementFrozen(localPlayer, true)

	editbox:createCustomEditbox('EDITBOX-KONTOBANK', 'Wprowadź swój nick...', (sw/2) - ((216/scale)/2), 600/scale, 216/scale, 37/scale)
end)

function clicked(btn, state)
	if btn ~= 'state' and state ~= 'down' then return end

	if isMouseIn(1001/scale, 697/scale, 190/scale, 46/scale) then
		removeEventHandler('onClientClick', root, clicked)
		removeEventHandler('onClientRender', root, gui)
		showCursor(false)
		showChat(true)
		setElementData(localPlayer, 'grey_shader', 0)
		setElementFrozen(localPlayer, false)
		setElementData(localPlayer, 'pokaz:hud', true)
		editbox:destroyCustomEditbox('EDITBOX-KONTOBANK')
	elseif isMouseIn(730/scale, 697/scale, 190/scale, 46/scale) then
		local nick = editbox:getCustomEditboxText('EDITBOX-KONTOBANK')
		if nick == getPlayerName(localPlayer) then
			removeEventHandler('onClientClick', root, clicked)
			removeEventHandler('onClientRender', root, gui)
			triggerServerEvent('konto:bankowe', resourceRoot)
			noti:addNotification('Pomyślnie założono konto bankowe.', 'success')
			showCursor(false)
			showChat(true)
			setElementData(localPlayer, 'grey_shader', 0)
			setElementFrozen(localPlayer, false)
			setElementData(localPlayer, 'pokaz:hud', true)
			editbox:destroyCustomEditbox('EDITBOX-KONTOBANK')
		else
			noti:addNotification('Podaj prawidłowy nick.', 'error')
		end
	end
end

addEventHandler('onClientResourceStop', resourceRoot, function()
	editbox:destroyCustomEditbox('EDITBOX-KONTOBANK')
end)