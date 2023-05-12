--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

strefa1 = createColCuboid(1730.1197509766, -1785.8660888672, 13.4921875-1, 15.5, 8, 4)
kolor1 = createMarker(1731.0928955078,-1779.7801513672,13.4921875-0.95, "cylinder", 1.5, 185, 43, 39, 100)
setElementData(kolor1, 'marker:icon', 'paint')
setElementData(kolor1, "malowanie", true)
setElementData(kolor1, "kolor", 1)
setElementData(kolor1, "cuboid:kolor1", strefa1)

addEventHandler("onMarkerHit", kolor1, function(hit)
	if getElementType(hit) ~= "player" then return end
	if isPedInVehicle(hit) then return end
	triggerClientEvent(hit, "lakernia:kolor1:gui", hit, source)
end)

addEvent("lakernia:pomaluj1", true)
addEventHandler("lakernia:pomaluj1", root, function(vehicle, r, g, b)
	setVehicleColor(vehicle, r, g, b)
	exports['dmta_base_connect']:query("UPDATE db_vehicles SET color=? where id=?", "[ [ "..r..", "..g..", "..b.." ] ]", getElementData(vehicle, "vehicle:id"))
end)