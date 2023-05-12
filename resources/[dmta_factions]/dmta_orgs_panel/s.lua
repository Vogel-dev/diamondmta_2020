--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--


addEvent("zaproszenie:org", true)
addEventHandler("zaproszenie:org", resourceRoot, function(player, org, thisPlayer, oferta)
	if oferta == true then
		exports["dmta_base_notifications"]:addNotification("Odrzuciłeś propozycję dołączenia do grupy przestępczej: "..org.."", player)
		thisPlayer = getPlayerFromName(thisPlayer)
		if thisPlayer then
			exports["dmta_base_notifications"]:addNotification(""..getPlayerName(player).." odrzucił propozycję dołączenia do grupy przestępczej", thisPlayer)
		end
	else
		exports["dmta_base_notifications"]:addNotification("Zaakceptowałeś propozycję dołączenia do grupy przestępczej: "..org.."", player)
		thisPlayer = getPlayerFromName(thisPlayer)
		if thisPlayer then
			exports["dmta_base_notifications"]:addNotification(""..getPlayerName(player).." zaakceptował propozycję dołączenia do grupy przestępczej", thisPlayer)
		end
		setElementData(player, "user:oname", org)
		setElementData(player, "user:oranga", 1)
		local q = exports['dmta_base_connect']:query("select * from db_organizations where organizacja=?", org)
		setElementData(player, "user:odata", q)
		exports['dmta_base_connect']:query("update db_users set org=? where id=?", q[1]["id"], getElementData(player, "user:dbid"))
	end
end)

addEvent("org:addgracz", true)
addEventHandler("org:addgracz", resourceRoot, function(client, nick)
	local q2 = exports['dmta_base_connect']:query("select * from db_users where login=?", getPlayerName(client))
	if q2[1]["orank"] == 4 or q2[1]["orank"] == 3 then
		local target = findPlayer(client, nick)
		if not target then 
			exports["dmta_base_notifications"]:addNotification("Nie znaleziono podanego gracza.", client)
			return 
		end
		if getElementData(target, "user:oname") then
			exports["dmta_base_notifications"]:addNotification(""..getPlayerName(target).." posiada organizacje.", client, "error")
			return
		end
		local org = getElementData(client, "user:oname")
		exports["dmta_base_notifications"]:addNotification("Wysłano propozycję dołączenia do grupy przestępczej dla gracza: "..getPlayerName(target).."", client)
		triggerClientEvent(target, "zaproszenie:org", resourceRoot, target, org, getPlayerName(client))
	end
end)

addEvent("org:kickgracz", true)
addEventHandler("org:kickgracz", resourceRoot, function(client, nick)
	local q2 = exports['dmta_base_connect']:query("select * from db_users where login=?", getPlayerName(client))
	if q2[1]["orank"] == 4 or q2[1]["orank"] == 3 then
	
		local q = exports['dmta_base_connect']:query("select * from db_users where login=?", nick)
	
		if q[1]["orank"] == 4 then
			exports["dmta_base_notifications"]:addNotification(client, "Nie możesz wyrzucić lidera.", "error")
			return
		end
	
		if q[1]["orank"] == 3 and q2[1]["orank"] ~= 4 then
			exports["dmta_base_notifications"]:addNotification(client, "Nie możesz wyrzucić vice-lidera nie będąc liderem.", "error")
			return
		end
	
		exports['dmta_base_connect']:query("update db_users set orank=1,org=0 where login=?", nick)
		exports["dmta_base_notifications"]:addNotification(client, ""..nick.." został wyrzucony z grupy przestępczej.", 'info')
	
		local target = findPlayer(client, nick)
		if target then
			exports["dmta_base_notifications"]:addNotification(target, "Zostałeś wyrzucony z grupy przestępczej "..q2[1]["org"].."", 'info')
			setElementData(target, "user:oname", false)
			setElementData(target, "user:odata", false)
			setElementData(target, "user:oranga", 1)
		end
	end
end)

addEvent("org:editgracz", true)
addEventHandler("org:editgracz", resourceRoot, function(client, rank, player, rank2)
	local q2 = exports['dmta_base_connect']:query("select * from db_users where login=?", getPlayerName(client))
	if q2[1]["orank"] == 4 or q2[1]["orank"] == 3 then
	
		local q = exports['dmta_base_connect']:query("select * from db_users where login=?", player)
		if q[1]["orank"] == 4 then
			exports["dmta_base_notifications"]:addNotification(client, "Nie możesz edytować lidera.", "error")
			return
		end
		
		if q2[1]["orank"] == 3 and rank == 3 then
			exports["dmta_base_notifications"]:addNotification(client, "Nie możesz nikomu dać vice-lidera.", "error")
			return
		end
		exports['dmta_base_connect']:query("update db_users set orank=? where login=?", rank, player)
		exports["dmta_base_notifications"]:addNotification(client, "Edytowano gracza "..player.." na rangę "..rank2.."", 'info')
		local target = findPlayer(client, player)
		if target then
			setElementData(target, "user:oranga", tonumber(rank))
			exports["dmta_base_notifications"]:addNotification(target, "Twoje informacje w grupie przestępczej zostały zaaktualizowane.", 'info')
		end
	end
end)

addCommandHandler("opuscgrupe", function(client)
	local rank = exports['dmta_base_connect']:query("select * from db_users where id=?", getElementData(client, "user:dbid"))
	if rank and #rank > 0 then
		if rank[1]["orank"] ~= 4 then
			exports['dmta_base_connect']:query("update db_users set org=0,orank=1 where id=?", getElementData(client, "user:dbid"))
			exports["dmta_base_notifications"]:addNotification(client, "Opuściłeś grupe o nazwie "..getElementData(client, "user:oname").."", 'info')
			setElementData(client, "user:oname", false)
			setElementData(client, "user:odata", false)
			setElementData(client, "user:oranga", 1)
		end
	end
end)

function orgGetPlayers(org)
	local q2 = exports['dmta_base_connect']:query("select * from db_organizations where organizacja=?", org)
	local q1 = exports['dmta_base_connect']:query("select * from db_users where org=?", q2[1].id)
	triggerClientEvent(source, "uzupelnijListe", source, q1, q2[1])
end
addEvent("orgGetPlayers", true)
addEventHandler("orgGetPlayers", getRootElement(), orgGetPlayers)

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