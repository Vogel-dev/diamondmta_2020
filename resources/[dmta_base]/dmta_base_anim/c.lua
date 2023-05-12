--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

function animation(startTick, startValue, stopValue, time, type)
    local anim = interpolateBetween(startValue, 0, 0, stopValue, 0, 0, (getTickCount() - startTick) / time, type)

    if (getTickCount() - startTick) > time then
        return anim, false
    else
        return anim, true
    end
end