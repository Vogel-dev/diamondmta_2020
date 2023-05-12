--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local noti = exports.dmta_base_notifications

local marker = createMarker(358.23608398438,169.01737976074,1008.3828125-0.97, "cylinder", 1.1, 191, 148, 228, 75)
setElementInterior(marker, 3)
setElementData(marker, 'marker:icon', 'car')

addEventHandler("onMarkerHit", marker, function(hit)
	if getElementType(hit) ~= "player" then return end
	local oname = getElementData(hit, "user:oname")

	local q = exports.dmta_base_connect:query("SELECT * FROM db_vehicles WHERE owner=?", getElementData(hit, "user:dbid"))
	if #q < 1 then
		outputChatBox("#ff0000● #ffffffNie posiadasz pojazdów.", hit, 255, 255, 255, true)
		return
	end
	triggerClientEvent(hit, "showOrgWindow", hit, q)
end)

addEventHandler("onMarkerLeave", marker, function(hit)
	triggerClientEvent(hit, "destroyOrgWindow", hit)
end)

addEvent("przepisz", true)
addEventHandler("przepisz", getRootElement(), function(player,uid)
	local oname = getElementData(player, "user:oname")
	local query = exports.dmta_base_connect:query("SELECT * FROM db_vehicles WHERE id=?", uid)
	if query[1].organization == "" then
		if not oname then
				outputChatBox("#ff0000● #ffffffNie przynależysz do żadnej organizacji przestępczej.", plr, 255, 255, 255, true)
	    	return
		end
		exports.dmta_base_connect:query("UPDATE db_vehicles SET organization=? WHERE id=?", oname, uid)
		outputChatBox("#00ff00● #ffffffPomyślnie przepisałeś pojazd o ID "..uid.." na organizacje.", plr, 255, 255, 255, true)
	else
		exports.dmta_base_connect:query("UPDATE db_vehicles SET organization=? WHERE id=?", "", uid)
		outputChatBox("#00ff00● #ffffffPomyślnie wypisałeś pojazd o ID "..uid.." z organizacji.", plr, 255, 255, 255, true)
	end
end)