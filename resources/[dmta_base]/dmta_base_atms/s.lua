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

local bankomaty = {
	--bank
	{834.60015869141,3.2498636245728,1004.1796875,272.30615234375, 0, 3},
	{830.73913574219,-1.28044706583023,1004.1796875,177.6785736084, 0, 3},
	{977.55084228516,-1293.7381591797,13.546875,268.92950439453, 0, 0},
	{967.81860351563,-1336.8311767578,13.517503738403,182.13520812988, 0, 0},
	{1010.4605712891,-1348.1813964844,13.348707199097,273.29266357422, 0, 0},
	{1072.1126708984,-1320.8677978516,13.546875,270.78616333008, 0, 0},
	{1093.1685791016,-1130.4246826172,23.824113845825,319.37686157227, 0, 0},
	{1014.5038452148,-928.95142822266,42.328125,6.3540196418762, 0, 0},
	{1108.2618408203,-1370.0970458984,13.990968704224,358.83389, 0, 0},
	{1174.6359863281,-1341.7360839844,13.994172096252,177.74887, 0, 0},
	{1367.2110595703,-1275.0504150391,13.546875,271.123138, 0, 0},
	{1419.103515625,-1622.6943359375,13.546875,268.92977138, 0, 0},
	{1502.7849853516,-1569.1387939453,13.549827575684,268.639801038, 0, 0},
	{1550.3526611328,-1671.7025146484,13.562602996826,178.4224201038, 0, 0},
	{1504.5443359375,-1752.4161376953,13.546875,90.954795831038, 0, 0},
	{1722.3050537109,-1742.8807373047,13.548543930054,1.340620, 0, 0},
	{1767.2132568359,-1722.6295410156,13.546875,1.340620, 0, 0},
	{1928.6841064453,-1782.9871826172,13.546875,89.36470, 0, 0},
	{2463.3564453125,-1513.9888916016,24,178.97870, 0, 0},
	{2825.3439941406,-1594.3182373047,11.101528167725,151.09180, 0, 0},
	{2181.3605957031,-2262.068359375,13.398496627808,136.0751380, 0, 0},
	{1969.5766601563,-2190.2629394531,13.546875,1.027180, 0, 0},
	{2273.8989257813,-2418.2409667969,13.546875,226.6059180, 0, 0},
	{547.16040039063,-1292.4005126953,17.248237609863,178.01580, 0, 0},
	{-79.410667419434,-1171.8472900391,2.1373405456543,247.23930, 0, 0},
}

for i,v in ipairs(bankomaty) do
	local csp = createColSphere(v[1], v[2], v[3]-0.15, 1.15)
	local obj = createObject(2942, v[1]-0.05, v[2]+0.05, v[3]-0.4, 0, 0, v[4])

	--local blip = createBlip(v[1], v[2], v[3], 0, 1, 105, 188, 235)
	--setBlipVisibleDistance(blip, 500)

	if v[5] then
		setElementDimension(obj, v[5])
		setElementDimension(csp, v[5])
	end
	if v[6] then
		setElementInterior(obj, v[5])
		setElementInterior(csp, v[5])
	end
end

function getBankMoney(player)
	local q = db:query('select * from db_users where login=? limit 1', getPlayerName(player))
	if q and #q > 0 then
		return q[1]['bank_money']
	end
	return 0
end

function getNewsPay(player)
	local q = db:query('select * from db_users where login=? limit 1', getPlayerName(player))
	if q and #q > 0 then
		return q[1]['nowe_przelewy']
	end
	return 0
end

function getBankAccount(player)
	local q = db:query('select * from db_users where login=? limit 1', getPlayerName(player))
	if q and #q > 0 then
		return q[1]['konto_bankowe']
	end
	return 0
end

addEventHandler('onColShapeHit', resourceRoot, function(hit, dim)
	if not hit or hit and not isElement(hit) or hit and isElement(hit) and getElementType(hit) ~= 'player' or hit and isElement(hit) and getElementType(hit) == 'player' and isPedInVehicle(hit) or not dim then return end

	if getBankAccount(hit) == 1 then
		triggerClientEvent(hit, 'goBankomat', resourceRoot, getBankMoney(hit), getNewsPay(hit))
		db:query('update db_users set nowe_przelewy=0 where login=?', getPlayerName(hit))
	else
		noti:addNotification(hit, 'Nie posiadasz konta bankowego.', 'error')
	end
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

addEvent('bankomat:akcja', true)
addEventHandler('bankomat:akcja', resourceRoot, function(action, money, login)
	if action == 'WPLAC' then
		if string.len(money) < 1 then
			noti:addNotification(client, 'Najpierw wprowadź sumę.', 'error')
			return
		elseif string.len(money) > 8 or not tonumber(money) or tonumber(money) and tonumber(money) < 1 then
			return
		end

		money = tonumber(money)
		money = math.floor(money)

		if getPlayerMoney(client) >= money then
			noti:addNotification(client, 'Pomyślnie wpłacono '..formatMoney(money)..'$ na konto bankowe.', 'success')
			takePlayerMoney(client, money)
			db:query('update db_users set bank_money=bank_money+?, money=? where login=?', money, getPlayerMoney(client), getPlayerName(client))
			duty:addLogs('przelew', formatMoney(money)..'$', client, 'WPLATA')
			triggerClientEvent(client, 'update:saldo', resourceRoot, getBankMoney(client))
		else
			noti:addNotification(client, 'Brak wystarczających środków.', 'error')
		end
	elseif action == 'WYPLAC' then
		if string.len(money) < 1 then
			noti:addNotification(client, 'Najpierw wprowadź sumę.', 'error')
			return
		elseif string.len(money) > 8 or not tonumber(money) or tonumber(money) and tonumber(money) < 1 then
			return
		end

		money = tonumber(money)
		money = math.floor(money)

		if getBankMoney(client) >= money then
			noti:addNotification(client, 'Pomyślnie wypłacono '..formatMoney(money)..'$ z konta bankowego.', 'success')
			givePlayerMoney(client, money)
			db:query('update db_users set bank_money=bank_money-?, money=? where login=?', money, getPlayerMoney(client), getPlayerName(client))
			duty:addLogs('przelew', formatMoney(money)..'$', client, 'WYPLATA')
			triggerClientEvent(client, 'update:saldo', resourceRoot, getBankMoney(client))
		else
			noti:addNotification(client, 'Brak wystarczających środków.', 'error')
		end
	end
end)