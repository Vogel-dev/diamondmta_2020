--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local db = exports['dmta_base_connect']
local core = exports['dmta_base_core']
local noti = exports['dmta_base_notifications']
local garaze = exports['dmta_garages']

local houses = {}

addEventHandler('onResourceStart', resourceRoot, function()
	local query = db:query('select * from db_houses')
	for i,v in ipairs(query) do
		if math.random(0,100) <= 100 then
			local result = db:query('select * from db_garages where house_id=? limit 1', v['id'])
			create_house(v, result)
		end
	end

	outputDebugString('DMTA/HOUSES Pomyślnie załadowanych domów: '..#query)
end)

function formatMoney(money)
	while true do
		money, i = string.gsub(money, '^(-?%d+)(%d%d%d)', '%1,%2')
		if i == 0 then
			break
		end
	end
	return money
end

function create_house(v, q)
	if q and #q > 0 and q[1]['places'] then
		v['places'] = q[1]['places']
	else
		v['places'] = false
	end

	local xyz = split(v.wejscie, ',')
	local w = split(v.teleport, ',')

	local id = 0
	if v.wlasciciel == 0 then
		id = 1273
		v.wlasciciel_nick = 'do wynajęcia'
	else
		id = 1272
	end

	local p_wejscie = createPickup(xyz[1], xyz[2], xyz[3], 3, id, 0, 0)
	local wejscie = createColSphere(xyz[1], xyz[2], xyz[3], 1)
	setElementData(wejscie, 'house:info', v)

	local xyz2 = split(v.wyjscie, ',')
	local wyjscie = createMarker(xyz2[1], xyz2[2], xyz2[3]-1, 'cylinder', 1.1, 0, 100, 200, 75)
	setElementData(wyjscie, 'marker:icon', 'door_exit')
	setElementData(wyjscie, 'text', 'Wyjście')
	setElementData(wyjscie, 'xyz', {xyz[1],xyz[2],xyz[3]})
	setElementDimension(wyjscie, (v.id+999))
	setElementInterior(wyjscie, v.interior)
	setElementData(wyjscie, 'house:info', v)

	local text = createElement('text')
	setElementData(text, 'text', v.nazwa..'\n'..v.wlasciciel_nick)
	setElementPosition(text, xyz[1], xyz[2], xyz[3]+0.7)

	table.insert(houses, {p_wejscie=p_wejscie,c_wejscie=wejscie,id=v.id,text=text,xyz={w[1],w[2],w[3]},wyjscie=wyjscie})
end

local interiors = {
	{name='Willa',interior=5,pos={140.34,1366.23,1083.85,140.37,1368.32,1083.86}}, -- 1
	{name='Mieszkanie',interior=8,pos={2365.42,-1135.58,1050.88,2365.23,-1133.36,1050.87}},-- 2
	{name='Dom',interior=4,pos={-260.48,1456.53,1084.36,-262.38,1456.62,1084.36}},-- 3
	{name='Mały dom',interior=8,pos={-42.60,1412.74,1084.42,-42.53,1410.63,1084.42}},-- 4
	{name='Pokój hotelowy',interior=1,pos={2218.06,-1076.21,1050.48,2215.69,-1076.01,1050.48}},-- 5
	{name='Kawalerka',interior=5,pos={2233.68,-1115.25,1050.88,2233.67,-1113.18,1050.88}},-- 6
	{name='Mieszkanie w kamienicy',interior=8,pos={-42.51,1405.57,1084.42,-42.6,1406.96,1084.42}},-- 7
	{name='Lokal organizacji',interior=10,pos={2270.34,-1210.51,1047.56,2264.9,-1210.53,1049.02}},-- 8
}

addCommandHandler('domek', function(player, _, cena, int)
	if getElementData(player, 'rank:duty') and getElementData(player, 'rank:duty') >= 4 and (cena and int) then
		local house_interior = interiors[tonumber(int)]
		if house_interior then
			local x,y,z = getElementPosition(player)

			local wejscie = x..','..y..','..z
			local wyjscie = house_interior['pos'][1]..', '..house_interior['pos'][2]..', '..house_interior['pos'][3]
			local teleport = house_interior['pos'][4]..', '..house_interior['pos'][5]..', '..house_interior['pos'][6]

			db:query('insert into db_houses set wlasciciel=0, wlasciciel_nick=?, nazwa=?, data=?, wejscie=?, wyjscie=?, teleport=?, cena=?, interior=?', '', house_interior['name'], '0000-00-00', wejscie, wyjscie, teleport, cena, house_interior['interior'])
			restartResource(getThisResource())
		end
	end
end)

function search_house(id)
	for i = 1,#houses do
		if houses[i]['id'] == id then
			return houses[i]
		end
	end
	return false
end

function remove_in_table(id)
	for i = 1,#houses do
		if houses[i] and houses[i]['id'] == id then
			table.remove(houses, i)
		end
	end
	return false
end

function remove_house(id)
	local house = search_house(id)
	if house then
		if house['p_wejscie'] and isElement(house['p_wejscie']) then
			destroyElement(house['p_wejscie'])
			destroyElement(house['c_wejscie'])
			destroyElement(house['text'])
			destroyElement(house['wyjscie'])
			remove_in_table(id)
			return true
		end
	end
	return false
end

function auto_refresh_houses()
	local query = db:query('select * from db_houses where data<NOW()')
	if query and #query > 0 then
		for k,v in ipairs(query) do
			local garage = db:query('select * from db_garages where house_id=? limit 1', v['id'])
			if garage and #garage > 0 then
				db:query('update db_vehicles set parking=1, garage=0 where garage=?', garage[1]['id'])
				garaze:refreshGarage(garage[1]['id'])
			end

			db:query('update db_houses set wlasciciel=0, wlasciciel_nick=?, data=?, lokatorzy=?, organizacja=? where id=? limit 1', '', '0000-00-00', '', '', v['id'])
			refresh_house(v['id'])
		end
	end
end
setTimer(auto_refresh_houses, 3600000, 0)

function teleport_home_position(id)
	local house = search_house(id)
	if house then
		return house['xyz']
	end
end

function refresh_house(id)
	local house = search_house(id)
	if house then
		local info = db:query('select * from db_houses where id=? limit 1', id)
		if info and #info > 0 then
			remove_house(id)

			local result = db:query('select * from db_garages where house_id=? limit 1', id)
			create_house(info[1], result)
			return true
		end
	end
	return false
end

addEventHandler('onMarkerHit', resourceRoot, function(hit, dim)
	if not hit or hit and not isElement(hit) or hit and isElement(hit) and getElementType(hit) ~= 'player' or hit and isElement(hit) and getElementType(hit) == 'player' and isPedInVehicle(hit) or not dim then return end

	local info = getElementData(source, 'house:info') 
	if info then
		fadeCamera(hit, false)
		setElementFrozen(hit, true)
		setElementData(hit, 'user:objecting', false)
		setTimer(function()
			if hit and isElement(hit) then
				local pos = split(info['wejscie'], ',')
				setElementPosition(hit, pos[1], pos[2], pos[3])
				setElementInterior(hit, 0)
				setElementDimension(hit, 0)

				setTimer(function()
					if hit and isElement(hit) then
						fadeCamera(hit, true)
						setElementFrozen(hit, false)
					end
				end, 2000, 1)
			end
		end, 1000, 1)
	end
end)

addEventHandler('onColShapeHit', resourceRoot, function(hit, dim)
	if not hit or hit and not isElement(hit) or hit and isElement(hit) and getElementType(hit) ~= 'player' or hit and isElement(hit) and getElementType(hit) == 'player' and isPedInVehicle(hit) or not dim then return end
	
	local info = getElementData(source, 'house:info')
	if not info then return end

	triggerClientEvent(hit, 'window:house', hit, info)
end)

function isLokatorAdded(name, result)
	local player = false
	local lokatorzy = fromJSON(result[1]['lokatorzy']) or {}
	for i,v in ipairs(lokatorzy) do
		if v['name'] == name then
			player = true
			break
		end
	end
	return player
end

addEvent('house:lokator:usun', true)
addEventHandler('house:lokator:usun', resourceRoot, function(player, id, nick)
	local r = db:query('select * from db_houses where id=? limit 1', id)
	if r and #r > 0 then
		local lokatorzy = fromJSON(r[1]['lokatorzy']) or {}
		for i,v in ipairs(lokatorzy) do
			if v['name'] == nick then
				table.remove(lokatorzy, i)
				db:query('update db_houses set lokatorzy=? where id=? limit 1', toJSON(lokatorzy), id)
				outputChatBox("#69bceb● #ffffffPomyślnie usunięto lokatora.", player, 255, 255, 255, true)
				refresh_house(id)
				break
			end
		end
	end
end)

addEvent('house:lokator:dodaj', true)
addEventHandler('house:lokator:dodaj', resourceRoot, function(player, id, text)
	local r = db:query('select * from db_houses where id=? limit 1', id)
	if r and #r > 0 then
		local toPlayer = core:findPlayer(text)
		local players = fromJSON(r[1]['lokatorzy']) or {}
		if #players >= 3 then
			outputChatBox("#ff0000● #ffffffMożesz dodać maksymalnie 3 lokatorów.", player, 255, 255, 255, true)
			return
		elseif not toPlayer then
			outputChatBox("#ff0000● #ffffffNie znaleziono podanego gracza.", player, 255, 255, 255, true)
			return
		elseif player == toPlayer then
			outputChatBox("#ff0000● #ffffffNie możesz dodać siebie jako lokatora.", player, 255, 255, 255, true)
			return
		elseif isLokatorAdded(getPlayerName(player), r) then
			outputChatBox("#ff0000● #ffffffTen gracz jest już lokatorem.", player, 255, 255, 255, true)
			return
		else
			local x,y,z = getElementPosition(player)
			local rx,ry,rz = getElementPosition(toPlayer)
			local distance = getDistanceBetweenPoints3D(rx, ry, rz, x, y, z)
			if distance > 20 then
				outputChatBox("#ff0000● #ffffffPodany gracz znajduje się zbyt daleko od domu.", player, 255, 255, 255, true)
			else
				outputChatBox("#ff0000● #ffffffWysłano prośbę do gracza: "..getPlayerName(toPlayer).."", player, 255, 255, 255, true)
				triggerClientEvent(toPlayer, 'send:lokator', resourceRoot, id, player)
			end
		end
	end
end)

addEvent('house:add:lokator', true)
addEventHandler('house:add:lokator', resourceRoot, function(id, player, text, type)
	if type == 'cancel' then
		noti:addNotification(player, text, 'info')
	elseif type == 'accept' then
		local r = db:query('select * from db_houses where id=? limit 1', id)
		if r and #r > 0 then
			local players = fromJSON(r[1]['lokatorzy']) or {}
			table.insert(players, {name=getPlayerName(client),dbid=getElementData(client, 'user:dbid')})
			db:query('update db_houses set lokatorzy=? where id=? limit 1', toJSON(players), id)
			outputChatBox("#00ff00● #969696"..getPlayerName(client).." #ffffffzaakceptował prośbę o dodanie jako lokatora", player, 255, 255, 255, true)
			refresh_house(id)
		end
	end
end)

addEvent('organizacja', true)
addEventHandler('organizacja', resourceRoot, function(btn)
	local organization = getElementData(client, 'user:oname')
	if organization then
		if btn == 'Przepisz na organizacje' then
			db:query('update db_houses set organizacja=? where id=? limit 1', organization, id)
		elseif btn == 'Wypisz z organizacji' then
			db:query('update db_houses set organizacja=? where id=? limit 1', '', id)
		end
	else
		outputChatBox("#ff0000● #ffffffNie posiadasz organizacji.", client, 255, 255, 255, true)
	end
end)

addEvent('house:zamek', true)
addEventHandler('house:zamek', resourceRoot, function(player, id)
	local info = db:query('select * from db_houses where id=? limit 1', id)
	if info and #info > 0 then
		if info[1].zamek == 0 then
			outputChatBox("#69bceb● #ffffffZamknąłeś zamek w domku.", player, 255, 255, 255, true)
			db:query('update db_houses set zamek=1 where id=? limit 1', id)
			refresh_house(id)
		else
			outputChatBox("#69bceb● #ffffffOtworzyłeś zamek w domku.", player, 255, 255, 255, true)
			db:query('update db_houses set zamek=0 where id=? limit 1', id)
			refresh_house(id)
		end
	end
end)

addEvent('tpto:house', true)
addEventHandler('tpto:house', resourceRoot, function(player, info)
	local hit = player
	if info then
		local q = db:query('select * from db_houses where id=? limit 1', info['id'])
		if q[1].zamek == 0 then
			fadeCamera(hit, false)
			setElementFrozen(hit, true)
			setTimer(function()
				if hit and isElement(hit) then
					local x,y,z = teleport_home_position(info['id'])[1],teleport_home_position(info['id'])[2],teleport_home_position(info['id'])[3]
					setElementPosition(hit, x, y, z)
					setElementInterior(hit, info['interior'])
					setElementDimension(hit, (info['id'] + 999))

					setTimer(function()
						if hit and isElement(hit) then
							fadeCamera(hit, true)
							setElementFrozen(hit, false)

							if q[1].wlasciciel_nick == getPlayerName(player) then
								setElementData(player, 'user:objecting', true)
							end
						end
					end, 2000, 1)
				end
			end, 1000, 1)
		else
			outputChatBox("#ff0000● #ffffffPodany domek jest zamknięty.", player, 255, 255, 255, true)
		end
	end
end)

addEvent('buy:house', true)
addEventHandler('buy:house', resourceRoot, function(player, id, days)
	if string.len(days) > 2 then
		days = 1
	elseif not tonumber(days) then
		days = 1
	end

	days = tonumber(days)
	days = math.floor(days)

	if days < 1 then return end

	local info = db:query('select * from db_houses where id=? limit 1', id)
	if info and #info > 0 then
		local cena = info[1]['cena']*days
		local money = getPlayerMoney(player)
		if cena <= money then
			if info[1]['data'] == '0000-00-00' then
				local domki = db:query('select * from db_houses where wlasciciel=? limit 1', getElementData(player, 'user:dbid'))
				if domki and #domki >= 3 then
					outputChatBox("#ff0000● #ffffffMożesz posiadać maksymalnie 3 domki.", player, 255, 255, 255, true)
					return
				end
				outputChatBox("#00ff00● #ffffffZakupiłeś dom na #969696"..days.." #ffffffdni za cene #969696"..formatMoney(cena).." #00ff00$", player, 255, 255, 255, true)
				takePlayerMoney(player, cena)
				setElementData(player, 'user:houseachv', true)
				db:query('update db_users set money=? where login=? limit 1', getPlayerMoney(player), getPlayerName(player))
				db:query('UPDATE db_houses SET wlasciciel=?, wlasciciel_nick=?, data=IF(data>NOW(), data, NOW())+INTERVAL ? DAY WHERE id=? limit 1', getElementData(player, 'user:dbid'), getPlayerName(player), days, id)
				refresh_house(id)
			else
				local domki = db:query('select * from db_houses where id=? limit 1', id)
				if domki[1]['wlasciciel'] == 0 or domki[1]['wlasciciel'] and domki[1]['wlasciciel'] == getElementData(player, 'user:dbid') then
					outputChatBox("#00ff00● #ffffffPrzedłużyłeś dom na #969696"..days.." #ffffffdni za cene #969696"..formatMoney(cena).." #00ff00$", player, 255, 255, 255, true)
					takePlayerMoney(player, cena)
					db:query('update db_users set money=? where login=? limit 1', getPlayerMoney(player), getPlayerName(player))
					db:query('UPDATE db_houses SET wlasciciel=?, wlasciciel_nick=?, data=IF(data>NOW(), data, NOW())+INTERVAL ? DAY WHERE id=? limit 1', getElementData(player, 'user:dbid'), getPlayerName(player), days, id)
					refresh_house(id)
				end
			end
		else
			if info[1]['data'] == '0000-00-00' then
				outputChatBox("#ff0000● #ffffffAby zakupić ten dom na #969696"..days.." #ffffffdni potrzebujesz #969696"..formatMoney(cena).." #00ff00$", player, 255, 255, 255, true)
			else
				outputChatBox("#ff0000● #ffffffAby przedłużyć ten dom na #969696"..days.." #ffffffdni potrzebujesz #969696"..formatMoney(cena).." #00ff00$", player, 255, 255, 255, true)
			end
		end
	end
end)

addEvent('remove:house', true)
addEventHandler('remove:house', resourceRoot, function(player, id)
	local garage = db:query('select * from db_garages where house_id=? limit 1', id)
	if garage and #garage > 0 then
		db:query('update db_vehicles set parking=1, garage=0 where garage=?', garage[1]['id'])
		garaze:refreshGarage(garage[1]['id'])
	end

	outputChatBox("#00ff00● #ffffffPomyślnie zwolniłeś dom.", player, 255, 255, 255, true)
	db:query('update db_houses set wlasciciel=0, wlasciciel_nick=?, data=?, lokatorzy=?, organizacja=? where id=? limit 1', '', '0000-00-00', '', '', id)
	refresh_house(id)
end)