--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local dxLibary = exports.dxLibary
local noti = exports.dmta_base_notifications
local editbox = exports.editbox
local gridlist = exports.gridlist

local sw,sh = guiGetScreenSize()
local baseX = 1920
local scale = 1
local minScale = 2
if sw < baseX then
    scale = math.min(minScale, baseX/sw)
end

local houseIcon = dxLibary:createTexture(':dmta_houses/images/house.png', 'dxt5', false, 'clamp')
local potwierdz = false

function isMouseIn(x, y, w, h)
	if not isCursorShowing() then return end

	local pos = {getCursorPosition()}
	pos[1],pos[2] = (pos[1]*sw),(pos[2]*sh)

	if pos[1] >= x and pos[1] <= (x+w) and pos[2] >= y and pos[2] <= (y+h) then
		return true
	end
	return false
end

bindKey('l', 'both', function(key,state)
	if state == 'down' then
		for i,v in ipairs(getElementsByType('colshape', resourceRoot)) do
			local info = getElementData(v, 'house:info')
			if info['wlasciciel'] ~= 0 then
				createBlipAttachedTo(v, 31)
			else
				createBlipAttachedTo(v, 32)
			end
		end
	elseif state == 'up' then
		for i,v in ipairs(getElementsByType('blip', resourceRoot)) do
			destroyElement(v)
		end
	end
end)

function formatMoney(money)
	while true do
		money, i = string.gsub(money, '^(-?%d+)(%d%d%d)', '%1,%2')
		if i == 0 then
			break
		end
	end
	return money
end

local domek = {
	showed = '',
	info = false,
  tickClick = getTickCount()
}

function gui()
  dxLibary:dxLibary_createWindow(710/scale, 319/scale, 501/scale, 442/scale, 235)
  dxLibary:dxLibary_text('#69bceb'..domek['info']['nazwa'], 710/scale, 319/scale, 1211/scale, 378/scale, tocolor(255, 255, 255, 255), 8, 'default', 'center', 'center', false, false, false, true, false)
  dxLibary:dxLibary_text('Panel zarządzania', 858/scale, 367/scale, 1062/scale, 390/scale, tocolor(255, 255, 255, 255), 3, 'default', 'center', 'top', false, false, false, false, false)

  dxDrawImage((sw/2) - (128/2)/scale, 447/scale, 128/scale, 128/scale, houseIcon)

  local garage_info = domek['info']['places'] and 'Miejsc w garażu: #69bceb'..domek['info']['places'] or 'Budynek nie posiada garażu.'
  local _garage_info = domek['info']['places'] and 'Miejsc w garażu: '..domek['info']['places'] or 'Budynek nie posiada garażu.'

  local x,y,z = getElementPosition(localPlayer)
  dxLibary:dxLibary_text(getZoneName(x, y, z, false)..', '..getZoneName(x, y, z, true)..' (ID: '..domek['info']['id']..')\n'..formatMoney(domek['info']['cena'])..'$ / doba\n'.._garage_info, 831/scale + 1, 580/scale + 1, 1089/scale + 1, 646/scale + 1, tocolor(0, 0, 0, 255), 4, 'default', 'center', 'center', false, false, false, true, false)
  dxLibary:dxLibary_text(getZoneName(x, y, z, false)..', '..getZoneName(x, y, z, true)..' (#939393ID: #69bceb'..domek['info']['id']..'#ffffff)\n#69bceb'..formatMoney(domek['info']['cena'])..'$#ffffff / doba\n'..garage_info, 831/scale, 580/scale, 1089/scale, 646/scale, tocolor(255, 255, 255, 255), 4, 'default', 'center', 'center', false, false, false, true, false)

  dxLibary:dxLibary_createButton('Wynajmij', 730/scale, 697/scale, 190/scale, 46/scale, 3)
  dxLibary:dxLibary_createButton('Zobacz wnętrze', 1001/scale, 697/scale, 190/scale, 46/scale, 3)

  if isMouseIn(1182/scale, 325/scale, 21/scale, 22/scale) then
		dxLibary:dxLibary_shadowText('X', 1182/scale, 325/scale, 21/scale + 1182/scale, 22/scale + 325/scale, tocolor(255, 0, 0, 255), 6, 'default', 'center', 'center', false, false, false, false, false)
	else
		dxLibary:dxLibary_shadowText('X', 1182/scale, 325/scale, 21/scale + 1182/scale, 22/scale + 325/scale, tocolor(150, 150, 150, 255), 6, 'default', 'center', 'center', false, false, false, false, false)
	end
