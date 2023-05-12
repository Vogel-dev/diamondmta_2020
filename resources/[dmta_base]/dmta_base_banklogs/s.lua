--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local marker = createMarker(822.0087890625,6.3238425254822,1004.1796875-0.97, 'cylinder', 1.2, 79, 134, 247, 75)
setElementInterior(marker, 3)
setElementData(marker, 'marker:icon', 'diamondbank_transakcje')

local db = exports.dmta_base_connect

addEventHandler('onMarkerHit', marker, function(hit, dim)
	if not hit or hit and not isElement(hit) or hit and isElement(hit) and getElementType(hit) ~= 'player' or hit and isElement(hit) and getElementType(hit) == 'player' and isPedInVehicle(hit) or not dim then return end

	local q = db:query('select * from logs_transfers where nick=? order by date desc', getPlayerName(hit))
	if q and #q > 0 then
		triggerClientEvent(hit, 'lista:przelewow', resourceRoot, q)
	else
		exports['dmta_base_notifications']:addNotification(hit, 'Nie posiadasz historii przelewów.', 'error')
	end
end)
