--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

addEvent("meth3:animacja", true)
addEventHandler("meth3:animacja", getRootElement(), function() 
setPedAnimation ( source, 'GANGS', 'prtial_gngtlkG', -1, false, false )
end)

addEvent("meth3:zanimacja", true) 
addEventHandler("meth3:zanimacja", getRootElement(), function() 
	local exp = 1
    if getElementData(source, 'user:premium') then
        exp = exp*1.5
    end
    exports["dmta_levels"]:addExp(source, exp)
setPedAnimation(source,false)
end)

addEvent("meth3:start", true)
addEventHandler("meth3:start", getRootElement(),
function()
end)

addEvent("daj:meth3", true)
addEventHandler("daj:meth3", root, function()
	local cena = math.random(120, 180)
	if getElementData(source, "user:premium") then
		cena = cena + cena*0.50
	end
    givePlayerMoney(source, cena)
    outputChatBox("#00ff00● #ffffffSprzedałeś paczkę metamfetaminy za #969696"..cena.." #00ff00$", source, 255, 255, 255, true)

	local text_log = getPlayerName(source)..' > '..cena..''
    exports['dmta_base_duty']:addLogs('illegal', text_log, source, 'METH/SELL')
end)