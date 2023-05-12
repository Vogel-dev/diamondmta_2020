--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local marker = createMarker(2395.369140625,-1730.546875,1070.4281005859-0.97, 'cylinder', 1.2, 137, 207, 240, 75)
setElementData(marker, 'marker:icon', 'przebieralnia')
setElementInterior(marker, 1)
--[[
local marker_ = createMarker(165.63531494141,-80.57926940918,1001.8046875-0.97, 'cylinder', 1.2, 100, 0, 255, 75)
setElementData(marker_, 'marker:icon', 'przebieralnia')
setElementInterior(marker_, 18)-]]

addEventHandler('onMarkerHit', resourceRoot, function(hit, dim)
	if not hit or hit and not isElement(hit) or hit and isElement(hit) and getElementType(hit) ~= 'player' or hit and isElement(hit) and getElementType(hit) == 'player' and isPedInVehicle(hit) or not dim then return end

	triggerClientEvent(hit, 'showGui', resourceRoot)
end)

addEvent('changeSkin', true)
addEventHandler('changeSkin', resourceRoot, function(skin)
	setElementModel(client, skin)
	exports['dmta_base_connect']:query('update db_users set skin=? where login=?', skin, getPlayerName(client))
end)
