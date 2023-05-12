--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local mysql = {
	database_game = false,
	host = '137.74.6.118',
	dbName = 'db_48513',
	userName = 'db_48513',
	dbPassword = 'X1gLn8GhMVo5',
}

addEventHandler('onResourceStart', resourceRoot, function()
	mysql['database_game'] = dbConnect('mysql', 'dbname='..mysql['dbName']..';host='..mysql['host']..';charset=utf8;', mysql['userName'], mysql['dbPassword'], 'share=1')
	if mysql['database_game'] then
		outputDebugString('DMTA_DATABASE / Połączenie z serwerem MYSQL - pozytywne.')
	else
		outputDebugString('DMTA_DATABASE / Połączenie z serwerem MYSQL - negatywne.')
	end
end)

function query(...)
	if not ... or ... and string.len(...) < 1 then return end
	if not mysql['database_game'] then return end

	local q = dbQuery(mysql['database_game'], ...)
	if q then
		local r = {dbPoll(q, -1)}
		return unpack(r)
	end
	return false
end