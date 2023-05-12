--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

addEventHandler("onResourceStart", resourceRoot, function ()
	local justcola = createColSphere(1009.6138305664,-1340.8422851563,13.365922927856, 3);
	addEventHandler("onColShapeHit", justcola, enter);
	addEventHandler("onColShapeLeave", justcola, exit);
end);

function enter(hit, dim)
	addCommandHandler("podnies", cmd_zbadaj);
	outputChatBox("#fada5e● #ffffffNa podłodze dostrzegasz znajomą puszkę.", hit, 255, 255, 255, true)
	outputChatBox("#fada5e● #ffffffAby podnieś puszkę z ziemi wpisz #969696/puszka", hit, 255, 255, 255, true)
end

function exit(hit, dim)
	removeCommandHandler("puszka", cmd_zbadaj);
end

function cmd_zbadaj(plr, cmd)
	local odkryl = getElementData(plr, "user:justcola") or 0;

	if odkryl == 0 then
		setElementData(plr, "user:justcola", 1);
		exports['dmta_base_connect']:query("UPDATE db_users SET justcola=1 WHERE id=?", getElementData(plr, "user:dbid"));

		triggerEvent("odegrajRp:eq", plr, plr, "#969696*"..getPlayerName(plr).." podnosi z ziemi Just Cole.");

		outputChatBox("#69bceb● #ffffffOstatnia puszka JustColi", plr, 255, 255, 255, true)
		outputChatBox("#69bceb● #ffffffOstatnio widziana 3 lata temu", plr, 255, 255, 255, true)

		local punkty = getElementData(plr, "user:reputation");
		setElementData(plr, "user:reputation", punkty + 250);

		exports['dmta_base_notifications']:addNotification(plr, "Za znalezienie ostatniej puszki JustColi otrzymujesz 250 respektu.", 'success');
	end
end