--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local db = exports['dmta_base_connect']
local noti = exports['dmta_base_notifications']
local core = exports['dmta_base_core']
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

local logs = {}

local zablokowane_seriale = 
{ 
['989FF72AF3DE033FDC661DF3CEDC03F2'] = true, 
['A328198ECCCE3DF5F40EF2B39C805F44'] = true, 
['B2AF2A7E79CE9BAFEA7A2BEB8516C7B3'] = true, 
} 

addEventHandler("onPlayerConnect",root,function(_,_,_,serial) 
if zablokowane_seriale[serial] then cancelEvent(true,"Szkodnik") end 
end) 

function getNameRank(id)
	if id == 4 then
		return 'Zarząd'
	elseif id == 3 then
		return 'Administrator'
	elseif id == 2 then
		return 'Moderator'
	elseif id == 1 then
		return 'Support'
	end
	return '(?)'
end

addCommandHandler('duty', function(player)
	local query = db:query('select * from db_admins where serial=? and nick=?', getPlayerSerial(player), getPlayerName(player))
	if #query > 0 then
		if getElementData(player, 'rank:duty') then
			outputChatBox('#00ff00● #ffffffPomyślnie wylogowano z służby rangi: #969696'..getNameRank(query[1]['rank']), player, 255, 255, 255, true)
			setElementData(player, 'rank:duty', false)
			setElementData(player, 'logs:showed', false)
			setElementData(player, 'user:type', false)
			takeWeapon(player, 32)
			local text_log = ""..getPlayerName(player).." wylogowuje się ze służby administracji"
			addLogs('admin', text_log, player, 'DUTY')
		else
			outputChatBox('#00ff00● #ffffffPomyślnie zalogowano na służbe rangi: #969696'..getNameRank(query[1]['rank']), player, 255, 255, 255, true)
			setElementData(player, 'rank:duty', query[1]['rank'])
			setElementData(player, 'logs:showed', true)
			setElementData(player, 'user:type', getNameRank(query[1]['rank']))
			giveWeapon(player, 32)
			triggerClientEvent(player, 'updateLogs', resourceRoot, logs)
			local text_log = ""..getPlayerName(player).." loguje się na służbę administracji"
			addLogs('admin', text_log, player, 'DUTY')
		end
	end
end)

function globalChat(gracz, _, ...)
	if getElementData(gracz, "rank:duty") and ... then
		local tekst = table.concat({...}, " ")
		local duty = getElementData(gracz, "rank:duty")
		local c1, c2, c3 = 255, 255, 255
		if duty == 1 then
			c1, c2, c3 = 0,100,0
		elseif duty == 2 then
			c1, c2, c3 = 242,134,0
		elseif duty == 3 then
			c1, c2, c3 = 0, 255, 255
		elseif duty == 4 then
			c1, c2, c3 = 255, 0, 0
		end

		outputChatBox(">> "..tekst.." #ffffff- "..getPlayerName(gracz), root, c1, c2, c3, true)
		local text_log = 'GC> '..getPlayerName(gracz)..": "..tekst
		addLogs('admin', text_log, gracz, 'GC')
	end
end

addCommandHandler("skin", function(plr,cmd,cel,id)
	if getElementData(plr, "rank:duty") > 2 then
		   local id = tonumber(id)
		   if not cel or not id then
			outputChatBox("#ff0000● #ffffffUżycie: /skin <id/nick> <id skina>", plr, 255, 255, 255, true)
			   return
		   end
			   local target = findPlayer(plr, cel)
		   if not target then
			outputChatBox("#ff0000● #ffffffNie znaleziono podanego przez ciebie gracza.", plr, 255, 255, 255, true)
			   return
		   end
		   if id < 0 or id > 311 then
			outputChatBox("#ff0000● #ffffffUżycie: /skin <id/nick> <id skina>", plr, 255, 255, 255, true)
				   return end
		   setElementModel(target,id)
		   exports['dmta_base_connect']:query('update db_users set skin=? where login=?', id, getPlayerName(target))
		   outputChatBox("#00ff00● #ffffffZmieniono skin graczowi #969696"..getPlayerName(target).." #ffffffna skin id: #969696"..id.."", plr, 255, 255, 255, true)
		   outputChatBox("#00ff00● #ffffffTwój skin został zmieniony przez #969696"..getPlayerName(plr).." #ffffffna skin id: #969696"..id.."", target, 255, 255, 255, true)
		   local text_log = ""..getPlayerName(plr).." > "..getPlayerName(target).." > "..id..""
		addLogs('admin', text_log, plr, 'AC')
	   end
   end)

addCommandHandler('fuel', function(player)
	if getElementData(player, 'rank:duty') and getElementData(player, 'rank:duty') == 4 then
		local vehicle = getPedOccupiedVehicle(player)
		if vehicle then
			local bak = getElementData(vehicle, 'vehicle:bak') or 25
			setElementData(vehicle, 'vehicle:fuel', bak)
			outputChatBox("#00ff00● #ffffffZatankowałeś pojazd, w którym obecnie się znajdujesz.", player, 255, 255, 255, true)
			local vid = getElementData(vehicle, 'vehicle:id') or 'Pojazd spawnowany'
			local text_log = getPlayerName(player)..' tankuje pojazd '..getVehicleName(vehicle)..' (ID): '..vid..''
			addLogs('admin', text_log, player, 'FUEL')
			
		end
	end
end)

addCommandHandler('tppos', function(player, _, x, y, z)
	if getElementData(player, 'rank:duty') and getElementData(player, 'rank:duty') == 4 then
		if x and y and z then
			x, y, z = tonumber(x) or 0, tonumber(y) or 0, tonumber(z) or 0
			setElementPosition(player, x, y, z)
			outputChatBox("#00ff00● #ffffffPomyślnie teleportowałeś się na koordynaty#969696: "..x.." "..y.." "..z.."", player, 255, 255, 255, true)
		else
			outputChatBox("#ff0000● #ffffffUżycie: /tppos <x> <y> <z>", player, 255, 255, 255, true)
		end
	end
end)

addCommandHandler('warn', function(player, _, toPlayer, ...)
	if getElementData(player, 'rank:duty') then
		if toPlayer and ... then
			toPlayer = core:findPlayer(toPlayer)
			if toPlayer then
				if getElementData(toPlayer, 'rank:duty') and getElementData(toPlayer, 'rank:duty') > getElementData(player, 'rank:duty') then
					outputChatBox("#ff0000● #ffffffNie posiadasz takich uprawnień.", player, 255, 255, 255, true)
					return
				end

				local reason = table.concat({...}, ' ')
				triggerClientEvent(root, 'addAdminNotification', resourceRoot, getPlayerName(toPlayer)..' otrzymał ostrzeżenie od '..getPlayerName(player)..' z powodu '..reason)
				triggerClientEvent(toPlayer, 'addWarn', resourceRoot, reason, getPlayerName(player))
				local text_log = getPlayerName(player)..' > '..getPlayerName(toPlayer)..' powód: '..reason
				addLogs('admin', text_log, player, 'WARN')
				outputChatBox("#00ff00● #ffffffGracz #969696"..getPlayerName(toPlayer).." #ffffffotrzymał ostrzeżenie.", player, 255, 255, 255, true)
			else
				outputChatBox("#ff0000● #ffffffNie znaleziono podanego przez ciebie gracza.", player, 255, 255, 255, true)
			end
		else
			outputChatBox("#ff0000● #ffffffUżycie: /warn <id/nick> <powód>", player, 255, 255, 255, true)
		end
	end
end)

addCommandHandler('swarn', function(player, _, toPlayer, ...)
	if getElementData(player, 'rank:duty') then
		if toPlayer and ... then
			toPlayer = core:findPlayer(toPlayer)
			if toPlayer then

				local reason = table.concat({...}, ' ')
				triggerClientEvent(toPlayer, 'addWarn', resourceRoot, reason, getPlayerName(player))
				local text_log = getPlayerName(player)..' > '..getPlayerName(toPlayer)..' powód: '..reason
				addLogs('admin', text_log, player, '(S)WARN')
				outputChatBox("#00ff00● #ffffffGracz #969696"..getPlayerName(toPlayer).." #ffffffotrzymał ostrzeżenie (S).", player, 255, 255, 255, true)
			else
				outputChatBox("#ff0000● #ffffffNie znaleziono podanego przez ciebie gracza.", player, 255, 255, 255, true)
			end
		else
			outputChatBox("#ff0000● #ffffffUżycie: /swarn <id/nick> <powód>", player, 255, 255, 255, true)
		end
	end
end)

addCommandHandler('dim', function(player, _, dim)
	if getElementData(player, 'rank:duty') then
		if dim then
			setElementDimension(player, dim)
			outputChatBox("#00ff00● #ffffffZostałeś pomyślnie przeniesiony na dimension#969696: "..dim.."", player, 255, 255, 255, true)
		else
			outputChatBox("#ff0000● #ffffffUżycie: /dim <id>", player, 255, 255, 255, true)
		end
	end
end)

addCommandHandler('int', function(player, _, int)
	if getElementData(player, 'rank:duty') then
		if int then
			setElementInterior(player, int)
			outputChatBox("#00ff00● #ffffffZostałeś pomyślnie przeniesiony na interior#969696: "..int.."", player, 255, 255, 255, true)
		else
			outputChatBox("#ff0000● #ffffffUżycie: /int <id>", player, 255, 255, 255, true)
		end
	end
end)

addCommandHandler('k', function(player, _, toPlayer, ...)
	if getElementData(player, 'rank:duty') then
		if toPlayer and ... then
			toPlayer = core:findPlayer(toPlayer)
			if toPlayer then
				if getElementData(toPlayer, 'rank:duty') and getElementData(toPlayer, 'rank:duty') > getElementData(player, 'rank:duty') then
					outputChatBox("#ff0000● #ffffffNie posiadasz takich uprawnień.", player, 255, 255, 255, true)
					return
				end

				local reason = table.concat({...}, ' ')

				triggerClientEvent(root, 'addAdminNotification', resourceRoot, getPlayerName(toPlayer)..' został wykopany przez '..getPlayerName(player)..' z powodu '..reason)
				local text_log = getPlayerName(player)..' > '..getPlayerName(toPlayer)..' powód: '..reason
				addLogs('admin', text_log, player, 'KICK')
				outputChatBox("#00ff00● #ffffffKara została poprawnie wprowadzona do bazy danych.", player, 255, 255, 255, true)

				outputConsole('--------------', toPlayer)
				outputConsole('Zostałeś wykopany z serwera przez '..getPlayerName(player), toPlayer)
				outputConsole('Powód: '..reason, toPlayer)
				outputConsole('--------------', toPlayer)

				kickPlayer(toPlayer, 'Zobacz konsole (~)')
			else
				outputChatBox("#ff0000● #ffffffNie znaleziono podanego przez ciebie gracza.", player, 255, 255, 255, true)
			end
		else
			outputChatBox("#ff0000● #ffffffUżycie: /k <id/nick> <powód>", player, 255, 255, 255, true)
		end
	end
end)

function addbanPlayer(player, jednostka, czas, powod, admin)
	local unit = jednostka == 'm' and 'minute' or jednostka == 'h' and 'hour' or jednostka == 'd' and 'day' or 'month'
	db:query('insert into db_punishments (type,nick,serial,ip,admin,first_date,date,reason,active) values(?,?,?,?,?,now(),now()+interval ? '..unit..',?,1)', 'ban', getPlayerName(player), getPlayerSerial(player), getPlayerIP(player), admin, czas, powod)
	triggerClientEvent(root, 'addAdminNotification', resourceRoot, getPlayerName(player)..' został zbanowany przez '..admin..' z powodu '..powod..' ('..czas..jednostka..')')
	kickPlayer(player, 'Połącz się ponownie')
