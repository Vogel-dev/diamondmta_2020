--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local db = exports['dmta_base_connect']
local noti = exports['dmta_base_notifications']
local duty = exports['dmta_base_duty']

-- db_punishments, etc

function getVehiclePositionFromID(id)
    local pos = {0,0,0}
    for i,v in ipairs(getElementsByType('vehicle')) do
        local _id = getElementData(v, 'vehicle:id')
        if _id and _id == id then
            pos = {getElementPosition(v)}
            break
        end
    end
    return pos
end

addEvent('change:date', true)
addEventHandler('change:date', resourceRoot, function(date)
	local login, password, mail, last, new = unpack(date)
	local q = db:query('select * from db_users where login=? limit 1', getPlayerName(client))
	if not q or #q < 1 then return end
		
	--login
	if login and last ~= getPlayerName(client) then
		noti:addNotification(client, 'Wprowadzony login nie jest poprawny.', 'error')
		return
	elseif login and new == getPlayerName(client) then
		noti:addNotification(client, 'Wprowadzony login jest aktualny.', 'error')
		return
	elseif login then
		local q = db:query('select * from db_users where login=? limit 1', new)
		if q and #q > 0 then
			noti:addNotification(client, 'Podany login jest już zajęty.', 'error')	
		else
			db:query('update db_users set login=? where login=? limit 1', new, getPlayerName(client))
			setPlayerName(client, new)
			noti:addNotification(client, 'Zmieniłeś swój login z: '..last..', na: '..new, 'success')
		end
		return
	--haslo
	elseif password and not passwordVerify(last, q[1]['password']) then
		noti:addNotification(client, 'Wprowadzone hasło nie jest poprawne.', 'error')
		return
	elseif password and passwordVerify(new, q[1]['password']) then
		noti:addNotification(client, 'Wprowadzone hasło jest aktualne.', 'error')
		return
	elseif password then
		db:query('update db_users set password=? where login=? limit 1', passwordHash(new, 'bcrypt', {}), getPlayerName(client))
		noti:addNotification(client, 'Zmieniłeś swoje hasło z: '..last..', na: '..new, 'success')
	--mail
	elseif mail and last ~= q[1]['email'] then
		noti:addNotification(client, 'Wprowadzony e-mail nie jest poprawny.', 'error')
		return
	elseif mail and new == q[1]['email'] then
		noti:addNotification(client, 'Wprowadzony e-mail jest aktualny.', 'error')
		return
	elseif mail then
		local q = db:query('select * from db_users where email=? limit 1', new)
		if q and #q > 0 then
			noti:addNotification(client, 'Podany e-mail jest już zajęty.', 'error')	
		else
			db:query('update db_users set email=? where login=? limit 1', new, getPlayerName(client))
			noti:addNotification(client, 'Zmieniłeś swój e-mail z: '..last..', na: '..new, 'success')
		end
		return
	end
end)

function awards(is)
    --mysql query
    local db_punishments = db:query('select * from db_punishments where nick=?', getPlayerName(client))
    local houses = db:query('select * from db_houses where wlasciciel_nick=?', getPlayerName(client))
    local db_vehicles = db:query('select * from db_vehicles where ownerName=?', getPlayerName(client))

    local user = db:query('select * from db_users where login=?', getPlayerName(client))

    local achievements = getElementData(client, 'user:achievements') or {}
    local mandates = fromJSON(user[1]['mandates']) or {}
    local pj = {user[1]['prawkoA'], user[1]['prawkoB'], user[1]['prawkoC'], user[1]['prawkoL'], user[1]['licencjaR'], user[1]['licencjaB']}
    local bank_money = user[1]['bank_money']
    local mail = user[1].email

    local db_diamond_exchange = db:query('select * from db_diamond_exchange')

    local vehs = {}
    local hses = {}
    local krs = {}
    local achv = {}
	local mds = {}

    --db_punishments
    for i,v in ipairs(db_punishments) do
        local type = v['type'] == 'ban' and 'Blokada globalna' or v['type'] == 'mute' and 'Wyciszenie lokalne' or v['type'] == 'pj' and 'Zawieszenie prawa jazdy' or v['type'] == 'aj' and 'Admin Jail'
        table.insert(krs, {'prawko', type, 'Powód: '..v['reason']..', nadane przez: '..v['admin'], {v['active'] == 1 and '#69bcebAktywne do:#ffffff\n'..string.sub(v['date'], 1, 16), 'Nie aktywne'}, (v['active'] == 0 and true or false)})
    end
    --

    --osiagniecia
    for i,v in ipairs(achievements) do
        table.insert(achv, {v['name'], v['date']})
    end
    --

    --db_houses
    for i,v in ipairs(houses) do
        local pos = split(v['wejscie'], ',')
        table.insert(hses, {'house', v['nazwa'], 'ID: '..v['id']..', Lokalizacja: '..(getZoneName(pos[1], pos[2], pos[3], false)..', '..getZoneName(pos[1], pos[2], pos[3], true))})
    end
    --

    --pojazdy
    for i,v in ipairs(db_vehicles) do
        local pos = getVehiclePositionFromID(v['id'])
        table.insert(vehs, {'car', getVehicleNameFromModel(v['model']), 'ID: '..v['id']..', Pojemność: '..string.format('%.1f', v['engine'])..'dm³'..', Lokalizacja: '..(v['parking'] == 1 and 'Parking strzeżony' or v['garage'] ~= 0 and 'Garaż' or (getZoneName(pos[1], pos[2], pos[3], false)..', '..getZoneName(pos[1], pos[2], pos[3], true)))})
    end
    --
		
	--mandaty
	for i,v in ipairs(mandates) do
		table.insert(mds, {'car', 'Mandat', 'Powód: '..v['reason']..', nick policjanta: '..v['nick']..', data nadania: '..v['date']..', koszt: '..v['cost']..'$'})	
	end
	--

    --table
    local awards = {
        {name='Kary',table=krs},
        {name='Nieruchomości',table=hses},
        {name='Pojazdy',table=vehs},
        {name='Osiągnięcia',table=achv},
        {name='Mandaty',table=mds},
    }

    --trigger
    triggerClientEvent((not is and client or root), 'playerAwards', resourceRoot, awards, pj, bank_money, db_diamond_exchange, mail)
