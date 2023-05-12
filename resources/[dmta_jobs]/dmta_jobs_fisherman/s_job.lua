--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--


local JOB = {}

JOB.blip = createBlip(2291.0798339844,-2420.5290527344,3, 52)
setBlipVisibleDistance(JOB.blip, 300)
local noti = exports.dmta_base_notifications

JOB.vehicles = {}

addEvent("rybak.vehicle", true)
addEventHandler("rybak.vehicle", resourceRoot, function()
    JOB.vehicles[client] = createVehicle(453, 2287.0451660156,-2442.5532226563,-0.29352161288261,0, 0, 251.39099121094)
    warpPedIntoVehicle(client, JOB.vehicles[client])
    setElementData(JOB.vehicles[client], "vehicle:ghost", true)
end)

addEvent("rybak.destroyVehicle", true)
addEventHandler("rybak.destroyVehicle", resourceRoot, function()
    if(JOB.vehicles[client] and isElement(JOB.vehicles[client]))then
        destroyElement(JOB.vehicles[client])
        JOB.vehicles[client] = nil
    end
    setElementData(client, "job:vehicle", false, false)
end)

addEvent("rybak.money", true)
addEventHandler("rybak.money", resourceRoot, function(money)
    if(getElementData(client, "user:premium"))then
        money = money*1.5
    end
    
    givePlayerMoney(client, money)
    money = money
    setElementData(client, "user:zarobione", getElementData(client, "user:zarobione")+money)
    noti:addNotification(client, 'Otrzymujesz '..money..' $ za złowione ryby.', 'success')

    local text_log = getPlayerName(client)..' > '..money..' $'
    exports['dmta_base_duty']:addLogs('job', text_log, client, 'JOB/FISHERMAN')
    
    local money = getPlayerMoney(client)
    exports["dmta_base_connect"]:query("update db_users set money=? where login=?", money, getPlayerName(client))
    local exp = 2
    if getElementData(client, 'user:premium') then
        exp = exp*1.5
    end
    exports["dmta_levels"]:addExp(client, exp)
end)

addEventHandler("onPlayerQuit", root, function()
    if(JOB.vehicles[source] and isElement(JOB.vehicles[source]))then
        destroyElement(JOB.vehicles[source])
        JOB.vehicles[source] = nil
    end
end)

addEventHandler("onPlayerQuit", root, function()
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