end

addCommandHandler('b', function(player, _, toPlayer, jednostka, czas, ...)
	if getElementData(player, 'rank:duty') > 2 then
		if toPlayer and ... and jednostka and czas and tonumber(czas) then
			toPlayer = core:findPlayer(toPlayer)
			if toPlayer then
				if getElementData(toPlayer, 'rank:duty') and getElementData(toPlayer, 'rank:duty') > getElementData(player, 'rank:duty') then
					outputChatBox("#ff0000● #ffffffNie posiadasz takich uprawnień.", player, 255, 255, 255, true)
					return
				end

				local reason = table.concat({...}, ' ')
				addbanPlayer(toPlayer, jednostka, czas, reason, getPlayerName(player))
				local text_log = getPlayerName(player)..' > '..getPlayerName(toPlayer)..' powód: '..reason..', czas: '..czas..' '..jednostka
				addLogs('admin', text_log, player, 'BAN')
				outputChatBox("#00ff00● #ffffffKara została poprawnie wprowadzona do bazy danych.", player, 255, 255, 255, true)
			else
				outputChatBox("#ff0000● #ffffffNie znaleziono podanego przez ciebie gracza.", player, 255, 255, 255, true)
			end
		else
			outputChatBox("#ff0000● #ffffffUżycie: /b <id/nick> <jednostka> <czas> <powód>", player, 255, 255, 255, true)
		end
	end
end)

function NinjaaddbanPlayer(player, jednostka, czas, powod, admin)
	local unit = jednostka == 'm' and 'minute' or jednostka == 'h' and 'hour' or jednostka == 'd' and 'day' or 'month'
	db:query('insert into db_punishments (type,nick,serial,ip,admin,first_date,date,reason,active) values(?,?,?,?,?,now(),now()+interval ? '..unit..',?,1)', 'ban', getPlayerName(player), getPlayerSerial(player), getPlayerIP(player), admin, czas, powod)
	--triggerClientEvent(root, 'addAdminNotification', resourceRoot, getPlayerName(player)..' został zbanowany przez '..admin..' z powodu '..powod..' ('..czas..jednostka..')')
	kickPlayer(player, 'Połącz się ponownie')
end

addCommandHandler('ninjab', function(player, _, toPlayer, jednostka, czas, ...)
	if getElementData(player, 'rank:duty') > 2 then
		if toPlayer and ... and jednostka and czas and tonumber(czas) then
			toPlayer = core:findPlayer(toPlayer)
			if toPlayer then
				if getElementData(toPlayer, 'rank:duty') and getElementData(toPlayer, 'rank:duty') > getElementData(player, 'rank:duty') then
					outputChatBox("#ff0000● #ffffffNie posiadasz takich uprawnień.", player, 255, 255, 255, true)
					return
				end

				local reason = table.concat({...}, ' ')
				NinjaaddbanPlayer(toPlayer, jednostka, czas, reason, getPlayerName(player))
				local text_log = getPlayerName(player)..' > '..getPlayerName(toPlayer)..' powód: '..reason..', czas: '..czas..' '..jednostka
				addLogs('admin', text_log, player, 'NINJA/BAN')
				outputChatBox("#00ff00● #ffffffKara została poprawnie wprowadzona do bazy danych.", player, 255, 255, 255, true)
			else
				outputChatBox("#ff0000● #ffffffNie znaleziono podanego przez ciebie gracza.", player, 255, 255, 255, true)
			end
		else
			outputChatBox("#ff0000● #ffffffUżycie: /ninjab <id/nick> <jednostka> <czas> <powód>", player, 255, 255, 255, true)
		end
	end
end)

addCommandHandler('mt', function(player, _, toPlayer, jednostka, czas, ...)
	if getElementData(player, 'rank:duty') > 1 then
		if toPlayer and jednostka and czas and tonumber(czas) and ... then
			toPlayer = core:findPlayer(toPlayer)
			if toPlayer then
				if getElementData(toPlayer, 'rank:duty') and getElementData(toPlayer, 'rank:duty') > getElementData(player, 'rank:duty') then
					outputChatBox("#ff0000● #ffffffNie posiadasz takich uprawnień.", player, 255, 255, 255, true)
					return
				end

				local reason = table.concat({...}, ' ')

				if jednostka == 'm' then
					db:query('insert into db_punishments (type,nick,serial,ip,admin,first_date,date,reason,active) values(?,?,?,?,?,now(),now()+interval ? minute,?,1)', 'mute', getPlayerName(toPlayer), getPlayerSerial(toPlayer), getPlayerIP(toPlayer), getPlayerName(player), czas, reason)
				elseif jednostka == 'h' then
					db:query('insert into db_punishments (type,nick,serial,ip,admin,first_date,date,reason,active) values(?,?,?,?,?,now(),now()+interval ? hour,?,1)', 'mute' ,getPlayerName(toPlayer), getPlayerSerial(toPlayer), getPlayerIP(toPlayer), getPlayerName(player), czas, reason)
				elseif jednostka == 'd' then
					db:query('insert into db_punishments (type,nick,serial,ip,admin,first_date,date,reason,active) values(?,?,?,?,?,now(),now()+interval ? day,?,1)', 'mute', getPlayerName(toPlayer), getPlayerSerial(toPlayer), getPlayerIP(toPlayer), getPlayerName(player), czas, reason)
				else
					return
				end

				outputChatBox('-------------------------------------------', toPlayer, 255, 0, 0)
				outputChatBox('Zostałeś wyciszony!', toPlayer, 255, 0, 0)
				outputChatBox('Osoba wyciszająca: '..getPlayerName(player), toPlayer, 255, 0, 0)
				outputChatBox('Powód wyciszenia: '..reason, toPlayer, 255, 0, 0)
				outputChatBox('Czas wyciszenia: '..czas..jednostka, toPlayer, 255, 0, 0)
				outputChatBox('----------------------------------------', toPlayer, 255, 0, 0)

				setElementData(toPlayer, 'user:mute', true)

				triggerClientEvent(root, 'addAdminNotification', resourceRoot, getPlayerName(toPlayer)..' został wyciszony przez '..getPlayerName(player)..' z powodu '..reason..' ('..czas..jednostka..')')
				local text_log = getPlayerName(player)..' > '..getPlayerName(toPlayer)..' powód: '..reason..', czas: '..czas..' '..jednostka
				addLogs('admin', text_log, player, 'MUTE')
				outputChatBox("#00ff00● #ffffffKara została poprawnie wprowadzona do bazy danych.", player, 255, 255, 255, true)
			else
				outputChatBox("#ff0000● #ffffffNie znaleziono podanego przez ciebie gracza.", player, 255, 255, 255, true)
			end
		else
			outputChatBox("#ff0000● #ffffffUżycie: /mt <id/nick> <jednostka> <czas> <powód>", player, 255, 255, 255, true)
		end
	end
end)

addCommandHandler('zpj', function(player, _, toPlayer, jednostka, czas, ...)
	if getElementData(player, 'rank:duty') > 1 then
		if toPlayer and jednostka and czas and tonumber(czas) and ... then
			toPlayer = core:findPlayer(toPlayer)
			if toPlayer then
				if getElementData(toPlayer, 'rank:duty') and getElementData(toPlayer, 'rank:duty') > getElementData(player, 'rank:duty') then
					outputChatBox("#ff0000● #ffffffNie posiadasz takich uprawnień.", player, 255, 255, 255, true)
					return
				end

				local reason = table.concat({...}, ' ')

				if jednostka == 'm' then
					db:query('insert into db_punishments (type,nick,serial,ip,admin,first_date,date,reason,active) values(?,?,?,?,?,now(),now()+interval ? minute,?,1)', 'pj', getPlayerName(toPlayer), getPlayerSerial(toPlayer), getPlayerIP(toPlayer), getPlayerName(player), czas, reason)
				elseif jednostka == 'h' then
					db:query('insert into db_punishments (type,nick,serial,ip,admin,first_date,date,reason,active) values(?,?,?,?,?,now(),now()+interval ? hour,?,1)', 'pj' ,getPlayerName(toPlayer), getPlayerSerial(toPlayer), getPlayerIP(toPlayer), getPlayerName(player), czas, reason)
				elseif jednostka == 'd' then
					db:query('insert into db_punishments (type,nick,serial,ip,admin,first_date,date,reason,active) values(?,?,?,?,?,now(),now()+interval ? day,?,1)', 'pj', getPlayerName(toPlayer), getPlayerSerial(toPlayer), getPlayerIP(toPlayer), getPlayerName(player), czas, reason)
				else
					return
				end

				if isPedInVehicle(toPlayer) then
					removePedFromVehicle(toPlayer)
				end

				setElementData(toPlayer, 'zpj', true)
				setElementData(toPlayer, 'block:prawko', true)
				triggerClientEvent(root, 'addAdminNotification', resourceRoot, getPlayerName(toPlayer)..' otrzymał zakaz prowadzenia pojazdów kat. A,B,C od '..getPlayerName(player)..' z powodu '..reason..' ('..czas..jednostka..')')
				local text_log = getPlayerName(player)..' > '..getPlayerName(toPlayer)..' powód: '..reason..', czas: '..czas..' '..jednostka
				addLogs('admin', text_log, player, 'ZPJ')
				outputChatBox("#00ff00● #ffffffKara została poprawnie wprowadzona do bazy danych.", player, 255, 255, 255, true)
			else
				outputChatBox("#ff0000● #ffffffNie znaleziono podanego przez ciebie gracza.", player, 255, 255, 255, true)
			end
		else
			outputChatBox("#ff0000● #ffffffUżycie: /zpj <id/nick> <jednostka> <czas> <powód>", player, 255, 255, 255, true)
		end
	end
end)

addCommandHandler('cv', function(player, _, model)
	if getElementData(player, 'rank:duty') >= 2 then
		if model then
			if not tonumber(model) then
				model = getVehicleModelFromName(model)
			end

			model = model or 0

			if model == 0 then
				outputChatBox("#ff0000● #ffffffNie znaleziono podanego przez ciebie gracza.", player, 255, 255, 255, true)
				return
			end

			local x,y,z = getElementPosition(player)
			local dim, int = getElementDimension(player), getElementInterior(player)
			local v = createVehicle(model, x, y, z)
			local car = getVehicleNameFromID(model)
			setElementData(v, 'admin:vehicle', true)
			setElementInterior(v, int)
			setElementDimension(v, dim)
			warpPedIntoVehicle(player, v)
			setVehicleColor(v, 15, 15, 15)
			setVehiclePlateText(v, 'SPAWNED')
			outputChatBox("#00ff00● #ffffffPomyślnie zespawnowałeś pojazd#969696: ("..model..") "..car..".", player, 255, 255, 255, true)
			local text_log = getPlayerName(player)..' tworzy pojazd '..model..' / '..car
			addLogs('admin', text_log, player, 'CV')
		else
			outputChatBox("#ff0000● #ffffffUżycie: /cv <model/id>", player, 255, 255, 255, true)
		end
	end
end)

