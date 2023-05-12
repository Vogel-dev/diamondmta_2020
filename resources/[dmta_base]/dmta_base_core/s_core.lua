--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

--blipy
--[[
local blip1 = createBlip(1481.9185791016,-1766.3193359375,18.795755386353, 19)
local blip2 = createBlip(1359.9744873047,-1274.7375488281,13.3828125, 15)
local blip3 = createBlip(1400.6298828125,-1616.7005615234,13.539485931396, 28)
local blip4 = createBlip(2820.3215332031,-1617.0899658203,11.088542938232, 17)
local blip5 = createBlip(1175.2008056641,-1323.4342041016,14.390625, 22)
local blip6 = createBlip(1733.04296875,-1746.0086669922,13.535557746887, 27)
local blip7 = createBlip(1544.1110839844,-1675.5170898438,13.557769775391, 30)
local blip8 = createBlip(1073.1667480469,-1384.8074951172,13.868677139282, 45)
local blip9 = createBlip(1785.1203613281,-2052.1770019531,13.576071739197, 51)
local blip10 = createBlip(1310.1888427734,-1366.7958984375,13.506487846375, 39)
local blip11 = createBlip(1774.3751220703,-1723.6434326172,13.546875, 38)
local blip12 = createBlip(1009.1525268555,-1368.1472167969,13.342638015747, 35)
setBlipVisibleDistance(blip1, 10)
setBlipVisibleDistance(blip2, 10)
setBlipVisibleDistance(blip3, 10)
setBlipVisibleDistance(blip4, 10)
setBlipVisibleDistance(blip5, 10)
setBlipVisibleDistance(blip6, 10)
setBlipVisibleDistance(blip7, 10)
setBlipVisibleDistance(blip8, 10)
setBlipVisibleDistance(blip9, 10)
setBlipVisibleDistance(blip10, 10)
setBlipVisibleDistance(blip11, 10)
setBlipVisibleDistance(blip12, 10)--]]

local discordczas = getRealTime()
local forbidden = {"4life", "pylife", "pyl", "newplace", "new", "place", "west", "westrpg"};
--local forbidden = {"cholera", "cholernie", "spierdalaj", "jebac", "pizda", "pierdolona", "pierdolony", "wypierdalaj", "wypierdalam", "wypierdalamy", "wypierdala", "wypierdalają", "chuj", "chujowo", "chujnia", "huj", "hujowo", "hujnia", "chujostwo", "hujostwo", "chuje", "huje", "ciota", "cipa", "ciul", "cwel", "kurwa", "kurwy", "kurwo", "zjeb", "zjebie", "zjebało", "zajebał", "zjebał", "zjebała", "zajebało", "jebany", "zajebała", "pierdolić", "pierdole", "pierdolę", "zajebala", "pierdolic"};

function checkForBadWords(message)
	for k,v in ipairs(forbidden) do
		local fakeMessage = utf8.lower(message);
		local startPosition, endPosition = utf8.find(fakeMessage, v);
		if startPosition and endPosition then
			local word = utf8.sub(message, startPosition, endPosition);
			message = utf8.gsub(message, word, string.rep("*", word:len()));
		end
	end
	return message;
end

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

addCommandHandler("komendy", function(player)
	if getElementData(player, "user:dbid") ~= 1 then return end
      local commandsList = {}
      for _, subtable in pairs( getCommandHandlers() ) do
     	local commandName = subtable[1]
     	local theResource = subtable[2]
            
        if not commandsList[theResource] then
        	commandsList[theResource] = {}
      	end
          
      	table.insert( commandsList[theResource], commandName )
      end
      for theResource, commands in pairs( commandsList ) do
      	local resourceName = getResourceInfo( theResource, "name" ) or getResourceName( theResource ) 
      	outputChatBox( "	#69bceb● #ffffff"..resourceName.. " #69bceb●", player, 255, 255, 255, true)
            
		  for _, command in pairs( commands ) do
        	outputChatBox( "	#00ff00● #ffffff/"..command, player, 255, 255, 255, true)
      	end
      end
end)

addCommandHandler("money.all", function(gracz, _, ilosc)
	if getElementData(gracz, "rank:duty") ~= 4 then return end
	outputChatBox("#69bceb● #ffffffPrezydent miasta podarował każdemu zasiłek w wysokości: #969696"..ilosc.." #00ff00$", root, 210, 210, 210, true)
	for i,v in ipairs(getElementsByType("player")) do
		if getElementData(v, "user:dbid") then
			givePlayerMoney(v, ilosc)
		end
	end
end)

addEventHandler("onVehicleStartEnter", root, function(g, s)
	if s ~= 0 then return end
	if getVehicleController(source) and getVehicleController(source) ~= g then
		cancelEvent()
	end
end)

