--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

function cmd_mandat(player, command, target, money, ...)
	if getElementData(player, "user:faction") ~= "SAPD" then return false; end

	if getElementData(player, "mandat:wystawil") then
		exports['dmta_base_notifications']:addNotification(player, "Wystawiłeś już komuś mandat, poczekaj na jego decyzję!", "error");
		return false;
	end

	if not target or not money then
		exports['dmta_base_notifications']:addNotification(player, "Użyj: /" .. command .. " [ID Gracza] [Kwota] [Opis]", 'error');
		return false;
	end

	local target2 = exports['dmta_base_core']:findPlayer(target)	
	if not target2 then
		exports['dmta_base_notifications']:addNotification(player, "Nie znaleziono takiego gracza", "error");
		return false;
	end

	local x1,y1,z1 = getElementPosition(player);
	local x2,y2,z2 = getElementPosition(target2);
	local dist = getDistanceBetweenPoints3D(x1,y1,z1, x2,y2,z2);
	if dist > 20 then
		exports['dmta_base_notifications']:addNotification(player, "Gracz jest za daleko", "error");
		return false;
	end

	local hajs = tonumber(money);
	if not hajs then
		exports['dmta_base_notifications']:addNotification(player, "Wpisana kwota jest błędna", "error");
		return false;
	end

	if hajs < 1 then
		exports['dmta_base_notifications']:addNotification(player, "Kwota mandatu musi być większa od 0", "error");
		return false;
	end

	local opis = table.concat({ ... }, " ");
	if not ... then
		opis = "Brak opisu";
	end

	if player == target2 then
    	exports["dmta_base_notifications"]:addNotification(player, "Nie możesz wystawić sobie mandatu.", "error")
		return
	end
	if getElementData(player, "user:id") == getElementData(target2, "user:id") then
    	exports["dmta_base_notifications"]:addNotification(player, "Nie możesz wystawić sobie mandatu.", "error")
		return
	end

	exports['dmta_base_notifications']:addNotification(player, "Wystawiasz graczowi " .. getPlayerName(target2) .. " mandat na kwotę " .. hajs .. " $", 'success');

	outputChatBox("==============================================", target2, 185, 43, 39);
	outputChatBox("#B92B27[#]#eeeeee Funkcjonariusz #B92B27" .. getPlayerName(player) .. "#eeeeee wystawia ci mandat!", target2, 230, 230, 230, true);
	outputChatBox("#B92B27[#]#eeeeee Kwota: " .. hajs .. " $", target2, 230, 230, 230, true);
	outputChatBox("#B92B27[#]#eeeeee " .. opis, target2, 230, 230, 230, true);
	outputChatBox("#B92B27[#]#eeeeee Przyjmowanie: /przyjmij  #B92B27|#eeeeee Odrzucanie: /odrzuc", target2, 185, 43, 39, true)
	outputChatBox("==============================================", target2, 185, 43, 39);

	setElementData(target2, "mandat", true, false);
	setElementData(target2, "mandat:kwota", hajs, false);
	setElementData(target2, "mandat:kto", player, false);
	setElementData(player, "mandat:wystawil", true, false);
	setElementData(target2, "mandat:opis", opis, false);

	local timer = setTimer(function ()
		setElementData(target2, "mandat", false, false);
		setElementData(target2, "mandat:kwota", false, false);
		setElementData(target2, "mandat:kto", false, false);
		setElementData(target2, "mandat:timer", false, false);
		setElementData(target2, "mandat:opis", false, false);
		setElementData(player, "mandat:wystawil", false, false);

		exports['dmta_base_notifications']:addNotification(player, "Mandat dla gracza " .. getPlayerName(target2) .. " wygasł", 'info');
	end, 30000, 1);

	setElementData(target2, "mandat:timer", timer, false);
end
addCommandHandler("mandat", cmd_mandat);

function cmd_przyjmij(player, command)
	if not getElementData(player, "mandat") then return false; end

	local kto = getElementData(player, "mandat:kto");
	local opis = getElementData(player, "mandat:opis");
	local kwota = getElementData(player, "mandat:kwota");
	local timer = getElementData(player, "mandat:timer"); 

	if getPlayerMoney(player) < kwota then
		exports['dmta_base_notifications']:addNotification(player, "Nie stać cię na zapłatę tego mandatu", "error");
		exports['dmta_base_notifications']:addNotification(kto, "Gracza nie stać na zapłacenie mandatu", "error");
	else
		takePlayerMoney(player, kwota)
		exports['dmta_base_notifications']:addNotification(player, "Zapłaciłeś mandat", 'success');
		givePlayerMoney(kto, kwota/4)


		local text_log = getPlayerName(kto)..' > '..getPlayerName(player)..' kwota: '..kwota..' opis: '..opis
			exports['dmta_base_duty']:addLogs('fac', text_log, player, 'MANDAT')
	end

	if isTimer(timer) then killTimer(timer); end

	setElementData(player, "mandat", false, false);
	setElementData(player, "mandat:kwota", false, false);
	setElementData(player, "mandat:kto", false, false);
	setElementData(player, "mandat:opis", false, false);
	setElementData(player, "mandat:timer", false, false);
	setElementData(kto, "mandat:wystawil", false, false);
end
addCommandHandler("przyjmij", cmd_przyjmij);

function cmd_odrzuc(player, command)
	if not getElementData(player, "mandat") then return false; end

	local kto = getElementData(player, "mandat:kto");

	exports['dmta_base_notifications']:addNotification(player, "Odrzucasz wystawiony mandat", player);
	exports['dmta_base_notifications']:addNotification(kto, "Gracz " .. getPlayerName(player) .. " odrzucił wystawiony mandat", kto);

	if isTimer(timer) then killTimer(timer); end

	setElementData(player, "mandat", false, false);
	setElementData(player, "mandat:kwota", false, false);
	setElementData(player, "mandat:kto", false, false);
	setElementData(player, "mandat:opis", false, false);
	setElementData(player, "mandat:timer", false, false);
	setElementData(kto, "mandat:wystawil", false, false);
end
addCommandHandler("odrzuc", cmd_odrzuc);




function data()
	local t = getRealTime()
	local r = t.year
	local m = t.month
	local t = t.monthday
	r = r+1900
	m = m+1 
	if t < 10 then
		t = "0"..t
	end
	return r.."-"..m.."-"..t
end

function czas()
	local t = getRealTime()
	local h = t.hour
	local m = t.minute
	return h..":"..m
end