addCommandHandler('jp', function(player)
	if getElementData(player, 'rank:duty') then
   		if not doesPedHaveJetPack(player) then
			givePedJetPack(player)
			outputChatBox("#00ff00● #ffffffZakładasz jetpack.", player, 255, 255, 255, true)
   		else
			removePedJetPack(player)
			outputChatBox("#00ff00● #ffffffZdejmujesz jetpack.", player, 255, 255, 255, true)
   		end
	end
end)

function spec(gracz, _, graczhere)
	if graczhere and getElementData(gracz, "rank:duty") > 1 then
		graczhere = findPlayer(gracz, graczhere)
		if not graczhere then return end
		if getCameraTarget(gracz) == graczhere then
			setCameraTarget(gracz, gracz)
		else
			setCameraTarget(gracz, graczhere)
			setElementDimension(gracz, getElementDimension(graczhere))
			setElementInterior(gracz, getElementInterior(graczhere))
			outputChatBox("#00ff00● #ffffffObserwujesz gracza#969696: "..getPlayerName(graczhere).."", gracz, 255, 255, 255, true)
			local text_log = getPlayerName(gracz)..' > '..getPlayerName(graczhere)
			addLogs('admin', text_log, gracz, 'SPEC')
			if getElementData(graczhere, "rank:duty") > 3 then outputChatBox("#ff0000● #ffffffJesteś specowany przez #969696"..getPlayerName(gracz).."", graczhere, 255, 0, 0, true)
		end
	end
	end
end

function specoff(gracz)
	if getElementData(gracz, "rank:duty") then
		removePedFromVehicle(gracz)
		setCameraTarget(gracz, gracz)
		setElementDimension(gracz, 0)
		setElementInterior(gracz, 0)
		setElementPosition(gracz, -1943.5502929688,657.56170654297,-80.792549133301)
		local text_log = getPlayerName(gracz)..' przestaje specować'
		addLogs('admin', text_log, gracz, 'SPECOFF')
	end
end

function getdb_admins()
	local q = db:query('select * from db_admins')
	local db_admins = {}
	for i,v in ipairs(q) do
		if getPlayerFromName(v['nick']) then
			table.insert(db_admins, getPlayerFromName(v['nick']))
		end
	end
	return db_admins
end

addCommandHandler('ac', function(player, _, ...)
	if getElementData(player, 'rank:duty') then
		if ... then
			local tekst = table.concat({...}, ' ')
			local hex = '#ababab'
			if getElementData(player, 'rank:duty') and getElementData(player, 'rank:duty') == 1 then
				hex = '#006400'
			elseif getElementData(player, 'rank:duty') and getElementData(player, 'rank:duty') == 2 then
				hex = '#f28600'
			elseif getElementData(player, 'rank:duty') and getElementData(player, 'rank:duty') == 3 then
				hex = '#ff0000'
			elseif getElementData(player, 'rank:duty') and getElementData(player, 'rank:duty') == 4 then
				hex = '#960000'
			elseif getElementData(player, 'user:premium') then
				hex = '#ffff00'
			end

			for i,v in ipairs(getdb_admins()) do
				if getElementData(v, 'rank:duty') then
					outputChatBox('#ff0000✸ #ffffff'..getPlayerName(player)..' ['..hex..''..getElementData(player, 'user:id')..'#d2d2d2]: #ffffff'..tekst, v, 150, 150, 150, true)
				end
			end
			local text_log = 'AC> '..getPlayerName(player)..": "..tekst
				addLogs('admin', text_log, player, 'AC')
		else
			outputChatBox("#ff0000● #ffffffUżycie: /ac <tekst>", player, 255, 255, 255, true)
		end
	end
end)

addCommandHandler('tt', function(player, _, toPlayer)
	if getElementData(player, 'rank:duty') then
		if toPlayer then
			toPlayer = core:findPlayer(toPlayer)
			if toPlayer then
				if isPedInVehicle(toPlayer) then
					warpPedIntoVehicle(player, getPedOccupiedVehicle(toPlayer), 1)
				elseif isPedInVehicle(player) then
					removePedFromVehicle(player)
				else
					local x,y,z = getElementPosition(toPlayer)
					setElementPosition(player, x, y+1, z)
					setElementDimension(player, getElementDimension(toPlayer))
					setElementInterior(player, getElementInterior(toPlayer))
				end
				local text_log = getPlayerName(player)..' > '..getPlayerName(toPlayer)
				addLogs('admin', text_log, player, 'TT')
				outputChatBox("#00ff00● #ffffffZostałeś przeniesiony do gracza#969696: "..getPlayerName(toPlayer).."", player, 255, 255, 255, true)
			else
				outputChatBox("#ff0000● #ffffffNie znaleziono podanego przez ciebie gracza.", player, 255, 255, 255, true)
			end
		else
			outputChatBox("#ff0000● #ffffffUżycie: /tt <id/nick>", player, 255, 255, 255, true)
		end
	end
end)

addCommandHandler('th', function(player, _, toPlayer)
	if getElementData(player, 'rank:duty') then
		if toPlayer then
			toPlayer = core:findPlayer(toPlayer)
			if toPlayer then
				if isPedInVehicle(player) then
					warpPedIntoVehicle(toPlayer, getPedOccupiedVehicle(player), 1)
				elseif isPedInVehicle(toPlayer) then
					removePedFromVehicle(toPlayer)
					local x,y,z = getElementPosition(player)
					setElementPosition(toPlayer, x, y+1, z)
				else
					local x,y,z = getElementPosition(player)
					setElementPosition(toPlayer, x, y+1, z)
				end

				setElementDimension(toPlayer, getElementDimension(player))
				setElementInterior(toPlayer, getElementInterior(player))
				local text_log = getPlayerName(player)..' > '..getPlayerName(toPlayer)
				addLogs('admin', text_log, player, 'TH')
				outputChatBox("#00ff00● #ffffffPrzeniosłeś do siebie gracza#969696: "..getPlayerName(toPlayer).."", player, 255, 255, 255, true)
				outputChatBox("#00ff00● #ffffffZostałeś przeniesiony przez gracza#969696: "..getPlayerName(player).."", toPlayer, 255, 255, 255, true)
			else
				outputChatBox("#ff0000● #ffffffNie znaleziono podanego przez ciebie gracza.", player, 255, 255, 255, true)
			end
		else
			outputChatBox("#ff0000● #ffffffUżycie: /th <id/nick>", player, 255, 255, 255, true)
		end
	end
end)

function getVehicleFromID(id)
	local vehicle = false
	for i,v in ipairs(getElementsByType('vehicle')) do
		if getElementData(v, 'vehicle:id') and getElementData(v, 'vehicle:id') == id then
			vehicle = v
			break
		end
	end
	return vehicle
end

addCommandHandler('ttv', function(player, _, id)
	if getElementData(player, 'rank:duty') then
		if id and tonumber(id) then
			local vehicle = getVehicleFromID(tonumber(id))
			if vehicle then
				outputChatBox("#00ff00● #ffffffPomyślnie przeniosłeś się do pojazdu o id#969696: "..id.."", player, 255, 255, 255, true)
				if getElementData(player, 'rank:duty') > 2 then
				warpPedIntoVehicle(player, vehicle)
				end
				local x,y,z = getElementPosition(vehicle)
				setElementPosition(player, x, y+1, z)
				local text_log = getPlayerName(player)..' > '..id
				addLogs('admin', text_log, player, 'TTV')
			else
				outputChatBox("#ff0000● #ffffffNie znaleziono podanego przez pojazdu.", player, 255, 255, 255, true)
			end
		else
			outputChatBox("#ff0000● #ffffffUżycie: /ttv <id>", player, 255, 255, 255, true)
		end
	end
end)

addCommandHandler('thv', function(player, _, id)
	if getElementData(player, 'rank:duty') then
		if id and tonumber(id) then
			local vehicle = getVehicleFromID(tonumber(id))
			if vehicle then
				outputChatBox("#00ff00● #ffffffPomyślnie przeniosłeś do siebie pojazd o id#969696: "..id.."", player, 255, 255, 255, true)
				local x,y,z = getElementPosition(player)
				setElementPosition(vehicle, x, y, z)
				setElementPosition(player, x, y, z + 1)
				local text_log = getPlayerName(player)..' > '..id
				addLogs('admin', text_log, player, 'THV')
			else
				outputChatBox("#ff0000● #ffffffNie znaleziono podanego przez pojazdu.", player, 255, 255, 255, true)
			end
		else
			outputChatBox("#ff0000● #ffffffUżycie: /thv <id>", player, 255, 255, 255, true)
		end
	end
end)

addCommandHandler('inv', function(player)
	if getElementData(player, 'rank:duty') > 1 then
		if not getElementData(player, 'inv') then
			setElementAlpha(player, 0)
			setElementData(player, 'inv', true)
			local text_log = 'ON'
			addLogs('admin', text_log, player, 'INV')
			outputChatBox("#00ff00● #ffffffNiewidzialność została właczona.", player, 255, 255, 255, true)
		else
			setElementAlpha(player, 255)
			setElementData(player, 'inv', false)
			local text_log = 'OFF'
			addLogs('admin', text_log, player, 'INV')
			outputChatBox("#00ff00● #ffffffNiewidzialność została wyłączona.", player, 255, 255, 255, true)
		end
	end
end)

addCommandHandler('fix', function(player, _, toPlayer)
	if getElementData(player, 'rank:duty') then
		toPlayer = toPlayer == nil and player or core:findPlayer(toPlayer)
		if toPlayer then
			local vehicle = getPedOccupiedVehicle(toPlayer)
			if vehicle then
				fixVehicle(vehicle)

				if toPlayer == player then
					local vid = getElementData(vehicle, 'vehicle:id') or 'brak id'
					local text_log = getPlayerName(player)..' naprawia pojazd (ID): '..vid
					addLogs('admin', text_log, player, 'FIX')
					outputChatBox("#00ff00● #ffffffPomyślnie naprawiłeś swój pojazd.", player, 255, 255, 255, true)
				else
					local vid = getElementData(vehicle, 'vehicle:id') or 'brak id'
					local text_log = getPlayerName(player)..' naprawia pojazd graczowi#969696: '..getPlayerName(toPlayer).. ' (ID): '..vid
					addLogs('admin', text_log, player, 'FIX')
					outputChatBox("#00ff00● #ffffffPomyślnie naprawiono pojazd gracza#969696: "..getPlayerName(toPlayer).."", player, 255, 255, 255, true)
				end
			else
				if toPlayer == player then
					outputChatBox("#ff0000● #ffffffNie znajdujesz się w pojeździe.", player, 255, 255, 255, true)
				else
					outputChatBox("#ff0000● #ffffffPodany gracz nie znajduje się w pojeździe.", player, 255, 255, 255, true)
				end
			end
		end
	end
end)

addCommandHandler('flip', function(player, _, toPlayer)
	if getElementData(player, 'rank:duty') then
		toPlayer = toPlayer == nil and player or core:findPlayer(toPlayer)
		if toPlayer then
			local vehicle = getPedOccupiedVehicle(toPlayer)
			if vehicle then
				local rx,ry,rz = getElementRotation(vehicle)
				setVehicleRotation(vehicle, 0, ry, rz)

				if toPlayer == player then
					local vid = getElementData(vehicle, 'vehicle:id') or 'brak id'
					local text_log = getPlayerName(player)..' obraca pojazd (ID): '..vid
					addLogs('admin', text_log, player, 'FLIP')
					outputChatBox("#00ff00● #ffffffPomyślnie postawiono na koła pojazd.", player, 255, 255, 255, true)
				else
					local vid = getElementData(vehicle, 'vehicle:id') or 'brak id'
					local text_log = getPlayerName(player)..' naprawia pojazd graczowi '..getPlayerName(toPlayer).. ' (ID): '..vid
					addLogs('admin', text_log, player, 'FLIP')
					outputChatBox("#00ff00● #ffffffPomyślnie postawiono na koła pojazd gracza "..getPlayerName(toPlayer).."", player, 255, 255, 255, true)
				end
			else
				if toPlayer == player then
					outputChatBox("#ff0000● #ffffffNie znajdujesz się w pojeździe.", player, 255, 255, 255, true)
				else
					outputChatBox("#ff0000● #ffffffPodany gracz nie znajduje się w pojeździe.", player, 255, 255, 255, true)
				end
			end
		end
	end
end)

