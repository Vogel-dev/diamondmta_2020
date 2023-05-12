--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local startCamera = getTickCount()
local actualCamera = 1

local camPosition = {
  {1629.07421875,-1885.462890625,45.365001678467,1612.6494140625,-1444.23046875,60.465003967285,15000,'Linear'},
  {1612.6494140625,-1444.23046875,60.465003967285,1630.0302734375,-1188.25390625,74.185104370117,8000,'Linear'},
  {1630.0302734375,-1188.25390625,74.185104370117,1556.1923828125,-1022.943359375,74.428398132324,5000,'Linear'},
  {1556.1923828125,-1022.943359375,74.428398132324,1382.060546875,-929.1875,84.88533782959,8000,'OutQuad'},
  {1382.060546875,-929.1875,84.88533782959,1172.0146484375,-900.337890625,119.89033508301,10000,'OutQuad'},
  {1172.0146484375,-900.337890625,119.89033508301,1139.720703125,-1080.33203125,117.39906311035,10000,'Linear'},
  {1139.720703125,-1080.33203125,117.39906311035,1230.458984375,-1461.2099609375,190.42976379395,10000,'Linear'},
  {1230.458984375,-1461.2099609375,190.42976379395,1837.9228515625,-1636.8046875,431.12976074219,12000,'OutQuad'},
  {1837.9228515625,-1636.8046875,431.12976074219,2090.5625,-967.8037109375,194.6250762939,8000,'Linear'},
  {2090.5625,-967.8037109375,194.6250762939,1165.41796875,-1382.1484375,147.6708068847,14000,'OutQuad'},
  {1165.41796875,-1382.1484375,147.6708068847,1558.529296875,-1775,109.42531585693,12000,'OutQuad'},
  {1558.529296875,-1775,109.42531585693,1629.07421875,-1885.462890625,45.365001678467,12000,'OutQuad'}
}

function camera_render()
  local x,y,z = interpolateBetween(camPosition[actualCamera][1], camPosition[actualCamera][2], camPosition[actualCamera][3], camPosition[actualCamera][4], camPosition[actualCamera][5], camPosition[actualCamera][6], (getTickCount() - startCamera) / camPosition[actualCamera][7], camPosition[actualCamera][8])
  setCameraMatrix(x,y,z,1645.2349853516,-1868.2073974609,59.248928070068)

  if (getTickCount()-startCamera) > camPosition[actualCamera][7] then
    if camPosition[actualCamera + 1] then
      actualCamera = actualCamera + 1
    else
      actualCamera = 1
    end

    startCamera = getTickCount()
  end
end

local sw,sh = guiGetScreenSize()
local baseX = 1920
local zoom = 1
local minzoom = 2
if sw < baseX then
    zoom = math.min(minzoom, baseX/sw)
end

local tick = getTickCount()
local action = 'login'
local regulamin = 0
local actionTick = false
local actionTypeLogin = 1
local actionTypeRegister = 1

local login,password = '',''

local notifications = {
  tick = getTickCount(),
  text = '',
  color = {255, 0, 0},
  back = false
}

images = {
  ['logo'] = exports['dxLibary']:createTexture(':dmta_base_auth/images/logo.png', 'dxt5', false, 'clamp'),
  ['logo2'] = exports['dxLibary']:createTexture(':dmta_base_auth/images/logo2.png', 'dxt5', false, 'clamp'),
  ['puls'] = exports['dxLibary']:createTexture(':dmta_base_auth/images/puls.png', 'dxt5', false, 'clamp'),
}

local spawns = {
    {1464.6962890625,-1025.240234375,23.828125},
    {1815.591796875,-1406.1787109375,13.424609184265},
    {1898.0341796875, -1204.642578125, 19.497230529785},
    {1722.421875, -1880.5751953125, 13.564747810364},
    {1479.29296875,-1616.33203125,14.039297103882},
    {1128.494140625,-1458.0419921875,15.796875},
    {1954.005859375,-2177.2236328125,13.546875},
    {2176.724609375,-1761.84375,13.546875},
    {814.47265625,-1352.251953125,13.533407211304},
    {2232.46875,-1159.724609375,25.890625},
    {1225.6953125,-1094.9832763672,25.525096893311},
}

