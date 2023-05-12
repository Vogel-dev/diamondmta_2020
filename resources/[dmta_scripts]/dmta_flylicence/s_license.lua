--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local db = exports.dmta_base_connect
local LIC = {}

LIC.vehs = {}
LIC.peds = {}

function isPlayerHaveLIC(player, type)
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

function givePlayerLIC(player, type)
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

addEvent("start.lic", true)
addEventHandler("start.lic", resourceRoot, function(v, type)
    if(v.cost > 0)then
        if(getPlayerMoney(client) < v.cost)then
            outputChatBox("#ff0000● #ffffffNie stać Cię na ten egzamin.", client, 255, 255, 255, true)
            return
        else
            takePlayerMoney(client, v.cost)
        end
    end

    if(isPlayerHaveLIC(client, type) == 0)then
        triggerClientEvent(client, "start.lic", resourceRoot, v, type)

        LIC.vehs[client] = createVehicle(unpack(v.veh))
        warpPedIntoVehicle(client, LIC.vehs[client])
        setElementData(LIC.vehs[client], "vehicle:ghost", true)
        setVehicleColor(LIC.vehs[client], 255, 255, 255)
        setElementInterior(LIC.vehs[client], 0)
        setElementInterior(client, 0)

        LIC.peds[client] = createPed(17, 0, 0, 0)
        warpPedIntoVehicle(LIC.peds[client], LIC.vehs[client], 1)
    else
        outputChatBox("#fada5e● #ffffffPosiadasz już zdaną licencje lotniczą.", client, 255, 255, 255, true)
    end
end)

addEvent("stop.lic", true)
addEventHandler("stop.lic", resourceRoot, function(passed)
    if(LIC.vehs[client] and isElement(LIC.vehs[client]))then
        destroyElement(LIC.vehs[client])
        LIC.vehs[client] = nil
    end

    if(LIC.peds[client] and isElement(LIC.peds[client]))then
        destroyElement(LIC.peds[client])
        LIC.peds[client] = nil
    end

    if(passed)then
        givePlayerLIC(client, passed)
    end
end)

addEventHandler("onVehicleStartEnter", resourceRoot, function(player, seat)
    cancelEvent()
end)

addEventHandler("onVehicleStartExit", resourceRoot, function(player, seat)
    if(LIC.vehs[player] and isElement(LIC.vehs[player]))then
        destroyElement(LIC.vehs[player])
        LIC.vehs[player] = nil
    end

    if(LIC.peds[player] and isElement(LIC.peds[player]))then
        destroyElement(LIC.peds[player])
        LIC.peds[player] = nil
    end

    triggerClientEvent(player, "stop.lic", resourceRoot)
    outputChatBox("#ff0000● #ffffffOblewasz egzamin.", player, 255, 255, 255, true) 

    setTimer(function()
        setElementPosition(player, 1978.4455566406,-2189.4633789063,13.546875)
        setElementInterior(player, 0)
    end, 500, 1)
end)

addEventHandler("onVehicleDamage", resourceRoot, function()
    local controller = getVehicleController(source)
    if(controller)then
        if(LIC.vehs[controller] and isElement(LIC.vehs[controller]))then
            destroyElement(LIC.vehs[controller])
            LIC.vehs[controller] = nil
        end

        if(LIC.peds[controller] and isElement(LIC.peds[controller]))then
            destroyElement(LIC.peds[controller])
            LIC.peds[controller] = nil
        end
    
        triggerClientEvent(controller, "stop.lic", resourceRoot)
        outputChatBox("#ff0000● #ffffffOblewasz egzamin.", controller, 255, 255, 255, true) 
    
        setTimer(function()
            setElementPosition(controller, 1978.4455566406,-2189.4633789063,13.546875)
            setElementInterior(controller, 0)
        end, 500, 1)
    end
end)

function isPlayerHave(player)
	--if getElementData(player, 'zpj', true) then
	local q = db:query('select * from db_punishments where (serial=? or ip=? or nick=?) and active=1 and type=? and date>now() limit 1', getPlayerSerial(player), getPlayerIP(player), getPlayerName(player), 'lic')
	if q and #q > 0 then
		outputChatBox('-------------------------------------------', player, 255, 0, 0)
		outputChatBox('Posiadasz zawieszoną licencje lotniczą!', player, 255, 0, 0)
		outputChatBox('Osoba zawieszająca: '..q[1]['admin'], player, 255, 0, 0)
		outputChatBox('Powód zawieszenia: '..q[1]['reason'], player, 255, 0, 0)
		outputChatBox('Czas zawieszenia: '..q[1]['date'], player, 255, 0, 0)
		outputChatBox('----------------------------------------', player, 255, 0, 0)
		return false
	else
		db:query('update db_punishments set active=0 where (serial=? or ip=? or nick=?) and type=? limit 1',getPlayerSerial(player), getPlayerIP(player), getPlayerName(player), 'lic')
	end

	local result = db:query('select * from db_users where login=? limit 1', getPlayerName(player))
	if result and #result > 0 then
        if result[1]['prawkoL'] ~= 1 then
            outputChatBox("#ff0000● #ffffffMusisz posiadać licencje lotniczą.", controller, 255, 255, 255, true) 
            return false
        end
	end

	return true
end