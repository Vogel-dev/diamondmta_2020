--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

addEventHandler("onElementDataChange", root, function(nazwa, stara)
	if getElementType(source) == "player" then
		if not getElementData(source, "user:dbid") then return end
		if nazwa == "muzyka" then
			if getElementData(source, "muzyka") == 1 then
				triggerClientEvent(source, "wylacz:muzyke", source, 2)
			end
			if getElementData(source, "muzyka") == 0 then
				triggerClientEvent(source, "wylacz:muzyke", source, 1)
			end
		end
	end
end)