--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local noti = exports.dmta_base_notifications

local frakcja = "SAPD"
local lider = "Generalny_Inspektor"
local vlider = "Nadinspektor"
local nowyranga = "Cadet"

local sluzba = createMarker(297.35800170898,186.0500793457,1007.171875-0.95, "cylinder", 1, 0, 127, 255, 100)
setElementData(sluzba, 'marker:icon', 'faction')
setElementInterior(sluzba, 3)
local liderka = createMarker(300.88427734375,187.76390075684,1007.171875-0.95, "cylinder", 1, 253, 14, 53, 100)
setElementData(liderka, 'marker:icon', 'faction')
setElementInterior(liderka, 3)

addEventHandler("onMarkerHit", sluzba, function(gracz)
	local spr = exports["dmta_base_connect"]:query("SELECT * FROM db_factions WHERE dbid=? and frakcja=?", getElementData(gracz, "user:dbid"), frakcja)
	if #spr == 1 then
		triggerClientEvent(gracz, "gui:sluzba:"..frakcja.."", gracz, pokaztopke())
	end
end)

function pokaztopke()
	local q = exports['dmta_base_connect']:query("select * from db_factions where frakcja = ? order by minuty desc", frakcja)
	local topka = {}
    local ile = #q
    if ile > 5 then
    	ile = 5
    end
	for i = 1, ile do
		table.insert(topka, {nick = q[i]["nick"], minuty = q[i]["minuty"]})
	end

	return topka
end

addEvent("rozpocznijSluzbe:"..frakcja.."", true)
addEventHandler("rozpocznijSluzbe:"..frakcja.."", root, function()
	local spr = exports["dmta_base_connect"]:query("SELECT * FROM db_factions WHERE dbid=? AND frakcja=?", getElementData(source, "user:dbid"), frakcja)
	if getElementData(source, "user:faction") then
        setElementData(source, "user:faction", false)
        noti:addNotification(source, 'Zakończyłeś służbe.', 'success')
		toggleControl(source, "fire", false)
		toggleControl(source, "aim_weapon", false)
        takeWeapon(source, 3)
        takeWeapon(source, 23)
        takeWeapon(source, 25)
        takeWeapon(source, 31)
        setPlayerArmor(source, 0)
        local model = getElementModel(source)
        setElementModel(source, getElementData(source, "user:facskin"))
        local text_log = getPlayerName(source)..' kończy służbe'
        exports['dmta_base_duty']:addLogs('fac', text_log, source, 'SAPD/END')
	else
		setElementData(source, "user:faction", frakcja)
        setElementData(source, "frakcja:ranga", spr[1].ranga)
        noti:addNotification(source, 'Rozpoczynasz służbe.', 'info')
		toggleControl(source, "fire", true)
		toggleControl(source, "aim_weapon", true)
        giveWeapon(source, 3, 9999999)
        giveWeapon(source, 23, 9999999)
        giveWeapon(source, 25, 9999999)
        giveWeapon(source, 31, 9999999)
        local model = getElementModel(source)
        setElementData(source, 'user:facskin', model)
        --setElementModel(source, getElementData(source, "skin"))
        setPlayerArmor(source, 100)
        local text_log = getPlayerName(source)..' rozpoczyna służbe'
        exports['dmta_base_duty']:addLogs('fac', text_log, source, 'SAPD/START')
	end
end)

-- liderka

addEventHandler("onMarkerHit", liderka, function(gracz)
	local spr = exports["dmta_base_connect"]:query("SELECT * FROM db_factions WHERE dbid=? AND frakcja=?", getElementData(gracz, "user:dbid"), frakcja)
    if #spr > 0 then 
    	if spr[1].ranga == lider or spr[1].ranga == vlider then
    		if getElementData(gracz, "user:faction") then
				triggerClientEvent(gracz, "gui:lidera:"..frakcja.."", gracz, pokazpracownikow())
			end
		end
	end
end)

function pokazpracownikow()
    local q = exports["dmta_base_connect"]:query("SELECT * FROM db_factions WHERE frakcja=?", frakcja)
    local pracownicy = {}

    for i = 1, #q do
        table.insert(pracownicy, {nick = q[i]["nick"], ranga = q[i]["ranga"], wyplata = q[i]["wyplata"], minuty = q[i]["minuty"]})
    end

    return pracownicy
