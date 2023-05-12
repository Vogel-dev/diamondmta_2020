--[[
@Author: Vogel
@Copyright: Vogel / Society MTA // 2019-2020
@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local noti = exports.dmta_base_notifications

function taser(atakujacy, bron, cialo, starciles)
	if atakujacy and (bron == 23) then
		outputChatBox("#fada5e● #ffffffZostałeś porażony paralizatorem przez "..getPlayerName(atakujacy).."", source, 255, 255, 255, true)
		setElementFrozen(source,true)
		setPedAnimation(source, "CRACK", "crckdeth2", -1, true, false)
		setTimer(setElementFrozen,30000,1,source,false)		
		setTimer(setPedAnimation,30000,1,source,false)		
	elseif atakujacy and (bron == 4) then
		local szansa = math.random(1, 5)
        	if tonumber(szansa) == 5 then
		outputChatBox("#fada5e● #ffffffZostałeś dźgnięty nożem przez "..getPlayerName(atakujacy).."", source, 255, 255, 255, true)
		setElementFrozen(source,true)
		setPedAnimation(source, "CRACK", "crckdeth2", -1, true, false)
		setTimer(setElementFrozen,30000,1,source,false)		
		setTimer(setPedAnimation,30000,1,source,false)		
		end
	elseif atakujacy and (bron == 5) then
		local szansa = math.random(5, 5)
        	if tonumber(szansa) == 5 then
		outputChatBox("#fada5e● #ffffffZostałeś znokautowany kijem przez "..getPlayerName(atakujacy).."", source, 255, 255, 255, true)
		setElementFrozen(source,true)
		setPedAnimation(source, "CRACK", "crckdeth2", -1, true, false)
		setTimer(setElementFrozen,30000,1,source,false)		
		setTimer(setPedAnimation,30000,1,source,false)	
		end	
	elseif atakujacy and (bron == 3) then
	local szansa = math.random(1, 5)
        if tonumber(szansa) == 5 then
	outputChatBox("#fada5e● #ffffffZostałeś znokautowany pałką policyjną przez "..getPlayerName(atakujacy).."", source, 255, 255, 255, true)
	setElementFrozen(source,true)
	setPedAnimation(source, "CRACK", "crckdeth2", -1, true, false)
	setTimer(setElementFrozen,30000,1,source,false)		
	setTimer(setPedAnimation,30000,1,source,false)		
	end
end
end
addEventHandler ( "onPlayerDamage", getRootElement (), taser)
