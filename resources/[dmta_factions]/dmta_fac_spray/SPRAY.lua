--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--


-- Otrzymujemy kasę
addEvent("givePlayerMoney", true)
addEventHandler("givePlayerMoney", root, function(kwota)
	givePlayerMoney(source, 1)
	if getElementData(source, 'user:premium') then
		givePlayerMoney(source, 1.5)
	end
end)