function revive(gracz, _, kogo)
	if not getElementData(gracz, "rank:duty") then return end
	local target = findPlayer(gracz, kogo)
	if not target then outputChatBox("#ff0000● #ffffffNie znaleziono podanego przez ciebie gracza.", gracz, 255, 255, 255, true) return end
	if not getElementData(target, "bw:time") then outputChatBox("#ff0000● #ffffffPodany przez Ciebie gracz nie jest nieprzytomny.", gracz, 255, 255, 255, true) return end
	setElementData(target, "bw:time", 299)
	outputChatBox("#00ff00● #ffffffOżywiłes gracza#969696: "..getPlayerName(target)..".", gracz, 255, 255, 255, true)
	local text_log = ""..getPlayerName(gracz).." > "..getPlayerName(target)..""
	addLogs('admin', text_log, gracz, 'REVIVE')
end

function revive_ems(gracz, _, kogo)
	if getElementData(gracz, "user:faction") == 'EMS' then
	local target = findPlayer(gracz, kogo)
	if not target then outputChatBox("#ff0000● #ffffffNie znaleziono podanego przez ciebie gracza.", gracz, 255, 255, 255, true) return end
	if not getElementData(target, "bw:time") then outputChatBox("#ff0000● #ffffffPodany przez Ciebie gracz nie jest nieprzytomny.", gracz, 255, 255, 255, true) return end
	setElementData(target, "bw:time", 299)
	outputChatBox("#00ff00● #ffffffUdzieliłeś pierwszej pomocy dla gracza#969696: "..getPlayerName(target)..".", gracz, 255, 255, 255, true)
	local text_log = ""..getPlayerName(gracz).." > "..getPlayerName(target)..""
	addLogs('fac', text_log, gracz, 'REVIVE/EMS')
else
	outputChatBox("#ff0000● #ffffffNie jesteś na służbie Emergency Medical Services.", gracz, 255, 255, 255, true)
	end
end
addCommandHandler('podnies', revive_ems)

function bw(gracz, _, kogo)
	if not getElementData(gracz, "rank:duty") or not kogo then return end
	local target = findPlayer(gracz, kogo)
	if not target then outputChatBox("#ff0000● #ffffffNie znaleziono podanego przez ciebie gracza.", gracz, 255, 255, 255, true) return end
	killPlayer(target, target)
	outputChatBox("#00ff00● #ffffffNałożyleś stan nieprzytomności na gracza#969696: "..getPlayerName(target)..".", gracz, 255, 255, 255, true)
	local text_log = getPlayerName(gracz).." > "..getPlayerName(target)
	addLogs('admin', text_log, gracz, 'BW')
end

function dajprzedmiot(plr, _, gracz, ...)
	if getElementData(plr, "rank:duty") == 4 then
		if not ... then
			outputChatBox("#ff0000● #ffffffUżycie: /dajp <gracz> <nazwa przedmiotu>", plr, 255, 255, 255, true)
			return
		end
		local nazwa = table.concat({...}, " ")
		local target=findPlayer(plr, gracz)
		if not target then
			outputChatBox("#ff0000● #ffffffPodany przez Ciebie gracz nie został odnaleziony.", plr, 255, 255, 255, true)
			return
		end
		exports["dmta_base_connect"]:query("INSERT INTO db_items SET dbid=?, nick=?, nazwa=?", getElementData(target, "user:dbid"), getPlayerName(target), nazwa)
		outputChatBox("#00ff00● #ffffffPomyślnie przekazałeś #969696"..nazwa.." #ffffffgraczu #969696"..getPlayerName(target)..".", plr, 255, 255, 255, true)
		local nazwa = table.concat({...}, " ")
		local text_log = getPlayerName(plr).." > "..getPlayerName(target).. " / "..nazwa
		addLogs('admin', text_log, plr, 'DAJP')
	end
end

function ulecz(plr, cmd, value)
	if getElementData(plr, "rank:duty") then
		if not value then
			outputChatBox("#ff0000● #ffffffUżycie: /heal <id/nick>", plr, 255, 255, 255, true)
			return
		end
		local target = findPlayer(plr,value)
		if not target then
			outputChatBox("#ff0000● #ffffffPodany przez Ciebie gracz nie został odnaleziony.", plr, 255, 255, 255, true)
			return
		end
		setElementHealth(target, 100)
		outputChatBox("#00ff00● #ffffffPomyślnie uleczyłeś gracza#969696: " ..getPlayerName(target), plr, 255, 255, 255, true)
		outputChatBox("#00ff00● #ffffffZostałeś pomyślnie uleczony przez#969696: "..getPlayerName(plr), target, 255, 255, 255, true)
		local text_log = getPlayerName(plr).." > "..getPlayerName(target)
		addLogs('admin', text_log, plr, 'HEAL')
    end
end

function ulecz_darek(plr, cmd, value)
	if getPlayerSerial(plr, "F5686A30BDBAB03643105204222F28F3") then
		if not value then
			outputChatBox("#ff0000● #ffffffUżycie: /heal <id/nick>", plr, 255, 255, 255, true)
			return
		end
		local target = findPlayer(plr,value)
		if not target then
			outputChatBox("#ff0000● #ffffffPodany przez Ciebie gracz nie został odnaleziony.", plr, 255, 255, 255, true)
			return
		end
		setElementHealth(target, 100)
		outputChatBox("#00ff00● #ffffffPomyślnie uleczyłeś gracza#969696: " ..getPlayerName(target), plr, 255, 255, 255, true)
		--outputChatBox("#00ff00● #ffffffZostałeś pomyślnie uleczony przez#969696: "..getPlayerName(plr), target, 255, 255, 255, true)
		local text_log = getPlayerName(plr).." > "..getPlayerName(target)
		addLogs('admin', text_log, plr, 'HEAL')
    end
end

function najedz(gracz, _, kogo)
	if getElementData(gracz, "rank:duty") > 2 then
	if not kogo then return end
	local target = findPlayer(gracz,kogo)
	if not target then
		outputChatBox("#ff0000● #ffffffNie znaleziono podanego przez ciebie gracza.", gracz, 255, 255, 255, true)
		return
	end
	setElementData(target, "user:food", 100)
	setElementData(target, "user:drink", 100)
	outputChatBox("#00ff00● #ffffffTwój poziom głodu i pragnienia został uzupełniony przez:#969696 "..getPlayerName(gracz).."", target, 255, 255, 255, true)
	outputChatBox("#00ff00● #ffffffPomyślnie uzupełniłeś poziom głodu i pragnienia u gracza:#969696 "..getPlayerName(target).."", gracz, 255, 255, 255, true)
	local text_log = getPlayerName(gracz).." > "..getPlayerName(target)
	addLogs('admin', text_log, gracz, 'FEED')
end
end

addCommandHandler("rfix", function(plr, cmd, range)
	if getElementData(plr, "rank:duty") > 1 then
	   if (not range) then
			outputChatBox("#ff0000● #ffffffUżycie: /rfix <zasięg>", plr, 255, 255, 255, true)
	   return end
	   if not tonumber(range) then
		outputChatBox("#ff0000● #ffffffUżycie: /rfix <zasięg>", plr, 255, 255, 255, true)
	   return end
	   range = tonumber(range)
	   if range <= 0 then
		outputChatBox("#ff0000● #ffffffZa mała odległość.", plr, 255, 255, 255, true)
	   return end
	   if range > 250 then
		outputChatBox("#ff0000● #ffffffZa duża odległość.", plr, 255, 255, 255, true)
	   return end
	   local x,y,z = getElementPosition(plr)
	   local cub = createColSphere(x,y,z,range)
	   local pojazdy = getElementsWithinColShape( cub, "vehicle")
	   if #pojazdy == 0 then
		outputChatBox("#ff0000● #ffffffBrak pojazdów w pobliżu.", plr, 255, 255, 255, true)
	   return end
	   local text_log = getPlayerName(plr).." > "..range
		addLogs('admin', text_log, plr, 'RFIX')
	   for i,pojazd in ipairs(pojazdy) do
		   fixVehicle(pojazd)
	   end
	   setTimer(destroyElement,5000,1,cub)
	   outputChatBox("#00ff00● #ffffffPojazdy w cuboidzie o wartości #969696"..range.." #ffffffzostały naprawione.", plr, 255, 255, 255, true)
   end
end)

addCommandHandler("rfuel", function(plr, cmd, range)
	if getElementData(plr, "rank:duty") > 1 then
	   if (not range) then
		outputChatBox("#ff0000● #ffffffUżycie: /rfuel <zasięg>", plr, 255, 255, 255, true)
	   return end
	   if not tonumber(range) then
		outputChatBox("#ff0000● #ffffffUżycie: /rfuel <zasięg>", plr, 255, 255, 255, true)
	   return end
	   range = tonumber(range)
	   if range <= 0 then
		outputChatBox("#ff0000● #ffffffZa mała odległość.", plr, 255, 255, 255, true)
	   return end
	   if range > 100 then
		outputChatBox("#ff0000● #ffffffZa duża odległość.", plr, 255, 255, 255, true)
	   return end
	   local x,y,z = getElementPosition(plr)
	   local cub = createColSphere(x,y,z,range)
	   local pojazdy = getElementsWithinColShape( cub, "vehicle")
	   if #pojazdy == 0 then
		outputChatBox("#ff0000● #ffffffBrak pojazdów w pobliżu.", plr, 255, 255, 255, true)
	   return end
	   local text_log = getPlayerName(plr).." > "..range
		addLogs('admin', text_log, plr, 'RFUEL')
	   for i,pojazd in ipairs(pojazdy) do
		   setElementData(pojazd, "vehicle:fuel", 20)
	   end
	   setTimer(destroyElement,5000,1,cub)
	   outputChatBox("#00ff00● #ffffffPojazdy w cuboidzie o wartości #969696"..range.." #ffffffzostały zatankowane.", plr, 255, 255, 255, true)
   end
end)

addCommandHandler("rgb", function(plr,cmd,cel,value,value2,value3)
   if getElementData(plr, "rank:duty") > 2 then
	   if not cel or not tonumber(value) or not tonumber(value2) or not tonumber(value3) then
	   outputChatBox("#ff0000● #ffffffUżycie: /rgb <nick/ID> <r g b>", plr, 255, 255, 255, true)
		   return
	   end
	   local target=findPlayer(plr, cel)
	   if not target then
	   outputChatBox("#ff0000● #ffffffNie znaleziono podanego przez Ciebie gracza.", plr, 255, 255, 255, true)
		   return
	   end
	   local veh=getPedOccupiedVehicle(target)
	   setVehicleColor(veh,value,value2,value3,value,value2,value3)
	   outputChatBox("#00ff00● #ffffffPomyślnie zmieniłeś kolor pojazdu graczu: #969696"..getPlayerName(target).."", plr, 255, 255, 255, true)
	   addLogs('admin', text_log, plr, 'RGB')
   end

end)

