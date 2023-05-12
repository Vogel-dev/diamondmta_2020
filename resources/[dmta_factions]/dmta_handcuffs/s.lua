--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local kaj = { }
local timer = { }
local noti = exports.dmta_base_notifications

function findPlayer(player, toPlayer)
	for i,v in ipairs(getElementsByType("player")) do
		if tonumber(toPlayer) then
			if getElementData(v, "user:id") == tonumber(toPlayer) then
				return v
			end
		else
			if string.find(string.gsub(getPlayerName(v):lower(),"#%x%x%x%x%x%x", ""), toPlayer:lower(), 1, true) then
				return v
			end
		end
	end
end

function zalozkaj(plr, cmd, target)
if getElementData(plr, "user:faction") == "SAPD" or getElementData(plr, "user:oname") then
	local gracz = findPlayer(plr, target)
	if not getElementData(plr, "kajdanki") then
		local gracz = getPlayerName(gracz)
		local gracz = getPlayerFromName(gracz)
		local x2,y2,z2 = getElementPosition(gracz)
		local x,y,z = getElementPosition(plr)
		if (getDistanceBetweenPoints3D(x,y,z,x2,y2,z2)<20) then
			toggleControl(gracz, "enter_exit", false)
			toggleControl(gracz, "enter_passenger", false)
			attachElements(gracz, plr, 0,1.1,0)
			setElementPosition(gracz, x,y,z)
			local graczz = getPlayerName(gracz)
			kaj[plr] = {}
			kaj[plr] = {graczz}
			setElementData(plr, "kajdanki", true)
			setElementData(gracz, "kajdanki", true)
			outputChatBox('#fada5e● #969696'..getPlayerName(plr)..' #ffffffzakuwa cię w kajdanki.', gracz, 255, 255, 255, true)
			outputChatBox('#00ff00● #ffffffZakładasz kajdanki graczowi #969696'..graczz..'#ffffff.', plr, 255, 255, 255, true)
			local text_log = getPlayerName(plr)..' zakuwa gracza '..getPlayerName(gracz)..''
			exports['dmta_base_duty']:addLogs('fac', text_log, plr, 'HANDCUFF/Z')
			end
		end
	else
		outputChatBox('#ff0000● #ffffffNie możesz założyć kajdanek dwóm osobom na raz.', plr, 255, 255, 255, true)
	end
end
addCommandHandler("z", zalozkaj)

addEventHandler("onVehicleEnter", root, function(plr)
	if getElementData(plr, "kajdanki") then
		local peds = kaj[plr][1]
		local ped = getPlayerFromName(peds)
		local veh = getPedOccupiedVehicle(plr)
		local atta = getAttachedElements(plr)
		for i,v in pairs(atta)do
			detachElements(v, plr)
		end
		warpPedIntoVehicle(ped, veh, 3)
		outputChatBox('#fada5e● #969696'..getPlayerName(plr)..' #ffffffwsadza cię do pojazdu.', ped, 255, 255, 255, true)
		outputChatBox('#00ff00● #ffffffWsadzasz do pojazdu gracza #969696'..getPlayerName(ped)..'#ffffff.', plr, 255, 255, 255, true)
	end
end)

addEventHandler("onVehicleStartExit", root, function(plr)
	if getElementData(plr, "kajdanki") then
		local ped = kaj[plr][1]
		local ped = getPlayerFromName(ped)
		local x,y,z = getElementPosition(plr)
		removePedFromVehicle(ped)
		attachElements(ped, plr, 0,1.1,0)
		outputChatBox('#fada5e● #969696'..getPlayerName(plr)..' #ffffffwyciąga cię z pojazdu.', ped, 255, 255, 255, true)
		outputChatBox('#00ff00● #ffffffWyciągasz z pojazdu gracza #969696'..getPlayerName(ped)..'#ffffff.', plr, 255, 255, 255, true)
	end
end)

function sciagnijkaj(plr, cmd, target)
	local gracz = findPlayer(plr, target)
	if getElementData(plr, "kajdanki") then
		local gracz = getPlayerName(gracz)
		local gracz = getPlayerFromName(gracz)
		local x2,y2,z2 = getElementPosition(gracz)
		local x,y,z = getElementPosition(plr)
		if (getDistanceBetweenPoints3D(x,y,z,x2,y2,z2)<20) then
			local atta = getAttachedElements(plr)
			toggleControl(gracz, "enter_exit", true)
			toggleControl(gracz, "enter_passenger", true)
			for i,v in pairs(atta)do
				detachElements(v, plr)
			end
			setElementPosition(gracz, x+2.5,y,z)
			setElementData(plr, "kajdanki", false)
			setElementData(gracz, "kajdanki", false)
			kaj[plr] = {}
			outputChatBox("#fada5e● #969696"..getPlayerName(plr).." #ffffffodkuwa cię.", gracz, 255, 255, 255, true)
			outputChatBox("#00ff00● #ffffffŚciągasz kajdanki graczowi #969696"..getPlayerName(gracz).."#ffffff.", plr, 255, 255, 255, true)
			local text_log = getPlayerName(plr)..' odkuwa gracza '..getPlayerName(gracz)..''
			exports['dmta_base_duty']:addLogs('fac', text_log, plr, 'HANDCUFF/OZ')
		end
	else
		outputChatBox('#ff0000● #ffffffNie założyłeś nikomu kajdanek.', plr, 255, 255, 255, true)
	end
end
addCommandHandler("oz",sciagnijkaj)