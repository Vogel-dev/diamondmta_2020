--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local noti = exports.dmta_base_notifications
local db = exports.dmta_base_connect
local duty = exports['dmta_base_duty']

function formatMoney(money)
    while true do
        money, i = string.gsub(money, '^(-?%d+)(%d%d%d)', '%1,%2')
        if i == 0 then
            break
        end
    end
    return money
end

local cuboidy = {
	--1
	{1806.29858, -2026.33936, 12.53051, 5.85107421875, 3.7459716796875, 1.9194063186646,1809.4035644531,-2024.5177001953,13.267434120178},
    {1806.29858, -2026.33936-4, 12.53051, 5.85107421875, 3.7459716796875, 1.9194063186646,1809.4035644531,-2024.5177001953-4,13.267434120178},
    {1806.29858, -2026.33936-8, 12.53051, 5.85107421875, 3.7459716796875, 1.9194063186646,1809.4035644531,-2024.5177001953-8,13.267434120178},
    {1806.29858, -2026.33936-12, 12.53051, 5.85107421875, 3.7459716796875, 1.9194063186646,1809.4035644531,-2024.5177001953-12,13.267434120178},
    {1806.29858, -2026.33936-16, 12.53051, 5.85107421875, 3.7459716796875, 1.9194063186646,1809.4035644531,-2024.5177001953-16,13.267434120178},
    {1806.29858, -2026.33936-20, 12.53051, 5.85107421875, 3.7459716796875, 1.9194063186646,1809.4035644531,-2024.5177001953-20,13.267434120178},
    {1806.29858, -2026.33936-24, 12.53051, 5.85107421875, 3.7459716796875, 1.9194063186646,1809.4035644531,-2024.5177001953-24,13.267434120178},
    {1806.29858, -2026.33936-28, 12.53051, 5.85107421875, 3.7459716796875, 1.9194063186646,1809.4035644531,-2024.5177001953-28,13.267434120178},
    {1806.29858, -2026.33936-32, 12.53051, 5.85107421875, 3.7459716796875, 1.9194063186646,1809.4035644531,-2024.5177001953-32,13.267434120178},
    {1806.29858, -2026.33936-36, 12.53051, 5.85107421875, 3.7459716796875, 1.9194063186646,1809.4035644531,-2024.5177001953-36,13.267434120178},
    --2
    {1793.49426, -2034.54785, 12.51422, 5.78515625, 3.9244384765625, 1.8957246780396,1796.3768310547,-2032.6370849609,13.235927581787},
    {1793.49426, -2034.54785-4, 12.51422, 5.78515625, 3.9244384765625, 1.8957246780396,1796.3768310547,-2032.6370849609-4,13.235927581787},
    {1793.49426, -2034.54785-8, 12.51422, 5.78515625, 3.9244384765625, 1.8957246780396,1796.3768310547,-2032.6370849609-8,13.235927581787},
    {1793.49426, -2034.54785-12, 12.51422, 5.78515625, 3.9244384765625, 1.8957246780396,1796.3768310547,-2032.6370849609-12,13.235927581787},
    {1793.49426, -2034.54785-16, 12.51422, 5.78515625, 3.9244384765625, 1.8957246780396,1796.3768310547,-2032.6370849609-16,13.235927581787},
    {1793.49426, -2034.54785-20, 12.51422, 5.78515625, 3.9244384765625, 1.8957246780396,1796.3768310547,-2032.6370849609-20,13.235927581787},
    {1793.49426, -2034.54785-24, 12.51422, 5.78515625, 3.9244384765625, 1.8957246780396,1796.3768310547,-2032.6370849609-24,13.235927581787},
    {1793.49426, -2034.54785-28, 12.51422, 5.78515625, 3.9244384765625, 1.8957246780396,1796.3768310547,-2032.6370849609-28,13.235927581787},
    {1793.49426, -2034.54785-32, 12.51422, 5.78515625, 3.9244384765625, 1.8957246780396,1796.3768310547,-2032.6370849609-32,13.235927581787},
    --3
    {1787.33008, -2034.56030, 12.51275, 5.3739013671875, 3.9368896484375, 1.8888143539429,1790.1365966797,-2032.5852050781,13.234238624573},
    {1787.33008, -2034.56030-4, 12.51275, 5.3739013671875, 3.9368896484375, 1.8888143539429,1790.1365966797,-2032.5852050781-4,13.234238624573},
    {1787.33008, -2034.56030-8, 12.51275, 5.3739013671875, 3.9368896484375, 1.8888143539429,1790.1365966797,-2032.5852050781-8,13.234238624573},
    {1787.33008, -2034.56030-12, 12.51275, 5.3739013671875, 3.9368896484375, 1.8888143539429,1790.1365966797,-2032.5852050781-12,13.234238624573},
    {1787.33008, -2034.56030-16, 12.51275, 5.3739013671875, 3.9368896484375, 1.8888143539429,1790.1365966797,-2032.5852050781-16,13.234238624573},
    {1787.33008, -2034.56030-20, 12.51275, 5.3739013671875, 3.9368896484375, 1.8888143539429,1790.1365966797,-2032.5852050781-20,13.234238624573},
    {1787.33008, -2034.56030-24, 12.51275, 5.3739013671875, 3.9368896484375, 1.8888143539429,1790.1365966797,-2032.5852050781-24,13.234238624573},
    {1787.33008, -2034.56030-28, 12.51275, 5.3739013671875, 3.9368896484375, 1.8888143539429,1790.1365966797,-2032.5852050781-28,13.234238624573},
    {1787.33008, -2034.56030-32, 12.51275, 5.3739013671875, 3.9368896484375, 1.8888143539429,1790.1365966797,-2032.5852050781-32,13.234238624573},
    --4
    {1774.50757, -2034.58081, 12.50969, 5.8712158203125, 3.9913330078125, 1.8887619018555,1777.5229492188,-2032.583984375,13.231155395508},
    {1774.50757, -2034.58081-4, 12.50969, 5.8712158203125, 3.9913330078125, 1.8887619018555,1777.5229492188,-2032.583984375-4,13.231155395508},
    {1774.50757, -2034.58081-8, 12.50969, 5.8712158203125, 3.9913330078125, 1.8887619018555,1777.5229492188,-2032.583984375-8,13.231155395508},
    {1774.50757, -2034.58081-12, 12.50969, 5.8712158203125, 3.9913330078125, 1.8887619018555,1777.5229492188,-2032.583984375-12,13.231155395508},
    {1774.50757, -2034.58081-16, 12.50969, 5.8712158203125, 3.9913330078125, 1.8887619018555,1777.5229492188,-2032.583984375-16,13.231155395508},
    {1774.50757, -2034.58081-20, 12.50969, 5.8712158203125, 3.9913330078125, 1.8887619018555,1777.5229492188,-2032.583984375-20,13.231155395508},
    {1774.50757, -2034.58081-24, 12.50969, 5.8712158203125, 3.9913330078125, 1.8887619018555,1777.5229492188,-2032.583984375-24,13.231155395508},
    {1774.50757, -2034.58081-28, 12.50969, 5.8712158203125, 3.9913330078125, 1.8887619018555,1777.5229492188,-2032.583984375-28,13.231155395508},
    {1774.50757, -2034.58081-32, 12.50969, 5.8712158203125, 3.9913330078125, 1.8887619018555,1777.5229492188,-2032.583984375-32,13.231155395508}
}