addCommandHandler("data.get", function(player, _, jaka)
	if getElementData(player, "rank:duty") ~= 4 then return end
	if not jaka then return end
	if not getElementData(player, jaka) then outputChatBox("#ff0000● #ffffffNie posiadasz takiej elementy-daty", player, 255, 0, 0, true) return end
	tekst = getElementData(player, jaka)
	if getElementData(player, jaka) == false then tekst = "false" end
	if getElementData(player, jaka) == true then tekst = "true" end
	outputChatBox("#00ff00● #ffffffDATA.GET #969696"..jaka.."#ffffff: #00ff00"..tekst, player, 0, 255, 0, true)
end)

addCommandHandler("data.set", function(player, _, jaka, wartosc)
	if getPlayerSerial(player) == "F5686A30BDBAB03643105204222F28F3" then
	if not jaka or not wartosc then return end
	if getElementData(player, jaka) then
		outputChatBox("#00ff00● #ffffffDATA.SET #969696"..jaka.."#ffffff: #969696"..getElementData(player, jaka).." #ffffff> #00ff00"..wartosc, player, 0, 255, 0, true)
	else
		outputChatBox("#00ff00● #ffffffDATA.SET #969696"..jaka.."#ffffff: #00ff00"..wartosc, player, 0, 255, 0, true)
	end
	setElementData(player, jaka, wartosc)
	end
end)

local db = exports['dmta_base_connect']
local noti = exports['dmta_base_notifications']
local duty = exports['dmta_base_duty']

addCommandHandler("dc", function(player, _, ...)
	if(... and getElementData(player, "user:premium"))then
		if isPlayerHaveMute(player) then return end
		local text = table.concat({...}, " ")
		local hex = '#8d8d8d'
		if getElementData(player, 'rank:duty') and getElementData(player, 'rank:duty') == 1 then
			hex = '#006400'
		elseif getElementData(player, 'rank:duty') and getElementData(player, 'rank:duty') == 2 then
			hex = '#f28600'
		elseif getElementData(player, 'rank:duty') and getElementData(player, 'rank:duty') == 3 then
			hex = '#ff0000'
		elseif getElementData(player, 'rank:duty') and getElementData(player, 'rank:duty') == 4 then
			hex = '#960000'
		elseif getElementData(player, 'user:premium') then
			hex = '#69bceb'
		end
		for i,v in pairs(getElementsByType("player")) do
			if(getElementData(v, "user:premium"))then
				outputChatBox("#69bceb★ #d2d2d2"..getPlayerName(player).." #69bceb["..hex..""..getElementData(player, "user:id").."#69bceb]: #d2d2d2"..text, v, 105, 188, 235, true)
			end
		end
		local text_log = 'DC> '..getPlayerName(player)..' /'..getElementData(player, 'user:id')..': '..text
		duty:addLogsDuty(text_log)
		duty:addLogs('czat', text, player, 'DC')
	end
end)

addCommandHandler("ooc", function(g, _, ...)
	if not ... then return end
	local nick = getPlayerName(g)
	local id = getElementData(g, "user:id") or 0
	--[[
	local spr = exports["smta_base_db"]:wykonaj("SELECT * FROM smtadb_mute WHERE serial=? AND data>NOW()", getPlayerSerial(g))
		if #spr > 0 then
			outputChatBox("Jesteś wyciszony przez "..spr[1].admin.." z powodu '"..spr[1].powod.."' do "..spr[1].data, g, 255, 0, 0)
			setElementData(g, "user:mute", true)
		else
			exports["smta_base_db"]:wykonaj("DELETE FROM smtadb_mute WHERE serial=?", getPlayerSerial(g))
			setElementData(g, user:"mute", false)
		end
		--]]
		if isPlayerHaveMute(g) then return end
	local wiadomosc = table.concat({...}, " ")
	local hex = '#8d8d8d'
		if getElementData(g, 'rank:duty') and getElementData(g, 'rank:duty') == 1 then
			hex = '#006400'
		elseif getElementData(g, 'rank:duty') and getElementData(g, 'rank:duty') == 2 then
			hex = '#f28600'
		elseif getElementData(g, 'rank:duty') and getElementData(g, 'rank:duty') == 3 then
			hex = '#ff0000'
		elseif getElementData(g, 'rank:duty') and getElementData(g, 'rank:duty') == 4 then
			hex = '#960000'
		elseif getElementData(g, 'user:premium') then
			hex = '#69bceb'
		end
	local x, y, z = getElementPosition(g)
	local cuboid = createColSphere(x, y, z, 50)
	local wCuboid = getElementsWithinColShape(cuboid, "player")	
	wiadomosc = string.gsub(wiadomosc, "#%x%x%x%x%x%x", "")
	local text_log = 'OOC> '..getPlayerName(g)..' /'..getElementData(g, 'user:id')..': '..wiadomosc
		duty:addLogsDuty(text_log)
		duty:addLogs('czat', wiadomosc, g, 'OOC')
	destroyElement(cuboid)
	for _, p in ipairs(wCuboid) do
		local nick = getPlayerName(g)
		wiadomosc = string.gsub(wiadomosc, "#%x%x%x%x%x%x", "")
		outputChatBox("#545454OOC #989898"..nick.." #545454["..hex..""..getElementData(g, "user:id").."#545454]: #989898"..wiadomosc, p, 105, 188, 235, true)
	end
end)

