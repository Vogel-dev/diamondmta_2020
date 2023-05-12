--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

addEvent("meth2:animacja", true)
addEventHandler("meth2:animacja", getRootElement(), function() 
setPedAnimation ( source, 'CASINO', 'dealone', -1, false, false )
end)

addEvent("meth2:zanimacja", true) 
addEventHandler("meth2:zanimacja", getRootElement(), function() 
    local exp = 2
    if getElementData(source, 'user:premium') then
        exp = exp*1.5
    end
    exports["dmta_levels"]:addExp(source, exp)
setPedAnimation(source,false)
end)

addEvent("meth2:start", true)
addEventHandler("meth2:start", getRootElement(),
function()
end)