--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local tick = getTickCount()
local key = true
local timeToAFK = 1

function getAFK()
	if not key and not getElementData(localPlayer, 'user:afk') then
		setElementData(localPlayer, 'user:afk', true)
	elseif key and getElementData(localPlayer, 'user:afk') then
		setElementData(localPlayer, 'user:afk', false)
	end

	if (getTickCount() - tick) > (timeToAFK * 60000) then
		key = false
	end
end

addEventHandler('onClientKey', getRootElement(), function()
	if key ~= true then
		key = true
		tick = getTickCount()
	end
end)

addEventHandler('onClientMinimize', getRootElement(), function()
	if not getElementData(localPlayer, '_user:afk') then
		setElementData(localPlayer, '_user:afk', true)
	end
end)

addEventHandler('onClientRestore', getRootElement(), function()
	if getElementData(localPlayer, '_user:afk') then
    	setElementData(localPlayer, '_user:afk', false)
	end
end)