function getElementsWithinDistance(element, type, distance)
	local myPos = {getElementPosition(element)}
	local elements = {}
	for i,v in pairs(getElementsByType(type), true) do
		local vPos = {getElementPosition(v)}
		local dist = getDistanceBetweenPoints3D(myPos[1], myPos[2], myPos[3], vPos[1], vPos[2], vPos[3])
		if dist <= distance then
			table.insert(elements, v)
		end
	end
	return elements
end

function outputChatWithDistance(player, text, distance)
	local inShape = getElementsWithinDistance(player, 'player', distance)
	for i,v in pairs(inShape) do
		if getElementData(player,"kominiarka") == true and getElementDimension(player) == getElementDimension(v) and getElementInterior(player) == getElementInterior(v) then
			outputChatBox('* Zamaskowany #'..string.format('%02d', string.sub(getElementData(player, 'user:dbid'), 1, 2))..''..string.sub(getPlayerSerial(player), 1, 3)..' '..text, v, 150, 150, 150, false)
		elseif getElementData(player,"kominiarka") == false or getElementData(player,"kominiarka") == nil and getElementDimension(player) == getElementDimension(v) and getElementInterior(player) == getElementInterior(v) then
			outputChatBox('* '..getPlayerName(player)..' '..text, v, 150, 150, 150, false)
		end
	end
end

function isPlayerHaveMute(player)
	local q = db:query('select * from db_punishments where (serial=? or ip=? or nick=?) and active=1 and type=? and date>now() limit 1', getPlayerSerial(player), getPlayerIP(player), getPlayerName(player), 'mute')
	if q and #q > 0 then
		outputChatBox("#ff0000● #ffffffJesteś wyciszony i nie możesz pisać wiadomości", player, 255, 255, 255, true)
		return true
	else
		db:query('update db_punishments set active=0 where (serial=? or ip=? or nick=?) and type=? limit 1',getPlayerSerial(player), getPlayerIP(player), getPlayerName(player), 'mute')

		setElementData(player, 'user:mute', false)
	end
	return false
end