end

function guiKupno()
  local text = ''
  if domek['showed'] == 'kupno' then
    text = 'Wynajmij'
  else
    text = 'Przedłuż'
  end

  dxLibary:dxLibary_createWindow(710/scale, 319/scale, 501/scale, 442/scale, 235)
  dxLibary:dxLibary_text('#69bceb'..domek['info']['nazwa'], 710/scale, 319/scale, 1211/scale, 378/scale, tocolor(255, 255, 255, 255), 8, 'default', 'center', 'center', false, false, false, true, false)
  dxLibary:dxLibary_text('Panel wynajmu', 858/scale, 367/scale, 1062/scale, 390/scale, tocolor(255, 255, 255, 255), 3, 'default', 'center', 'top', false, false, false, false, false)

  dxLibary:dxLibary_createButton(text, 730/scale, 697/scale, 190/scale, 46/scale, 3)
  dxLibary:dxLibary_createButton('Cofnij', 1001/scale, 697/scale, 190/scale, 46/scale, 3)

  if isMouseIn(1182/scale, 325/scale, 21/scale, 22/scale) then
		dxLibary:dxLibary_shadowText('X', 1182/scale, 325/scale, 21/scale + 1182/scale, 22/scale + 325/scale, tocolor(255, 0, 0, 255), 6, 'default', 'center', 'center', false, false, false, false, false)
	else
		dxLibary:dxLibary_shadowText('X', 1182/scale, 325/scale, 21/scale + 1182/scale, 22/scale + 325/scale, tocolor(150, 150, 150, 255), 6, 'default', 'center', 'center', false, false, false, false, false)
	end

  local days = editbox:getCustomEditboxText('domek-DAYS1') == '' and '1' or editbox:getCustomEditboxText('domek-DAYS1')
  if not tonumber(days) then
    editbox:customEditboxSetText('domek-DAYS1', string.sub(days, 0, string.len(days)-1))
  elseif tonumber(days) and tonumber(days) < 1 then
    editbox:customEditboxSetText('domek-DAYS1', string.sub(days, 0, string.len(days)-1))
  elseif tostring(days):len() > 2 then
    editbox:customEditboxSetText('domek-DAYS1', string.sub(days, 0, string.len(days)-1))
  elseif not tonumber(days) then
    days = 1
  end

  days = tonumber(days) or 1

  local cena = days * domek['info']['cena']

  dxLibary:dxLibary_text('Koszt budynku na '..days..' dni:\n'..formatMoney(cena)..'$', 691/scale + 1, 515/scale + 1, 1214/scale + 1, 445/scale + 1, tocolor(0, 0, 0, 255), 4, 'default', 'center', 'center', false, false, false, false, false)
  dxLibary:dxLibary_text('Koszt budynku na '..days..' dni:\n#69bceb'..formatMoney(cena)..'$', 691/scale, 515/scale, 1214/scale, 445/scale, tocolor(255, 255, 255, 255), 4, 'default', 'center', 'center', false, false, false, true, false)

  dxLibary:dxLibary_text('Dostępna gotówka: '..formatMoney(getPlayerMoney(localPlayer))..'$', 691/scale + 1, 825/scale + 1, 1214/scale + 1, 445/scale + 1, tocolor(0, 0, 0, 255), 3, 'default', 'center', 'center', false, false, false, false, false)
  dxLibary:dxLibary_text('Dostępna gotówka: #69bceb'..formatMoney(getPlayerMoney(localPlayer))..'$', 691/scale, 825/scale, 1214/scale, 445/scale, tocolor(255, 255, 255, 255), 3, 'default', 'center', 'center', false, false, false, true, false)
end