end

addEvent("usunPracownika:"..frakcja.."", true)
addEventHandler("usunPracownika:"..frakcja.."", root, function(nick)
    exports["dmta_base_connect"]:query("DELETE FROM db_factions WHERE nick=?", nick)
    local text_log =  nick..' zostaje wyrzucony z frakcji'
    exports['dmta_base_duty']:addLogs('fac', text_log, source, 'SAPD/DEL')
end)

addEvent("edytujPracownika:"..frakcja.."", true)
addEventHandler("edytujPracownika:"..frakcja.."", root, function(nick, wyplata, ranga)
    exports["dmta_base_connect"]:query("UPDATE db_factions SET ranga=?, wyplata=? WHERE nick=?", ranga, wyplata, nick)
    local text_log = nick..' > '..ranga..' > '..wyplata..''
    exports['dmta_base_duty']:addLogs('fac', text_log, source, 'SAPD/EDIT')
end)

addEvent("dodajPracownika:"..frakcja.."", true)
addEventHandler("dodajPracownika:"..frakcja.."", root, function(nick)
	local gracz = findPlayer(source, nick)
	if gracz then
		local dbid = getElementData(gracz, "user:dbid")
    	local nickname = getPlayerName(gracz)
    	local result = exports["dmta_base_connect"]:query("SELECT * FROM db_factions WHERE dbid=?", dbid)
        if #result > 0 then
            noti:addNotification(source, ''..nickname..' pracuje w frakcji.', 'error')
    	return
        end
        noti:addNotification(source, 'Dodano: '..nickname..' do frakcji.', 'success')
    	exports["dmta_base_connect"]:query("INSERT INTO db_factions SET dbid=?, frakcja=?, ranga=?, nick=?, wyplata=?", dbid, frakcja, nowyranga, nickname, 150)
        setElementData(gracz, "frakcja", frakcja)
        local text_log =nickname..' zostaje dodany do frakcji'
        exports['dmta_base_duty']:addLogs('fac', text_log, source, 'SAPD/ADD')
    else
        noti:addNotification(source, 'Nie znaleziono podanego gracza.', 'error')
    end
end)


-- pojazdy 


local auta = {
    {596,1575.2421875,-1613.609375,13.144445419312,0},
    {596,1570.2421875,-1613.609375,13.144445419312,0},
    {596,1565.2421875,-1613.609375,13.144445419312,0},
    {596,1560.2421875,-1613.609375,13.144445419312,0},
    {596,1555.2421875,-1613.609375,13.144445419312,0},
    {596,1550.2421875,-1613.609375,13.144445419312,0},
    {596,1545.2421875,-1613.609375,13.144445419312,0},

    {596,1585.0815429688,-1606.8568115234,13.174844741821,0, 0, 180},
    {596,1590.0815429688,-1606.8568115234,13.174844741821,0, 0, 180},
    {596,1595.0815429688,-1606.8568115234,13.174844741821,0, 0, 180},
    {596,1600.0815429688,-1606.8568115234,13.174844741821,0, 0, 180},
    {596,1605.0815429688,-1606.8568115234,13.174844741821,0, 0, 180},

    {415,1604.1225585938,-1630.5369873047,13.210489273071,0,0,89.566528320313},
    {415,1603.9946289063,-1625.1401367188,13.210385322571,0,0,90.499633789063},

    {579,1603.4838867188,-1620.8570556641,13.496771812439,359.19641113281,0.0035400390625,91.417236328125},
    {579,1603.4130859375,-1615.7077636719,13.416926765442,359.15728759766,359.99267578125,90.584655761719},

    {560,1602.4224853516,-1683.9127197266,5.7789549827576,359.82836914063,0.01953125,90.869506835938},
    {560,1602.3071289063,-1687.7506103516,5.7789549827576,0,0,90.0673828125},

    {426,1602.107421875,-1692.0513916016,5.580322265625,0,0,90.11767578125},
    {426,1602.2073974609,-1696.0999755859,5.580322265625,0,0,90.224487304688},

    {490,1602.3060302734,-1700.0262451172,5.9061999320984,0,0,90.951477050781},
    {490,1602.28515625,-1704.2261962891,5.9061999320984,0,0,89.547729492188},

    {427,1595.3244628906,-1710.0147705078,6.0226240158081,0.021240234375,0.00115966796875,359.73114013672},
    {427,1591.5754394531,-1709.9555664063,6.0226240158081,0,0,358.69201660156},

}

