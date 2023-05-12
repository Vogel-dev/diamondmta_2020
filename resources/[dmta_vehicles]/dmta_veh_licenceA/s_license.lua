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
local PJA = {}

PJA.vehs = {}
PJA.peds = {}

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

addEvent("start.PJA", true)
addEventHandler("start.PJA", resourceRoot, function(v, type)
    if(v.cost > 0)then
        if(getPlayerMoney(client) < v.cost)then
            noti:addNotification(client, 'Nie stać Cię na ten egzamin.', 'error')
            return
        else
            takePlayerMoney(client, v.cost)
        end
    end

    if(isPlayerHavePJ(client, type) == 0)then
        triggerClientEvent(client, "start.PJA", resourceRoot, v, type)

        PJA.vehs[client] = createVehicle(unpack(v.veh))
        warpPedIntoVehicle(client, PJA.vehs[client])
        setElementData(PJA.vehs[client], "vehicle:ghost", true)
        setVehicleColor(PJA.vehs[client], 255, 255, 255)
        setElementInterior(PJA.vehs[client], 0)
        setElementInterior(client, 0)
        setVehicleHandling(PJA.vehs[client], "maxVelocity", 50)

        PJA.peds[client] = createPed(56, 0, 0, 0)
        warpPedIntoVehicle(PJA.peds[client], PJA.vehs[client], 1)
        setVehicleEngineState(PJA.vehs[client], true)
        local text_log = getPlayerName(client)..' rozpoczyna egzamin kat.A'
		duty:addLogs('lic', text_log, client, 'LIC-A/START')
    else
        noti:addNotification(client, 'Posiadasz już zdane prawo jazdy tej kategorii.', 'info')
    end
end)

addEvent("stop.PJA", true)
addEventHandler("stop.PJA", resourceRoot, function(passed)
    if(PJA.vehs[client] and isElement(PJA.vehs[client]))then
        destroyElement(PJA.vehs[client])
        PJA.vehs[client] = nil
    end

    if(PJA.peds[client] and isElement(PJA.peds[client]))then
        destroyElement(PJA.peds[client])
        PJA.peds[client] = nil
    end

    if(passed)then
        givePlayerPJ(client, passed)
        local text_log = getPlayerName(client)..' zdaje egzamin kat.A'
		duty:addLogs('lic', text_log, client, 'LIC-A/ZDANY')
    end
end)

addEventHandler("onVehicleStartEnter", resourceRoot, function(player, seat)
    cancelEvent()
end)

addEventHandler("onVehicleStartExit", resourceRoot, function(player, seat)
    if(PJA.vehs[player] and isElement(PJA.vehs[player]))then
        destroyElement(PJA.vehs[player])
        PJA.vehs[player] = nil
    end

    if(PJA.peds[player] and isElement(PJA.peds[player]))then
        destroyElement(PJA.peds[player])
        PJA.peds[player] = nil
    end

    triggerClientEvent(player, "stop.PJA", resourceRoot)
    noti:addNotification(player, 'Oblewasz egzamin.', 'error')
    local text_log = getPlayerName(player)..' wysiada podczas - egzamin kat.A'
	duty:addLogs('lic', text_log, player, 'LIC-A/ERROR')

    setTimer(function()
        setElementPosition(player, 1776.6812744141,-1721.8638916016,13.546875)
        setElementInterior(player, 0)
    end, 500, 1)
end)

addEventHandler("onVehicleDamage", resourceRoot, function()
    local controller = getVehicleController(source)
    if(controller)then
        if(PJA.vehs[controller] and isElement(PJA.vehs[controller]))then
            destroyElement(PJA.vehs[controller])
            PJA.vehs[controller] = nil
        end

        if(PJA.peds[controller] and isElement(PJA.peds[controller]))then
            destroyElement(PJA.peds[controller])
            PJA.peds[controller] = nil
        end
    
        triggerClientEvent(controller, "stop.PJA", resourceRoot)
        noti:addNotification(controller, 'Oblewasz egzamin.', 'error')
        local text_log = getPlayerName(controller)..' uderza podczas - egzamin kat.A'
        duty:addLogs('lic', text_log, controller, 'LIC-A/ERROR')
    
        setTimer(function()
            setElementPosition(controller, 1776.6812744141,-1721.8638916016,13.546875)
            setElementInterior(controller, 0)
        end, 500, 1)
    end
end)