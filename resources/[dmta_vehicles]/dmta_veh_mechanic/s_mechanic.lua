--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local noti = exports['dmta_base_notifications']
local duty = exports['dmta_base_duty']

addEvent("mechanic.repair", true)
addEventHandler("mechanic.repair", resourceRoot, function(veh, i, koszt, name)
  koszt = tonumber(koszt)
  i = tonumber(i)

  if(koszt > getPlayerMoney(client))then
  noti:addNotification(client, 'Brak wystarczających funduszy!', 'error')
    return
  end
  
  takePlayerMoney(client, koszt)
  local text_log = ''..getPlayerName(client)..' naprawił część za '..koszt..' $.'
		duty:addLogs('veh', text_log, client, 'MECHANIC/FIX')
  

  if i == 1 then
    setElementHealth(veh, 1000)
  elseif i == 2 then
    setVehicleDoorState(veh, 0, 0)
  elseif i == 3 then
    setVehicleDoorState(veh, 1, 0)
  elseif i == 4 then
    setVehicleDoorState(veh, 2, 0)
  elseif i == 5 then
    setVehicleDoorState(veh, 3, 0)
  elseif i == 6 then
    setVehicleDoorState(veh, 4, 0)
  elseif i == 7 then
    setVehicleDoorState(veh, 5, 0)
  elseif i == 8 then
    setVehiclePanelState(veh, 4, 0)
  elseif i == 9 then
    setVehiclePanelState(veh, 5, 0)
  elseif i == 10 then
    setVehiclePanelState(veh, 6, 0)
  elseif i == 11 then
    setVehicleLightState(veh, 0, 0)
    setVehicleLightState(veh, 1, 0)
    setVehicleLightState(veh, 2, 0)
    setVehicleLightState(veh, 3, 0)
  elseif i == 12 then
    setVehicleWheelStates(veh, 0, 0, 0, 0)
  end
end)