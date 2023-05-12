--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

function math.percent(percent,maxvalue)
    if tonumber(percent) and tonumber(maxvalue) then
        return (maxvalue*percent)/100
    end
    return false
end

local JOB = {}

JOB.vehicles = {}
local noti = exports.dmta_base_notifications

JOB.blip = createBlip(1998.2813720703,-2248.2526855469,13.546875, 52)
setBlipVisibleDistance(JOB.blip, 300)

addEvent("dodo.rozpocznij", true)
addEventHandler("dodo.rozpocznij", resourceRoot, function()
    JOB.vehicles[client] = createVehicle(593, 1988.7912597656,-2247.0932617188,13.546875,0,0,90)
    warpPedIntoVehicle(client, JOB.vehicles[client])
    setElementData(JOB.vehicles[client], "vehicle:ghost", true)
end)

addEvent("dodo.stop", true)
addEventHandler("dodo.stop", resourceRoot, function()
    if(JOB.vehicles[client] and isElement(JOB.vehicles[client]))then
        destroyElement(JOB.vehicles[client])
        JOB.vehicles[client] = nil
    end
end)

addEvent("dodo.money", true)
addEventHandler("dodo.money", resourceRoot, function(money)
    if(getElementData(client, "user:premium"))then
        money = money*1.5
    end
    
    givePlayerMoney(client, money)
    money = money
    setElementData(client, "user:zarobione", getElementData(client, "user:zarobione")+money)
    noti:addNotification(client, 'Otrzymujesz '..money..' $\nUdaj się do nastepnęgo miejsca.', 'success')

    local text_log = getPlayerName(client)..' > '..money..' $'
    exports['dmta_base_duty']:addLogs('job', text_log, client, 'JOB/DODO')
    
    local money = getPlayerMoney(client)
    exports["dmta_base_connect"]:query("update db_users set money=? where login=?", money, getPlayerName(client))
    local exp = 5
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

addEventHandler("onVehicleStartEnter", resourceRoot, function(player, seat)
    if(seat ~= 0)then return end
    if(not JOB.vehicles[player] or JOB.vehicles[player] and source ~= JOB.vehicles[player])then
        cancelEvent()
    end
end)