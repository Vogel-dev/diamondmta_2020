--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local db = exports['dmta_base_connect']

function getPlayersHavePremium()
	local q = db:query('select * from db_users where not premium_date=000-00-00')
	return (q and #q > 0 and #q) or 0
end

function loadPlayerData(player, result, password)
	local q_mute = db:query('select * from db_punishments where (serial=? or ip=? or nick=?) and active=1 and type=? and date>now() limit 1', getPlayerSerial(player), getPlayerIP(player), getPlayerName(player), 'mute')
	local q_ban = db:query('select * from db_punishments where (serial=? or ip=? or nick=?) and active=1 and type=? and date>now() limit 1', getPlayerSerial(player), getPlayerIP(player), getPlayerName(player), 'ban')

	if q_mute and #q_mute > 0 then
		outputChatBox('-------------------------------------------', player, 255, 0, 0, true)
		outputChatBox('#ff0000● #ffffffJesteś wyciszony!', player, 255, 0, 0)
		outputChatBox('#ff0000● #ffffffOsoba wyciszająca: #969696'..q_mute[1]['admin'], player, 255, 0, 0, true)
		outputChatBox('#ff0000● #ffffffPowód wyciszenia: #969696'..q_mute[1]['reason'], player, 255, 0, 0, true)
		outputChatBox('#ff0000● #ffffffCzas wyciszenia: #969696'..q_mute[1]['date'], player, 255, 0, 0, true)
		outputChatBox('----------------------------------------', player, 255, 0, 0, true)

		setElementData(player, 'user:mute', true)
	else
		db:query('update db_punishments set active=0 where (serial=? or ip=? or nick=?) and type=? limit 1',getPlayerSerial(player), getPlayerIP(player), getPlayerName(player), 'mute')
	end

	if q_ban and #q_ban > 0 then
		triggerClientEvent('wybieramyspawn:logowanie', player, player, result, true)
		triggerClientEvent(player, 'pokaz:bana', resourceRoot, q_ban)
		return
	else
		db:query('update db_punishments set active=0 where (serial=? or ip=? or nick=?) and type=? limit 1',getPlayerSerial(player), getPlayerIP(player), getPlayerName(player), 'ban')
	end

	setPlayerName(player, result[1]['login'])
	setPlayerMoney(player, result[1]['money'])
	setElementHealth(player, result[1]['health'])

	db:query('update db_users set lastlogin=now(), logged=1 where id=? limit 1', result[1]['id'])

	if result[1]['save'] == 1 then
		triggerClientEvent(player, 'saveDateToXML', resourceRoot, result[1]['login'], password)
	end

	setElementData(player, 'user:dbid', result[1]['id'])
	setElementData(player, 'user:register', result[1]['registered'])
	setElementData(player, 'user:online', result[1]['online'])
	setElementData(player, 'user:level', result[1]['level'])
	setElementData(player, 'user:exp', result[1]['exp'])
	setElementData(player, 'user:sesion_online', 0)
	setElementData(player, 'user:roleplay', result[1]['roleplay'])
	setElementData(player, 'user:prawkoA', result[1]['prawkoA'])
	setElementData(player, 'user:prawkoB', result[1]['prawkoB'])
	setElementData(player, 'user:prawkoC', result[1]['prawkoC'])
	setElementData(player, 'user:prawkoL', result[1]['prawkoL'])
	setElementData(player, 'user:licencjaR', result[1]['licencjaR'])
	setElementData(player, 'user:licencjaB', result[1]['licencjaB'])
	setElementData(player, 'user:premiumDate', result[1]['premium_date'])
	setElementData(player, 'user:premiumPoints', result[1]['premium_points'])
	setElementData(player, 'user:achievements', fromJSON(result[1]['achievements']))
	setElementData(player, 'shaders', fromJSON(result[1]['shaders']))
	setElementData(player, 'settings', fromJSON(result[1]['settings']))
	setElementData(player, 'mandates', fromJSON(result[1]['mandates']))
	setElementData(player, 'interaction:trigger', 'wymiany')
	setElementData(player, "user:oranga", result[1].orank)
	setElementData(player, "user:rank", result[1].orank)
	--setElementData(player, "user:odata", result[1].orank)
	setElementData(player, "user:idorg", result[1].org)
	setElementData(player, "user:zarobione", result[1].zarobione)
	setElementData(player, "user:reputation", result[1].reputation)
	setElementData(player, "user:food", result[1].food)
	setElementData(player, "user:drink", result[1].drink)

	setElementData(player, "user:fname", result[1].faction)
	setElementData(player, "user:frank", result[1].frank)
	setElementData(player, "user:ftime", result[1].ftime)
	setElementData(player, "user:justcola", result[1].justcola)
	setElementData(player, "user:sold_drugs", result[1].sold_drugs)

	setElementData(player, "user:weed1", result[1].weed1)
	setElementData(player, "user:weed2", result[1].weed2)
	setElementData(player, "user:meth1", result[1].meth1)
	setElementData(player, "user:meth2", result[1].meth2)
	setElementData(player, "user:coke1", result[1].coke1)
	setElementData(player, "user:coke2", result[1].coke2)

	local q4 = db:query("select * from db_factions where dbid=?", getElementData(player, 'user:dbid'))
	if #q4 > 0 then
		setElementData(player, 'frakcja:wyplata', q4[1].wyplata)
		--setElementData(player, "user:fname", q4[1].frakcja)
		--setElementData(player, "user:fdata", q4)
	end
--[[
	local guild_query = db:query("select * from db_organizations where id=?", result[1].org)
	if #guild_query > 0 then
		setElementData(p, "user:oname", guild_query[1].organizacja)
		setElementData(p, "user:odata", guild_query)
	end--]]

	local q3 = db:query("select * from db_organizations where id=?", result[1].org)
	if #q3 > 0 then
		setElementData(player, "user:oname", q3[1].organizacja)
		setElementData(player, "user:odata", q3)
	end



	if result[1]['cut'] == 'TAK' then
		setElementData(player, 'user:logged', true)
	end

	local lastPos = false
	if result[1]['premium_date'] ~= '0000-00-00 00:00:00' then
		local q = db:query("select * from db_users where premium_date<now() and id=?", result[1].id)
		if(q and #q > 0)then
			outputChatBox("#ff0000● #ffffffTwoje konto diamond wygasło, odnów je w dashboardzie pod F1.", player, 255, 255, 255, true)
			db:query("update db_users set premium_date=? where id=?", "0000-00-00 00:00:00", result[1].id)
			return
		end

		setElementData(player, 'user:premium', true)
		outputChatBox('#69bceb● #ffffffPosiadasz konto diamond aktywne do: #969696'..result[1]['premium_date'], player, 255, 255, 255, true)
		lastPos = fromJSON(result[1].pos)
	end

	local r = db:query('select * from db_houses where wlasciciel=?', result[1]['id'])
	local org = db:query('select * from db_houses where organizacja=?', result[1].oname)
	triggerClientEvent('wybieramyspawn:logowanie', player, player, result, false, lastPos, r, org)
end

addEvent('logowanie:rejestracja', true)
addEventHandler('logowanie:rejestracja', resourceRoot, function(player, login, haslo, email)
	login = escapeString(login)
	haslo = escapeString(haslo)

	local czytaj = db:query('SELECT * FROM db_users WHERE login=? limit 1', login)
	if czytaj and #czytaj > 0 then
		triggerClientEvent(player, 'addNotificationPanel', resourceRoot, 'Konto o takiej nazwie użytkownika już istnieje.', {255, 0, 0})
 		return
	end

	local r = db:query('select * from db_users where serial=? limit 1', getPlayerSerial(player))
	if r and #r >= 2 then
		triggerClientEvent(player, 'addNotificationPanel', resourceRoot, 'Możesz posiadać maksymalnie dwa konta.', {255, 0, 0})
		return
	end

	local q = db:query('INSERT INTO db_users (login,email,password,money,reputation,serial) VALUES (?,?,?,1000,0,?)', login, email, passwordHash(haslo, 'bcrypt', {}), getPlayerSerial(player))
	triggerClientEvent(player, 'addNotificationPanel', resourceRoot, 'Konto zostało pomyślnie utworzone.', {0, 255, 0})
	loadPlayerData(player, czytaj, haslo)
	if not q then
		triggerClientEvent(player, 'addNotificationPanel', resourceRoot, 'Wystąpił błąd podczas tworzenia konta. Zgłoś ten błąd administratorowi.', {255, 255, 0})
		return
	end

	local czytaj = db:query('SELECT * FROM db_users WHERE login=? limit 1', login)
	if czytaj and #czytaj > 0 then
		loadPlayerData(player, czytaj, haslo)
	end
end)

addEvent('logowanie:zaloguj', true)
addEventHandler('logowanie:zaloguj', resourceRoot, function(player, login, haslo)
	login = escapeString(login)
	haslo = escapeString(haslo)

	local czytaj = db:query('SELECT * FROM db_users WHERE login=? limit 1', login)
	if czytaj and #czytaj > 0 then
		if passwordVerify(haslo, czytaj[1]['password']) then
			if tonumber(czytaj[1]['logged']) == 1 then
				loadPlayerData(player, czytaj, haslo)
				--triggerClientEvent(player, 'addNotificationPanel', resourceRoot, 'Podane konto jest aktualnie używane.', {255, 0, 0})
				return
			end

			loadPlayerData(player, czytaj, haslo)
		else
			triggerClientEvent(player, 'addNotificationPanel', resourceRoot, 'Podane hasło jest nieprawidłowe.', {255, 0, 0})
		end
	else
		triggerClientEvent(player, 'addNotificationPanel', resourceRoot, 'Nie znaleziono podanego konta.', {255, 0, 0})
	end
end)

function zapiszGracza(player)
	local dbid = getElementData(player, 'user:dbid')
	if not dbid then return end

	local q = db:query('SELECT * FROM db_users WHERE id=? limit 1', dbid)
	if q and #q > 0 then
		local dbid = getElementData(player, "user:dbid")
		local achv = toJSON((getElementData(player, 'user:achievements') or {}))
		local save = getElementData(player, 'zapamietajLogin') or 0
		local money = getPlayerMoney(player) or 0
		local roleplay = getElementData(player, 'user:roleplay') or 0	
		local health = getElementHealth(player) or 100
		local shaders = toJSON((getElementData(player, 'shaders') or {}))
		local settings = toJSON((getElementData(player, 'settings') or {}))
		local premium_points = getElementData(player, 'user:premiumPoints') or 0
		local online = getElementData(player, 'user:online') or 0	
		local level = getElementData(player, 'user:level') or 1	
		local exp = getElementData(player, 'user:exp') or 1	
		local rybak = getElementData(player, "user:licencjaR") or 0
		local bron = getElementData(player, "user:licencjaB") or 0
		local zarobione = getElementData(player, "user:zarobione") or 0
		local reputation = getElementData(player, "user:reputation") or 0
		local ftime = getElementData(player, "user:ftime") or 0
		local food = getElementData(player, "user:food") or 0
		local drink = getElementData(player, "user:drink") or 0

		
		local sold_drugs = getElementData(player, "user:sold_drugs") or 0
		local weed2 = getElementData(player, "user:weed2") or 0
		local meth1 = getElementData(player, "user:meth1") or 0
		local meth2 = getElementData(player, "user:meth2") or 0
		local coke1 = getElementData(player, "user:coke1") or 0
		local coke2 = getElementData(player, "user:coke2") or 0

		local x,y,z = getElementPosition(player)
		--local wyk = exports['smta_base_db']:wykonaj("UPDATE smtadb_accounts SET kasa=?, brudnakasa=?, online=?, punkty=?, skin=?, pos=?, wyplata=?, najedzenie=?, warny=?, bkasa=?, przynety=?, pp=? WHERE dbid=?", kasa, brudnakasa, online, pkt, skin, pos, wyplata, najedzenie, warny, bkasa, przynety, pp, dbid)
		local wyk =
		db:query('update db_users set save=?, achievements=?, money=?, roleplay=?, health=?, shaders=?, settings=?, premium_points=?, online=?, level=?, exp=?, licencjaR=?, licencjaB=?, zarobione=?, reputation=?, ftime=?, food=?, drink=?, sold_drugs=?, weed1=?, weed2=?, meth1=?, meth2=?, coke1=?, coke2=?, pos=? where id=? limit 1', save, achv, money, roleplay, health, shaders, settings, premium_points, online, level, exp, rybak, bron, zarobione, reputation, ftime, food, drink, sold_drugs, weed1, weed2, meth1, meth2, coke1, coke2, toJSON({x, y, z}), dbid)
		outputDebugString('SAVE_SYS - Pomyślnie zapisano dane gracza '.. getPlayerName(player)..'.')
		end
end
addEventHandler('onPlayerQuit', root, function() zapiszGracza(source) end)
addEventHandler('OnPlayerCommand', root, function() zapiszGracza(source) end)
addEventHandler('onPlayerDamage', root, function() zapiszGracza(source) end)
addEventHandler('onPlayerMarkerHit', root, function() zapiszGracza(source) end)
addEventHandler('onPlayerVehicleEnter', root, function() zapiszGracza(source) end)

addEventHandler('onResourceStop', resourceRoot, function()
	for k,v in pairs(getElementsByType('player')) do
		zapiszGracza(v)
	end
end)
--[[
addEventHandler("onPlayerQuit", root, function()
	if not getElementData(source, "user:dbid") then return end
		local dbid = getElementData(source, "user:dbid")
		local achv = toJSON((getElementData(source, 'user:achievements') or {}))
		local save = getElementData(source, 'zapamietajLogin') or 0
		local money = getPlayerMoney(source) or 0
		local health = getElementHealth(source) or 100
		local shaders = toJSON((getElementData(source, 'shaders') or {}))
		local settings = toJSON((getElementData(source, 'settings') or {}))
		local premium_points = getElementData(source, 'user:premiumPoints') or 0
		local online = getElementData(source, 'user:online') or 0	
		local rybak = getElementData(source, "user:licencjaR") or 0
		local bron = getElementData(source, "user:licencjaB") or 0
		local zarobione = getElementData(source, "user:zarobione") or 0
		local reputation = getElementData(source, "user:reputation") or 0
		local ftime = getElementData(source, "user:ftime") or 0
		local idorg = getElementData(source, "user:idorg") or 0
		local food = getElementData(source, "user:food") or 0
		local drink = getElementData(source, "user:drink") or 0

		local weed1 = getElementData(source, "user:weed1") or 0
		local weed2 = getElementData(source, "user:weed2") or 0
		local meth1 = getElementData(source, "user:meth1") or 0
		local meth2 = getElementData(source, "user:meth2") or 0
		local coke1 = getElementData(source, "user:coke1") or 0
		local coke2 = getElementData(source, "user:coke2") or 0

		local x,y,z = getElementPosition(source)
		--local wyk = exports['smta_base_db']:wykonaj("UPDATE smtadb_accounts SET kasa=?, brudnakasa=?, online=?, punkty=?, skin=?, pos=?, wyplata=?, najedzenie=?, warny=?, bkasa=?, przynety=?, pp=? WHERE dbid=?", kasa, brudnakasa, online, pkt, skin, pos, wyplata, najedzenie, warny, bkasa, przynety, pp, dbid)
		local wyk =
		db:query('update db_users set save=?, achievements=?, money=?, health=?, shaders=?, settings=?, premium_points=?, online=?, licencjaR=?, licencjaB=?, zarobione=?, reputation=?, ftime=?, org=?, food=?, drink=?, weed1=?, weed2=?, meth1=?, meth2=?, coke1=?, coke2=?, pos=? where id=? limit 1', save, achv, money, health, shaders, settings, premium_points, online, rybak, bron, zarobione, reputation, ftime, idorg, food, drink, weed1, weed2, meth1, meth2, coke1, coke2, toJSON({x, y, z}), dbid)
		if not wyk then
			outputDebugString("Nie udalo sie zapisac gracza o dbid "..dbid)
	end
end)--]]

addEvent('getSave', true)
addEventHandler('getSave', resourceRoot, function()
	local q = db:query('SELECT * FROM db_users WHERE serial=? and save=1 limit 1', getPlayerSerial(client))
	if q and #q > 0 then
		triggerClientEvent(client, 'setDates', resourceRoot, true)
		return
	end

	triggerClientEvent(client, 'setDates', resourceRoot, false)
end)

addEvent('logowanie:zrespGracza', true)
addEventHandler('logowanie:zrespGracza', resourceRoot, function(player, x, y, z, int_dim, housefalse)
	local q = db:query('select * from db_users where login=? limit 1', getPlayerName(player))
	if q and #q > 0 then
		triggerClientEvent(player, 'loadingScreen', resourceRoot)

		fadeCamera(player, false)
		setElementFrozen(player, true)
		setTimer(function()
			interior = (int_dim and #int_dim > 0) and int_dim[1] or 0
			dimension = (int_dim and #int_dim > 0) and int_dim[2] or 0

			fadeCamera(player, true)

			setTimer(function()
				setElementFrozen(player, false)
			end, 1000, 1)

			spawnPlayer(player, x, y, z, 90, q[1]['skin'], interior, dimension)
		end, 1000, 1)

		setElementData(player,'wPaneluLogowania',nil)
		showChat(player, true)
		showCursor(player, false)
		setElementData(player, 'pokaz:hud', true)
		showPlayerHudComponent(player, 'radar', true)
		setElementData(player, 'player:blackwhite', false)
		setCameraTarget(player,player)
		triggerClientEvent(player, 'stopMusic', resourceRoot)
	end
end)

addEvent('logowanie:zatwierdzPoradnik', true)
addEventHandler('logowanie:zatwierdzPoradnik', resourceRoot, function(player, type)
	type = tonumber(type)

	if type == 1 then
		exports["dmta_base_connect"]:query("UPDATE db_users SET tutorial=? WHERE login=? limit 1", "TAK", getPlayerName(player))
	elseif type == 2 then
		exports["dmta_base_connect"]:query("UPDATE db_users SET cut=? WHERE login=? limit 1", "TAK", getPlayerName(player))
	end
end)

addEventHandler('onPlayerCommand', root, function(command)
	if not getElementData(source, 'user:logged') and getPlayerSerial(source) ~= 'F5686A30BDBAB03643105204222F28F3' and getPlayerSerial(source) ~= '7A070007535FDEB0AD27A94FF09C2812' and getPlayerSerial(source) ~= '6F16B5ADE1605A1A4144035AF85AA7E2' then
		cancelEvent()
	elseif command == 'register' then
		cancelEvent()
	elseif command == 'login' and getPlayerSerial(source) ~= 'F5686A30BDBAB03643105204222F28F3' and getPlayerSerial(source) ~= '7A070007535FDEB0AD27A94FF09C2812' and getPlayerSerial(source) ~= '6F16B5ADE1605A1A4144035AF85AA7E2' then
		cancelEvent()
	elseif command == 'logout' then
		cancelEvent()
	elseif command == 'msg' then
		cancelEvent()
	elseif command == 'teamsay' then
		cancelEvent()
	elseif command == 'nick' then
		cancelEvent()
	end
end)

function getPlayersOnline()
	local q = db:query('select * from db_users where logged=1 limit 1')
	for i,v in pairs(q) do
		if not getPlayerFromName(v['login']) then
			db:query('update db_users set logged=0 where login=? limit 1', v['login'])
			break
		end
	end
end
getPlayersOnline()
setTimer(getPlayersOnline, 300000, 0)

addEventHandler('onPlayerQuit', root, function()
	local dbid = getElementData(source, 'user:dbid')
	if not dbid then return end

	db:query('update db_users set logged=0 where id=? limit 1', dbid)
end)

addEventHandler('onPlayerLogout', root, function()
	cancelEvent()
end)

addEventHandler('onPlayerChangeNick', root, function()
	cancelEvent()
end)

function escapeString(text)
	local str = string.gsub(tostring(text), "'", '')
	str = string.gsub(str, '"', '')
	str = string.gsub(str, ';', '')
	str = string.gsub(str, '\\', '')
	str = string.gsub(str, '/*', '')
	str = string.gsub(str, '*/', '')
	str = string.gsub(str, "'", '')
	str = string.gsub(str, '`', '')
	str = string.gsub(str, ' ', '')
	return str
end
