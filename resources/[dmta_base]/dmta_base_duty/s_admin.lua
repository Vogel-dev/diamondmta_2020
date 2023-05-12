--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--


local db = exports.dmta_base_connect

addCommandHandler('db', function(player)
	if getElementData(player, 'rank:duty') > 2 then
		local players = db:query('select * from db_users')
		local vehicles = db:query('select * from db_vehicles')
		triggerClientEvent(player, 'admin:gui', resourceRoot, players, vehicles)
	end
end)