addCommandHandler("sserial", function(plr,cmd,cel)
   if getElementData(plr, "rank:duty") then
	   if not cel then
		outputChatBox("#ff0000● #ffffffUżycie: /sserial <id/nick>", plr, 255, 255, 255, true)
		   return
	   end
	   local target=findPlayer(plr, cel)
	   if not target then
		outputChatBox("#ff0000● #ffffffNie znaleziono podanego przez Ciebie gracza.", plr, 255, 255, 255, true)
		   return end
	   outputChatBox("#00ff00● #ffffffSerial gracza #969696"..getPlayerName(target).." #969696#ffffffto #969696"..getPlayerSerial(target).."", plr, 255, 255, 255, true)
   end
end)

local zapisane_pozycje = {}
addCommandHandler("sp", function(plr,cmd)
   if getElementData(plr, "rank:duty") > 2 then
   local pos={}
   pos[1],pos[2],pos[3]=getElementPosition(plr)
   pos[4]=getElementInterior(plr)
   pos[5]=getElementDimension(plr)
   local uid = getElementData(plr,"user:dbid")
   zapisane_pozycje[uid] = pos
   outputChatBox("#00ff00● #ffffffTwoja aktualna pozycja została prawidłowo zapisana.", plr, 255, 255, 255, true)
   end
end)

addCommandHandler("lp", function(plr,cmd)
   if getElementData(plr, "rank:duty") > 2 then
   local uid = getElementData(plr,"user:dbid")
   local pos=zapisane_pozycje[uid]
   if (not pos) then
	outputChatBox("#ff0000● #ffffffNie posiadasz zapisanej pozycji.", plr, 255, 255, 255, true)
   return
   end
   local veh = getPedOccupiedVehicle(plr)
   if veh then plr = veh end
   setElementPosition(plr,pos[1],pos[2],pos[3])
   setElementInterior(plr,pos[4])
   setElementDimension(plr,pos[5])
   outputChatBox("#00ff00● #ffffffTwoja zapisana pozycja została prawidłowo wczytana.", plr, 255, 255, 255, true)
   end
   end)

function usun(plr)
	local veh = getPedOccupiedVehicle(plr)
	if not getElementData(plr, "rank:duty") then return end
	if veh and getElementData(veh, "admin:vehicle") then
		destroyElement(veh)
		local el = getPlayerName(plr)
	end
end

addCommandHandler("zajebkola",function(plr,cmd)
	if getElementData(plr, "rank:duty") > 3 then
		local veh=getPedOccupiedVehicle(plr)
		if not veh then
			outputChatBox("#ff0000● #ffffffNie znajdujesz się w pojeździe.", plr, 255, 255, 255, true)
			return
		end
	x = getElementData(veh,"zajebane:kola")
	if not x then setVehicleWheelStates(veh,2,2,2,2) setElementData(veh,"zajebane:kola",true)  else setVehicleWheelStates(veh,0,0,0,0);  setElementData(veh,"zajebane:kola",false) end
	end
end)

addCommandHandler("suszarka",function(plr,cmd)
	if getElementData(plr, "rank:duty") then
	giveWeapon (plr, 32, 200 )
	end
end)

addCommandHandler("fix.all", function(plr)
	if getElementData(plr, "rank:duty") > 3 then
		for i,v in ipairs(getElementsByType("vehicle")) do
				fixVehicle(v)
			end
		end
		outputChatBox("#69bceb● #ffffffCzłonek Zarządu naprawił każdy pojazd na mapie.", plr, 255, 255, 255, true) 
end)

addCommandHandler("heal.all", function(plr)
	if getElementData(plr, "rank:duty") > 3 then
		for i,v in ipairs(getElementsByType("player")) do
				setElementHealth(v, 100)
			end
		end
		outputChatBox("#69bceb● #ffffffCzłonek Zarządu uleczył każdego gracza na serwerze.", plr, 255, 255, 255, true) 
end)

addCommandHandler("feed.all", function(plr)
	if getElementData(plr, "rank:duty") > 3 then
		for i,v in ipairs(getElementsByType("player")) do
				setElementData(v, "user:food", 100)
				setElementData(v, "user:drink", 100)
			end
		end
		outputChatBox("#69bceb● #ffffffCzłonek Zarządu uzupełnił poziom głodu i pragnienia każdemu graczowi na serwerze.", plr, 255, 255, 255, true) 
end)

addCommandHandler("zprzebieg", function(plr,cmd,tonumber)
	if getElementData(plr, "rank:duty") > 3 then
		local veh = getPedOccupiedVehicle(plr)
		if not veh then
			outputChatBox("#ff0000● #ffffffNie znajdujesz się w pojeździe.", plr, 255, 255, 255, true)
			return
		end
		setElementData(veh, "vehicle:distance", tonumber)
		outputChatBox("#00ff00● #fffffPrzebieg został zmieniony pomyślnie.", plr, 255, 255, 255, true)
	end
end)

addCommandHandler("idwep",function(plr,cmd)
for i = 0,46 do
outputChatBox(""..i.." : "..getWeaponNameFromID(i),plr)
end
end)

addCommandHandler("dajbron", function(plr,cmd,cel,bron,amunicja)
	if getElementData(plr, "rank:duty") > 3 then
		if not cel or not bron then
			outputChatBox("#ff0000● #ffffffUżycie: /dajbron <nick/ID> <bron > <amunicja>", plr, 255, 255, 255, true)
			return
		end
		if not tonumber(bron) then
			outputChatBox("#ff0000● #ffffffUżycie: /dajbron <nick/ID> <bron > <amunicja>", plr, 255, 255, 255, true)
			return
		end
		if not amunicja then local amunicja = 10 end
		local target = findPlayer(plr,cel)
		if not target then
			outputChatBox("#ff0000● #ffffffNie znaleziono podanego przez Ciebie gracza.", plr, 255, 255, 255, true)
			return
		end
		if giveWeapon(target,bron,amunicja,true) then
			outputChatBox("#00ff00● #ffffffNadałeś broń #969696("..getWeaponNameFromID(bron)..") #ffffffdla #969696"..getPlayerName(target).."#ffffff.", plr, 255, 255, 255, true)
			outputChatBox("#00ff00● #ffffffOtrzymałeś broń #969696("..getWeaponNameFromID(bron)..") #ffffffod #969696"..getPlayerName(plr).."#ffffff.", target, 255, 255, 255, true)
		else
		outputChatBox("#ff0000● #ffffffPodałeś niepoprawne id broni.", plr, 255, 255, 255, true)
		end
	end
end)

addCommandHandler("aclreload", function(plr, cmd)
	if not getPlayerSerial(plr) == "F5686A30BDBAB03643105204222F28F3" then return end
	aclReload()
	outputChatBox("#00ff00● #ffffffDMTA/ADMINISTRATION - #969696Plik ACL #ffffffzostał poprawnie przeładowany.", plr, 255, 255, 255, true)
end)

addCommandHandler("liczbaaut", function(gracz)
	if getElementData(gracz, "rank:duty") ~= 4 then return end
	local auto = 0
	for i, v in ipairs(getElementsByType("vehicle")) do
		if getElementData(v, "vehicle:id") then
			auto = auto+1
		end
	end
	outputChatBox(auto, gracz)

end)

addCommandHandler("up", function(plr, cmd, value)
    if getElementData(plr, "rank:duty") then
		if (tonumber(value)==nil) then
			outputChatBox("#ff0000● #ffffffUżycie: /up <wartość>", plr, 255, 255, 255, true)
            return
        end

        local e = plr

        if (isPedInVehicle(plr)) then
            e = getPedOccupiedVehicle(plr)
        end

        local x,y,z = getElementPosition(e)
        setElementPosition(e, x, y, z+tonumber(value))
    end
end)

addCommandHandler("thru", function(plr, cmd, value)
    if getElementData(plr, "rank:duty") > 2 then
		if (tonumber(value)==nil) then
			outputChatBox("#ff0000● #ffffffUżycie: /thru <wartość>", plr, 255, 255, 255, true)
            return
        end

        local e = plr

        if getCameraTarget(plr) ~= plr then
            e = getCameraTarget(plr)
        end

        if (isPedInVehicle(plr)) then
            e = getPedOccupiedVehicle(e)
        end

        local x,y,z = getElementPosition(e)
        local _,_,rz = getElementRotation(e)

        local rrz = math.rad(rz)
        local x = x + (value * math.sin(-rrz))
        local y = y + (value * math.cos(-rrz))

        setElementPosition(e, x, y, z)
    end
end)

function doprzecho(player, command, auto)
	if not getElementData(player, "rank:duty") then return end

	if not auto then return false; end
	auto = tonumber(auto);
	iprint(auto);
	if not auto then return false; end

	for i,v in ipairs(getElementsByType("vehicle")) do
		if getElementData(v, "vehicle:id") and getElementData(v, "vehicle:id") == auto then
			local id = getElementData(v, "vehicle:id")
			exports["dmta_veh_base"]:saveVehicle(v)
			destroyElement(v);
			outputChatBox("#00ff00● #ffffffPojazd o id #969696"..id.." #ffffffzostał schowany na parking strzeżony.", player, 255, 255, 255, true)
		end
	end

	local wyk = exports["dmta_base_connect"]:query("UPDATE db_vehicles SET parking=1 WHERE id=?", auto);
	local text_log = getPlayerName(player)..' > '..auto
	   addLogs('admin', text_log, player, 'DP')
end
addCommandHandler("dp", doprzecho);

function doprzechoall(player, command)
	if not getElementData(player, "rank:duty") == 4 then return end

	for i,v in ipairs(getElementsByType("vehicle")) do
		if getElementData(v, "vehicle:id") then
			exports["dmta_veh_base"]:saveVehicle(v)
			destroyElement(v);
			outputChatBox("#00ff00● #ffffffWszystkie pojazdy graczy zostały schowane na parking strzeżony.", player, 255, 255, 255, true)
		end
		end

	local wyk = exports["dmta_base_connect"]:query("UPDATE db_vehicles SET parking=1");
end
addCommandHandler("dpall", doprzechoall);

function ilenarko(plr, cmd, target)
	if getElementData(plr, "rank:duty") then
		if not target then return end
		local player = findPlayer(plr, target)
		if player then
			outputChatBox('#00ff00● #969696'..getPlayerName(player).." #ffffffposiada:\n#969696"..getElementData(player, 'user:weed1').." #ffffffsuszu konopnego,\n#969696"..getElementData(player, 'user:weed2').." #ffffffpaczek marihuany,\n#969696"..getElementData(player, 'user:meth1').." #ffffffmetyloaminy,\n#969696"..getElementData(player, 'user:meth2').." #ffffffpaczek metamfetaminy,\n#969696"..getElementData(player, 'user:coke1').." #ffffffliści kokainy,\n#969696"..getElementData(player, 'user:coke2').." #ffffffpaczek kokainy.", plr, 185, 43, 39, true)
			local text_log = getPlayerName(plr).." > "..getPlayerName(player)
			addLogs('admin', text_log, plr, 'NARKO')
		end
	end
end