function guiZajety()
  dxLibary:dxLibary_createWindow(710/scale, 319/scale, 501/scale, 442/scale, 235)
  dxLibary:dxLibary_text('#69bceb'..domek['info']['nazwa'], 710/scale, 319/scale, 1211/scale, 378/scale, tocolor(255, 255, 255, 255), 8, 'default', 'center', 'center', false, false, false, true, false)
  dxLibary:dxLibary_text('Panel mieszkania', 858/scale, 367/scale, 1062/scale, 390/scale, tocolor(255, 255, 255, 255), 3, 'default', 'center', 'top', false, false, false, false, false)

  dxDrawImage((sw/2) - (128/2)/scale, 447/scale, 128/scale, 128/scale, houseIcon)

  local garage_info = domek['info']['places'] and 'Miejsc w garażu: #69bceb'..domek['info']['places'] or 'Budynek nie posiada garażu.'
  local _garage_info = domek['info']['places'] and 'Miejsc w garażu: '..domek['info']['places'] or 'Budynek nie posiada garażu.'

  local x,y,z = getElementPosition(localPlayer)
  dxLibary:dxLibary_text(getZoneName(x, y, z, false)..', '..getZoneName(x, y, z, true)..' (ID: '..domek['info']['id']..')\nWynajęty do: '..domek['info']['data']..'\n'.._garage_info, 831/scale + 1, 585/scale + 1, 1089/scale + 1, 646/scale + 1, tocolor(0, 0, 0, 255), 4, 'default', 'center', 'top', false, false, false, false, false)
  dxLibary:dxLibary_text(getZoneName(x, y, z, false)..', '..getZoneName(x, y, z, true)..' (#939393ID: #69bceb'..domek['info']['id']..'#ffffff)\nWynajęty do: #69bceb'..domek['info']['data']..'\n#ffffff'..garage_info, 831/scale, 585/scale, 1089/scale, 646/scale, tocolor(255, 255, 255, 255), 4, 'default', 'center', 'top', false, false, false, true, false)

  dxLibary:dxLibary_createButton('Zobacz wnętrze', 865/scale, 697/scale, 190/scale, 46/scale, 3)

  if isMouseIn(1182/scale, 325/scale, 21/scale, 22/scale) then
		dxLibary:dxLibary_shadowText('X', 1182/scale, 325/scale, 21/scale + 1182/scale, 22/scale + 325/scale, tocolor(255, 0, 0, 255), 6, 'default', 'center', 'center', false, false, false, false, false)
	else
		dxLibary:dxLibary_shadowText('X', 1182/scale, 325/scale, 21/scale + 1182/scale, 22/scale + 325/scale, tocolor(150, 150, 150, 255), 6, 'default', 'center', 'center', false, false, false, false, false)
	end
end

function guiWlasciciel()
  dxLibary:dxLibary_createWindow(710/scale, 319/scale, 501/scale, 442/scale, 235)
  dxLibary:dxLibary_text('#69bceb'..(domek['info'] and domek['info']['nazwa'] or 'Dom'), 710/scale, 319/scale, 1211/scale, 378/scale, tocolor(255, 255, 255, 255), 8, 'default', 'center', 'center', false, false, false, true, false)
  dxLibary:dxLibary_text('Panel zarządzania', 858/scale, 367/scale, 1062/scale, 390/scale, tocolor(255, 255, 255, 255), 3, 'default', 'center', 'top', false, false, false, false, false)

  if isMouseIn(1182/scale, 325/scale, 21/scale, 22/scale) then
		dxLibary:dxLibary_shadowText('X', 1182/scale, 325/scale, 21/scale + 1182/scale, 22/scale + 325/scale, tocolor(255, 0, 0, 255), 6, 'default', 'center', 'center', false, false, false, false, false)
	else
		dxLibary:dxLibary_shadowText('X', 1182/scale, 325/scale, 21/scale + 1182/scale, 22/scale + 325/scale, tocolor(150, 150, 150, 255), 6, 'default', 'center', 'center', false, false, false, false, false)
	end

  dxLibary:dxLibary_createButton('Przedłuż', 765/scale, 635/scale, 125/scale, 50/scale, 3)
  dxLibary:dxLibary_createButton('Zwolnij', 900/scale, 635/scale, 125/scale, 50/scale, 3)
  dxLibary:dxLibary_createButton('Wejdź', 1035/scale, 635/scale, 125/scale, 50/scale, 3)

  local zamek = domek['info']['zamek'] == 0 and 'Zamknij zamek' or 'Otwórz zamek'
  dxLibary:dxLibary_createButton(zamek, 765/scale, 695/scale, 190/scale, 50/scale, 3)

  local btn = domek['info']['nazwa'] == 'Lokal organizacji' and (domek['info']['organizacja'] == '' and 'Przepisz na organizacje' or 'Wypisz z organizacji') or 'Lokatorzy'
  dxLibary:dxLibary_createButton(btn, 970/scale, 695/scale, 190/scale, 50/scale, 3)

  dxDrawImage((sw/2) - (128/2)/scale, 415/scale, 128/scale, 128/scale, houseIcon)

  local garage_info = domek['info']['places'] and 'Miejsc w garażu: #69bceb'..domek['info']['places'] or 'Budynek nie posiada garażu.'
  local _garage_info = domek['info']['places'] and 'Miejsc w garażu: '..domek['info']['places'] or 'Budynek nie posiada garażu.'

  local x,y,z = getElementPosition(localPlayer)
  dxLibary:dxLibary_text(getZoneName(x, y, z, false)..', '..getZoneName(x, y, z, true)..' (ID: '..domek['info']['id']..')\nWynajęty do: '..domek['info']['data']..'\n'.._garage_info, 831/scale + 1, 515/scale + 1, 1089/scale + 1, 646/scale + 1, tocolor(0, 0, 0, 255), 4, 'default', 'center', 'center', false, false, false, false, false)
  dxLibary:dxLibary_text(getZoneName(x, y, z, false)..', '..getZoneName(x, y, z, true)..' (#939393ID: #69bceb'..domek['info']['id']..'#ffffff)\nWynajęty do: #69bceb'..domek['info']['data']..'\n#ffffff'..garage_info, 831/scale, 515/scale, 1089/scale, 646/scale, tocolor(255, 255, 255, 255), 4, 'default', 'center', 'center', false, false, false, true, false)

  if potwierdz then
    dxLibary:dxLibary_createWindow(793/scale, 480/scale, 334/scale, 120/scale, tocolor(15, 15, 15, 235), false)
    dxLibary:dxLibary_text('Czy na pewno chcesz zwonić ten dom?', 793/scale, 480/scale, 1127/scale, 545/scale, tocolor(255, 255, 255, 255), 2, 'default', 'center', 'center', false, true, false, true, false)
    dxLibary:dxLibary_createButton('Akceptuj', 803/scale, 550/scale, 140/scale, 40/scale, 3)
    dxLibary:dxLibary_createButton('Anuluj', 977/scale, 550/scale, 140/scale, 40/scale, 3)
  end
