--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

-- Leczenie sprayem
local koszt = 10 -- tutaj ustawiamy koszt za uleczonego gracza.

-- Leczenie sprayem
addEventHandler("onClientPlayerDamage", root, function(attacker, weapon)
	if weapon == 41 then cancelEvent() end -- blokujemy zabijanie
	if weapon == 41 and attacker then -- sprawdzamy broń
		local hp = getElementHealth(localPlayer) -- pobieramy hp
		local health = hp+math.random(1,2) -- losujemy ilośc hp
		if health > hp and health <= 100 then -- sprawdza hp
			setElementHealth(localPlayer, health) -- ulecza gracza
			if health > 99 then end -- otrzymuje kasę
			triggerServerEvent('givePlayerMoney', attacker)
		end
	end
end)