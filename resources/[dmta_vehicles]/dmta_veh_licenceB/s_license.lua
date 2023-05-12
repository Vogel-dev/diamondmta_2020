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
local PJ = {}

PJ.vehs = {}
PJ.peds = {}

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

addEvent("start.pj", true)
addEventHandler("start.pj", resourceRoot, function(v, type)
    if(v.cost > 0)then
        if(getPlayerMoney(client) < v.cost)then
            noti:addNotification(client, 'Nie stać Cię na ten egzamin.', 'error')
            return
        else
            takePlayerMoney(client, v.cost)
        end
    end

    if(isPlayerHavePJ(client, type) == 0)then
        triggerClientEvent(client, "start.pj", resourceRoot, v, type)

        PJ.vehs[client] = createVehicle(unpack(v.veh))
        warpPedIntoVehicle(client, PJ.vehs[client])
        setElementData(PJ.vehs[client], "vehicle:ghost", true)
        setVehicleColor(PJ.vehs[client], 255, 255, 255)
        setElementInterior(PJ.vehs[client], 0)
        setElementInterior(client, 0)
        setVehicleHandling(PJ.vehs[client], "maxVelocity", 50)

        PJ.peds[client] = createPed(72, 0, 0, 0)
        warpPedIntoVehicle(PJ.peds[client], PJ.vehs[client], 1)
        setVehicleEngineState(PJ.vehs[client], true)
        local text_log = getPlayerName(client)..' rozpoczyna egzamin kat.B'
		duty:addLogs('lic', text_log, client, 'LIC-B/START')
    else
        noti:addNotification(client, 'Posiadasz już zdane prawo jazdy tej kategorii.', 'info')
    end
end)

addEvent("stop.pj", true)
addEventHandler("stop.pj", resourceRoot, function(passed)
    if(PJ.vehs[client] and isElement(PJ.vehs[client]))then
        destroyElement(PJ.vehs[client])
        PJ.vehs[client] = nil
    end

    if(PJ.peds[client] and isElement(PJ.peds[client]))then
        destroyElement(PJ.peds[client])
        PJ.peds[client] = nil
    end

    if(passed)then
        givePlayerPJ(client, passed)
        local text_log = getPlayerName(client)..' zdaje egzamin kat.B'
		duty:addLogs('lic', text_log, client, 'LIC-B/ZDANY')
    end
end)

addEventHandler("onVehicleStartEnter", resourceRoot, function(player, seat)
    cancelEvent()
end)

addEventHandler("onVehicleStartExit", resourceRoot, function(player, seat)
    if(PJ.vehs[player] and isElement(PJ.vehs[player]))then
        destroyElement(PJ.vehs[player])
        PJ.vehs[player] = nil
    end

    if(PJ.peds[player] and isElement(PJ.peds[player]))then
        destroyElement(PJ.peds[player])
        PJ.peds[player] = nil
    end

    triggerClientEvent(player, "stop.pj", resourceRoot)
    noti:addNotification(player, 'Oblewasz egzamin.', 'error')
    local text_log = getPlayerName(player)..' wysiada podczas - egzamin kat.B'
	duty:addLogs('lic', text_log, player, 'LIC-B/ERROR')

    setTimer(function()
        setElementPosition(player, 1776.6812744141,-1721.8638916016,13.546875)
        setElementInterior(player, 0)
    end, 500, 1)
end)

addEventHandler("onVehicleDamage", resourceRoot, function()
    local controller = getVehicleController(source)
    if(controller)then
        if(PJ.vehs[controller] and isElement(PJ.vehs[controller]))then
            destroyElement(PJ.vehs[controller])
            PJ.vehs[controller] = nil
        end

        if(PJ.peds[controller] and isElement(PJ.peds[controller]))then
            destroyElement(PJ.peds[controller])
            PJ.peds[controller] = nil
        end
    
        triggerClientEvent(controller, "stop.pj", resourceRoot)
        noti:addNotification(controller, 'Oblewasz egzamin.', 'error')
        local text_log = getPlayerName(controller)..' uderza podczas - egzamin kat.B'
        duty:addLogs('lic', text_log, controller, 'LIC-B/ERROR')
    
        setTimer(function()
            setElementPosition(controller, 1776.6812744141,-1721.8638916016,13.546875)
            setElementInterior(controller, 0)
        end, 500, 1)
    end
end)