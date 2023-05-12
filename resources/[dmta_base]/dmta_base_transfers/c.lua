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

local bank_money = 0
local accept = false

local potwierdzenie = {
  login = '',
  money = 0,
  gui = false,
  checkbox = exports['dxLibary']:createTexture(':dmta_base_transfers/images/checkbox.png'),
  checkbox_selected = exports['dxLibary']:createTexture(':dmta_base_transfers/images/checkbox_selected.png')
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

function formatMoney(money)
	while true do
		money, i = string.gsub(money, '^(-?%d+)(%d%d%d)', '%1,%2')
		if i == 0 then
			break
		end
	end
	return money
end

function gui()
  dxDrawRectangle(0, 0, 1920, 1080, tocolor(15, 15, 15, 200), false)
  if potwierdzenie['gui'] == true then
    exports['dxLibary']:dxLibary_createWindow(793/scale, 480/scale, 334/scale, 120/scale, false)
    exports['dxLibary']:dxLibary_text('Czy na pewno akceptujesz transakcje:\n#69bceb'..formatMoney(potwierdzenie['money'])..'$#ffffff dla gracza #69bceb'..potwierdzenie['login']..'#ffffff?', 793/scale, 480/scale, 1127/scale, 545/scale, tocolor(255, 255, 255, 255), 2, 'default', 'center', 'center', false, true, false, true, false)
    exports['dxLibary']:dxLibary_createButton('Akceptuj', 803/scale, 550/scale, 140/scale, 40/scale, tocolor(255, 255, 255, 255), false)
    exports['dxLibary']:dxLibary_createButton('Odrzuć', 977/scale, 550/scale, 140/scale, 40/scale, tocolor(255, 255, 255, 255), false)
    return
  end

  exports['dxLibary']:dxLibary_createWindow(710/scale, 319/scale, 501/scale, 442/scale, false)

  exports['dxLibary']:dxLibary_text('#69bcebDiamond BANK', 710/scale, 319/scale, 1211/scale, 378/scale, tocolor(255, 255, 255, 255), 8, 'default', 'center', 'center', false, false, false, true, false)
  exports['dxLibary']:dxLibary_text('Przelew bankowy', 858/scale, 367/scale, 1062/scale, 390/scale, tocolor(255, 255, 255, 255), 3, 'default', 'center', 'top', false, false, false, false, false)

  exports['dxLibary']:dxLibary_createButton('Wyślij przelew', 730/scale, 697/scale, 190/scale, 46/scale, tocolor(255, 255, 255, 255), false)
  exports['dxLibary']:dxLibary_createButton('Anuluj', 1001/scale, 697/scale, 190/scale, 46/scale, tocolor(255, 255, 255, 255), false)

  exports['dxLibary']:dxLibary_text('Saldo posiadane na koncie bankowym:\n'..formatMoney(bank_money)..'$', 691/scale + 1, 425/scale + 1, 1214/scale + 1, 445/scale + 1, tocolor(0, 0, 0, 255), 3, 'default', 'center', 'center', false, false, false, true, false)
  exports['dxLibary']:dxLibary_text('Saldo posiadane na koncie bankowym:\n#69bceb'..formatMoney(bank_money)..'$', 691/scale, 425/scale, 1214/scale, 445/scale, tocolor(255, 255, 255, 255), 3, 'default', 'center', 'center', false, false, false, true, false)

  if accept == true then
    dxDrawImage(816/scale, 635/scale, 18/scale, 18/scale, potwierdzenie['checkbox_selected'])
  else
    dxDrawImage(816/scale, 635/scale, 18/scale, 18/scale, potwierdzenie['checkbox'])
  end

  exports['dxLibary']:dxLibary_shadowText2('Akceptuje regulamin przelewów', 840/scale, 635/scale, 953/scale, 600/scale, tocolor(255, 255, 255, 255), 1, 'default', 'left', 'top', false, false, false, false, false)

  local przelej_edit = exports['editbox']:getCustomEditboxText('BANKOMAT-PRZELEJ2') == '' and '1' or exports['editbox']:getCustomEditboxText('BANKOMAT-PRZELEJ2')
  local przelej2_edit = exports['editbox']:getCustomEditboxText('BANKOMAT-PRZELEJ1') == '' and '1' or exports['editbox']:getCustomEditboxText('BANKOMAT-PRZELEJ1')

  if not tonumber(przelej_edit) then
    exports['editbox']:customEditboxSetText('BANKOMAT-PRZELEJ2', string.sub(przelej_edit, 0, string.len(przelej_edit)-1))
  elseif tostring(przelej_edit):len() > 8 then
    exports['editbox']:customEditboxSetText('BANKOMAT-PRZELEJ2', string.sub(przelej_edit, 0, string.len(przelej_edit)-1))
  elseif tonumber(przelej_edit) and tonumber(przelej_edit) < 1 then
    exports['editbox']:customEditboxSetText('BANKOMAT-PRZELEJ2', string.sub(przelej_edit, 0, string.len(przelej_edit)-1))
  elseif tostring(przelej2_edit):len() > 15 then
    exports['editbox']:customEditboxSetText('BANKOMAT-PRZELEJ1', string.sub(przelej2_edit, 0, string.len(przelej2_edit)-1))
  end
end

addEvent('potwierdz:przelew', true)
addEventHandler('potwierdz:przelew', resourceRoot, function(login, money)
  potwierdzenie['money'] = money
  potwierdzenie['login'] = login
  potwierdzenie['gui'] = true
  exports['editbox']:destroyCustomEditbox('BANKOMAT-PRZELEJ1')
  exports['editbox']:destroyCustomEditbox('BANKOMAT-PRZELEJ2')
end)

addEvent('gui:przelewy', true)
addEventHandler('gui:przelewy', resourceRoot, function(money)
	addEventHandler('onClientRender', root, gui)
	addEventHandler('onClientClick', root, clicked)

  bank_money = money
  accept = false

	showCursor(true)
	showChat(false)
	setElementData(localPlayer, 'grey_shader', 1)
	setElementData(localPlayer, 'pokaz:hud', false)
	setElementFrozen(localPlayer, true)

  exports['editbox']:createCustomEditbox('BANKOMAT-PRZELEJ1', 'Wprowadź nick gracza...', 808/scale, 485/scale, 303/scale, 45/scale, false)
  exports['editbox']:createCustomEditbox('BANKOMAT-PRZELEJ2', 'Wprowadź sumę...', 808/scale, 560/scale, 303/scale, 45/scale, false)
end)

function clicked(btn, state)
	if btn ~= 'state' and state ~= 'down' then return end

	if isMouseIn(1001/scale, 697/scale, 190/scale, 46/scale) and potwierdzenie['gui'] ~= true then
		removeEventHandler('onClientClick', root, clicked)
		removeEventHandler('onClientRender', root, gui)
		setElementFrozen(localPlayer, false)
		showCursor(false)
		showChat(true)
		setElementData(localPlayer, 'grey_shader', 0)
		setElementData(localPlayer, 'pokaz:hud', true)
    exports['editbox']:destroyCustomEditbox('BANKOMAT-PRZELEJ1')
  	exports['editbox']:destroyCustomEditbox('BANKOMAT-PRZELEJ2')
    potwierdzenie['gui'] = false
  elseif isMouseIn(816/scale, 635/scale, 18/scale, 18/scale) and potwierdzenie['gui'] ~= true then
    accept = not accept
  elseif isMouseIn(730/scale, 697/scale, 190/scale, 46/scale) and potwierdzenie['gui'] ~= true then
    if accept == true then
      local money = exports['editbox']:getCustomEditboxText('BANKOMAT-PRZELEJ2')
			local nick = exports['editbox']:getCustomEditboxText('BANKOMAT-PRZELEJ1')
			triggerServerEvent('wyslij:przelew', resourceRoot, money, nick)
    else
      exports['dmta_base_notifications']:addNotification('Aby wysłać przelew, musisz zaakceptować regulamin przelewów.', 'error')
    end
  elseif isMouseIn(803/scale, 550/scale, 140/scale, 40/scale) and potwierdzenie['gui'] == true then
    triggerServerEvent('potwierdz:przelew', resourceRoot, potwierdzenie['login'], potwierdzenie['money'])
    potwierdzenie['gui'] = false
    removeEventHandler('onClientClick', root, clicked)
		removeEventHandler('onClientRender', root, gui)
		setElementFrozen(localPlayer, false)
		showCursor(false)
		showChat(true)
		setElementData(localPlayer, 'grey_shader', 0)
		setElementData(localPlayer, 'pokaz:hud', true)
    exports['editbox']:destroyCustomEditbox('BANKOMAT-PRZELEJ1')
  	exports['editbox']:destroyCustomEditbox('BANKOMAT-PRZELEJ2')
    potwierdzenie['gui'] = false
  elseif isMouseIn(977/scale, 550/scale, 140/scale, 40/scale) and potwierdzenie['gui'] == true then
    potwierdzenie['gui'] = false
    exports['editbox']:createCustomEditbox('BANKOMAT-PRZELEJ1', 'Wprowadź nick gracza...', 808/scale, 485/scale, 303/scale, 45/scale, false)
    exports['editbox']:createCustomEditbox('BANKOMAT-PRZELEJ2', 'Wprowadź sumę...', 808/scale, 560/scale, 303/scale, 45/scale, false)
	end
end

addEventHandler('onClientResourceStop', resourceRoot, function()
	exports['editbox']:destroyCustomEditbox('BANKOMAT-PRZELEJ1')
	exports['editbox']:destroyCustomEditbox('BANKOMAT-PRZELEJ2')
end)
