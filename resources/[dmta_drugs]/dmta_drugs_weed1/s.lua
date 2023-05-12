--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

addEvent("weed1:animacja", true)
addEventHandler("weed1:animacja", getRootElement(), function() 
setPedAnimation ( source, "CAMERA", "camstnd_to_camcrch", -1, false, false )
end)

addEvent("weed1:zanimacja", true) 
addEventHandler("weed1:zanimacja", getRootElement(), function() 
    local exp = 3
    if getElementData(source, 'user:premium') then
        exp = exp*1.5
    end
    exports["dmta_levels"]:addExp(source, exp)
setPedAnimation(source,false)
end)

addEvent("weed1:start", true)
addEventHandler("weed1:start", getRootElement(),
function()
end)