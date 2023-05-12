--[[
@Author: Vogel
@Copyright: Vogel / Society MTA // 2019-2020
@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

function init()
    local biznesy = exports['dmta_base_connect']:query("select db_businesses.id,db_businesses.owner,db_businesses.cost,db_businesses.zajety,db_businesses.nazwa,db_businesses.saldo,db_businesses.xyz,db_businesses.data,db_users.login from db_businesses LEFT JOIN db_users on db_businesses.owner=db_users.id")
    for i,v in ipairs(biznesy) do
		stworz(v)
    end
end

local pickup = {}

local bramy = {}

function stworz(v)
	if not v.login then v.zajety="n" end
	v.xyz=split(v.xyz,",")
	biz = createPickup ( v.xyz[1], v.xyz[2], v.xyz[3], 3, 1274, 0 )
	local biz2 = biz
	local tw=createElement("text")
	local x2342=v.cost/2500
	local x234 = math.floor(x2342)
	if v.zajety == "n" then v.login = "Brak własciciela";v.data="Nie posiada własciciela" end
	local profit1 = math.floor(x234*60*24)
	local format1 = (""..v.nazwa.."\nKoszt: "..v.cost.." $\nWłasciciel: "..v.login.."\nUmowa trwa do: "..v.data.."\nPotencjalny dochód dzienny: "..profit1.." $")
	setElementData(tw, "text", format1)
	setElementPosition(tw, v.xyz[1], v.xyz[2], v.xyz[3]+0.8)
	setElementData(biz2, "cost", v.cost)
	setElementData(biz2, "z", v.zajety)
	setElementData(biz2, "name", v.nazwa)
	setElementData(biz2, "id", v.id)
	setElementData(biz2, "payday",x234)
	setElementData(biz2, "saldo",v.saldo)
	setElementData(biz2,"data",v.data)
	setElementData(biz2, "owner", v.owner)
end

function sprzedajbiznes(plr)
	if isElementWithinColShape(plr, getElementColShape(pickup[plr])) then
		local biz2 = pickup[plr]
		if getElementData(biz2, "z") == "n" then outputChatBox("#ff0000● #ffffffTen biznes posiada właściciela.", plr, 255, 255, 255, true) return end
		if tonumber(getElementData(biz2, "owner")) ~= tonumber(getElementData(plr, "user:dbid")) then outputChatBox("#ff0000● #ffffffTen biznes nie należy do Ciebie.", plr, 255, 255, 255, true) return end
		local cashit = getElementData(biz2, "cost")
		local lasthit2 = cashit/4
		local lasthit = math.floor(lasthit2)
		outputChatBox("#00ff00● #ffffffOtrzymujesz #969696"..lasthit.." #00fff00$ #ffffffza sprzedaż swojego biznesu #969696"..getElementData(biz2, "name").."", plr, 255, 255, 255, true)
		givePlayerMoney(plr, lasthit)
		exports['dmta_base_connect']:query("UPDATE db_businesses SET owner=?, zajety=?, saldo=0 WHERE id=?","brak", "n", getElementData(biz2, "id"))
		local text_log = getPlayerName(plr)..' sprzedał biznes '..getElementData(biz2, 'name')..' - otrzymał '..lasthit..' $'
		exports['dmta_base_duty']:addLogs('bus', text_log, plr, 'BUSINESS/SELL')
		restartResource(getThisResource())
	end
end
addEvent("sprzedaj:biznesy", true)
addEventHandler("sprzedaj:biznesy", root, sprzedajbiznes)

function kupbiznes(plr)
	if isElementWithinColShape(plr, getElementColShape(pickup[plr])) then
		local biz2 = pickup[plr]
		if getElementData(biz2, "z") == "t" then outputChatBox("#ff0000● #ffffffTen biznes posiada właściciela.", plr, 255, 255, 255, true) return end
		if getElementData(biz2, "z") == "n" then
			local bkoszt = getElementData(biz2, "cost")
			local hajs = getPlayerMoney(plr)
			if tonumber(bkoszt) > tonumber(hajs) then outputChatBox("#ff0000● #ffffffNie posiadasz #969696"..getElementData(biz2, "cost").." #00ff00$", plr, 255, 255, 255, true) return end
			local limit = exports['dmta_base_connect']:query("SELECT * FROM db_businesses WHERE owner=?", getElementData(plr,"user:dbid"))
			if #limit >= 1 then outputChatBox("#ff0000● #ffffffPosiadasz już jeden biznes.", plr, 255, 255, 255, true) return end
			outputChatBox("#00ff00● #ffffffPomyślnie zakupiłeś biznes o nazwie #969696"..getElementData(biz2, "name").." #ffffffza #969696"..getElementData(biz2, "cost").." #00ff00$ #969696na 3 dni!", plr, 255, 255, 255, true)
			takePlayerMoney(plr, bkoszt)
			setElementData(plr, 'user:biznesachv', true)
			local text_log = getPlayerName(plr)..' zakupił biznes '..getElementData(biz2, 'name')..' - zapłacił '..bkoszt..' $'
			exports['dmta_base_duty']:addLogs('bus', text_log, plr, 'BUSINESS/BUY')
			exports['dmta_base_connect']:query("UPDATE db_businesses SET zajety=?, owner=?, saldo=?, data = NOW() + INTERVAL 3 day WHERE id=?", "t", getElementData(plr, "user:dbid"), "0", getElementData(biz2, "id"))
			restartResource(getThisResource())
		end
	end
end
addEvent("kup:biznesy", true)
addEventHandler("kup:biznesy", root, kupbiznes)


function wyplac(plr)
	if isElementWithinColShape(plr, getElementColShape(pickup[plr])) then
		local biz2 = pickup[plr]
		if getElementData(biz2, "z") == "n" then outputChatBox("#ff0000● #ffffffTen biznes posiada właściciela.", plr, 255, 255, 255, true) return end
		if tonumber(getElementData(biz2, "owner")) ~= tonumber(getElementData(plr, "user:dbid")) then outputChatBox("#ff0000● #ffffffTen biznes nie należy do Ciebie.", plr, 255, 255, 255, true) return end
		local sal = exports['dmta_base_connect']:query("select saldo from db_businesses where id=?",getElementData(biz2,"id"))
		local saldo = sal[1].saldo
		if saldo < 1 then outputChatBox("#fada5e● #ffffffAby wypłacić pieniądze z biznesu saldo musi być większę niż #00ff001 $", plr, 255, 255, 255, true) return end
		givePlayerMoney(plr, saldo)
		outputChatBox("#00ff00● #ffffffPomyślnie wypłacileś #969696"..saldo.. " #00ff00$ #ffffffz biznesu.", plr, 255, 255, 255, true)
		exports['dmta_base_connect']:query("update db_businesses set saldo=0 where id=?", getElementData(biz2,"id"))
		local text_log = getPlayerName(plr)..' wypłacił z biznesu '..getElementData(biz2, 'name')..' - otrzymał '..saldo..' $'
		exports['dmta_base_duty']:addLogs('bus', text_log, plr, 'BUSINESS/WITHDRAW')
		restartResource(getThisResource())
	end
end
addEvent("wyplac:biznesy", true)
addEventHandler("wyplac:biznesy", root, wyplac)

function wbil ( hitElement )
	if getElementType(hitElement) ~= "player" then return end
	if getPedOccupiedVehicle(hitElement) then return end
	pickup[hitElement] = source
	local biznes = source
	local uid = getElementData(hitElement, "user:dbid")
	local wlasciciel = getElementData(biznes, "owner")
	local nazwa = getElementData(biznes, "name")
	local id = getElementData(biznes, "id")
	local koszt = getElementData(biznes, "cost")
	local saldo = getElementData(biznes, "saldo")
	local data = getElementData(biznes,"data")
	triggerClientEvent("gui:otworz", hitElement, hitElement, wlasciciel, nazwa, id, koszt,saldo,data)
end
addEventHandler ( "onPickupHit", resourceRoot, wbil )


function cmd(plr,cmd,cost,...)
if getElementData(plr, "rank:duty") > 3 then
 if not tonumber(cost) or #arg == 0 then
	outputChatBox("#ff0000● #ffffffUżycie: /biznes.create <koszt> <nazwa>", plr, 255, 255, 255, true)
  return
 end
local x,y,z=getElementPosition(plr)
local name2 = table.concat(arg, " ")
outputChatBox("#00ff00● #ffffffPomyślnie utworzyłeś nowy biznes o nazwie #969696"..name2.." #ffffffza koszt #969696"..cost.." #00ff00$", plr, 255, 255, 255, true)
exports['dmta_base_connect']:query("INSERT INTO db_businesses SET owner=?, xyz='?,?,?', cost=?, nazwa=?, zajety=?", "brak",x,y,z,tonumber(cost),tostring(name2),"n")
restartResource(getThisResource())
end
end
addCommandHandler("biznes.create", cmd)



function cmd4(plr,cmd,...)
if getElementData(plr, "duty") > 3 then
 if #arg == 0 then
	outputChatBox("#ff0000● #ffffffUżycie: /biznes.auto <nazwa>", plr, 255, 255, 255, true)
  return
 end
 local cost = math.random(5000,25000)
local x,y,z=getElementPosition(plr)
local name2 = table.concat(arg, " ")
outputChatBox("#00ff00● #ffffffPomyślnie utworzyłeś nowy biznes o nazwie #969696"..name2.." #ffffffza koszt #969696"..cost.." #00ff00$", plr, 255, 255, 255, true)
exports['dmta_base_connect']:query("INSERT INTO db_businesses SET owner=?, xyz='?,?,?', cost=?, nazwa=?, zajety=?",
"brak",x,y,z,tonumber(cost),tostring(name2),"n")
restartResource(getThisResource())
end
end
addCommandHandler("biznes.auto", cmd4)

function oplac(plr)
	if isElementWithinColShape(plr, getElementColShape(pickup[plr])) then
		local biz2 = pickup[plr]
		if getElementData(biz2, "z") == "n" then outputChatBox("#ff0000● #ffffffTen biznes posiada właściciela.", plr, 255, 255, 255, true) return end
		if tonumber(getElementData(biz2, "owner")) ~= tonumber(getElementData(plr, "user:dbid")) then outputChatBox("#ff0000● #ffffffTen biznes nie należy do Ciebie.", plr, 255, 255, 255, true) return end
		local sal = exports['dmta_base_connect']:query("select data from db_businesses where data < NOW() and id=?",getElementData(biz2,"id"))
		if sal and #sal > 0 then outputChatBox("#ff0000● #ffffffTen biznes nie należy do Ciebie.", plr, 255, 255, 255, true); restartResource(getThisResource()) return end
		local bkoszt=getElementData(biz2, "cost")
		local kwota = math.floor(bkoszt)
		local saldo = getPlayerMoney(plr)
		--local brakuje = kwota - saldo
		if saldo < kwota then outputChatBox("#ff0000● #ffffffNie posiadasz wystarczająco pieniędzy na opłacenie biznesu.", plr, 255, 255, 255, true) return end
		exports['dmta_base_connect']:query("update db_businesses set data=data + INTERVAL 3 day where id=?",getElementData(biz2,"id"))
		takePlayerMoney(plr, kwota)
		outputChatBox("#00ff00● #ffffffPomyślnie przedłużyłeś termin umowy o 3 dni.", plr, 255, 255, 255, true)
		local text_log = getPlayerName(plr)..' opłacił biznes '..getElementData(biz2, 'name')..' - zapłacił '..bkoszt..' $'
		exports['dmta_base_duty']:addLogs('bus', text_log, plr, 'BUSINESS/PAY')
		restartResource(getThisResource())
	end
end
addEvent("oplac:biznesy", true)
addEventHandler("oplac:biznesy", root, oplac)

addEventHandler("onResourceStart",resourceRoot,function()
	exports['dmta_base_connect']:query("UPDATE db_businesses SET owner=?,zajety=? WHERE data < NOW()","brak","n")
	setTimer(init,3000,1)
end)

local czas_restartu = 60*60*1000
setTimer(function()
for i,p in pairs(getElementsByType('pickup')) do
 if #getElementsWithinColShape(getElementColShape(p)) > 0 then return end
end
restartResource(getThisResource())
end,czas_restartu,0)


local minut = 6
function sypnijmu()
	local marker = getElementsByType("pickup")
	for _,m in ipairs(marker) do
		if getElementData(m, "owner") then
			local wyplata= getElementData(m, "payday")
			exports['dmta_base_connect']:query("UPDATE db_businesses SET saldo=saldo+?? WHERE id=?", wyplata, getElementData(m,"id"))
		end
	end
end
setTimer(sypnijmu,10000*minut,0)