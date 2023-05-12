--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local JOB = {}

JOB.objects = {}

JOB.blip = createBlip(2185.3859863281,-2255.3732910156,14.770004272461, 52)
setBlipVisibleDistance(JOB.blip, 300)

local noti = exports.dmta_base_notifications

addEvent("magazyn.object", true)
addEventHandler("magazyn.object", resourceRoot, function()
    JOB.objects[client] = createObject(3052, 0, 0, 0)
    attachElements(JOB.objects[client], client, 0, 0.5, 0.4)
    setElementCollisionsEnabled(JOB.objects[client], false)
    setPedAnimation(client, "CARRY", "crry_prtial", 4.1, true, true, true)
end)

addEvent("magazyn.stop", true)
addEventHandler("magazyn.stop", resourceRoot, function()
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

addEvent("magazyn.money", true)
addEventHandler("magazyn.money", resourceRoot, function(money)
    if(getElementData(client, "user:premium"))then
        money = money*1.5
    end
    
    givePlayerMoney(client, money)
    money = money
    setElementData(client, "user:zarobione", getElementData(client, "user:zarobione")+money)
    noti:addNotification(client, 'Otrzymujesz '..money..' $\nUdaj się po kolejna paczkę', 'success')

    local text_log = getPlayerName(client)..' > '..money..' $'
    exports['dmta_base_duty']:addLogs('job', text_log, client, 'JOB/WAREHOUSE')
    
    local money = getPlayerMoney(client)
    exports["dmta_base_connect"]:query("update db_users set money=? where login=?", money, getPlayerName(client))
    local exp = 2
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
end)