local cameras = {
  {pos={1679.4040527344,-1817.7581787109,59.880001068115,1679.9091796875,-1818.5628662109,59.568103790283, 1720.4075927734,-1739.6469726563,60.955799102783,1719.9841308594,-1738.8822021484,60.47021484375}, time=10},
  {pos={1720.4075927734,-1739.6469726563,60.955799102783,1719.9841308594,-1738.8822021484,60.47021484375, 1903.7032470703,-1752.0319824219,60.912601470947,1904.5310058594,-1752.3333740234,60.439357757568}, time=10},
  {pos={1903.7032470703,-1752.0319824219,60.912601470947,1904.5310058594,-1752.3333740234,60.439357757568, 2089.9248046875,-1929.3918457031,53.578701019287,2089.1147460938,-1928.9437255859,53.200824737549}, time=10},
  {pos={2089.9248046875,-1929.3918457031,53.578701019287,2089.1147460938,-1928.9437255859,53.200824737549, 2233.6147460938,-1644.34765625,54.288501739502,2234.0554199219,-1645.0322265625,53.707847595215}, time=10},
  {pos={2233.6147460938,-1644.34765625,54.288501739502,2234.0554199219,-1645.0322265625,53.707847595215, 1931.4125976563,-1443.5472412109,53.998699188232,1930.9786376953,-1442.7963867188,53.500869750977}, time=10},
  {pos={1931.4125976563,-1443.5472412109,53.998699188232,1930.9786376953,-1442.7963867188,53.500869750977, 1887.1563720703,-1227.5179443359,53.669399261475,1887.8627929688,-1226.9365234375,53.265636444092}, time=10},
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

function addNotificationPanel(text, color)
  notifications['text'] = text
  notifications['color'] = color
  notifications['tick'] = getTickCount()
  notifications['back'] = false
  notifications['visible'] = true
end
addEvent('addNotificationPanel', true)
addEventHandler('addNotificationPanel', resourceRoot, addNotificationPanel)

local checkbox = exports['dxLibary']:createTexture(':dmta_base_auth/images/checkbox.png', 'dxt5', false, 'clamp')
local checkbox_selected = exports['dxLibary']:createTexture(':dmta_base_auth/images/checkbox_selected.png', 'dxt5', false, 'clamp')

function gui()
  local tickTime = 500
  local animations = {
    ['button'] = {
      actionTick ~= false and {interpolateBetween(sw, 0, 0, 800, 0, 0, (getTickCount()-actionTick)/tickTime, 'OutBack'), interpolateBetween(800, 0, 0, -1500, 0, 0, (getTickCount()-actionTick)/tickTime, 'OutBack')} or {800, -1500},
    },
    ['checkbox'] = {
      actionTick ~= false and {interpolateBetween(sw - 30, 0, 0, 825, 0, 0, (getTickCount()-actionTick)/tickTime, 'OutBack'), interpolateBetween(825, 0, 0, -1500, 0, 0, (getTickCount()-actionTick)/tickTime, 'OutBack')} or {825, -1500},
    },
    ['editbox'] = {
      actionTick ~= false and {interpolateBetween(sw, 0, 0, 800, 0, 0, (getTickCount()-actionTick)/tickTime, 'OutBack'), interpolateBetween(800, 0, 0, -1500, 0, 0, (getTickCount()-actionTick)/tickTime, 'OutBack')} or {800, -1500},
    },
  }

  if action == 'login' then
    dxDrawRectangle(0, 0, 1920, 1080, tocolor(15, 15, 15, 200), false)
    exports['editbox']:customEditboxSetPosition('LOGGING-LOGIN1', animations['editbox'][1][actionTypeLogin]/zoom, 444/zoom)
    exports['editbox']:customEditboxSetPosition('LOGGING-HASH1', animations['editbox'][1][actionTypeLogin]/zoom, 510/zoom)

  	exports['dxLibary']:dxLibary_createButton('Zaloguj się', animations['button'][1][actionTypeLogin]/zoom, 622/zoom, 324/zoom, 35/zoom, 3)

    if getElementData(localPlayer, 'zapamietajLogin') == 1 then
      dxDrawImage(animations['button'][1][actionTypeLogin]/zoom, 582/zoom, 19/zoom, 19/zoom, checkbox_selected, 0, 0, 0, tocolor(255, 255, 255, 255), false)
    else
      dxDrawImage(animations['button'][1][actionTypeLogin]/zoom, 582/zoom, 19/zoom, 19/zoom, checkbox, 0, 0, 0, tocolor(255, 255, 255, 255), false)
    end

  	exports['dxLibary']:dxLibary_shadowText2('Zapamiętaj moje dane', animations['checkbox'][1][actionTypeLogin]/zoom, 582/zoom, 953/zoom, 600/zoom, tocolor(255, 255, 255, 255), 1, 'default', 'left', 'top', false, false, false, false, false)

    local x = math.sin(getTickCount()/500)*1
  	dxDrawImage((644 + x)/zoom, 220/zoom, 632/zoom, 194/zoom, images['logo'])

    local a = (math.sqrt(getSoundFFTData(sound, 2048, 2)[1])*256) or 150
    dxDrawImage((747 + x)/zoom, 102/zoom, 400/zoom, 400/zoom, images['puls'], 0, 0, 0, tocolor(105, 188, 235, a), false)

  	exports['dxLibary']:dxLibary_text('Nie posiadasz konta?  Załóż je teraz!', animations['button'][1][actionTypeLogin]/zoom + 1, 645/zoom + 1, 1123/zoom + 1, 705/zoom + 1, tocolor(0, 0, 0, 255), 1, 'default', 'center', 'center', false, false, false, true, false)
  	exports['dxLibary']:dxLibary_text('Nie posiadasz konta?  #69bcebZałóż je teraz!', animations['button'][1][actionTypeLogin]/zoom, 645/zoom, 1123/zoom, 705/zoom, tocolor(255, 255, 255, 255), 1, 'default', 'center', 'center', false, false, false, true, false)
  elseif action == 'register' then
    dxDrawRectangle(0, 0, 1920, 1080, tocolor(15, 15, 15, 200), false)
    exports['editbox']:customEditboxSetPosition('LOGGING-LOGIN1', animations['editbox'][1][actionTypeRegister]/zoom, 444/zoom)
    exports['editbox']:customEditboxSetPosition('LOGGING-HASH1', animations['editbox'][1][actionTypeRegister]/zoom, 510/zoom)
    exports['editbox']:customEditboxSetPosition('LOGGING-EMAIL', animations['editbox'][1][actionTypeRegister]/zoom, 575/zoom)

    exports['dxLibary']:dxLibary_createButton('Stwórz konto', animations['button'][1][actionTypeRegister]/zoom, 675/zoom, 324/zoom, 35/zoom, 3)

    if regulamin == 1 then
      dxDrawImage(animations['button'][1][actionTypeRegister]/zoom, 640/zoom, 19/zoom, 19/zoom, checkbox_selected, 0, 0, 0, tocolor(255, 255, 255, 255), false)
    else
      dxDrawImage(animations['button'][1][actionTypeRegister]/zoom, 640/zoom, 19/zoom, 19/zoom, checkbox, 0, 0, 0, tocolor(255, 255, 255, 255), false)
    end

  	exports['dxLibary']:dxLibary_shadowText2('Akceptuje regulamin', animations['checkbox'][1][actionTypeRegister]/zoom, 640/zoom, 953/zoom, 600/zoom, tocolor(255, 255, 255, 255), 1, 'default', 'left', 'top', false, false, false, false, false)

    local x = math.sin(getTickCount()/500)*1
  	dxDrawImage((644 + x)/zoom, 220/zoom, 632/zoom, 194/zoom, images['logo'])

    local a = (math.sqrt(getSoundFFTData(sound, 2048, 2)[1])*256) or 150
    dxDrawImage((747 + x)/zoom, 102/zoom, 400/zoom, 400/zoom, images['puls'], 0, 0, 0, tocolor(105, 188, 235, a), false)

  	exports['dxLibary']:dxLibary_text('Posiadasz już konto?  Zaloguj się teraz!', animations['button'][1][actionTypeRegister]/zoom + 1, 750/zoom + 1, 1123/zoom + 1, 705/zoom + 1, tocolor(0, 0, 0, 255), 1, 'default', 'center', 'center', false, false, false, true, false)
  	exports['dxLibary']:dxLibary_text('Posiadasz już konto?  #69bcebZaloguj się teraz!', animations['button'][1][actionTypeRegister]/zoom, 750/zoom, 1123/zoom, 705/zoom, tocolor(255, 255, 255, 255), 1, 'default', 'center', 'center', false, false, false, true, false)
  end

  if notifications['visible'] == true then
    if (getTickCount()-notifications['tick']) > 5000 and notifications['back'] ~= true then
      notifications['back'] = true
      notifications['tick'] = getTickCount()
    elseif (getTickCount()-notifications['tick']) > 1000 and notifications['back'] == true then
      notifications['text'] = ''
      notifications['back'] = false
      notifications['visible'] = false
      return
    end

    local y = notifications['back'] ~= true and interpolateBetween(-47, 0, 0, 22, 0, 0, (getTickCount()-notifications['tick'])/1000, 'OutBack') or interpolateBetween(22, 0, 0, -47, 0, 0, (getTickCount()-notifications['tick'])/1000, 'OutBack')

    customWindow(698/zoom, y/zoom, 524/zoom, 47/zoom, tocolor(notifications['color'][1], notifications['color'][2], notifications['color'][3], 200))

    exports['dxLibary']:dxLibary_shadowText2(notifications['text'], 698/zoom, y/zoom, 524/zoom + 698/zoom, 47/zoom + y/zoom, tocolor(notifications['color'][1], notifications['color'][2], notifications['color'][3], 255), 2, 'default', 'center', 'center', false, true, true, false, false)
  end
end

function customWindow(x, y, w, h, color)
  dxDrawRectangle(x, y, w, h, tocolor(15, 15, 15, 200), false)
  dxDrawRectangle(x, (y + h), w, 2, color, false)
end

function clicked(btn, state)
  if btn ~= 'left' or state ~= 'down' then return end

  if isMouseIn(799/zoom, 582/zoom, 19/zoom, 18/zoom) and action == 'login' then
    setElementData(localPlayer,'zapamietajLogin', (getElementData(localPlayer, 'zapamietajLogin') == 1 and 0 or 1))
  elseif isMouseIn(799/zoom, 640/zoom, 19/zoom, 18/zoom) and action == 'register' then
    regulamin = regulamin == 1 and 0 or 1
  elseif isMouseIn(799/zoom, 622/zoom, 324/zoom, 35/zoom) and action == 'login' then
    local login = exports['editbox']:getCustomEditboxText('LOGGING-LOGIN1')
    local haslo = exports['editbox']:getCustomEditboxText('LOGGING-HASH1')

    if string.len(login) < 4 then
      addNotificationPanel('Login powinien posiadać przynajmniej 4 znaki.', {255, 0, 0})
		  return
    elseif string.len(haslo) < 7 then
      addNotificationPanel('Hasło powinno posiadać przynajmniej 7 znaków.', {255, 0, 0})
      return
    end

    triggerServerEvent('logowanie:zaloguj', resourceRoot, localPlayer, login, haslo)
  elseif isMouseIn(799/zoom, 675/zoom, 324/zoom, 35/zoom) and action == 'register' then
    if regulamin ~= 1 then
      addNotificationPanel('Najpierw zaakceptuj regulamin.', {255, 0, 0})
      return
    end

    local login = exports['editbox']:getCustomEditboxText('LOGGING-LOGIN1')
    local haslo = exports['editbox']:getCustomEditboxText('LOGGING-HASH1')
    local email = exports['editbox']:getCustomEditboxText('LOGGING-EMAIL')

    if string.len(login) < 4 then
      addNotificationPanel('Login powinien posiadać przynajmniej 4 znaki.', {255, 0, 0})
		  return
    elseif string.len(haslo) < 7 then
      addNotificationPanel('Hasło powinno posiadać przynajmniej 7 znaków.', {255, 0, 0})
			return
    elseif string.len(email) < 5 then
      addNotificationPanel('Adres e-mail powinien posiadać przynajmniej 5 znaków.', {255, 0, 0})
			return
		elseif not string.match(email, '[A-Za-z0-9%.%%%+%-]+@[A-Za-z0-9%.%%%+%-]+%.%w%w%w?%w?') then
      addNotificationPanel('Adres e-mail jest nieprawidłowy.', {255, 0, 0})
      return
    end

    triggerServerEvent('logowanie:rejestracja', resourceRoot, localPlayer, login, haslo, email)
  elseif isMouseIn(806/zoom, 665/zoom, 306/zoom, 20/zoom) and action == 'login' then
    exports['editbox']:createCustomEditbox('LOGGING-EMAIL', 'Adres e-mail...', sw, sh, 323/zoom, 42/zoom, false, '')
    setTimer(function()
      action = 'register'
      actionTick = getTickCount()
    end, 100, 1)
    actionTick = getTickCount()
    actionTypeLogin = 2
    actionTypeRegister = 1
    exports['editbox']:customEditboxSetText('LOGGING-LOGIN1', '')
    exports['editbox']:customEditboxSetText('LOGGING-HASH1', '')
  elseif isMouseIn(806/zoom, 718/zoom, 306/zoom, 20/zoom) and action == 'register' then
    exports['editbox']:destroyCustomEditbox('LOGGING-EMAIL')
    setTimer(function()
      action = 'login'
      actionTick = getTickCount()
    end, 300, 1)
    actionTick = getTickCount()
    actionTypeRegister = 2
    actionTypeLogin = 1
    exports['editbox']:customEditboxSetText('LOGGING-LOGIN1', login)
    exports['editbox']:customEditboxSetText('LOGGING-HASH1', password)
  end
end

-- usefull function created by Asper

  function isMouseInPosition(x, y, w, h)
    if not isCursorShowing() then return end
    
    local mouse = {getCursorPosition()}
    local myX, myY = (mouse[1] * sw), (mouse[2] * sh)
    if (myX >= x and myX <= (x + w)) and (myY >= y and myY <= (y + h)) then
        return true
    end
    
    return false
end

local click = false
function onClick(x, y, w, h, called)
    if(isMouseInPosition(x, y, w, h) and not click and getKeyState("mouse1"))then
        click = true
        called()
    elseif(not getKeyState("mouse1") and click)then
        click = false
    end
end

--

-- new places

local places = {
  {pos={994.73101806641,-1311.1893310547,13.546875},camera={972.54827880859,-1333.5218505859,26.112300872803,973.34423828125,-1332.9815673828,25.839324951172},name="Centrum, Los Santos"},
  {pos={1481.1463623047,-1708.0764160156,14.046875},camera={1460.1746826172,-1709.3797607422,25.612499237061,1460.7412109375,-1710.17578125,25.399364471436},name="Urząd, Los Santos"},
}
function startPlaces()
  for i,v in pairs(places) do
    local sY = (75/zoom)*(i-1)  	
    exports['dxLibary']:dxLibary_createButton(v.name, 20/zoom, 20/zoom+sY, 300/zoom, 70/zoom, 3, 245)

    if(isMouseInPosition(20/zoom, 20/zoom+sY, 300/zoom, 70/zoom))then
      setCameraMatrix(unpack(v.camera))
    end

    onClick(20/zoom, 20/zoom+sY, 300/zoom, 70/zoom, function()
      triggerServerEvent('logowanie:zrespGracza', resourceRoot, localPlayer, v.pos[1], v.pos[2], v.pos[3])
      showCursor(false)
      removeEventHandler("onClientRender", root, startPlaces)
    end)
  end
end

--

addEvent('wybieramyspawn:logowanie',true)
addEventHandler( 'wybieramyspawn:logowanie', getLocalPlayer(), function(player, wynik, ban, lastPos, domki)
    exports['editbox']:destroyCustomEditbox('LOGGING-LOGIN1')
    exports['editbox']:destroyCustomEditbox('LOGGING-HASH1')
    exports['editbox']:destroyCustomEditbox('LOGGING-EMAIL')
    removeEventHandler('onClientRender', root, gui)
    removeEventHandler('onClientClick', root, clicked)
    showCursor(false)

    if ban then return end

    removeEventHandler('onClientRender', root, camera_render)

    if wynik[1]['cut'] == 'TAK' then
      addEventHandler("onClientRender", root, startPlaces)
      showCursor(true)
      setElementData(localPlayer, 'player:blackwhite', false)

      setCameraMatrix(unpack(places[1].camera))        
      
      if(lastPos)then
        table.insert(places, {pos=lastPos, camera=lastPos, name="Ostatnia pozycja"})  
      end

      if(domki)then
        for i,v in pairs(domki) do
          local wejscie = split(v.wejscie, ",")
          table.insert(places, {pos={wejscie[1], wejscie[2], wejscie[3]}, camera={wejscie[1], wejscie[2], wejscie[3]}, name=v.nazwa})
        end
      end
	  elseif wynik[1]['cut'] == 'NIE' then
        veh = createVehicle(519,898.04577636719,-2587.9560546875,427.64086914063,0,0,270)
        setVehicleLandingGearDown(veh,false)
        setElementFrozen(veh,true)
        setVehicleEngineState(veh, true)
        kamera = 1
        samolot1 = getTickCount()
        addEventHandler('onClientRender',getRootElement(),camera)
    end
end)

addEventHandler('onClientResourceStart', resourceRoot, function()
  if getElementData(localPlayer, 'user:dbid') then return end

  startCamera = getTickCount()
  actualCamera = 1
  addEventHandler('onClientRender', root, camera_render)

  addEventHandler('onClientRender',getRootElement(),gui)
  exports['editbox']:createCustomEditbox('LOGGING-LOGIN1', 'Imię i nazwisko postaci (np. John_Black)', sw, sh, 323/zoom, 42/zoom, false, '')
  exports['editbox']:createCustomEditbox('LOGGING-HASH1', 'Hasło dostępu do konta...', sw, sh, 323/zoom, 42/zoom, true, '')
  setPlayerHudComponentVisible('all', false)
  setElementData(localPlayer, 'player:blackwhite', true)
  setElementData(localPlayer, 'wPaneluLogowania', true)
  setElementData(localPlayer, 'pokaz:hud', false)
  showCursor(true)
  showChat(false)
  fadeCamera(true)
  music(true)
  addEventHandler('onClientClick', root, clicked)
  triggerServerEvent('getSave', resourceRoot)
end)

addEvent('loadingScreen', true)
addEventHandler('loadingScreen', resourceRoot, function()
  exports['dmta_base_loading']:createLoadingScreen('Trwa ładowanie gry', 3000, true)
  exports.dmta_base_textures:loadTextures()
end)

addEvent('setDates', true)
addEventHandler('setDates', resourceRoot, function(save)
  if save then
    setElementData(localPlayer, 'zapamietajLogin', 1)

    data = loadDateFromXML() or {'', ''}
    login, password = unpack(data)

    exports['editbox']:customEditboxSetText('LOGGING-LOGIN1', login)
    exports['editbox']:customEditboxSetText('LOGGING-HASH1', password)
  else
    setElementData(localPlayer, 'zapamietajLogin', 0)
  end
end)

addEventHandler('onClientResourceStop', resourceRoot, function()
  exports['editbox']:destroyCustomEditbox('LOGGING-LOGIN1')
  exports['editbox']:destroyCustomEditbox('LOGGING-HASH1')
  exports['editbox']:destroyCustomEditbox('LOGGING-EMAIL')
end)
