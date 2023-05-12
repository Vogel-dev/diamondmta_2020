--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local db = exports.dmta_base_connect
local noti = exports.dmta_base_notifications
local duty = exports['dmta_base_duty']
local PJC = {}

PJC.vehs = {}
PJC.peds = {}

function isPlayerHavePJ(player, type)
    local result = db:query("select * from db_users where login=? limit 1", getPlayerName(player))
    if(type == "A")then
        return result[1].prawkoA
    elseif(type == "B")then
        return result[1].prawkoB
    elseif(type == "C")then
        return result[1].prawkoC 
    elseif(type == "L")then
        return result[1].prawkoL
    end
end

function givePlayerPJ(player, type)
    if(type == "A")then
        db:query("update db_users set prawkoA=1 where login=?", getPlayerName(player))
    elseif(type == "B")then
        db:query("update db_users set prawkoB=1 where login=?", getPlayerName(player))
    elseif(type == "C")then
        db:query("update db_users set prawkoC=1 where login=?", getPlayerName(player))
    elseif(type == "L")then
        db:query("update db_users set prawkoL=1 where login=?", getPlayerName(player))
    end
end

addEvent("start.pjC", true)
addEventHandler("start.pjC", resourceRoot, function(v, type)
    if(v.cost > 0)then
        if(getPlayerMoney(client) < v.cost)then
            noti:addNotification(client, 'Nie stać Cię na ten egzamin.', 'error')
            return
        else
            takePlayerMoney(client, v.cost)
        end
    end

    if(isPlayerHavePJ(client, type) == 0)then
        triggerClientEvent(client, "start.pjC", resourceRoot, v, type)

        PJC.vehs[client] = createVehicle(unpack(v.veh))
        warpPedIntoVehicle(client, PJC.vehs[client])
        setElementData(PJC.vehs[client], "vehicle:ghost", true)
        setVehicleColor(PJC.vehs[client], 255, 255, 255)
        setElementInterior(PJC.vehs[client], 0)
        setElementInterior(client, 0)
        setVehicleHandling(PJC.vehs[client], "maxVelocity", 50)

        PJC.peds[client] = createPed(56, 0, 0, 0)
        warpPedIntoVehicle(PJC.peds[client], PJC.vehs[client], 1)
        setVehicleEngineState(PJC.vehs[client], true)
        local text_log = getPlayerName(client)..' rozpoczyna egzamin kat.C'
		duty:addLogs('lic', text_log, client, 'LIC-C/START')
    else
        noti:addNotification(client, 'Posiadasz już zdane prawo jazdy tej kategorii.', 'info')
    end
end)

addEvent("stop.pjC", true)
addEventHandler("stop.pjC", resourceRoot, function(passed)
    if(PJC.vehs[client] and isElement(PJC.vehs[client]))then
        destroyElement(PJC.vehs[client])
        PJC.vehs[client] = nil
    end

    if(PJC.peds[client] and isElement(PJC.peds[client]))then
        destroyElement(PJC.peds[client])
        PJC.peds[client] = nil
    end

    if(passed)then
        givePlayerPJ(client, passed)
        local text_log = getPlayerName(client)..' zdaje egzamin kat.C'
		duty:addLogs('lic', text_log, client, 'LIC-C/ZDANY')
    end
end)

addEventHandler("onVehicleStartEnter", resourceRoot, function(player, seat)
    cancelEvent()
end)

addEventHandler("onVehicleStartExit", resourceRoot, function(player, seat)
    if(PJC.vehs[player] and isElement(PJC.vehs[player]))then
        destroyElement(PJC.vehs[player])
        PJC.vehs[player] = nil
    end

    if(PJC.peds[player] and isElement(PJC.peds[player]))then
        destroyElement(PJC.peds[player])
        PJC.peds[player] = nil
    end

    triggerClientEvent(player, "stop.pjC", resourceRoot)
    noti:addNotification(player, 'Oblewasz egzamin.', 'error')
    local text_log = getPlayerName(player)..' wysiada podczas - egzamin kat.C'
	duty:addLogs('lic', text_log, player, 'LIC-C/ERROR')

    setTimer(function()
        setElementPosition(player, 1776.6812744141,-1721.8638916016,13.546875)
        setElementInterior(player, 0)
    end, 500, 1)
end)

addEventHandler("onVehicleDamage", resourceRoot, function()
    local controller = getVehicleController(source)
    if(controller)then
        if(PJC.vehs[controller] and isElement(PJC.vehs[controller]))then
            destroyElement(PJC.vehs[controller])
            PJC.vehs[controller] = nil
        end

        if(PJC.peds[controller] and isElement(PJC.peds[controller]))then
            destroyElement(PJC.peds[controller])
            PJC.peds[controller] = nil
        end
    
        triggerClientEvent(controller, "stop.pjC", resourceRoot)
        noti:addNotification(controller, 'Oblewasz egzamin.', 'error')
        local text_log = getPlayerName(controller)..' uderza podczas - egzamin kat.C'
        duty:addLogs('lic', text_log, controller, 'LIC-C/ERROR')
    
        setTimer(function()
            setElementPosition(controller, 1776.6812744141,-1721.8638916016,13.546875)
            setElementInterior(controller, 0)
        end, 500, 1)
    end
end)