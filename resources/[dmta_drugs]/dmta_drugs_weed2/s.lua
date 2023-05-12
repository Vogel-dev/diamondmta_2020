--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

addEvent("weed2:animacja", true)
addEventHandler("weed2:animacja", getRootElement(), function() 
setPedAnimation ( source, 'CASINO', 'dealone', -1, false, false )
end)

addEvent("weed2:zanimacja", true) 
addEventHandler("weed2:zanimacja", getRootElement(), function() 
    local exp = 2
    if getElementData(source, 'user:premium') then
        exp = exp*1.5
    end
    exports["dmta_levels"]:addExp(source, exp)
setPedAnimation(source,false)
end)

addEvent("weed2:start", true)
addEventHandler("weed2:start", getRootElement(),
function()
end)