end
addEvent('getPlayerAwards', true)
addEventHandler('getPlayerAwards', resourceRoot, awards)

-- gielda premium

addEvent('premium:action', true)
addEventHandler('premium:action', resourceRoot, function(action, row_1, row_2, row_3)
    if not row_1 or not row_2 or not row_3 then return end

    local points = getElementData(client, 'user:premiumPoints') or 0
    if action == 'usun' and row_1 == getPlayerName(client) then
        local q = db:query('select * from db_diamond_exchange where nick=?', getPlayerName(client))
        if q and #q > 0 then
            setElementData(client, 'user:premiumPoints', points + q[1]['points'])
            db:query('delete from db_diamond_exchange where nick=?', getPlayerName(client))
            noti:addNotification(client, 'Usunąłeś swoje ogłoszenie.', 'success')
            awards(true)
        end
    elseif action == 'kup' and row_1 ~= getPlayerName(client) then
        local money = getPlayerMoney(client)
        local cost = string.sub(row_2, 1, string.len(row_2) - 1)
        if money >= tonumber(cost) then
            setElementData(client, 'user:premiumPoints', points + tonumber(row_3))
            noti:addNotification(client, 'Zakupiłeś '..row_3..' punktów diamond, od gracza '..row_1..' za cene '..cost..'$', 'success')
            takePlayerMoney(client, cost)
            db:query('delete from db_diamond_exchange where nick=?', row_1)
            db:query('update db_users set money=? where login=?', getPlayerMoney(client), getPlayerName(client))
            awards(true)
            local text_log = 'DIAMOND/KUPNO> '..getPlayerName(client)..' '..row_3..' punktów diamond, od gracza '..row_1..' za cene '..cost..'$'
		    -- duty:addLogsDuty(text_log)
		    duty:addLogs('diamond', text_log, client, 'DIAMOND/KUPNO')

            local player = getPlayerFromName(row_1)
            if player then
                givePlayerMoney(player, cost)
                db:query('update db_users set money=? where login=?', getPlayerMoney(player), row_1)
                --noti:addNotification(player, getPlayerName(client)..' zakupił od ciebie, '..row_3..' punktów diamond za cene '..cost..'$', 'info')
            else
                db:query('update db_users set money=money+? where login=?', cost, row_1)
            end
        else
            noti:addNotification(client, 'Brak wystarczających funduszy.', 'error')
        end
    elseif action == 'wystaw' then
        if not tonumber(row_1) or not tonumber(row_2) then return else row_1 = tonumber(row_1) row_2 = tonumber(row_2) end

        local q = db:query('select * from db_diamond_exchange where nick=?', getPlayerName(client))
        if q and #q > 0 then
            noti:addNotification(client, 'Możesz wystawić maksymalnie jedno ogłoszenie.', 'error')
        else
            if row_1 < 10 or row_2 < 9999999999 then
                --noti:addNotification(client, 'Możesz wystawić minimum 1 punkt, o minimalnej cenie 100$.', 'info')
            else
                if row_1 <= points then
                    noti:addNotification(client, 'Wystawiłeś '..row_1..' punktów diamond za cene '..row_2..'$', 'success')
                    setElementData(client, 'user:premiumPoints', points - row_1)
                    local text_log = 'DIAMOND/WYSTAWIL> '..getPlayerName(client)..' '..row_1..' punktów diamond za cene '..row_2..'$'
		           -- duty:addLogsDuty(text_log)
		            duty:addLogs('diamond', text_log, client, 'DIAMOND/WYSTAWIL')
                    db:query('insert into db_diamond_exchange (nick,points,cost) values (?,?,?)', getPlayerName(client), row_1, row_2)
                    awards(true)
                else
                    noti:addNotification(client, 'Nie posiadasz tyle punktów diamond.', 'error')
                end
            end
        end
    end
end)

