--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local db = exports.dmta_base_connect
local noti = exports.dmta_base_notifications
local vehicles = exports.dmta_veh_base
local duty = exports['dmta_base_duty']

addCommandHandler("zone", function(plr, _, dist, max)
	if(dist and max)then
		local x,y,z = getElementPosition(plr)
		local cs = createColSphere(x, y, z, dist)
		setElementData(cs, "zone:suszarka", max)
	end
end)

addEvent('interaction:admin', true)
addEventHandler('interaction:admin', resourceRoot, function(veh, id)
	if id == 1 then
		fixVehicle(veh)
		noti:addNotification(client, 'Pojazd został naprawiony.', 'success')
		local idcar = getElementData(veh, 'vehicle:id') or 'respiony'
		local text_log = ''..getPlayerName(client)..' naprawił pojazd o ID: '..idcar..''
		duty:addLogs('admin', text_log, client, 'DRYER/FIX')
	elseif id == 2 then
		local _,ry,rz = getElementRotation(veh)
		setElementRotation(veh, 0, ry, rz)
		noti:addNotification(client, 'Pojazd został obrócony.', 'success')
		local idcar = getElementData(veh, 'vehicle:id') or 'respiony'
		local text_log = ''..getPlayerName(client)..' obrócił pojazd o ID: '..idcar..''
		duty:addLogs('admin', text_log, client, 'DRYER/FLIP')
	elseif id == 3 then

		local i = getElementData(veh, 'vehicle:id')
		if not i then
			if getElementData(veh, 'un:destroyed') then
				noti:addNotification(client, 'Nie możesz usunąć tego pojazdu.', 'error')
			else
				destroyElement(veh)
				noti:addNotification(client, 'Pomyślnie usunięto pojazd', 'error')
				local idcar = getElementData(veh, 'vehicle:id') or 'respiony'
				local text_log = ''..getPlayerName(client)..' usuwa pojazd.'
				duty:addLogs('admin', text_log, client, 'DRYER/DELETE')
			end
			return
		end

		local q = db:query('update db_vehicles set parking=1 where id=?', i)
		if q then
			noti:addNotification(client, 'Pojazd został oddany do przechowalni.', 'success')
			local idcar = getElementData(veh, 'vehicle:id') or 'respiony'
			local text_log = ''..getPlayerName(client)..' odesłał pojazd o ID: '..idcar..''
			duty:addLogs('admin', text_log, client, 'DRYER/DP')
			vehicles:saveVehicle(veh)
			destroyElement(veh)
			
		end
	elseif id == 4 then
		local x,y,z = getElementPosition(client)
		setElementPosition(veh, x, y-1, z)
		local idcar = getElementData(veh, 'vehicle:id') or 'respiony'
		local text_log = ''..getPlayerName(client)..' teleportował pojazd o ID: '..idcar..''
		duty:addLogs('admin', text_log, client, 'DRYER/TH')
	elseif id == 5 then
		local x,y,z = getElementPosition(veh)
		setElementPosition(client, x, y-1, z)
		local idcar = getElementData(veh, 'vehicle:id') or 'respiony'
		local text_log = ''..getPlayerName(client)..' teleportował się do pojazdu o ID: '..idcar..''
		duty:addLogs('admin', text_log, client, 'DRYER/TT')
		if getElementData(client, 'rank:duty') >=2 then
			warpPedIntoVehicle(client, veh, 0)
	elseif id == 6 then
		local fuel = getElementData(veh, 'vehicle:fuel') or 0
		if fuel < 2 then
			setElementData(veh, 'vehicle:fuel', 2)
			noti:addNotification(client, 'Pojazd został zatankowany.', 'success')
			local idcar = getElementData(veh, 'vehicle:id') or 'respiony'
			local text_log = ''..getPlayerName(client)..' tankuje pojazd o ID: '..idcar..''
			duty:addLogs('admin', text_log, client, 'DRYER/FUEL')
		end
	end
	end
end)

addEvent('mandat', true)
addEventHandler('mandat', resourceRoot, function(veh)
	local typ = getVehicleController(veh)
	if(typ)then
		takePlayerMoney(typ, 50)
		db:query("update db_users set money=? where login=?", getPlayerMoney(typ), getPlayerName(typ))
		outputChatBox("Otrzymałeś mandat w wysokości 50$ za przekroczenie prędkości.", typ)
		outputChatBox("Pomyślnie wystawiono mandat.", client)
		triggerClientEvent(typ, "fotka:starego", resourceRoot)
	else
		outputChatBox("Nikt nie kieruje tego pojazdu!", client)
	end
end)