end

function guiLokatorzy()
  dxLibary:dxLibary_createWindow(710/scale, 319/scale, 501/scale, 442/scale, 235)
  dxLibary:dxLibary_text('#69bceb'..(domek['info'] and domek['info']['nazwa'] or 'Dom'), 710/scale, 319/scale, 1211/scale, 378/scale, tocolor(255, 255, 255, 255), 8, 'default', 'center', 'center', false, false, false, true, false)
  dxLibary:dxLibary_text('Panel lokatorów', 858/scale, 367/scale, 1062/scale, 390/scale, tocolor(255, 255, 255, 255), 3, 'default', 'center', 'top', false, false, false, false, false)

  if isMouseIn(1182/scale, 325/scale, 21/scale, 22/scale) then
		dxLibary:dxLibary_shadowText('X', 1182/scale, 325/scale, 21/scale + 1182/scale, 22/scale + 325/scale, tocolor(255, 0, 0, 255), 6, 'default', 'center', 'center', false, false, false, false, false)
	else
		dxLibary:dxLibary_shadowText('X', 1182/scale, 325/scale, 21/scale + 1182/scale, 22/scale + 325/scale, tocolor(150, 150, 150, 255), 6, 'default', 'center', 'center', false, false, false, false, false)
	end

  local list_selected = gridlist:dxLibary_checkSelectedItem('GRIDLIST-LOKATOR1')
  local text_lokator = ''
  if list_selected then
    text_lokator = 'Usuń lokatora'
  else
    text_lokator = 'Dodaj lokatora'
  end

  dxLibary:dxLibary_createButton(text_lokator, 730/scale, 697/scale, 190/scale, 46/scale, 3)
  dxLibary:dxLibary_createButton('Cofnij', 1001/scale, 697/scale, 190/scale, 46/scale, 3)
end

addEvent('window:house', true)
addEventHandler('window:house', root, function(info)
	if not info then return end

	domek['info'] = info

  if domek['info']['wlasciciel'] == 0 then
    addEventHandler('onClientRender', root, gui)
    domek['showed'] = 'wolny'
  elseif domek['info']['wlasciciel'] ~= 0 and domek['info']['wlasciciel'] ~= getElementData(localPlayer, 'user:dbid') then
    addEventHandler('onClientRender', root, guiZajety)
    domek['showed'] = 'zajety'
  elseif domek['info']['wlasciciel'] ~= 0 and domek['info']['wlasciciel'] == getElementData(localPlayer, 'user:dbid') then
    addEventHandler('onClientRender', root, guiWlasciciel)
    domek['showed'] = 'wlasciciel'
  end

	addEventHandler('onClientClick', root, clicked)

	showCursor(true)
	setElementData(localPlayer, 'grey_shader', 1)
	setElementData(localPlayer, 'pokaz:hud', false)
	setElementFrozen(localPlayer, true)
	showChat(false)

  potwierdz = false
end)

