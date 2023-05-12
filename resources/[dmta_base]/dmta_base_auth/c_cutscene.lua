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

local x,y,z = 0,0,0
local tickSpace = getTickCount()

local czasKoniec = getTickCount()
local czasKoniec2 = getTickCount()
local czasKoniec3 = getTickCount()
local czasKoniec4 = getTickCount()

function rotacja1()
    if rendering_wartosc == 1 then
        local speedx, speedy, speedz = getElementVelocity (veh)
        setElementVelocity(veh, speedx+0.001, speedy, speedz)
    end
end

function tutorial()
	fadeCamera(false, 0.01)
	triggerServerEvent('logowanie:zrespGracza', resourceRoot, localPlayer, 1497.943359375,-1601.4077148438,13.546875, {0,0}, true)
end

function endCamera()
  removeEventHandler('onClientRender',getRootElement(),camera)
  setElementData(localPlayer, 'user:logged', true)
  czasEnd = getTickCount()
	
  tutorial()
  triggerServerEvent('logowanie:zatwierdzPoradnik', resourceRoot, localPlayer, 2)

  if veh and isElement(veh) then
    destroyElement(veh)
    veh = false
  end

  if pilot and isElement(pilot) then
    destroyElement(pilot)
  end

  if ochrona1 and isElement(ochrona1) then
    destroyElement(ochrona1)
  end
--[[
  if ochrona2 and isElement(ochrona2) then
    destroyElement(ochrona2)
  end
--]]
  if ped6 and isElement(ped6) then
    destroyElement(ped6)
  end
end

function getSecond(second)
  second = tonumber(second)

  if second < 1000 then
    second = 5
  elseif second > 1000 and second < 2000 then
    second = 4
  elseif second > 2000 and second < 3000 then
    second = 3
  elseif second > 3000 and second < 4000 then
    second = 2
  elseif second > 4000 and second < 5000 then
    second = 1
  elseif second > 5000 and second < 6000 then
    second = 0
  else
    second = 5
  end

  return second
end

function camera()
   -- czarne paski
  for i = 0,1080 do
    local sY = i * (2/scale)
    dxDrawRectangle(0, sY, 1920/scale, 1/scale, tocolor(0, 0, 0, 75), false)
  end

  dxDrawRectangle(0, 0, 1920/scale, 95/scale, tocolor(0, 0, 0, (250-25)), false)
  dxDrawRectangle(0, 985/scale, 1920/scale, 95/scale, tocolor(0, 0, 0, 250), false)

  local second = getKeyState('space') and (getTickCount()-tickSpace) or 5
  if second ~= 5 then
    second = getSecond(second)
  end

  local text = 'Przytrzymaj #69bcebspacje#ffffff przez #69bceb'..second..'#ffffff sekund, aby pominąć przerywnik filmowy.'
  exports['dxLibary']:dxLibary_text(text, 0, 0, 1920/scale, 95/scale, tocolor(255, 255, 255, 255), 4, 'default', 'center', 'center', false, false, false, true, false)
  	
  if kamera == 1 then
    x, y, z = interpolateBetween(864,-2586,428,900,-2585,428, (getTickCount()-samolot1)/15000, 'Linear')
    setCameraMatrix(x,y,z,900,-2585,428)
    x1,y1,z1 = getElementPosition(veh)
    setElementPosition(veh,x1+0.1,y1,z1)
  elseif kamera == 2 then
    x, y, z = interpolateBetween(1430,-2478,19,1669,-2478,19, (getTickCount()-samolot2)/20000, 'Linear')
    setCameraMatrix(x,y,z,1699,-2495,19)
  elseif kamera == 3 then
    x, y, z = interpolateBetween(1908,-2290,15,1921,-2303,14, (getTickCount()-samolot3)/10000, 'Linear')
    setCameraMatrix(x,y,z,1925,-2306,14)
  elseif kamera == 4 then
    x, y, z = interpolateBetween(1785,-2468,20,1778,-2443,17, (getTickCount()-samolot4)/10000, 'Linear')
    setCameraMatrix(x,y,z,1772,-2437,16)
  end

  if x >= 896 and kamera == 1 then
    fadeCamera(false, 1.0, 0, 0, 0)
  end

  if x >= 899 and kamera == 1 then
    fadeCamera(true, 0.5)
    setElementFrozen(veh,false)
    samolot2 = getTickCount()
    kamera = 2
    destroyElement(veh)

    veh = createVehicle(519,1429.501953125,-2494.0219726563,13.5546875,0,0,270)
  end

  if x >= 1430 and kamera == 2 then
    local x,y,z = getElementPosition(veh)
    setElementPosition(veh,x+0.32,y,z)
  end
  
  if x >= 1655 and kamera == 2 then
    fadeCamera(false, 1.0, 0, 0, 0)
  end
  
  if x >= 1669 and kamera == 2 then
    fadeCamera(true, 0.5)
    destroyElement(veh)
    samolot3 = getTickCount()
    kamera = 3

    veh = createVehicle(519,1930.0883789063,-2312.7385253906,14.546875)
    setVehicleLocked(veh,true)
    setElementFrozen(veh,true)
    setVehicleDoorOpenRatio(veh,2,1,2500)
    pilot = createPed(253,1928.8006591797,-2305.2785644531,13.546875)
    --ochrona1 = createPed(229,1927.7120117188,-2307.9345703125,13.546875)
    -- ochrona2 = createPed(229,1927.7120117188,-2310.2,13.546875)
    ped6 = createPed(0,1926.4916992188,-2309.0817871094,13.546875)
    setElementRotation(pilot,0,0,90)
    setElementRotation(ochrona1,0,0,90)
    setElementRotation(ochrona2,0,0,90)
    setElementRotation(ped6,0,0,90)
    setPedAnimation(ped6, 'ped', 'WALK_civi')

    --setPedAnimation(ochrona1, 'DEALER', 'DEALER_IDLE', -1, true, false)
    setPedAnimation(pilot, 'LOWRIDER', 'M_smklean_loop', -1, true, false)
    --setPedAnimation(ochrona2, 'DEALER', 'DEALER_IDLE', -1, true, false)
  end
  
  if x >= 1921 and kamera == 3 then
    destroyElement(veh)
    destroyElement(pilot)
    --destroyElement(ochrona1)
    --destroyElement(ochrona2)
    destroyElement(ped6)
    samolot4 = getTickCount()
    kamera = 4

    ped6 = createPed(0,1768.4836425781,-2439.8366699219,13.5546875)
    setPedAnimation(ped6, 'ped', 'WALK_civi')
    setTimer(fadeCamera,3800,1,false, 1.0, 0, 0, 0)
    setTimer(fadeCamera,4500,true,0.5)
    setTimer(destroyElement,4500,1,ped6)
  end
  
  if x == 1778 and kamera == 4 then
    endCamera()
  end

  if getKeyState('space') and (getTickCount()-tickSpace) > 5000 then
    endCamera()
  elseif not getKeyState('space') then
    tickSpace = getTickCount()
  end
end