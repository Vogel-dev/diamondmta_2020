--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

function setLevel( player, level )
	setElementData( player, "user:level", level )
end

function setExp( player, level )
	setElementData( player, "user:exp", level )
end

function getLevel( player )
	return getElementData( player, "user:level" )
end

function addExp( player, exp )
	triggerClientEvent ( player, "addExpC", player, exp )
end

function getExp( player )
	return getElementData( player, "user:exp" )
end