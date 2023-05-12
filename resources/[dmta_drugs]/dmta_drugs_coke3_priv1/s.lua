--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

addEvent("coke3_priv1:animacja", true)
addEventHandler("coke3_priv1:animacja", getRootElement(), function() 
setPedAnimation ( source, 'GANGS', 'prtial_gngtlkG', -1, false, false )
end)

addEvent("coke3_priv1:zanimacja", true) 
addEventHandler("coke3_priv1:zanimacja", getRootElement(), function() 
	local exp = 1
    if getElementData(source, 'user:premium') then
        exp = exp*1.5
    end
    exports["dmta_levels"]:addExp(source, exp)
setPedAnimation(source,false)
end)

addEvent("coke3_priv1:start", true)
addEventHandler("coke3_priv1:start", getRootElement(),
function()
end)

addEvent("daj:coke3_priv1", true)
addEventHandler("daj:coke3_priv1", root, function()
	local cena = math.random(100, 150)
	if getElementData(source, "user:premium") then
		cena = cena + cena*0.50
	end
    givePlayerMoney(source, cena)
    outputChatBox("#00ff00● #ffffffSprzedałeś paczkę kokainy za #969696"..cena.." #00ff00$", source, 255, 255, 255, true)

	local text_log = getPlayerName(source)..' > '..cena..''
    exports['dmta_base_duty']:addLogs('illegal', text_log, source, 'COKE/SELL')
end)