for _,v in ipairs(auta)do
    auto = createVehicle(v[1], v[2], v[3], v[4], v[5], v[6], v[7])
    setElementData(auto, "nametag", v[8])
    setElementData(auto, "vehicle:actualType", "Benzyna")
    setElementData(auto, "vehicle:bak", 100)
    setElementData(auto, "vehicle:fuel", 100)
    setElementData(auto, "vehicle:engine", 3.0)
    setVehicleHandling(auto, "maxVelocity", 333);
    setVehicleHandling(auto, "steeringLock", 72);
    setVehicleHandling(auto, "driveType", "awd");
    setVehicleHandling(auto, "engineAcceleration", 25)
    setElementData(auto, "vehicle:distance", 1)
    setElementData(auto, "veh:frakcja", frakcja)
    setElementFrozen(auto, true)
    setVehicleColor(auto, 0, 0, 25, 255, 255, 255)
    addVehicleUpgrade(auto, 1025)
    setVehiclePlateText(auto, frakcja.." ".._)
end


addEventHandler("onVehicleStartEnter", resourceRoot, function(plr, seat, jacked)
    if seat ~= 0 then return end
        if getElementData(plr, "user:faction") == frakcja then
    else
        cancelEvent()
        noti:addNotification(plr, 'Nie możesz wejśc do tego pojazdu.', 'error')
    end
end)

addEvent("zamknijDrzwi:"..frakcja.."", true)
addEventHandler("zamknijDrzwi:"..frakcja.."", root, function(pojazd)
	setVehicleDoorOpenRatio(pojazd, 4, 0, 4, 1000)
    setVehicleDoorOpenRatio(pojazd, 5, 0, 5, 1000)
end)

--przebieralnia

local skiny = {
    {280, 262.62, 186.84, 1008.17, "Policjant 1", 3},
    {281, 257.46, 186.28, 1008.17, "Policjant 2", 3},
    {282, 251.98, 186.18, 1008.17, "Narkotykowy 1", 3},
    {283, 245.79, 186.19, 1008.17, "Narkotykowy 2", 3},
    {284, 250.37, 192.70, 1008.17, "Narkotykowy 3", 3},
    {285, 261.21, 192.55, 1008.17, "Kadet", 3},
}
     
for i, v in ipairs(skiny) do
    local marker = createMarker(v[2], v[3], v[4]-0.9, "cylinder", 1, 251, 206, 177, 50)
    setElementInterior(marker, v[6])
    setElementData(marker, "skin", v[1])
    setElementData(marker, 'marker:icon', 'przebieralnia')
    local napis = createElement("text")
    setElementPosition(napis, v[2], v[3], v[4])
    setElementData(napis, "text", v[5])
    setElementInterior(napis, 3)
    addEventHandler("onMarkerHit", marker, function(gracz)
        if getElementType(gracz) ~= "player" then return end
        if getElementData(gracz, "user:faction") == frakcja then
            setElementModel(gracz, getElementData(source, "skin"))
        end
    end)
end


addCommandHandler("blokady", function(player, command)
    if getElementData(player, "user:faction") ~= frakcja then return end
    if getElementData(player, "maBlokady") then
        triggerClientEvent(player, "schowaj:blokady", player)
    else
        triggerClientEvent(player, "daj:blokady", player)
    end
end)

function findPlayer(p, ph)
	for i,v in ipairs(getElementsByType("player")) do
		if tonumber(ph) then
			if getElementData(v, "user:id") == tonumber(ph) then
				return getPlayerFromName(getPlayerName(v))
			end
		else
			if string.find(string.gsub(getPlayerName(v):lower(),"#%x%x%x%x%x%x", ""), ph:lower(), 1, true) then
				return getPlayerFromName(getPlayerName(v))
			end
		end
	end
end