function clicked(btn, state)
	if btn ~= 'state' and state ~= 'down' then return end

  --iks zamkniecia
	if isMouseIn(1182/scale, 325/scale, 21/scale, 22/scale) then
		removeEventHandler('onClientRender', root, gui)
    removeEventHandler('onClientRender', root, guiKupno)
    removeEventHandler('onClientRender', root, guiZajety)
    removeEventHandler('onClientRender', root, guiWlasciciel)
    removeEventHandler('onClientRender', root, guiLokatorzy)
		setElementData(localPlayer, 'grey_shader', 0)
		setElementData(localPlayer, 'pokaz:hud', true)
		setElementFrozen(localPlayer, false)
		showChat(true)
		removeEventHandler('onClientClick', root, clicked)
		showCursor(false)
    editbox:destroyCustomEditbox('domek-DAYS1')
    editbox:destroyCustomEditbox('domek-LOKATOR1')
    potwierdz = false
    gridlist:dxLibary_destroyGridlist('GRIDLIST-LOKATOR1')
  --
  --wlasciciel
  elseif isMouseIn(765/scale, 695/scale, 190/scale, 50/scale) and domek['showed'] == 'wlasciciel' then
    triggerServerEvent('house:zamek', resourceRoot, localPlayer, domek['info']['id'])
    removeEventHandler('onClientRender', root, guiWlasciciel)
    setElementData(localPlayer, 'grey_shader', 0)
    setElementData(localPlayer, 'pokaz:hud', true)
    setElementFrozen(localPlayer, false)
    showChat(true)
    potwierdz = false
    removeEventHandler('onClientClick', root, clicked)
    showCursor(false)
  elseif isMouseIn(1035/scale, 635/scale, 125/scale, 50/scale) and domek['showed'] == 'wlasciciel' then
    removeEventHandler('onClientRender', root, guiWlasciciel)
    setElementData(localPlayer, 'grey_shader', 0)
    setElementData(localPlayer, 'pokaz:hud', true)
    setElementFrozen(localPlayer, false)
    showChat(true)
    potwierdz = false
    removeEventHandler('onClientClick', root, clicked)
    showCursor(false)
    triggerServerEvent('tpto:house', resourceRoot, localPlayer, domek['info'])
  elseif isMouseIn(765/scale, 635/scale, 125/scale, 50/scale) and domek['showed'] == 'wlasciciel' then
    removeEventHandler('onClientRender', root, guiWlasciciel)
    addEventHandler('onClientRender', root, guiKupno)
    domek['showed'] = 'przedluz'
    potwierdz = false
    editbox:createCustomEditbox('domek-DAYS1', 'Wprowadź ilość dni...', 808/scale, 550/scale, 303/scale, 42/scale, false)
  elseif isMouseIn(900/scale, 635/scale, 125/scale, 50/scale) and domek['showed'] == 'wlasciciel' then
    potwierdz = true
  elseif isMouseIn(803/scale, 550/scale, 140/scale, 40/scale) and domek.showed == 'wlasciciel' and potwierdz then
    triggerServerEvent('remove:house', resourceRoot, localPlayer, domek['info']['id'])
    removeEventHandler('onClientRender', root, guiWlasciciel)
    setElementData(localPlayer, 'grey_shader', 0)
    setElementData(localPlayer, 'pokaz:hud', true)
    setElementFrozen(localPlayer, false)
    showChat(true)
    removeEventHandler('onClientClick', root, clicked)
    showCursor(false)
    potwierdz = false
  elseif isMouseIn(977/scale, 550/scale, 140/scale, 40/scale) and domek.showed == 'wlasciciel' and potwierdz then
    potwierdz = false
  elseif isMouseIn(970/scale, 695/scale, 190/scale, 50/scale) and domek['showed'] == 'wlasciciel' and domek['info']['motel'] == 0 then
    local btn = domek['info']['nazwa'] == 'Lokal organizacji' and (domek['info']['organizacja'] == '' and 'Przepisz na organizacje' or 'Wypisz z organizacji') or 'Lokatorzy'
    if btn == 'Lokatorzy' then
      removeEventHandler('onClientRender', root, guiWlasciciel)
      addEventHandler('onClientRender', root, guiLokatorzy)
      domek['showed'] = 'lokatorzy'
      potwierdz = false

      editbox:createCustomEditbox('domek-LOKATOR1', 'Wprowadź login...', 808/scale, 625/scale, 303/scale, 42/scale, false)
      gridlist:dxLibary_createGridlist('GRIDLIST-LOKATOR1',{{name='ID',height=0}, {name='Nazwa użytkownika',height=50}}, 5, 740/scale, 415/scale, 437/scale)

      local tabela = {}
      local lokatorzy = fromJSON(domek['info']['lokatorzy']) or {}
      for i,v in ipairs(lokatorzy) do
        table.insert(tabela, {v['dbid'], v['name']})
      end

      for i,v in ipairs(tabela) do
        gridlist:dxLibary_addGridlistItem('GRIDLIST-LOKATOR1', {i, v[2]})
      end
    else
      triggerServerEvent('organizacja', resourceRoot, btn, domek['info']['id'])
      removeEventHandler('onClientRender', root, guiWlasciciel)
      setElementData(localPlayer, 'grey_shader', 0)
      setElementData(localPlayer, 'pokaz:hud', true)
      setElementFrozen(localPlayer, false)
      showChat(true)
      removeEventHandler('onClientClick', root, clicked)
      showCursor(false)
      potwierdz = false
    end
  --
  --lokatorzy
  elseif isMouseIn(730/scale, 697/scale, 190/scale, 46/scale) and domek['showed'] == 'lokatorzy' then
    local list_selected = gridlist:dxLibary_checkSelectedItem('GRIDLIST-LOKATOR1')
    if list_selected then
      local nick = gridlist:dxLibary_gridlistGetSelectedItemText('GRIDLIST-LOKATOR1', 2)
      triggerServerEvent('house:lokator:usun', resourceRoot, localPlayer, domek['info']['id'], nick)
    else
      local text = editbox:getCustomEditboxText('domek-LOKATOR1')
      if text:len() < 1 then
        outputChatBox("#ff0000● #ffffffPodany login zawiera zbyt mało znaków.", player, 255, 255, 255, true)
        return
      end

      triggerServerEvent('house:lokator:dodaj', resourceRoot, localPlayer, domek['info']['id'], text)
    end

    removeEventHandler('onClientRender', root, guiLokatorzy)
    setElementData(localPlayer, 'grey_shader', 0)
    setElementData(localPlayer, 'pokaz:hud', true)
    setElementFrozen(localPlayer, false)
    showChat(true)
    removeEventHandler('onClientClick', root, clicked)
    showCursor(false)
    potwierdz = false
    editbox:destroyCustomEditbox('domek-LOKATOR1')
    gridlist:dxLibary_destroyGridlist('GRIDLIST-LOKATOR1')
  elseif isMouseIn(1001/scale, 697/scale, 190/scale, 46/scale) and domek['showed'] == 'lokatorzy' then
    addEventHandler('onClientRender', root, guiWlasciciel)
    removeEventHandler('onClientRender', root, guiLokatorzy)
    domek['showed'] = 'wlasciciel'
    potwierdz = false
    editbox:destroyCustomEditbox('domek-LOKATOR1')
    gridlist:dxLibary_destroyGridlist('GRIDLIST-LOKATOR1')
  --
  --wolny domek
	elseif (isMouseIn(1001/scale, 697/scale, 190/scale, 46/scale) and domek['showed'] == 'wolny') or (isMouseIn(865/scale, 697/scale, 190/scale, 46/scale) and domek['showed'] == 'zajety') then
    removeEventHandler('onClientRender', root, gui)
    removeEventHandler('onClientRender', root, guiZajety)
		setElementData(localPlayer, 'grey_shader', 0)
		setElementData(localPlayer, 'pokaz:hud', true)
		setElementFrozen(localPlayer, false)
		showChat(true)
		removeEventHandler('onClientClick', root, clicked)
		showCursor(false)
    potwierdz = false
		triggerServerEvent('tpto:house', resourceRoot, localPlayer, domek['info'])
	elseif isMouseIn(730/scale, 697/scale, 190/scale, 46/scale) and domek['showed'] == 'wolny' then
		removeEventHandler('onClientRender', root, gui)
		domek['showed'] = 'kupno'
    potwierdz = false
		addEventHandler('onClientRender', root, guiKupno)
    editbox:createCustomEditbox('domek-DAYS1', 'Wprowadź ilość dni...', 808/scale, 550/scale, 303/scale, 42/scale, false)
  --
  --kupno domku
  elseif isMouseIn(1001/scale, 697/scale, 190/scale, 46/scale) then
    local action = (domek['showed'] == 'kupno' and 1) or (domek['showed'] == 'przedluz' and 2) or 0
    if action == 1 then
      addEventHandler('onClientRender', root, gui)
      domek['showed'] = 'wolny'
      removeEventHandler('onClientRender', root, guiKupno)
      editbox:destroyCustomEditbox('domek-DAYS1')
      potwierdz = false
    elseif action == 2 then
      addEventHandler('onClientRender', root, guiWlasciciel)
      domek['showed'] = 'wlasciciel'
      removeEventHandler('onClientRender', root, guiKupno)
      editbox:destroyCustomEditbox('domek-DAYS1')
      potwierdz = false
    end
  elseif isMouseIn(730/scale, 697/scale, 190/scale, 46/scale) and (domek['showed'] == 'kupno' or domek['showed'] == 'przedluz') then
    local text = editbox:getCustomEditboxText('domek-DAYS1')

		triggerServerEvent('buy:house', resourceRoot, localPlayer, domek['info']['id'], text)
    removeEventHandler('onClientRender', root, guiKupno)
		setElementData(localPlayer, 'grey_shader', 0)
		setElementData(localPlayer, 'pokaz:hud', true)
		setElementFrozen(localPlayer, false)
		showChat(true)
		removeEventHandler('onClientClick', root, clicked)
		showCursor(false)
    editbox:destroyCustomEditbox('domek-DAYS1')
    potwierdz = false
	end