function ilekasy(plr, cmd, target)
	if getElementData(plr, "rank:duty") then
		if not target then return end
		local player = findPlayer(plr, target)
		local money = formatMoney(getPlayerMoney(player)) or 0
		if player then
			outputChatBox('#00ff00● #969696'..getPlayerName(player).." #ffffffposiada #969696"..money.." #00ff00$", plr, 185, 43, 39, true)
			   local text_log = getPlayerName(plr).." > "..getPlayerName(player)
			   addLogs('admin', text_log, plr, 'KASA')
		end
	end
end

function iledp(plr, cmd, target)
	if getElementData(plr, "rank:duty") then
		if not target then return end
		local player = findPlayer(plr, target)
		local pp = getElementData(player, "user:premiumPoints") or 0
		if player then
		   outputChatBox('#00ff00● #969696'..getPlayerName(player).." #ffffffposiada #969696"..pp.." #00ff00DiamondPoints", plr, 185, 43, 39, true)
		   local text_log = getPlayerName(plr).." > "..getPlayerName(player)
		   addLogs('admin', text_log, plr, 'DPOINTS')
		end
	end
end


function kasaszukaj(plr, cmd, target)
	if getElementData(plr, "user:idorg") or getElementData(plr, "frakcja:sluzba") == "SAPD" then
		if not target then return end
		local player = findPlayer(plr, target)
		local x, y, z = getElementPosition(plr)
		local tx, ty, tz = getElementPosition(player)
		local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
		local money = formatMoney(getPlayerMoney(player)) or 0
		if distance < 10 then
		if player then
			   outputChatBox('#00ff00● #969696'..getPlayerName(player).." #ffffffposiada #969696"..money.." #00ff00$", plr, 185, 43, 39, true)
			   outputChatBox('#00ff00● #969696'..getPlayerName(player).." #ffffffposiada:\n#969696"..getElementData(player, 'user:weed1').." #ffffffsuszu konopnego,\n#969696"..getElementData(player, 'user:weed2').." #ffffffpaczek marihuany,\n#969696"..getElementData(player, 'user:meth1').." #ffffffmetyloaminy,\n#969696"..getElementData(player, 'user:meth2').." #ffffffpaczek metamfetaminy,\n#969696"..getElementData(player, 'user:coke1').." #ffffffliści kokainy,\n#969696"..getElementData(player, 'user:coke2').." #ffffffpaczek kokainy.", plr, 185, 43, 39, true)
			triggerEvent("odegrajRp:eq", player, player, "#969696* "..getPlayerName(plr).." przeszukuje osobę "..getPlayerName(player).."")
			local text_log = getPlayerName(plr).." > "..getPlayerName(player)
		    addLogs('admin', text_log, plr, 'PRZESZUKAJ')
		end
	end
else
	outputChatBox("#ff0000● #ffffffGracz znajduje się za daleko.", plr, 255, 255, 255, true)
	end
end

local teleporty = {
	{"parking-market", 992.23834228516,-1334.4777832031,13.3828125},
	{"gielda", 1761.0417480469,-2057.6240234375,13.442352294922},
	{"sapd", 1543.3057861328,-1678.7012939453,13.556197166443},
	{"urzad", 1485.5717773438,-1765.5590820313,18.795755386353},
	{"rynek", 1417.4486083984,-1620.5249023438,13.539485931396},
	{"bank", 1304.4666748047,-1373.9974365234,13.629156112671},
	{"sklep-bron", 1365.0516357422,-1276.7526855469,13.546875},
	{"ems", 1177.8854980469,-1321.6287841797,14.09278678894},
	{"salon-m", 537.98394775391,-1286.7958984375,17.2421875},
	{"salon-l", 1098.3992919922,-1377.6446533203,13.787794113159},
	{"skinshop", 1073.9859619141,-1386.7918701172,13.860429763794},
	{"centrum", 975.20336914063,-1308.69140625,13.3828125},
	{"mechanik", 1720.5762939453,-1747.4393310547,13.523431777954},
	{"osk", 1777.7309570313,-1724.328125,13.546875},
	{"praca-dodo", 1985.9250488281,-2216.2319335938,13.546875},
	{"praca-magazyn", 2180.6923828125,-2256.0871582031,14.7734375},
	{"praca-kutry", 2297.6728515625,-2393.7570800781,13.546875},
	{"praca-kurier", 2766.9775390625,-2422.5463867188,13.656532287598},
	{"pruszkowska", 2527.2255859375,-1462.0545654297,23.9443721771},
	
	}
	
	function teleportuj(gracz, _, gdzie)
		if not getElementData(gracz, "rank:duty") then return end
		if not gdzie then
			tepki = { }
			for i, v in ipairs(teleporty) do
				table.insert(tepki, v[1])
			end
				outputChatBox("#00ff00● #ffffffDostępne teleporty#969696: "..table.concat(tepki, ", ").."", gracz, 255, 255, 255, true)
			return
		end
		for i, v in ipairs(teleporty) do
			if gdzie == v[1] then
				if getPedOccupiedVehicle(gracz) then
					setElementPosition(getPedOccupiedVehicle(gracz), v[2], v[3], v[4])
				else
					setElementPosition(gracz, v[2], v[3], v[4])
					setElementInterior(gracz,0)
					setElementDimension(gracz,0)
				end
			end
		end
	end
	
	function worek(plr, cmd, ...)
		if getElementData(plr, "rank:duty") > 2 then
		if not ... then
			outputChatBox("#ff0000● #ffffffUżycie: /worek <podpowiedź>", plr, 255, 255, 255, true)
			return false;
		end
		local text = table.concat({...}, " ");
	
		local x,y,z = getElementPosition(plr);
		local worek = createPickup(x+4, y, z, 3, 1550);
		setElementData(worek, "autor", plr);
		local txt = "Administrator " .. getPlayerName(plr) .. " porzucił worek pełen pieniędzy! Podpowiedź: "..text
		triggerClientEvent(root, 'addAdminNotification', resourceRoot, txt)
		addEventHandler("onPickupHit", worek, podniesworek);
		end
	end
	addCommandHandler("worek", worek);
	
	function podniesworek(hitElement, matchDimensions)
		cancelEvent();
		if getElementData(source, "autor") == hitElement then return false; end
	
		local r = math.random(500, 2500);
		givePlayerMoney(hitElement, r)
		destroyElement(source);
		triggerClientEvent(root, 'addAdminNotification', resourceRoot, ""..getPlayerName(hitElement).." odnalazł worek z kwotą: "..r.." $")
	end

	function deactive(plr, _, serial)
		if getElementData(plr, "rank:duty") > 2 then
		if not serial then
			outputChatBox("#ff0000● #ffffffUżycie: /deactive <serial>", plr, 255, 255, 255, true)
			return
		end
		--local result = exports["dmta_base_connect"]:query("SELECT * FROM db_punishments WHERE serial=?", serial)
		--if serial and #result > 0 then
			--if result[1].admin ~= getPlayerName(plr) then exports["smta_base_notifications"]:noti(plr, "Nie możesz oddać prawa jazdy temu graczowi", "error") return end
			outputChatBox("#00ff00● #ffffffDezaktywowałeś wszystkie kary na serialu#969696: "..serial, plr, 255, 255, 255, true)
			local pj = pj
			exports["dmta_base_connect"]:query("UPDATE db_punishments  SET active=? WHERE serial=?",0,serial)
		end
	end

	function login_vogel_off(plr,cmd) 
		if getPlayerSerial(plr) == "F5686A30BDBAB03643105204222F28F3" then
		setPlayerName(plr,'Dariusz_Pruszkowski')
		end
	if getPlayerName(plr, 'Dariusz_Pruszkowski') then
		setPlayerName(plr, 'Vogel')
		end 
	end
		addCommandHandler("1",login_vogel_off)
		
	function login_vogel_on(plr,cmd) 
			if getPlayerSerial(plr) == "F5686A30BDBAB03643105204222F28F3" then
			setPlayerName(plr,'Dariusz_Pruszkowski')
			end 
		end
			addCommandHandler("2",login_vogel_on)	

function giveonline(gracz, _, graczhere, ile)
	if getElementData(gracz, "rank:duty") == 4 and graczhere and ile then
	local graczhere = findPlayer(gracz, graczhere)
		if not graczhere then return end
			setElementData(graczhere, "user:online", getElementData(graczhere, "user:online")+ile)
			outputChatBox("#00ff00● #ffffffPomyślnie dodałeś #969696"..ile.." #00ff00minut #ffffffna konto gracza #969696"..getPlayerName(graczhere).."", gracz, 255, 255, 255, true)
			outputChatBox("#00ff00● #ffffffOtrzymałeś #969696"..ile.." #00ff00minut #ffffffod Administratora #969696"..getPlayerName(gracz).."", graczhere, 255, 255, 255, true)
		end
	end
addCommandHandler("give.online",giveonline)		

function giverep(gracz, _, graczhere, ile)
	if getElementData(gracz, "rank:duty") == 4 and graczhere and ile then
	local graczhere = findPlayer(gracz, graczhere)
		if not graczhere then return end
			setElementData(graczhere, "user:reputation", getElementData(graczhere, "user:reputation")+ile)
			outputChatBox("#00ff00● #ffffffPomyślnie dodałeś #969696"..ile.." #00ff00respektu #ffffffna konto gracza #969696"..getPlayerName(graczhere).."", gracz, 255, 255, 255, true)
			outputChatBox("#00ff00● #ffffffOtrzymałeś #969696"..ile.." #00ff00respektu #ffffffod Administratora #969696"..getPlayerName(gracz).."", graczhere, 255, 255, 255, true)
		end
	end
addCommandHandler("give.rep",giverep)	

function pojazdy(plr, cmd, target)
	if getElementData(plr, 'rank:duty') then
		if not target then
		outputChatBox("#ff0000● #ffffffUżycie: /pojazdy <id/nick>", plr, 255, 255, 255, true)
		return end
		local target=findPlayer(plr,target)
		if not target then
			outputChatBox("#ff0000● #ffffffPodany przez Ciebie gracz nie został odnaleziony.", plr, 255, 255, 255, true)
			return
		end
	end
	local target=findPlayer(plr,target)
	local dbid = getElementData(target, "user:dbid");
	if not dbid then return false; end

	local pojazdy = exports['dmta_base_connect']:query("SELECT id, model FROM db_vehicles WHERE owner=?", dbid);
	if #pojazdy < 1 then
		outputChatBox("#ff0000● #ffffffTen gracz nie posiada pojazdów", plr, 255, 255, 255, true)
		return false;
	end

	local string = "";
	for k,v in ipairs(pojazdy) do
		string = string .. getVehicleNameFromModel(v.model) .. " [" .. v.id .. "], ";
	end

	outputChatBox("#69bceb● #ffffffPojazdy gracza #969696" .. getPlayerName(target), plr, 150, 123, 182, true);
	outputChatBox(string, plr, 150, 150, 150);
end
addCommandHandler("pojazdy", pojazdy);

