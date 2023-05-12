--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

setTimer(function()
    if not getElementData(localPlayer, 'user:dbid') or getElementData(localPlayer, 'user:afk') or getElementData(localPlayer, '_user:afk') then return end

    local online = getElementData(localPlayer, 'user:online') or 0
    setElementData(localPlayer, 'user:online', online + 1)

    local sesion_online = getElementData(localPlayer, 'user:sesion_online') or 0
    setElementData(localPlayer, 'user:sesion_online', sesion_online + 1)
end, 60000, 0)