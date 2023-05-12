--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local JOB = {}

JOB.blip = createBlip(2773.1259765625,-2416.3073730469,13.65098285675, 52)
setBlipVisibleDistance(JOB.blip, 300)
local noti = exports.dmta_base_notifications

JOB.objects = {}
JOB.vehicles = {}

local lokalizacje = {
    {2770.7297363281,-2409.7548828125,13.732954025269,0.0162353515625, 0},
    }
    
    for i,v in ipairs(lokalizacje) do
        pojazd = createVehicle(498, v[1], v[2], v[3], 0, 0, v[4])
        setVehicleColor(pojazd, 33, 33, 33, 105, 188, 235)
        ped = createPed(50, v[1], v[2], v[3], v[4])
        warpPedIntoVehicle(ped, pojazd)
        setVehicleDoorOpenRatio(pojazd, 4, 90)
        setVehicleDoorOpenRatio(pojazd, 5, 90)
        setElementFrozen(pojazd, true)
        setVehicleLocked(pojazd, true)
    end

addEvent("kurier.object", true)
addEventHandler("kurier.object", resourceRoot, function()
    JOB.objects[client] = createObject(3052, 0, 0, 0)
    attachElements(JOB.objects[client], client, 0, 0.5, 0.4)
    setElementCollisionsEnabled(JOB.objects[client], false)
    setPedAnimation(client, "CARRY", "crry_prtial", 4.1, true, true, true)
end)

addEvent("kurier.vehicle", true)
addEventHandler("kurier.vehicle", resourceRoot, function()
    JOB.vehicles[client] = createVehicle(498, 2769.2922363281,-2417.7795410156,13.704897880554,0.0162353515625, 0, 90)
    warpPedIntoVehicle(client, JOB.vehicles[client])
    setVehicleColor(JOB.vehicles[client], 33, 33, 33, 105, 188, 235)
    triggerClientEvent(client, "kurier.createAttached", resourceRoot, JOB.vehicles[client])
    setElementData(JOB.vehicles[client], "vehicle:ghost", true)
end)

addEvent("kurier.stop", true)
addEventHandler("kurier.stop", resourceRoot, function()
    if(JOB.objects[client] and isElement(JOB.objects[client]))then
        destroyElement(JOB.objects[client])
        JOB.objects[client] = nil
    end

    local player = client
    setPedAnimation(player, "CAMERA", "camstnd_to_camcrch", -1, false, false)
    setTimer(function()
        setPedAnimation(player, false)
    end, 100, 1)
end)

addEvent("kurier.destroyVehicle", true)
addEventHandler("kurier.destroyVehicle", resourceRoot, function()
    if(JOB.vehicles[client] and isElement(JOB.vehicles[client]))then
        destroyElement(JOB.vehicles[client])
        JOB.vehicles[client] = nil
    end
    setElementData(client, "job:vehicle", false, false)
end)

addEvent("kurier.money", true)
addEventHandler("kurier.money", resourceRoot, function(money)
    if(getElementData(client, "user:premium"))then
        money = money*1.5
    end
    
    givePlayerMoney(client, money)
    money = money
    setElementData(client, "user:zarobione", getElementData(client, "user:zarobione")+money)
    noti:addNotification(client, 'Otrzymujesz '..money..' $ za dostarczenie wszystkich paczek do celu.', 'success')

    local text_log = getPlayerName(client)..' > '..money..' $'
    exports['dmta_base_duty']:addLogs('job', text_log, client, 'JOB/COURIER')

    local money = getPlayerMoney(client)
    exports["dmta_base_connect"]:query("update db_users set money=? where login=?", money, getPlayerName(client))
    local exp = 10
    if getElementData(client, 'user:premium') then
        exp = exp*1.5
    end
    exports["dmta_levels"]:addExp(client, exp)
end)

addEventHandler("onPlayerQuit", root, function()
    if(JOB.objects[source] and isElement(JOB.objects[source]))then
        destroyElement(JOB.objects[source])
        JOB.objects[source] = nil
    end

    if(JOB.vehicles[source] and isElement(JOB.vehicles[source]))then
        destroyElement(JOB.vehicles[source])
        JOB.vehicles[source] = nil
    end
end)

addEventHandler("onVehicleStartEnter", resourceRoot, function(player, seat)
    if(seat ~= 0)then return end
    if(not JOB.vehicles[player] or JOB.vehicles[player] and source ~= JOB.vehicles[player])then
        cancelEvent()
    end
end)