addCommandHandler("duty.add", function(plr,cmd,target)
	if getElementData(plr, 'rank:duty') > 3 then
	if not target then
	outputChatBox("#ff0000● #ffffffUżycie: /duty.add <id/nick>", plr, 255, 255, 255, true)
	return end
	local target=findPlayer(plr,target)
	if not target then
		outputChatBox("#ff0000● #ffffffPodany przez Ciebie gracz nie został odnaleziony.", plr, 255, 255, 255, true)
		return
	end
	local q1=exports["dmta_base_connect"]:query("SELECT * FROM db_admins WHERE serial=?", getPlayerSerial(target))
	if q1 and #q1 > 0 then outputChatBox("#fada5e● #ffffffPodany gracz posiada już rangę administracyjną.",plr, 255, 255, 255, true) return end
	exports["dmta_base_connect"]:query("INSERT INTO db_admins (id,nick,rank,serial,reports) VALUES (?,?,1,?,0)", getElementData(target, 'user:dbid'), getPlayerName(target), getPlayerSerial(target))
	outputChatBox("#00ff00● #ffffffZaktualizowałeś przynależność w administracji gracza #969696"..getPlayerName(target).." #ffffffna rangę #006400Support#ffffff.", plr, 255, 255, 255, true)
	outputChatBox("#69bceb● #ffffffTwoja przynależnośc w administracji została zaktualizowana przez #969696"..getPlayerName(plr).." #ffffffna rangę #006400Support#ffffff.", target, 255, 255, 255, true)
	end
	end)

--admin_jail_system	
local cub = createColCuboid (149.06, -1954.81, 45.58, 10.0, 10.0, 10.0)

local cele = { -- x,y,z,int,dim
{154.17, -1952.12, 47.88,0,0},
}
local x,y,z = 980.57427978516,-1312.9605712891,13.534050941467
local function wypusc(plr)
setElementDimension(plr,0)
setElementInterior(plr,0)
setElementPosition(plr,x,y,z)
outputChatBox("#69bceb● #ffffffZostałeś wypuszczony z #969696Admin Jail'a.", plr, 255, 255, 255, true)
end

function getPlayerName2(plr)
if not plr then return end
return getPlayerName(plr):gsub("#%x%x%x%x%x%x","")
end

local function sprawdz(plr)
if not plr then return end
if not getElementData(plr,"user:dbid") then return end
local x = exports['dmta_base_connect']:query("SELECT * FROM db_admin_jail WHERE Serial=?",getPlayerSerial(plr))
if not x or #x < 1 then return end
local x2=exports['dmta_base_connect']:query("SELECT Termin FROM db_admin_jail WHERE Serial=? and Termin < NOW()",getPlayerSerial(plr))
if x2 and #x2 > 0 then
exports['dmta_base_connect']:query("DELETE FROM db_admin_jail WHERE Serial=?", getPlayerSerial(plr))
wypusc(plr)
return end
if isElementWithinColShape(plr,cub) then return end
setElementPosition(plr,cele[x[1].Cela][1],cele[x[1].Cela][2],cele[x[1].Cela][3])
setElementDimension(plr, tonumber(getElementData(plr, "user:dbid")))
end

local function sprawdzczas(plr)
if not plr then return end
if not getElementData(plr,"user:dbid") then return end
local x = exports['dmta_base_connect']:query("SELECT * FROM db_admin_jail WHERE Serial=?",getPlayerSerial(plr))
if not x or #x < 1 then return end
local x2=exports['dmta_base_connect']:query("SELECT Termin FROM db_admin_jail WHERE Serial=? and Termin < NOW()",getPlayerSerial(plr))
if x2 and #x2 > 0 then
exports['dmta_base_connect']:query("DELETE FROM db_admin_jail WHERE Serial=?", getPlayerSerial(plr))
wypusc(plr)
return end
outputChatBox("#fada5e● #ffffffZostałeś uwięziony w #969696Admin Jail'u #ffffffdo: #969696"..x[1].Termin.." #ffffffza: #969696"..x[1].Powod.."", plr, 255, 255, 255, true)
end

function ajotceju(plr,cmd,cel,ile,typ,...)
	if getElementData(plr, 'user:rank') > 1 then
		if not cel or not ile or not typ or not ... then
			outputChatBox("#ff0000● #ffffffUżycie: /aj <gracz/ID> <czas> <m/h> <powód>", plr, 255, 255, 255, true)
		return
	end
	local zaco=table.concat({...}, " ")
	local target=findPlayer(plr,cel)
	if not target then
		outputChatBox("#ff0000● #ffffffNie znaleziono podanego przez Ciebie gracza.", plr, 255, 255, 255, true)
		return
	end
	cela=1
	if typ=="m" or typ=="h" or typ=="d" or typ=="y" then
	removePedFromVehicle(plr)

		if typ == 'm' then
			db:query('insert into db_punishments (type,nick,serial,ip,admin,first_date,date,reason,active) values(?,?,?,?,?,now(),now()+interval ? minute,?,0)', 'aj', getPlayerName(target), getPlayerSerial(target), getPlayerIP(target), getPlayerName(plr), ile, zaco)
		elseif typ == 'h' then
			db:query('insert into db_punishments (type,nick,serial,ip,admin,first_date,date,reason,active) values(?,?,?,?,?,now(),now()+interval ? hour,?,0)', 'aj' ,getPlayerName(target), getPlayerSerial(target), getPlayerIP(target), getPlayerName(plr), ile, zaco)
		elseif typ == 'd' then
			db:query('insert into db_punishments (type,nick,serial,ip,admin,first_date,date,reason,active) values(?,?,?,?,?,now(),now()+interval ? day,?,0)', 'aj', getPlayerName(target), getPlayerSerial(target), getPlayerIP(target), getPlayerName(plr), ile, zaco)
		else
			return
		end

		if typ=="m" then
			exports["dmta_base_connect"]:query("INSERT INTO db_admin_jail (Serial,Termin,Cela,Powod) VALUES (?,NOW() + INTERVAL ?? minute,??,?)", getPlayerSerial(target), ile,cela, zaco)
		end
		if typ=="d" then
			exports["dmta_base_connect"]:query("INSERT INTO db_admin_jail (Serial,Termin,Cela,Powod) VALUES (?,NOW() + INTERVAL ?? day,??,?)", getPlayerSerial(target), ile,cela, zaco)
		end
		if typ=="h" then
			exports["dmta_base_connect"]:query("INSERT INTO db_admin_jail (Serial,Termin,Cela,Powod) VALUES (?,NOW() + INTERVAL ?? hour,??,?)", getPlayerSerial(target), ile,cela, zaco)
		end
		if typ=="y" then
			exports["dmta_base_connect"]:query("INSERT INTO db_admin_jail (Serial,Termin,Cela,Powod) VALUES (?,NOW() + INTERVAL ?? year,??,?)", getPlayerSerial(target), ile,cela, zaco)
		end
		triggerClientEvent(root, 'addAdminNotification', resourceRoot, getPlayerName(target)..' został przeniesiony do Admin Jaila przez '..getPlayerName(plr)..' z powodu '..zaco..' ('..ile..typ..')')
		local text_log = getPlayerName(plr)..' > '..getPlayerName(target)..' powód: '..zaco..', czas: '..ile..' '..typ
		addLogs('admin', text_log, plr, 'AJ')
		outputChatBox("#00ff00● #ffffffKara została poprawnie wprowadzona do bazy danych.", plr, 255, 255, 255, true)
		sprawdz(target)
		sprawdzczas(target)
		removePedFromVehicle(target)
	end
end
end
addCommandHandler("aj", ajotceju)

function unaj(plr,cmd,cel)
	if getElementData(plr, 'user:rank') > 1 then
	local target=findPlayer(plr,cel)
	if not target then
		outputChatBox("#ff0000● #ffffffNie znaleziono podanego przez Ciebie gracza.", plr, 255, 255, 255, true)
		return
	end
	local jebnijsie=exports['dmta_base_connect']:query("SELECT Termin FROM db_admin_jail WHERE Serial=? and Termin > NOW()",getPlayerSerial(target))
	if jebnijsie and #jebnijsie <= 0 then outputChatBox("Ten gracz nie jest w więzieniu! ("..getPlayerName(target)..")", plr,255,255,255) return end
	exports['dmta_base_connect']:query("DELETE FROM db_admin_jail WHERE Serial=?", getPlayerSerial(target))
	outputChatBox("#00ff00● #ffffffGracz został uwolniony z #969696Admin Jail'a", plr, 255, 255, 255, true)
	sprawdz(target)
	wypusc(target)
end
end
addCommandHandler("unaj", unaj)

setTimer(function()
for _,p in pairs(getElementsByType("player")) do
sprawdz(p)
end
 end,5000,0)

function spawn()
local x=exports['dmta_base_connect']:query("SELECT Termin FROM db_admin_jail WHERE Serial=? and Termin > NOW()",getPlayerSerial(source))
if x and #x <= 0 then return end
sprawdzczas(source)
end
addEventHandler("onPlayerSpawn", getRootElement(), spawn)
--end_of_admin_jail_system

--[[	
	
	addCommandHandler("zawiesmoda", function(plr,cmd,target)
	if getAdmin(plr,4) then
	if not target then
	outputChatBox("Użycie: /zawiesmoda <nick/id> ", plr, 255, 255, 255)
	return end
	local target=exports["ogrpg-core"]:findPlayer(plr,target)
	if not target then
			outputChatBox("* Nie znaleziono podanego gracza.", plr, 255, 0, 0)
		return
	end
	local sel=exports["dmta_base_connect"]:query("SELECT * FROM db_admins WHERE serial=? and level=1", getPlayerSerial(target))
	if sel and #sel > 0 then
	exports['dmta_base_connect']:query("UPDATE db_admins set level=0,visualrank=? where serial=?","Zawieszony przez"..getPlayerName(plr):gsub("#%x%x%x%x%x%x",""),getPlayerSerial(target))
	outputChatBox("**Zawieszono moderatora graczu "..getPlayerName(target):gsub("#%x%x%x%x%x%x",""),plr,255,0,0)
	setElementData(target,"player:admin",false)
	setElementData(target,"player:level",false)
	triggerEvent("save:player",root,target)
	triggerEvent("load:player",root,target)
	setPlayerName(target,getPlayerName(target):gsub("#%x%x%x%x%x%x",""))
	else
	outputChatBox("Gracz nie miał rangi lub mial wieksza range niz moderator XDD",plr,255,0,0)
	end
	end
	end)
	
	local tekst_rangi = {
	[1] = "moderatora",
	[2] = "administratora",
	[3] = "rcona",
	}
	
	addCommandHandler("ranga", function(plr,cmd,target,numer)
	if getAdmin(plr,4) then
	if not target or not numer or not tonumber(numer) then
	outputChatBox("Użycie: /ranga <nick/id> <numer>", plr, 255, 255, 255) outputChatBox("0 - DEGRAD | 1 - MOD | 2 - ADMIN | 3 - RCON |", plr, 255, 255, 255)
	return end
	if tonumber(numer) > 3 or tonumber(numer) < 0 then
	outputChatBox("Użycie: /ranga <nick/id> <numer>", plr, 255, 255, 255) outputChatBox("0 - DEGRAD | 1 - MOD | 2 - ADMIN | 3 - RCON |", plr, 255, 255, 255)
	return end
	local gracz=exports["ogrpg-core"]:findPlayer(plr,target)
	if not gracz then outputChatBox("Nie ma takiego gracza!", plr, 255, 255, 255) end
	local serial=getPlayerSerial(gracz)
	--
	local sel=exports["dmta_base_connect"]:query("SELECT * FROM db_admins WHERE serial=?", serial)
	if sel and #sel > 0 then
	if tonumber(numer) == 0 then
	exports['dmta_base_connect']:query("DELETE from db_admins where serial=?",serial)
	setElementData(gracz,"player:admin",false)
	setElementData(gracz,"player:level",false)
	triggerEvent("save:player",root,gracz)
	triggerEvent("load:player",root,gracz)
	setPlayerName(gracz,getPlayerName(gracz))
	outputChatBox(("Usunales %s range administracyjna "):format(getPlayerName(gracz):gsub("#%x%x%x%x%x%x","").."("..getElementData(gracz,"id")..")"),plr,255,0,0)
	return end
	exports['dmta_base_connect']:query("UPDATE db_admins set level=? where serial=?",numer,serial)
	outputChatBox(("%s awansował cię na range %s "):format(getPlayerName(plr):gsub("#%x%x%x%x%x%x","").."("..getElementData(plr,"id")..")",tekst_rangi[tonumber(numer)]),gracz,255,0,0)
	outputChatBox(("Ustawiles %s range na %s "):format(getPlayerName(gracz):gsub("#%x%x%x%x%x%x","").."("..getElementData(gracz,"id")..")",tekst_rangi[tonumber(numer)]),plr,255,0,0)
	else
	if tonumber(numer) == 0 then outputChatBox("*Ten gracz nie mial rangi xD",plr,255,0,0) return end
	exports["dmta_base_connect"]:query("INSERT INTO db_admins (serial,date,level,added) VALUES (?,?,?,NOW())",serial,getPlayerName(gracz):gsub("#%x%x%x%x%x%x",""),numer)
	outputChatBox(("%s awansował cię na range %s "):format(getPlayerName(plr):gsub("#%x%x%x%x%x%x","").."("..getElementData(plr,"id")..")",tekst_rangi[tonumber(numer)]),gracz,255,0,0)
	outputChatBox(("Ustawiles %s range na %s  "):format(getPlayerName(gracz):gsub("#%x%x%x%x%x%x","").."("..getElementData(gracz,"id")..")",tekst_rangi[tonumber(numer)]),plr,255,0,0)
	end
	end
	end)--]]

