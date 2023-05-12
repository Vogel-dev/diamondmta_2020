--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

addEvent("coke1_priv2:animacja", true)
addEventHandler("coke1_priv2:animacja", getRootElement(), function() 
setPedAnimation ( source, "CAMERA", "camstnd_to_camcrch", -1, false, false )
end)

addEvent("coke1_priv2:zanimacja", true) 
addEventHandler("coke1_priv2:zanimacja", getRootElement(), function() 
    local exp = 3
    if getElementData(source, 'user:premium') then
        exp = exp*1.5
    end
    exports["dmta_levels"]:addExp(source, exp)
setPedAnimation(source,false)
end)

addEvent("coke1_priv2:start", true)
addEventHandler("coke1_priv2:start", getRootElement(),
function()
end)