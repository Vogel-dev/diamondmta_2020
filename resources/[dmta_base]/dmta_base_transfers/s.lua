--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local marker = createMarker(822.01013183594,4.1431312561035,1004.1796875-0.97, 'cylinder', 1.2, 0, 147, 175, 75)
setElementInterior(marker, 3)
setElementData(marker, 'marker:icon', 'diamondbank_przelewy')

function getBankMoney(player)
	local q = exports['dmta_base_connect']:query('select * from db_users where login=?', getPlayerName(player))
	if q and #q > 0 then
		return q[1]['bank_money']
	end
	return 0
end

function formatMoney(money)
	while true do
		money, i = string.gsub(money, '^(-?%d+)(%d%d%d)', '%1,%2')
		if i == 0 then
			break
		end
	end
	return money
end

addEventHandler('onMarkerHit', marker, function(hit, dim)
	if not hit or hit and not isElement(hit) or hit and isElement(hit) and getElementType(hit) ~= 'player' or hit and isElement(hit) and getElementType(hit) == 'player' and isPedInVehicle(hit) or not dim then return end

  local q = exports['dmta_base_connect']:query('select * from db_users where login=? and konto_bankowe=1', getPlayerName(hit))
  if q and #q > 0 then
    triggerClientEvent(hit, 'gui:przelewy', resourceRoot, q[1]['bank_money'])
  else
    exports['dmta_base_notifications']:addNotification(hit, 'Nie posiadasz konta bankowego.', 'error')
  end
end)

addEvent('potwierdz:przelew', true)
addEventHandler('potwierdz:przelew', resourceRoot, function(login, money)
	local q = exports['dmta_base_connect']:query('select * from db_users where login=?', login)
	if q and #q > 0 then
		exports['dmta_base_notifications']:addNotification(client, 'Pomyślnie przelano '..formatMoney(money)..'$ na konto bankowe gracza '..login..'.', 'success')
		exports['dmta_base_connect']:query('update db_users set bank_money=bank_money-? where login=?', money, getPlayerName(client))
		exports['dmta_base_connect']:query('update db_users set bank_money=bank_money+?, nowe_przelewy=nowe_przelewy+1 where login=?', money, login)
		exports['dmta_base_duty']:addLogs('przelew', login..' > '..formatMoney(money)..'$', client, 'WYCHODZĄCY')
		exports['dmta_base_duty']:addLogs('przelew', getPlayerName(client)..' < '..formatMoney(money)..'$', {login,q[1]['serial']}, 'PRZYCHODZĄCY')
	end
end)

addEvent('wyslij:przelew', true)
addEventHandler('wyslij:przelew', resourceRoot, function(money, login)
  if string.len(money) < 1 then
    exports['dmta_base_notifications']:addNotification(client, 'Najpierw wprowadź sumę.', 'error')
    return
  elseif login == getPlayerName(client) then
    exports['dmta_base_notifications']:addNotification(client, 'Nie możesz wysłać sobie przelewu.', 'error')
    return
  elseif string.len(login) < 1 then
    exports['dmta_base_notifications']:addNotification(client, 'Najpierw wprowadź nicku.', 'error')
    return
  elseif string.len(money) > 8 or not tonumber(money) or tonumber(money) and tonumber(money) < 1 then
    return
  end

  money = tonumber(money)
  money = math.floor(money)

  if getBankMoney(client) >= money then
    local q = exports['dmta_base_connect']:query('select * from db_users where login=?', login)
    if q and #q > 0 then
      if q[1]['konto_bankowe'] == 1 then
				triggerClientEvent(client, 'potwierdz:przelew', resourceRoot, login, money)
      else
        exports['dmta_base_notifications']:addNotification(client, 'Podana osoba nie posiada konta bankowego.', 'error')
      end
    else
      exports['dmta_base_notifications']:addNotification(client, 'Nie znaleziono gracza o podanym nicku.', 'error')
    end
  else
    exports['dmta_base_notifications']:addNotification(client, 'Brak wystarczających środków.', 'error')
  end
end)