end

local player_lokator = nil
local id_lokator = nil

addEvent('send:lokator', true)
addEventHandler('send:lokator', resourceRoot, function(id, player)
  outputChatBox("#69bceb● #ffffffOtrzymałeś prośbę o dodanie jako lokator do domku o ID #969696"..id.." #ffffffod #969696"..getPlayerName(player)"", player, 255, 255, 255, true)
  outputChatBox("#69bceb● #ffffffWpisz /akceptuj, aby akceptować prośbę.", player, 255, 255, 255, true)
  outputChatBox("#69bceb● #ffffffWpisz /anuluj, aby anulować prośbę.", player, 255, 255, 255, true)
  outputChatBox("#69bceb● #ffffffProśba przedawni się po 30 sekundach.", player, 255, 255, 255, true)

  player_lokator = player
  id_lokator = id

  setTimer(function()
    outputChatBox("#fada5e● #ffffffProśba została przedawniona.", player, 255, 255, 255, true)
    triggerServerEvent('house:add:lokator', resourceRoot, nil, player_lokator, 'Prośba została przedawniona.', 'cancel')

    player_lokator = nil
    id_lokator = nil
  end, (1000 * 30), 1)
end)

addCommandHandler('akceptuj', function()
  if player_lokator and id_lokator then
    outputChatBox("#00ff00● #ffffffPomyślnie zaakceptowano prośbę.", player, 255, 255, 255, true)
    triggerServerEvent('house:add:lokator', resourceRoot, id_lokator, player_lokator, getPlayerName(localPlayer)..' zaakceptował twoją prośbę o dodanie jako lokatora.', 'accept')

    player_lokator = nil
    id_lokator = nil
  end
end)

addCommandHandler('anuluj', function()
  if player_lokator and id_lokator then
    outputChatBox("#00ff00● #ffffffPomyślnie anulowano prośbę.", 255, 255, 255, true)
    triggerServerEvent('house:add:lokator', resourceRoot, nil, player_lokator, getPlayerName(localPlayer)..' anulował twoją prośbę o dodanie jako lokatora.', 'cancel')

    player_lokator = nil
    id_lokator = nil
  end
end)

addEventHandler('onClientResourceStop', resourceRoot, function()
  editbox:destroyCustomEditbox('domek-DAYS1')
  editbox:destroyCustomEditbox('domek-LOKATOR1')
  gridlist:dxLibary_destroyGridlist('GRIDLIST-LOKATOR1')
end)