local cs = {}

function czyStrefaJestZajeta(id)
    local zajeta = false
    local get = {}
    for i = 1,#cuboidy do
        get[i] = (#getElementsWithinColShape(cs[i], 'vehicle') > 0 and true or false)
    end
    return get[id]
end

function wyszukajWolnaStrefe()
    local wolna = false
    for i = 1,#cuboidy do
        if not czyStrefaJestZajeta(i) then
            wolna = i
            break
        end
    end
    return wolna
end

for i,v in pairs(cuboidy) do
    cs[i] = createColCuboid(v[1], v[2], v[3], v[4], v[5], v[6])
end

local marker = {}

local wystaw = createMarker(1809.0323486328,-2069.7829589844,13.556895256042-1, 'cylinder', 2.5, 0, 75, 255, 125)
setElementData(wystaw, 'marker:icon', 'car')
local usun = createColCuboid(1729.73340, -2076.93457, 12.63847 - 1, 82.414428710938, 56.799926757813, 5)

addEventHandler('onMarkerHit', resourceRoot, function(hit, dim)
    if not hit or hit and not isElement(hit) or hit and isElement(hit) and getElementType(hit) ~= 'player' or not dim then return end
    
    local veh = getElementData(source, 'gielda:veh')
    if source == wystaw and isPedInVehicle(hit) and getVehicleController(getPedOccupiedVehicle(hit)) == hit then
        local wolnaStrefa = wyszukajWolnaStrefe()
        if wolnaStrefa then
    	   triggerClientEvent(hit, 'open:gui', resourceRoot)
        else
            noti:addNotification(hit, 'W tej chwili, nie ma wolnych miejsc na giełdzie.', 'error')
        end
    elseif source ~= wystaw and not isPedInVehicle(hit) and veh then
    	triggerClientEvent(hit, 'show:gui', resourceRoot, veh)
    end
end)

addEventHandler('onColShapeLeave', usun, function(hit, dim)
    if not hit or hit and not isElement(hit) or hit and isElement(hit) and getElementType(hit) ~= 'vehicle' then return end

    if marker[hit] and isElement(marker[hit]) then
		destroyElement(marker[hit])
		marker[hit] = false
	end

	setElementData(hit, 'vehicle:sell', false)
end)

addEvent('wystaw:pojazd', true)
addEventHandler('wystaw:pojazd', resourceRoot, function(veh, cost)
    local wolnaStrefa = wyszukajWolnaStrefe()
    if wolnaStrefa then
        noti:addNotification(client, 'Pomyślnie wystawiono pojazd na giełdzie za cene '..cost..'$', 'success')

        marker[veh] = createMarker(0, 0, 0, 'cylinder', 1.35, 255, 235, 205, 75)
        attachElements(marker[veh], veh, 0, 3.75, -0.65)
        setElementData(marker[veh], 'gielda:veh', veh)
        setElementData(marker[veh], 'marker:icon', 'car')

        setElementData(veh, 'vehicle:sell', {cost=cost, owner=getPlayerName(client)})

        local x,y,z = cuboidy[wolnaStrefa][7],cuboidy[wolnaStrefa][8],cuboidy[wolnaStrefa][9]
        local rz = wolnaStrefa >= 11 and wolnaStrefa <= 19 and 270 or wolnaStrefa >= 20 and wolnaStrefa <= 28 and 90 or wolnaStrefa >= 29 and wolnaStrefa <= 37 and 270 or 90
        setElementPosition(veh, x,y,z)
        setElementRotation(veh, 0, 0, rz)

        setElementFrozen(veh, true)

        removePedFromVehicle(client)
        setElementPosition(client, x,y,z+1)
        local text_log = getPlayerName(client)..' wystawił pojazd '..getVehicleName(veh)..' (ID) '..getElementData(veh, 'vehicle:id')..' za cenę '..cost..' $'
		duty:addLogs('veh', text_log, client, 'EXCHANGE/WYSTAW')
    else
        noti:addNotification(client, 'Brak wolnego miejsca na giełdzie.', 'error')
    end
end)

addEvent('kup:pojazd', true)
addEventHandler('kup:pojazd', resourceRoot, function(veh)
    local id = getElementData(veh, 'vehicle:id')
    local sell = getElementData(veh, 'vehicle:sell')
    local typ = getPlayerFromName(sell.owner)
    if not id or not sell then return end

    local q = db:query('select * from db_vehicles where id=?', id)
    if not q or q and #q < 0 then return end

    sell.cost = tonumber(sell.cost)
    
    if getPlayerMoney(client) >= sell.cost then
        noti:addNotification(client, 'Zakupiono pojazd '..getVehicleName(veh)..', za cene: '..formatMoney(sell.cost)..'$', 'success')
        takePlayerMoney(client, sell.cost)
        db:query('update db_users set money=? where id=?', getPlayerMoney(client), getElementData(client, 'user:dbid'))
        db:query('update db_vehicles set owner=?, ownerName=? where id=?', getElementData(client, 'user:dbid'), getPlayerName(client), id)
        setElementData(veh, 'vehicle:owner', getElementData(client, 'user:dbid'))
        setElementData(veh, 'vehicle:ownerName', getPlayerName(client))
        setElementPosition(veh, 1809.0778808594,-2065.0810546875,13.211654663086)
        setElementRotation(veh, 0, 0, 90) 
        warpPedIntoVehicle(client, veh)
        setElementFrozen(veh, false)
        local text_log = getPlayerName(client)..' zakupił pojazd '..getVehicleName(veh)..' (ID) '..getElementData(veh, 'vehicle:id')..' za cenę: '..sell.cost..' $ od gracza: '..sell.owner..''
		duty:addLogs('veh', text_log, client, 'EXCHANGE/KUPNO')

        local typ = getPlayerFromName(sell.owner)
        if(typ)then
            givePlayerMoney(typ, sell.cost)
            db:query('update db_users set money=? where id=?', getPlayerMoney(typ), getElementData(typ, 'user:dbid'))
        else
            db:query('update db_users set money=money+? where login=?', sell.cost, sell.owner)
        end

        if marker[veh] and isElement(marker[veh]) then 
            destroyElement(marker[veh])
            marker[veh] = false
        end

        setElementData(veh, 'vehicle:sell', false)
    else
        noti:addNotification(client, 'Nie stać Cię na zakup tego pojazdu.', 'error')
    end
end)

addEvent('destroy', true)
addEventHandler('destroy', resourceRoot, function(veh)
    warpPedIntoVehicle(client, veh)
    setElementFrozen(veh, false)

    if marker[veh] and isElement(marker[veh]) then 
        destroyElement(marker[veh])
        marker[veh] = false
    end
end)

addEventHandler('onElementDestroy', root, function ()
	if getElementType(source) ~= 'vehicle' then return end
	
	local veh = source
    if marker[veh] and isElement(marker[veh]) then 
		destroyElement(marker[veh])
		marker[veh] = false
	end
end)

addEventHandler('onVehicleStartEnter', root, function(player)
    if getElementData(source, 'vehicle:sell') then
        cancelEvent()

        local owner = getElementData(source, 'vehicle:ownerName') or ''
        local text = owner == getPlayerName(player) and 'Aby zabrać pojazd, wejdź do markera.' or 'Nie możesz zabrać pojazdu z giełdy.'
        noti:addNotification(player, text, 'error')
    end
end)