function getIpInText(ip)
    if ip == nil or type(ip) ~= 'string' then
        return false
    end
    local chunks = {ip:match('(%d+)%.(%d+)%.(%d+)%.(%d+)')}
    if (#chunks == 4) then
        for _,v in pairs(chunks) do
            if (tonumber(v) < 0 or tonumber(v) > 255) then
                return false
			else
			return true
			end
        end
    end
    return false
end

local cmd = {
	tick = getTickCount(),
	ms = 500
}

addEventHandler('onPlayerCommand', root, function(command)
	if (getTickCount()-cmd['tick']) < cmd['ms'] then
		cancelEvent()
	else
		cmd['tick'] = getTickCount()
	end
end)

addEventHandler('onResourceStart', resourceRoot, function()
	setGameType('RPG/RP')
	setMapName('RPG/RP')

	setRuleValue('script', 'Vogel')
	setRuleValue('map', 'Dudek')
	setRuleValue('graphic', 'Vogel')
	--setTime((getRealTime().hour), (getRealTime().minute))
	--setTime(22, 22)
	
	setFPSLimit(60)
	setOcclusionsEnabled(false)
	setWeather(7)

	--removeWorldModel(6192, 80, 929.05310058594, -1539.4201660156, 27.65468788147) -- usuniecie okien kolo salonu
end)
--[[
addCommandHandler('pm', function(player, _, target, ...)
	if target and ... then
		local text = table.concat({...}, ' ')
		if getIpInText(text) then return end

		target = findPlayer(target)
		if target and isElement(target) and target ~= player and not isPlayerHaveMute(player) then
			outputChatBox('#0072ff>>#dda764 '..getPlayerName(target)..' #0072ff[#dda764'..getElementData(target, 'user:id')..'#0072ff]#dda764: '..text, player, _, _, _, true)
			outputChatBox('#0072ff<<#dda764 '..getPlayerName(player)..' #0072ff[#dda764'..getElementData(player, 'user:id')..'#0072ff]#dda764: '..text, target, _, _, _, true)

			local text_log = '[PM] '..getPlayerName(player)..' ('..getElementData(player, 'user:id')..') > '..getPlayerName(target)..' ('..getElementData(target, 'user:id')..'): '..text
			duty:addLogsDuty(text_log)

			local _text_log = '> '..getPlayerName(target)..': '..text
			duty:addLogs('czat', _text_log, player, 'PM')

			playSoundFrontEnd(target, 43)
			setElementData(target, 'user:re', player)
		else
			noti:addNotification(player, 'Nie znaleziono podanego gracza.', 'error')
		end
	else
		noti:addNotification(player, 'Użyj: /pm <id/nick> <treść>', 'info')
	end
end)

addCommandHandler('re', function(player, _, ...)
	if ... then
		local text = table.concat({...}, ' ')
		if getIpInText(text) then return end

		local target = getElementData(player, 'user:re')
		if target and isElement(target) and target ~= player and not isPlayerHaveMute(player) then
			outputChatBox('#0072ff>>#dda764 '..getPlayerName(target)..' #0072ff[#dda764'..getElementData(target, 'user:id')..'#0072ff]#dda764: '..text, player, _, _, _, true)
			outputChatBox('#0072ff<<#dda764 '..getPlayerName(player)..' #0072ff[#dda764'..getElementData(player, 'user:id')..'#0072ff]#dda764: '..text, target, _, _, _, true)

			local text_log = '[PM] '..getPlayerName(player)..' ('..getElementData(player, 'user:id')..') > '..getPlayerName(target)..' ('..getElementData(target, 'user:id')..'): '..text
			duty:addLogsDuty(text_log)

			local _text_log = '> '..getPlayerName(target)..': '..text
			duty:addLogs('czat', _text_log, player, 'PM')

			playSoundFrontEnd(target, 43)
			setElementData(target, 'user:re', player)
		end
	end
end)

function pm(player, _, target, ...)
	if not getElementData(player, "user:logged") then return end
	if target and ... then
		
		local spr = exports["smta_base_db"]:wykonaj("SELECT * FROM smtadb_mute WHERE serial=? AND data>NOW()", getPlayerSerial(player))
		if #spr > 0 then
			outputChatBox("Jesteś wyciszony przez "..spr[1].admin.." z powodu '"..spr[1].powod.."' do "..spr[1].data, player, 255, 0, 0)
			setElementData(player, "mute", true)
		else
			exports["smta_base_db"]:wykonaj("DELETE FROM smtadb_mute WHERE serial=?", getPlayerSerial(player))
			setElementData(player, "mute", false)
		end
		----
		if getElementData(player, "user:mute") then 
			noti:addNotification(player, 'Jesteś wyciszony i nie możesz pisać wiadomości.', 'error')
			return end
		local tresc = table.concat({...}, " ")
		if getIpInText(text) then return end
		target = findPlayer2(player, target)
		if not target then
			noti:addNotification(player, 'Nie znaleziono podanego gracza.', 'error')
			return
		end
		if getElementData(target, "poff") then
			noti:addNotification(player, "Podana osoba posiada wyłączone prywatne wiadomości z powodu "..getElementData(target, "poff"), 'info')
			return
		end
		local idh = getElementData(target, "user:id")
		local id = getElementData(player, "user:id")
		setElementData(target, 'user:re', player)
		outputChatBox("#d2d2d2>>#dda764 "..getPlayerName(target).."#b6884e [#dda764"..idh.."#b6884e]#d2d2d2: "..checkForBadWords(tresc), player, 255, 255, 255, true)
		outputChatBox("#d2d2d2<<#dda764 "..getPlayerName(player).."#b6884e [#dda764"..id.."#b6884e]#d2d2d2: "..checkForBadWords(tresc), target, 255, 255, 255, true)
		local text_log = 'PM> '..getPlayerName(player)..' /'..getElementData(player, 'user:id')..' > '..getPlayerName(target)..' /'..getElementData(target, 'user:id')..': '..tresc
			duty:addLogsDuty(text_log)
			local _text_log = '> '..getPlayerName(target)..': '..tresc
			duty:addLogs('czat', _text_log, player, 'PM')
	end
end
addCommandHandler("pm", pm)
addCommandHandler("pw", pm)

function pmoff(player, _, ...)
	if not getElementData(player, "poff") then
		local powod = table.concat({...}, " ")
		if not ... then 
			powod = "brak powodu"
		end
		noti:addNotification(player, "Wyłączyłeś prywatne wiadomości z powodu "..powod, "success")
		setElementData(player, "poff", powod)
	end
end
addCommandHandler("pmoff", pmoff)
addCommandHandler("pwoff", pmoff)

function pmon(player, _)
	if getElementData(player, "poff") then
		noti:addNotification(player, "Włączyłeś prywatne wiadomości", "success")
		setElementData(player, "poff", false)
	end
end
addCommandHandler("pmon", pmon)
addCommandHandler("pwon", pmon)
--]]

function sms(player, _, target, ...)
	if not getElementData(player, "user:logged") then return end
	if not getElementData(player, "user:sms") then outputChatBox("#ff0000● #ffffffPosiadasz wyłączony telefon lub go nie posiadasz, nie możesz wysyłać wiadomości.", player, 255, 255, 255, true) return end
	if target and ... then
		if getElementData(player, "user:mute") then 
			outputChatBox("#ff0000● #ffffffJesteś wyciszony i nie możesz pisac wiadomości.", player, 255, 255, 255, true)
			return end
		local tresc = table.concat({...}, " ")
		if getIpInText(text) then return end
		target = findPlayer2(player, target)
		if not target then
			outputChatBox("#ff0000● #ffffffPodany numer nie został odnaleziony.", player, 255, 255, 255, true)
			return
		end
		if not getElementData(target, "user:sms") then
			outputChatBox("#ff0000● #ffffffPodany numer posiada wyłączony telefon.", player, 255, 255, 255, true)
			return
		end
		local idh = getElementData(target, "user:id")
		local id = getElementData(player, "user:id")
		setElementData(target, 'user:re', player)
		playSoundFrontEnd(target, 5)
		outputChatBox("#d2d2d2SMS do * #dda764 "..getPlayerName(target).."#b6884e [#dda764"..idh.."#b6884e]#d2d2d2: "..checkForBadWords(tresc), player, 255, 255, 255, true)
		outputChatBox("#d2d2d2SMS od * #dda764 "..getPlayerName(player).."#b6884e [#dda764"..id.."#b6884e]#d2d2d2: "..checkForBadWords(tresc), target, 255, 255, 255, true)
		local text_log = 'SMS> '..getPlayerName(player)..' /'..getElementData(player, 'user:id')..' > '..getPlayerName(target)..' /'..getElementData(target, 'user:id')..': '..tresc
			duty:addLogsDuty(text_log)
			local _text_log = '> '..getPlayerName(target)..': '..tresc
			duty:addLogs('czat', _text_log, player, 'SMS')
	end
end
addCommandHandler("sms", sms)

function formatMoney(money)
	while true do
		money, i = string.gsub(money, '^(-?%d+)(%d%d%d)', '%1,%2')
		if i == 0 then
			break
		end
	end
	return money
end

function przelej(player, _, kplayer, ilosc)
	if not player or not kplayer or not ilosc then
		outputChatBox("#ff0000● #ffffffUżycie: /przekaz <id/nick> <kwota>", player, 255, 255, 255, true)
	    return
	end
	kplayer = findPlayer2(player, kplayer)
	if not kplayer then
		outputChatBox("#ff0000● #ffffffNie znaleziono podanego przez Ciebie gracza.", player, 255, 255, 255, true)
	    return
	end
	local x, y, z = getElementPosition(player)
	local tx, ty, tz = getElementPosition(kplayer)
	local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
	if distance < 10 then
	
	if kplayer == player then
		outputChatBox("#ff0000● #ffffffNie możesz przekazać sobie pieniędzy.", player, 255, 255, 255, true)
		return
	end
	if getElementData(player, "user:dbid") == getElementData(kplayer, "user:dbid") then
		outputChatBox("#ff0000● #ffffffNie możesz przekazać sobie pieniędzy.", player, 255, 255, 255, true)
		return
	end
	 if not tonumber(ilosc) then
		outputChatBox("#ff0000● #ffffffWprowadzona wartość nie jest liczbą.", player, 255, 255, 255, true)
   		return
  	end
	local ile = tonumber(ilosc)
	if ile == 0 or ile < 0 then
		outputChatBox("#ff0000● #ffffffWprowadzona wartość musi być większa od 0", player, 255, 255, 255, true)
		return
	end
	
	if getPlayerMoney(player) >= tonumber(ilosc) then
		givePlayerMoney(kplayer, ilosc)
		takePlayerMoney(player, ilosc)

		outputChatBox('#00ff00● #ffffffPrzekazujesz #969696'..formatMoney(ilosc)..' #00ff00$ #ffffffgraczowi #969696'..getPlayerName(kplayer)..' ', player, 255, 255, 255, true)
		outputChatBox('#00ff00● #ffffffOtrzymujesz #969696'..formatMoney(ilosc)..' #00ff00$ #ffffffod gracza #969696'..getPlayerName(player)..' ', kplayer, 255, 255, 255, true)
		triggerEvent("odegrajRp:eq", player, player, "#969696*"..getPlayerName(player).." podaje pieniądze człowiekowi obok.")

		db:query('update db_users set money=money-? where login=?', ilosc, getPlayerName(player))
		db:query('update db_users set money=money+? where login=?', ilosc, getPlayerName(kplayer))

		local text_log = 'TRANSFER> '..getPlayerName(player)..' /'..getElementData(player, 'user:id')..' > '..getPlayerName(kplayer)..' /'..getElementData(kplayer, 'user:id')..': '..formatMoney(ilosc)..' USD'
		duty:addLogsDuty(text_log)

		  local text_database = {getPlayerName(kplayer)..' > '..formatMoney(ilosc)..' USD', getPlayerName(player)..' < '..formatMoney(ilosc)..'USD'}
		duty:addLogs('przelew', text_database[1], player, 'PRZEKAZANE')
		duty:addLogs('przelew', text_database[2], kplayer, 'OTRZYMANE')
	else
		outputChatBox("#ff0000● #ffffffNie posiadasz wystarczająco funduszy.", player, 255, 255, 255, true)
	end
else
	outputChatBox("#ff0000● #ffffffPodany przez Ciebie gracz znajduje się za daleko.", player, 255, 255, 255, true)
end
end
addCommandHandler("dajkase", przelej)
addCommandHandler("zaplac", przelej)
addCommandHandler("przelej", przelej)
addCommandHandler("przekaz", przelej)

addCommandHandler('do', function(player, _, ...)
	if ... and not isPlayerHaveMute(player) then
		local text = table.concat({...}, ' ')

		local getPlayersInColShape = getElementsWithinDistance(player, 'player', 25)
		for i,v in pairs(getPlayersInColShape) do
			if getElementData(player,"kominiarka") == true and getElementDimension(player) == getElementDimension(v) and getElementInterior(player) == getElementInterior(v) then
				outputChatBox('* '..text..' ((Zamaskowany #'..string.format('%02d', string.sub(getElementData(player, 'user:dbid'), 1, 2))..''..string.sub(getPlayerSerial(player), 1, 3)..'))', v, 61, 112, 255, false)
			elseif getElementData(player,"kominiarka") == nil or getElementData(player,"kominiarka") == false and getElementDimension(player) == getElementDimension(v) and getElementInterior(player) == getElementInterior(v) then
				outputChatBox('* '..text..' (('..getPlayerName(player)..'))', v, 61, 112, 255, false)
			end
		end

		local text_log = 'DO> '..getPlayerName(player)..' /'..getElementData(player, 'user:id')..': '..text
		duty:addLogsDuty(text_log, 'DO')

		duty:addLogs('czat', text, player, 'DO')
	end
end)

local letters = {
'?','!'
}

function findLetter(text)
	local delete = false
	for i,v in pairs(letters) do
		v = v..'.'

		if string.find(text:lower(), v:lower()) then
			delete = true
		end
	end

	if delete == true then
		text = string.sub(text, 1, string.len(text) - 1)
	end

	return text
end

function firstToUpper(text)
	return string.gsub(text, '^%l', string.upper)
end

addEventHandler('onPlayerChat', root, function(text, type)
	local player = source
	cancelEvent()

	if isPlayerHaveMute(player) then return end
	if getIpInText(text) then return end

	if type == 0 and (getTickCount()-cmd['tick']) < cmd['ms'] and text ~= ' ' then
		local getPlayersInColShape = getElementsWithinDistance(player, 'player', 25)

		local hex = '#8d8d8d'
		if getElementData(player, 'rank:duty') and getElementData(player, 'rank:duty') == 1 then
			hex = '#006400'
		elseif getElementData(player, 'rank:duty') and getElementData(player, 'rank:duty') == 2 then
			hex = '#f28600'
		elseif getElementData(player, 'rank:duty') and getElementData(player, 'rank:duty') == 3 then
			hex = '#ff0000'
		elseif getElementData(player, 'rank:duty') and getElementData(player, 'rank:duty') == 4 then
			hex = '#960000'
		elseif getElementData(player, 'user:premium') then
			hex = '#69bceb'
		end

		text = text .. '.'
		text = findLetter(text)
		text = firstToUpper(text)

		for i,v in pairs(getPlayersInColShape) do
			if getElementData(player,"kominiarka") == true and getElementDimension(player) == getElementDimension(v) and getElementInterior(player) == getElementInterior(v) then
				outputChatBox('#e5e5e5Zamaskowany #'..string.format('%02d', string.sub(getElementData(player, 'user:dbid'), 1, 2))..''..string.sub(getPlayerSerial(player), 1, 3)..' #ffffff['..hex..''..getElementData(player, 'user:id')..'#ffffff]: '..text:gsub('#%x%x%x%x%x%x', '') , v, 255, 255, 255, true)
			elseif getElementData(player,"kominiarka") == false or getElementData(player,"kominiarka") == nil and getElementDimension(player) == getElementDimension(v) and getElementInterior(player) == getElementInterior(v) then
      			outputChatBox('#e5e5e5 '..getPlayerName(player):gsub('#%x%x%x%x%x%x', '')..' #e5e5e5['..hex..''..getElementData(player, 'user:id')..'#e5e5e5]: '..text:gsub('#%x%x%x%x%x%x', '') , v, 255, 255, 255, true)
      		end
		end

		local text_log = 'CHAT> '..getPlayerName(player)..' /'..getElementData(player, 'user:id')..': '..text
		duty:addLogsDuty(text_log)

		duty:addLogs('czat', text, player, 'CHAT')

		cmd['tick'] = getTickCount()

		setElementData(player, 'last:mess', {text, getTickCount()})
		setTimer(function()
			if player and isElement(player) then
				setElementData(player, 'last:mess', false)
			end
		end, 5000, 1)
	elseif type == 1 and (getTickCount()-cmd['tick']) < cmd['ms'] and text ~= ' ' then
		outputChatWithDistance(player, text, 25)

		local text_log = 'ME> '..getPlayerName(player)..' /'..getElementData(player, 'user:id')..': '..text
		duty:addLogsDuty(text_log)

		duty:addLogs('czat', text, player, 'ME')
	end
end)

function krotkofalowkachat(plr, cmd, ...)
	local frakcja = getElementData(plr, "user:faction")
	if isPlayerHaveMute(plr) then return end
	if not frakcja then return end
	local msg = table.concat ( { ... }, " " )
	local text_log = "FRAKCJA/"..frakcja.."> "..getPlayerName(plr).." ["..getElementData(plr, "user:id").."] : "..msg
		duty:addLogsDuty(text_log)

		duty:addLogs('fac', msg, plr, 'FRAKCJA/'..frakcja..'')

	if string.find(msg, "#", 1) == 1 then
		for i,v in pairs(getElementsByType("player")) do
			if getElementData(v, "user:faction") then
				local msg = string.sub(msg, 2, #msg)
				outputChatBox("#5d8aa8FRAKCJA "..frakcja..">#ffffff "..getPlayerName(plr).." ["..getElementData(plr, "user:id").."] :#ffffff "..msg, v, 255, 0, 0, true)
			end
		end
	else
		for i,v in pairs(getElementsByType("player")) do
			if getElementData(v, "user:faction") == getElementData(plr, "user:faction") then
				outputChatBox("#5d8aa8FRAKCJA "..frakcja..">#ffffff "..getPlayerName(plr).." ["..getElementData(plr, "user:id").."] :#ffffff "..msg, v, 255, 0, 0, true)
			end
		end
	end
end
addCommandHandler("frakcja", krotkofalowkachat)

function allkrotkofalowkachat(plr, cmd, ...)
	local frakcja = getElementData(plr, "user:faction")
	if isPlayerHaveMute(plr) then return end
	if not frakcja then return end
	local msg = table.concat ( { ... }, " " )
	local frakcja = getElementData(plr, "user:faction")
	local text_log = "SŁUŻBY> "..getPlayerName(plr).." ["..getElementData(plr, "user:id").."] ["..frakcja.."] : "..msg
		duty:addLogsDuty(text_log)

		duty:addLogs('fac', msg, plr, 'SŁUŻBY')

	if string.find(msg, "#", 1) == 1 then
		for i,v in pairs(getElementsByType("player")) do
			if getElementData(v, "user:faction") then
				local msg = string.sub(msg, 2, #msg)
				outputChatBox("#00ff7fSŁUŻBY>#ffffff "..getPlayerName(plr).." ["..getElementData(plr, "user:id").."] ["..frakcja.."]:#ffffff "..msg, v, 255, 0, 0, true)
			end
		end
	else
		for i,v in pairs(getElementsByType("player")) do
			if getElementData(v, "user:faction") then
				outputChatBox("#00ff7fSŁUŻBY>#ffffff "..getPlayerName(plr).." ["..getElementData(plr, "user:id").."] ["..frakcja.."]:#ffffff "..msg, v, 255, 0, 0, true)
			end
		end
	end
end
addCommandHandler("sluzby", allkrotkofalowkachat)

function twitter(plr, cmd, ...)
	if isPlayerHaveMute(plr) then return end
	local koszt = 250
	if getElementData(plr, 'user:premium') then
		koszt = 125
	end
	if not getElementData(plr, 'user:sms') then outputChatBox("#ff0000● #ffffffAby pisać wiadomości na tweeterze, musisz mieć włączony telefon.", plr, 255, 255, 255, true) return end
	if getPlayerMoney(plr) < koszt then outputChatBox("#ff0000● #ffffffNie posiadasz #969696"..koszt.." #00ff00$ #ffffffna wysłanie wiadomości na tweeterze.", plr, 255, 255, 255, true) return end

	local hex = '#8d8d8d'
	if getElementData(plr, 'rank:duty') and getElementData(plr, 'rank:duty') == 1 then
		hex = '#006400'
	elseif getElementData(plr, 'rank:duty') and getElementData(plr, 'rank:duty') == 2 then
		hex = '#f28600'
	elseif getElementData(plr, 'rank:duty') and getElementData(plr, 'rank:duty') == 3 then
		hex = '#ff0000'
	elseif getElementData(plr, 'rank:duty') and getElementData(plr, 'rank:duty') == 4 then
		hex = '#960000'
	elseif getElementData(plr, 'user:premium') then
		hex = '#69bceb'
	end

	local msg = table.concat ( { ... }, " " )
	local text_log = "TWT> "..getPlayerName(plr).." /"..getElementData(plr, "user:id")..": "..msg
		duty:addLogsDuty(text_log)

		duty:addLogs('czat', msg, plr, 'TWT')
		takePlayerMoney(plr, 250)
		outputChatBox("#69bceb● #ffffffWiadomość na tweeterze kosztowała Cię #969696"..koszt.." #00ff00$", plr, 255, 255, 255, true)

	if string.find(msg, "#", 1) == 1 then
		for i,v in pairs(getElementsByType("player")) do
			if getElementData(v, "user:dbid") then
			if getElementData(v, "user:sms") then
				local msg = string.sub(msg, 2, #msg)
				outputChatBox("#4099ffTWEET ► #70b3ff"..getPlayerName(plr).." #666666["..hex..""..getElementData(plr, "user:id").."#666666]:#a0ccff "..msg, v, 255, 0, 0, true)
			end
		end
		end
	else
		for i,v in pairs(getElementsByType("player")) do
			if getElementData(v, "user:dbid") then
			if getElementData(v, "user:sms") then
				outputChatBox("#4099ffTWEET ► #70b3ff"..getPlayerName(plr).." #666666["..hex..""..getElementData(plr, "user:id").."#666666]:#a0ccff "..msg, v, 255, 0, 0, true)
			end
		end
		end
	end
end
addCommandHandler("twt", twitter)
addCommandHandler("tweet", twitter)

function orgchat(plr, cmd, ...)
	local org = getElementData(plr, "user:oname")
	if isPlayerHaveMute(plr) then return end
	if not org then return end

	local hex = '#8d8d8d'
	if getElementData(plr, 'rank:duty') and getElementData(plr, 'rank:duty') == 1 then
		hex = '#006400'
	elseif getElementData(plr, 'rank:duty') and getElementData(plr, 'rank:duty') == 2 then
		hex = '#f28600'
	elseif getElementData(plr, 'rank:duty') and getElementData(plr, 'rank:duty') == 3 then
		hex = '#ff0000'
	elseif getElementData(plr, 'rank:duty') and getElementData(plr, 'rank:duty') == 4 then
		hex = '#960000'
	elseif getElementData(plr, 'user:premium') then
		hex = '#69bceb'
	end

	local msg = table.concat ( { ... }, " " )
	local text_log = "ORG / "..getElementData(plr, "user:oname").."> "..getPlayerName(plr).." /"..getElementData(plr, "user:id")..": "..msg
		duty:addLogsDuty(text_log)

		duty:addLogs('fac', msg, plr, 'ORG / '..getElementData(plr, 'user:oname')..'')

	if string.find(msg, "#", 1) == 1 then
		for i,v in pairs(getElementsByType("player")) do
			if getElementData(v, "user:oname") then
				local msg = string.sub(msg, 2, #msg)
				outputChatBox("#666699✦ #8c8cb3"..org.." -#969696 "..getPlayerName(plr).." #666666["..hex..""..getElementData(plr, "user:id").."#666666]:#969696 "..msg, v, 255, 0, 0, true)
			end
		end
	else
		for i,v in pairs(getElementsByType("player")) do
			if getElementData(v, "user:oname") == getElementData(plr, "user:oname") then
				outputChatBox("#666699✦ #8c8cb3"..org.." -#969696 "..getPlayerName(plr).." #666666["..hex..""..getElementData(plr, "user:id").."#666666]:#969696 "..msg, v, 255, 0, 0, true)
			end
		end
	end
end
addCommandHandler("org", orgchat)

addEventHandler("onResourceStart", root, function()
	local players = getElementsByType("player")
	for _, p in pairs(players) do
		bindKey(p, "y", "down", "chatbox", "frakcja")
		bindKey(p, "u", "down", "chatbox", "sluzby")
		bindKey(p, "o", "down", "chatbox", "ooc")
	end
end)

addEventHandler( "onPlayerSpawn", getRootElement(), function()
	bindKey(source, "y", "down", "chatbox", "frakcja")
	bindKey(source, "u", "down", "chatbox", "sluzby")
	bindKey(source, "o", "down", "chatbox", "ooc")
end)

function findPlayer(target)
	for i,v in pairs(getElementsByType('player')) do
		if tonumber(target) then
			if getElementData(v, 'user:id') == tonumber(target) then
				return v
			end
		else
			if string.find(string.gsub(getPlayerName(v):lower(),'#%x%x%x%x%x%x', ''), target:lower(), 1, true) then
				return v
			end
		end
	end
	return false
end

function findPlayer2(player, target)
	for i,v in ipairs(getElementsByType("player")) do
		if tonumber(target) then
			if getElementData(v, "user:id") == tonumber(target) then
				return v
			end
		else
			if string.find(string.gsub(getPlayerName(v):lower(),"#%x%x%x%x%x%x", ""), target:lower(), 1, true) then
				return v
			end
		end
	end
end

function findFreeID(id)
	table.sort(id)
	local free = 1
	for i,v in pairs(id) do
		if v == free then
			free = free+1
		end
		if v > free then
			return free
		end
	end
	return free
end

addEventHandler('onPlayerJoin', root, function()
	local idt = {}
	for i,v in pairs(getElementsByType('player')) do
		if getElementData(v, 'user:id') then
			table.insert(idt, tonumber(getElementData(v, 'user:id')))
		end
	end
	local id = findFreeID(idt)
	setElementData(source, 'user:id', id)
end)
