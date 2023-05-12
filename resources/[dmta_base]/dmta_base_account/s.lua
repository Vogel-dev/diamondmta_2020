--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local marker = createMarker(822.0732421875,2.2080883979797,1004.1796875-0.97, 'cylinder', 1.2, 31, 117, 254, 75)
--setElementDimension(marker, 60)
setElementInterior(marker, 3)
setElementData(marker, 'marker:icon', 'diamondbank_konto')

addEventHandler('onMarkerHit', marker, function(hit, dim)
	if not hit or hit and not isElement(hit) or hit and isElement(hit) and getElementType(hit) ~= 'player' or hit and isElement(hit) and getElementType(hit) == 'player' and isPedInVehicle(hit) or not dim then return end

	local q = exports['dmta_base_connect']:query('select * from db_users where login=? and konto_bankowe=0', getPlayerName(hit))
	if q and #q > 0 then
		triggerClientEvent(hit, 'konto:bankowe', resourceRoot)
	else
		exports['dmta_base_notifications']:addNotification(hit, 'Posiadasz już założone konto bankowe.', 'error')
	end
end)

addEvent('konto:bankowe', true)
addEventHandler('konto:bankowe', resourceRoot, function()
	local q = exports['dmta_base_connect']:query('update db_users set konto_bankowe=1 where login=?', getPlayerName(client))
end)