function isPlayerHavePremium(player)
    local q = db:query('select * from db_users where login=? and premium_date>now()', getPlayerName(player))
    if q and #q > 0 then
        return true
    end
    return false
end

function updatePremium(player, days)
    local havePremium = isPlayerHavePremium(player)
    if havePremium then
        db:query('update db_users set premium_date=premium_date+interval ? day where login=?', days, getPlayerName(player))
    else
        db:query('update db_users set premium_date=now()+interval ? day where login=?', days, getPlayerName(player))
    end
end

addEvent('buy:premium', true)
addEventHandler('buy:premium', resourceRoot, function(data)
    if not data then return end
    local points = getElementData(client, 'user:premiumPoints') or 0
    if points >= data.points then
        setElementData(client, 'user:premiumPoints', points - data.points)
        updatePremium(client, data.days)
        noti:addNotification(client, 'Zakupiłeś usługę diamond na '..data.days..' dni za '..data.points..' punktów diamond.', 'success')
        local text_log = 'KUPNO/DNI> '..getPlayerName(client)..' zakupił usługę diamond na '..data.days..' dni za '..data.points..' punktów diamond.'
		duty:addLogsDuty(text_log)
		duty:addLogs('diamond', text_log, client, 'KUPNO/DNI')

        local q = db:query('select * from db_users where login=? and premium_date>now()', getPlayerName(client))
        if q and #q > 0 then
            setElementData(client, 'user:premium', true)
            setElementData(client, 'user:premiumDate', q[1]['premium_date'])
        end
    else
        noti:addNotification(client, 'Nie posiadasz wystarczających punktów, aby zakupić tą usługę.', 'error')
    end
end)

addEvent('buy:points', true)
addEventHandler('buy:points', resourceRoot, function(code)
    fetchRemote('http://microsms.pl/api/v2/multi.php?userid=4619&code='..code..'&serviceid=5212', getPremium, '', false, client)
end)

function getPremium(json, error, player)
    if error ~= 0 then return end

    local table = fromJSON(json)
    local points = 0
    local myPoints = getElementData(player, 'user:premiumPoints') or 0

    for i,v in pairs(table) do
        if v.status and tonumber(v.status) and tonumber(v.status) == 1 then
            if v.number and tonumber(v.number) and tonumber(v.number) == 71480 then
                points = 10
                break
            elseif v.number and tonumber(v.number) and tonumber(v.number) == 74480 then
                points = 50
                break
            elseif v.number and tonumber(v.number) and tonumber(v.number) == 76480 then
                points = 100
                break
            elseif v.number and tonumber(v.number) and tonumber(v.number) == 79480 then
                points = 200
                break
            elseif v.number and tonumber(v.number) and tonumber(v.number) == 91400 then
                points = 300
                break
            end
        else
            noti:addNotification(player, 'Podany kod jest nieprawidłowy.', 'error')
            break
        end
    end

    if points > 0 then
        setElementData(player, 'user:premiumPoints', myPoints + points)
        noti:addNotification(player, 'Pomyślnie zakupiłeś '..points..' punktów diamond.', 'success')
        local text_log = 'KUPNO/PUNKTY> '..getPlayerName(player)..' zakupił '..points..' punktów diamond.'
		duty:addLogsDuty(text_log)
		duty:addLogs('diamond', text_log, player, 'KUPNO/PUNKTY')
    end
end

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

addCommandHandler("give.diamond", function(gracz, _, kgracz, dni)
    if getElementData(gracz, "rank:duty") ~= 4 then return end
    if not kgracz or not dni then return end
    local target = findPlayer(gracz, kgracz)
    if not target then return end
    setElementData(target, "user:premium", true)
    setElementData(target, "premium_czas", 0)
    updatePremium(target, dni)
    outputChatBox("#00ff00● #969696"..getPlayerName(gracz).." #ffffffnadał Ci konto diamond na #969696"..dni.." dni.", target, 255, 255, 255, true)
    outputChatBox("#00ff00● #ffffffPomyślnie nadałeś konto diamond dla gracza #969696"..getPlayerName(target).." #ffffffna #969696"..dni.." dni.", gracz, 255, 255, 255, true)
end)

addCommandHandler("give.dp", function(gracz, _, kgracz, dni)
    if getElementData(gracz, "rank:duty") ~= 4 then return end
    if not kgracz or not dni then return end
    local target = findPlayer(gracz, kgracz)
    if not target then return end
    setElementData(target, "user:premiumPoints", (getElementData(target, "user:premiumPoints") or 0)+tonumber(dni))
    outputChatBox("#00ff00● #969696"..getPlayerName(gracz).." #ffffffpodarował Ci #969696"..dni.." DiamondPoints.", target, 255, 255, 255, true)
    outputChatBox("#00ff00● #ffffffPomyślnie nadałeś graczu #969696"..getPlayerName(target).." #ffffffDiamondPoints w ilości #969696"..dni..".", gracz, 255, 255, 255, true)
end)