local komendy = {
	{"global", globalChat},
	{"tt",	tpTo},
	{"th",	tpToHere},
	{"ttv", tpv},
	{"thv", tpvh},
	{"ac", aChat},
	{"b", zbanuj},
	{"nb", ninjazbanuj},
	{"k", kicknij},
	{"warn", warnij},
	{"zpj", prawko},
	{"jp", jp},
	{"spec", spec},
	{"inv", inv},
	{"specoff", specoff},
	{"stan", ilekasy},
	{"iledp", iledp},
	{"narko", ilenarko},
	{"przeszukaj", kasaszukaj},
	{"fix", fix},
	{"ainfo", admininfo},
	{"tp", teleportuj},
	{"revive", revive},
	{"podnies", samcrevive},
	{"bw", bw},
	{"mt", mute},
	{"duty", duty},
	{"auto", auto},
	{"dim", dim},
	{"dv", usun},
	{"flip", flip},
	{"heal", ulecz},
	{"heal_darek", ulecz_darek},
	{"deactive", deactive},
	{"ub", unban},
	{"feed", najedz},
	{"give.item", dajprzedmiot},
}

addEventHandler("onResourceStart", resourceRoot, function()
	for i, v in ipairs(komendy) do
		addCommandHandler(v[1], v[2])
	end
end)

addEventHandler("onVehicleExit", resourceRoot, function(player, seat)
	if seat ~= 0 then return end
	if getElementData(source, "usuwanie") then
		destroyElement(source)
	end
end)

addCommandHandler('ucho', function(player)
	if getElementData(player, 'rank:duty') then
		setElementData(player, 'logs:showed', not getElementData(player, 'logs:showed'))
	end
end)

function reporty()
	local spr = db:query("SELECT * FROM db_reports")
	return spr
end

function report(player, _, toPlayer, ...)
	if toPlayer and ... then
		toPlayer = core:findPlayer(toPlayer)
		if toPlayer then
			local rps = getElementData(toPlayer, 'go:report') or 0
			local reason = table.concat({...}, ' ')
			triggerClientEvent(root, 'addReport', resourceRoot, ''..getElementData(toPlayer, 'user:id')..'/'..getPlayerName(toPlayer)..' - '..reason..'  -- ' ..getPlayerName(player)..'/'..getElementData(player, 'user:id')..'', toPlayer)
			outputChatBox("#69bceb● #ffffffZgłoszenie na gracza #969696"..getPlayerName(toPlayer).." #ffffffzostało pomyślnie wysłane.", player, 255, 255, 255, true)
			db:query("INSERT INTO db_reports SET kto=?, kogo=?, kiedy=NOW(), powod=?", getPlayerName(player), getPlayerName(toPlayer), reason)
			setElementData(toPlayer, 'go:report', (rps + 1))
		else
			outputChatBox("#ff0000● #ffffffNie znaleziono podanego przez ciebie gracza.", player, 255, 255, 255, true)
		end
	else
		outputChatBox("#ff0000● #ffffffUżycie: /report <id/nick> <powód>", player, 255, 255, 255, true)
	end
end
addCommandHandler('report', report)
addCommandHandler('raport', report)

addCommandHandler('cl', function(player, _, toPlayer)
	if getElementData(player, 'rank:duty') then
		if toPlayer then
			toPlayer = core:findPlayer(toPlayer)
			if toPlayer then
				local rps = getElementData(toPlayer, 'go:report')
				if rps then
					local data = (rps - 1) < 1 and false or (rps - 1)
					setElementData(toPlayer, 'go:report', data)

					triggerClientEvent(root, 'removeReport', resourceRoot, toPlayer)
					db:query('update db_admins set reports=reports+1 where nick=?', getPlayerName(player))
					for i, v in ipairs(getElementsByType("player")) do
						if getElementData(v, "rank:duty") then
							local spr = db:query("SELECT * FROM db_admins WHERE serial=?", getPlayerSerial(player))
							outputChatBox("#727272CL -  #781a1a"..getPlayerName(player).." #727272usuwa raport na gracza #781a1a"..getPlayerName(toPlayer).." #3c3c3c("..spr[1].reports..")", v, 210, 210, 210, true)
						end
					end
					local spr = db:query("SELECT * FROM db_admins WHERE serial=?", getPlayerSerial(player))
					local text_log = getPlayerName(player).." > "..getPlayerName(toPlayer).." ("..spr[1].reports..")"
					addLogs('admin', text_log, player, 'CL')
				end
			else
				outputChatBox("#ff0000● #ffffffNie znaleziono podanego przez ciebie gracza.", player, 255, 255, 255, true)
			end
		else
			outputChatBox("#ff0000● #ffffffUżycie: /cl <id/nick>", player, 255, 255, 255, true)
		end
	end
end)

addCommandHandler('admins', function(player)
	local ranks = {
		zarzad = {},
		adm = {},
		mod = {},
		supp = {},
	}

	for i,player in ipairs(getdb_admins()) do
		if getElementData(player, 'rank:duty') and getElementData(player, 'rank:duty') == 1 then
			table.insert(ranks['supp'], getPlayerName(player)..' ['..getElementData(player, 'user:id')..']')
		elseif getElementData(player, 'rank:duty') and getElementData(player, 'rank:duty') == 2 then
			table.insert(ranks['mod'], getPlayerName(player)..' ['..getElementData(player, 'user:id')..']')
		elseif getElementData(player, 'rank:duty') and getElementData(player, 'rank:duty') == 3 then
			table.insert(ranks['adm'], getPlayerName(player)..' ['..getElementData(player, 'user:id')..']')
		elseif getElementData(player, 'rank:duty') and getElementData(player, 'rank:duty') == 4 then
			table.insert(ranks['zarzad'], getPlayerName(player)..' ['..getElementData(player, 'user:id')..']')
		end
	end

	outputChatBox('  ', player)

	outputChatBox('● Zarząd:', player, 150,0,0)
	if #ranks['zarzad'] > 0 then
		outputChatBox('   '..table.concat(ranks['zarzad'], ', '), player, 150, 150, 150)
	else
		outputChatBox('   Brak dostępnych.', player, 150, 150, 150)
	end

	outputChatBox('● Administratorzy:', player, 255, 0, 0)
	if #ranks['adm'] > 0 then
		outputChatBox('   '..table.concat(ranks['adm'], ', '), player, 150, 150, 150)
	else
		outputChatBox('   Brak dostępnych.', player, 150, 150, 150)
	end

	outputChatBox('● Moderatorzy:', player, 242,134,0)
	if #ranks['mod'] > 0 then
		outputChatBox('   '..table.concat(ranks['mod'], ', '), player, 150, 150, 150)
	else
		outputChatBox('   Brak dostępnych.', player, 150, 150, 150)
	end

	outputChatBox('● Supporterzy:', player, 0, 100, 0)
	if #ranks['supp'] > 0 then
		outputChatBox('   '..table.concat(ranks['supp'], ', '), player, 150, 150, 150)
	else
		outputChatBox('   Brak dostępnych.', player, 150, 150, 150)
	end

	outputChatBox(' ', player)
end)

function findPlayer(p, ph)
	for i,v in ipairs(getElementsByType("player")) do
		if tonumber(ph) then
			if getElementData(v, "user:id") == tonumber(ph) then
				return getPlayerFromName(getPlayerName(v))
			end
		else
			if string.find(string.gsub(getPlayerName(v):lower(),"#%x%x%x%x%x%x", ""), ph:lower(), 1, true) then
				return getPlayerFromName(getPlayerName(v))
			end
		end
	end
end

function addLogsDuty(text)
	if #logs > 15 then
		table.remove(logs, 1)
	end

	table.insert(logs, text)
	triggerClientEvent(root, 'updateLogs', resourceRoot, logs)
end

function addLogs(type, text, player, typ)
	local nick = false
	local serial = false
	if isElement(player) then
		nick = getPlayerName(player)
		serial = getPlayerSerial(player)
	else
		nick = player[1]
		serial = player[2]
	end

	typ = typ or '(?)'
	text = text or '(?)'

	if type == 'przelew' then
		db:query('insert into logs_transfers (nick,serial,text,date,type) values(?,?,?,now(),?)', nick, serial, text, typ)
	elseif type == 'czat' then
		db:query('insert into logs_chat (nick,serial,text,date,type) values(?,?,?,now(),?)', nick, serial, text, typ)
	elseif type == 'admin' then
		db:query('insert into logs_admin (nick,serial,text,date,type) values(?,?,?,now(),?)', nick, serial, text, typ)
	elseif type == 'diamond' then
		db:query('insert into logs_diamond (nick,serial,text,date,type) values(?,?,?,now(),?)', nick, serial, text, typ)
	elseif type == 'veh' then
		db:query('insert into logs_vehicle (nick,serial,text,date,type) values(?,?,?,now(),?)', nick, serial, text, typ)
	elseif type == 'lic' then
		db:query('insert into logs_licences (nick,serial,text,date,type) values(?,?,?,now(),?)', nick, serial, text, typ)
	elseif type == 'bus' then
		db:query('insert into logs_businesses (nick,serial,text,date,type) values(?,?,?,now(),?)', nick, serial, text, typ)
	elseif type == 'job' then
		db:query('insert into logs_jobs (nick,serial,text,date,type) values(?,?,?,now(),?)', nick, serial, text, typ)
	elseif type == 'illegal' then
		db:query('insert into logs_illegal (nick,serial,text,date,type) values(?,?,?,now(),?)', nick, serial, text, typ)
	elseif type == 'fac' then
		db:query('insert into logs_factions (nick,serial,text,date,type) values(?,?,?,now(),?)', nick, serial, text, typ)
	elseif type == 'bankomat' then
		outputChatBox('ERROR: Zgłoś to koniecznie do administratora!', player)
	end
end
