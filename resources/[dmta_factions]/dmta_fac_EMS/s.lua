--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local noti = exports.dmta_base_notifications

local frakcja = "EMS"
local lider = "Dyrektor_Szpitala"
local vlider = "Zastepca_Dyrektora"
local nowyranga = "Pielegniarz"

local sluzba = createMarker(2540.6879882813,-1648.2106933594,9916.822265625-0.95, "cylinder", 1, 212, 0, 0, 100)
setElementInterior(sluzba, 1)
setElementData(sluzba, 'marker:icon', 'faction')
local liderka = createMarker(2537.8828125,-1655.7287597656,9916.82421875-0.95, "cylinder", 1, 65, 105, 225)
setElementInterior(liderka, 1)
setElementData(liderka, 'marker:icon', 'faction')

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
        takeWeapon(source, 41)
        local model = getElementModel(source)
        setElementModel(source, getElementData(source, "user:facskin"))
        local text_log = getPlayerName(source)..' kończy służbe'
        exports['dmta_base_duty']:addLogs('fac', text_log, source, 'EMS/END')
	else
		setElementData(source, "user:faction", frakcja)
        setElementData(source, "frakcja:ranga", spr[1].ranga)
        noti:addNotification(source, 'Rozpoczynasz służbe.', 'info')
		toggleControl(source, "fire", true)
		toggleControl(source, "aim_weapon", true)
		giveWeapon(source, 41, 9999999)
		local model = getElementModel(source)
        setElementData(source, 'user:facskin', model)
        local text_log = getPlayerName(source)..' rozpoczyna służbe'
        exports['dmta_base_duty']:addLogs('fac', text_log, source, 'EMS/START')
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
    local text_log = getPlayerName(nick)..' zostaje wyrzucony z frakcji'
    exports['dmta_base_duty']:addLogs('fac', text_log, source, 'EMS/DEL')
end)

addEvent("edytujPracownika:"..frakcja.."", true)
addEventHandler("edytujPracownika:"..frakcja.."", root, function(nick, wyplata, ranga)
    exports["dmta_base_connect"]:query("UPDATE db_factions SET ranga=?, wyplata=? WHERE nick=?", ranga, wyplata, nick)
    local text_log = getPlayerName(nick)..' > '..ranga..' > '..wyplata..''
    exports['dmta_base_duty']:addLogs('fac', text_log, source, 'EMS/EDIT')
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
        local text_log = getPlayerName(nickname)..' zostaje dodany do frakcji'
        exports['dmta_base_duty']:addLogs('fac', text_log, source, 'EMS/ADD')
    else
        noti:addNotification(source, 'Nie znaleziono podanego gracza.', 'error')
    end
end)


-- pojazdy 

local eq = { }
local nosze = { }

local auta = {
	{416,-1721.0625,999.53778076172,17.735486984253,0.050048828125,359.61767578125,88.350830078125},
	{416,-1721.3247070313,1003.7290039063,17.735486984253,0,0,91.904052734375},
	{416,-1721.4090576172,1007.8671264648,17.735486984253,0,0,92.489501953125},
	{416,-1721.5947265625,1011.9724731445,17.735486984253,0,0,89.956848144531},
	{416,-1721.7813720703,1024.5391845703,17.735486984253,0,0,90.247497558594},
	{416,-1721.8463134766,1028.55859375,17.735486984253,0,0,90.546813964844},
	{416,-1721.8638916016,1032.4879150391,17.735486984253,0,0,91.143737792969},
	{416,-1721.9002685547,1036.6872558594,17.735486984253,0,0,90.861694335938},
	{579,-1736.6822509766,1007.7911376953,17.579568862915,359.82720947266,0.0247802734375,270.81921386719},
	{579,-1736.5919189453,1011.8400268555,17.579568862915,0,0,269.8955078125},
	{426,-1735.6888427734,1016.2115478516,17.239328384399,0.087890625,0.01324462890625,269.60070800781},
	{426,-1735.6024169922,1020.0788574219,17.23895072937,0.01690673828125,0,268.50927734375},
	{586,-1735.1630859375,1024.3287353516,17.092439651489,359.89477539063,0.0020751953125,270.71520996094},
	{586,-1735.3413085938,1028.3713378906,17.09260559082,359.90228271484,0.002197265625,269.02288818359},
}

for _,v in ipairs(auta)do
    auto = createVehicle(v[1], v[2], v[3], v[4], v[5], v[6], v[7])
    setElementData(auto, "nametag", v[8])
    setElementData(auto, "vehicle:actualType", "Beznyna")
    setElementData(auto, "vehicle:bak", 100)
    setElementData(auto, "vehicle:fuel", 100)
    setElementData(auto, "vehicle:engine", 3)
    setElementData(auto, "vehicle:distance", 1)
	setElementData(auto, "veh:frakcja", frakcja)
	--setElementDimension(auto, 1)
	setElementFrozen(auto, true)
	setVehicleColor(auto,  212, 0, 0, 255, 255, 255)
	--setVehiclePlateText(auto, v[8])
	setVehiclePlateText(auto, frakcja.." ".._)
	if v[1] == 442 then
		addVehicleUpgrade(auto, 1025)
        setVehicleHandling(auto, "engineAcceleration", getVehicleHandling(auto).engineAcceleration+5)
		setVehicleHandling(auto, "driveType", "awd")
		setVehicleHandling(auto, "engineAcceleration", 25)
		setVehicleHandling(auto, "maxVelocity", 265);
    	setVehicleHandling(auto, "steeringLock", 65);
	end

	if v[1] == 431 then
		addVehicleUpgrade(auto, 1025)
        setVehicleHandling(auto, "engineAcceleration", getVehicleHandling(auto).engineAcceleration+5)
		setVehicleHandling(auto, "driveType", "awd")
		setVehicleHandling(auto, "engineAcceleration", 25)
		setVehicleHandling(auto, "maxVelocity", 265);
    	setVehicleHandling(auto, "steeringLock", 65);
	end

if v[1] == 487 then
		addVehicleUpgrade(auto, 1025)
        setVehicleHandling(auto, "engineAcceleration", getVehicleHandling(auto).engineAcceleration+5)
		setVehicleHandling(auto, "driveType", "awd")
		setVehicleHandling(auto, "engineAcceleration", 25)
		setVehicleHandling(auto, "maxVelocity", 265);
    	setVehicleHandling(auto, "steeringLock", 65);
	end

	if v[1] == 426 then
		addVehicleUpgrade(auto, 1025)
        setVehicleHandling(auto, "engineAcceleration", getVehicleHandling(auto).engineAcceleration+5)
		setVehicleHandling(auto, "driveType", "awd")
		setVehicleHandling(auto, "engineAcceleration", 25)
		setVehicleHandling(auto, "maxVelocity", 265);
    	setVehicleHandling(auto, "steeringLock", 65);
	end

	if v[1] == 507 then
		addVehicleUpgrade(auto, 1025)
        setVehicleHandling(auto, "engineAcceleration", getVehicleHandling(auto).engineAcceleration+5)
		setVehicleHandling(auto, "driveType", "awd")
		setVehicleHandling(auto, "engineAcceleration", 25)
		setVehicleHandling(auto, "maxVelocity", 265);
    	setVehicleHandling(auto, "steeringLock", 65);
	end

if v[1] == 516 then
		addVehicleUpgrade(auto, 1025)
        setVehicleHandling(auto, "engineAcceleration", getVehicleHandling(auto).engineAcceleration+5)
		setVehicleHandling(auto, "driveType", "awd")
		setVehicleHandling(auto, "engineAcceleration", 25)
		setVehicleHandling(auto, "maxVelocity", 265);
    	setVehicleHandling(auto, "steeringLock", 65);
	end

	if v[1] == 586 then
        setVehicleHandling(auto, "engineAcceleration", getVehicleHandling(auto).engineAcceleration+5)
		setVehicleHandling(auto, "driveType", "awd")
		setVehicleHandling(auto, "engineAcceleration", 25)
		setVehicleHandling(auto, "maxVelocity", 265);
    	setVehicleHandling(auto, "steeringLock", 65);
    end

	if v[1] == 560 then
		addVehicleUpgrade(auto, 1025)
        setVehicleHandling(auto, "engineAcceleration", getVehicleHandling(auto).engineAcceleration+5)
		setVehicleHandling(auto, "driveType", "awd")
		setVehicleHandling(auto, "engineAcceleration", 25)
		setVehicleHandling(auto, "maxVelocity", 265);
    	setVehicleHandling(auto, "steeringLock", 65);
    end

    if v[1] == 490 then
		addVehicleUpgrade(auto, 1025)
        setVehicleHandling(auto, "engineAcceleration", getVehicleHandling(auto).engineAcceleration+5)
		setVehicleHandling(auto, "driveType", "awd")
		setVehicleHandling(auto, "engineAcceleration", 25)
		setVehicleHandling(auto, "maxVelocity", 265);
    	setVehicleHandling(auto, "steeringLock", 65);
    end

    if v[1] == 502 then
		addVehicleUpgrade(auto, 1025)
        setVehicleHandling(auto, "engineAcceleration", getVehicleHandling(auto).engineAcceleration+5)
		setVehicleHandling(auto, "driveType", "awd")
		setVehicleHandling(auto, "engineAcceleration", 25)
		setVehicleHandling(auto, "maxVelocity", 265);
    	setVehicleHandling(auto, "steeringLock", 65);
    end
	
	if v[1] == 470 then
		addVehicleUpgrade(auto, 1025)
        setVehicleHandling(auto, "engineAcceleration", getVehicleHandling(auto).engineAcceleration+5)
		setVehicleHandling(auto, "driveType", "awd")
		setVehicleHandling(auto, "engineAcceleration", 25)
		setVehicleHandling(auto, "maxVelocity", 265);
    	setVehicleHandling(auto, "steeringLock", 65);
    end
	
	if v[1] == 468 then
		addVehicleUpgrade(auto, 1025)
        setVehicleHandling(auto, "engineAcceleration", getVehicleHandling(auto).engineAcceleration+5)
		setVehicleHandling(auto, "driveType", "awd")
		setVehicleHandling(auto, "engineAcceleration", 25)
		setVehicleHandling(auto, "maxVelocity", 265);
    	setVehicleHandling(auto, "steeringLock", 65);
    end

	if v[1] == 471 then
		addVehicleUpgrade(auto, 1025)
        setVehicleHandling(auto, "engineAcceleration", getVehicleHandling(auto).engineAcceleration+5)
		setVehicleHandling(auto, "driveType", "awd")
		setVehicleHandling(auto, "engineAcceleration", 25)
		setVehicleHandling(auto, "maxVelocity", 265);
    	setVehicleHandling(auto, "steeringLock", 65);
	end
	
	if v[1] == 579 then
		addVehicleUpgrade(auto, 1025)
        setVehicleHandling(auto, "engineAcceleration", getVehicleHandling(auto).engineAcceleration+5)
		setVehicleHandling(auto, "driveType", "awd")
		setVehicleHandling(auto, "engineAcceleration", 25)
		setVehicleHandling(auto, "maxVelocity", 265);
    	setVehicleHandling(auto, "steeringLock", 65);
    end

    if v[1] == 416 then
		addVehicleUpgrade(auto, 1025)
       	local eq = createMarker(0,0,0, "corona", 1, 255, 0, 0, 255)
    	attachElements(eq, auto, 0, -4, 0)
    	local nosze = createObject(1997, 0, 0, 0, 0, 0, 0)
    	attachElements(nosze, auto, 0, -1.5, -0.5)
    	setElementCollisionsEnabled(nosze, false)
    	setElementData(eq, "nosze", nosze)
    	setElementData(eq, "pojazd", auto)
    	setElementData(auto, "nosze", true)
    	addEventHandler("onMarkerHit", eq, function(gracz)
    		if getElementType(gracz) ~= "player" then return end
    		if isPedInVehicle(gracz) then return end
    		if getElementData(gracz, "user:faction") == frakcja then
    			triggerClientEvent(gracz, "pokazBagaznik:"..frakcja.."", gracz, source)
    			setVehicleDoorOpenRatio(getElementData(source, "pojazd"), 4, 1, 4, 1000)
    			setVehicleDoorOpenRatio(getElementData(source, "pojazd"), 5, 1, 5, 1000)
    		end 
    	end)
    	addEventHandler("onMarkerLeave", eq, function(gracz)
    		if getElementType(gracz) ~= "player" then return end
    		if isPedInVehicle(gracz) then return end
    		if getElementData(gracz, "user:faction") == frakcja then
    			triggerClientEvent(gracz, "usunBagaznik:"..frakcja.."", gracz)
    		end
    	end)
    end
end

addEventHandler("onVehicleStartEnter", resourceRoot, function(plr, seat, jacked)
    if seat ~= 0 then return end
        if getElementData(plr, "user:faction") == frakcja then
    else
        cancelEvent()
        exports["smta_base_notifications"]:noti("Nie możesz wejśc do tego pojazdu", plr, "error")
    end
end)

-- bagaznik

local timer = { }

addEvent("wezNosze:"..frakcja.."", true)
addEventHandler("wezNosze:"..frakcja.."", root, function(nosze, pojazd, marker)
	if not getElementData(source, "nosze") then
		if getElementData(pojazd, "nosze") then
			detachElements(nosze, pojazd)
			attachElements(nosze, source, 0, 1.5, -1)
			setElementData(pojazd, "nosze", false)
			setElementData(source, "nosze", nosze)
			exports["smta_base_notifications"]:noti("Wyciągasz nosze z karetki", client)
		else
			exports["smta_base_notifications"]:noti("W pojezdzie nie ma noszy!", source, "error")
		end
	else
		if not getElementData(pojazd, "nosze") then
			attachElements(nosze, pojazd, 0, -1.5, -0.5)
			setElementData(source, "nosze", false)
			setElementData(pojazd, "nosze", true)
			setElementData(marker, "nosze", nosze)
			exports["smta_base_notifications"]:noti("Chowasz nosze do karetki", client)
		else
			exports["smta_base_notifications"]:noti("W pojezdzie są nosze!", source, "error")
		end
	end
end)

addCommandHandler("pnosze", function(gracz)
	if not getElementData(gracz, "nosze") then return end
	local nosze = getElementData(gracz, "nosze")
	local rx, ry, rz = getElementRotation(gracz)
    detachElements(nosze, gracz)
    setElementRotation(nosze, rx, ry, rz)
    setElementData(gracz, "nosze", false)
end)


addCommandHandler("pnosze2", function(gracz)
	if getElementData(gracz, "user:faction") ~= frakcja then return end
	if getElementData(gracz, "nosze") then return end
	local x, y, z = getElementPosition(gracz)
	local strefa = createColSphere(x, y, z, 2)
	local nosze = getElementsWithinColShape(strefa, "object" )
	destroyElement(strefa)
	if #nosze < 1 then return end
	if #nosze > 1 then return end
	attachElements(nosze[1], gracz, 0, 1.5, -1)
	setElementData(gracz, "nosze", nosze[1])
end)


addCommandHandler("nanosze", function(gracz, _, kogo)
	if not kogo then return end
	if not getElementData(gracz, "nosze") then return end
	local target = exports["smta_base_core"]:findPlayer(gracz, kogo)
	if not target then exports["smta_base_notifications"]:noti("Nie znaleziono podanego gracz", gracz, "error") return end
	local x1, y1, z1 = getElementPosition(target)
	local x2, y2, z2 = getElementPosition(gracz)
	local dystans = getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2)
	if dystans > 5 then exports["smta_base_notifications"]:noti("Podany gracz jest za daleko", gracz, "error") return end
	attachElements(target, getElementData(gracz, "nosze"), 0, 0, 2)
	setElementCollisionsEnabled(target, false)
	setPedAnimation(target, "CRACK", "crckidle4", -1, true, false )
	setElementData(target, "nanoszach", true)
	setTimer(function()
		triggerClientEvent(target, "nosze:rotacja", root, target, getElementData(gracz, "nosze"), true)
	end, 100, 1)
end)

addCommandHandler("znosze", function(gracz, _, kogo)
	if not kogo then return end
	if not getElementData(gracz, "nosze") then return end
	local target = exports["smta_base_core"]:findPlayer(gracz, kogo)
	if not target then exports["smta_base_notifications"]:noti("Nie znaleziono podanego gracz", gracz, "error") return end
	local x1, y1, z1 = getElementPosition(target)
	local x2, y2, z2 = getElementPosition(gracz)
	local dystans = getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2)
	if dystans > 5 then exports["smta_base_notifications"]:noti("Podany gracz jest za daleko", gracz, "error") return end
	if not getElementData(target, "nanoszach") then return end
	detachElements(target, getElementData(gracz, "nosze"))
	setElementCollisionsEnabled(target, true)
	setPedAnimation(target, false)
	setElementData(target, "nanoszach", false)
	triggerClientEvent(target, "nosze:usunRotacje", root)
end)

addEvent("zamknijDrzwi:"..frakcja.."", true)
addEventHandler("zamknijDrzwi:"..frakcja.."", root, function(pojazd)
	setVehicleDoorOpenRatio(pojazd, 4, 0, 4, 1000)
    setVehicleDoorOpenRatio(pojazd, 5, 0, 5, 1000)
end)

addEvent("wezTorbe:"..frakcja.."", true)
addEventHandler("wezTorbe:"..frakcja.."", root, function()
	if not getElementData(client, "torbawreku") then
		local torba = createObject(1210, 0, 0, 0)
		exports.bone_attach:attachElementToBone(torba, client, 12, 0, 0.05, 0.27, 0, 180, 90)
		setElementData(client, "torbawreku", true)
		setElementData(client, "torba", torba)
		exports["smta_base_notifications"]:noti("Wyciągasz torbe R1", client)
		bindKey(client, "z", "down", postawtorbe)
	else
		unbindKey(client, "z", "down", postawtorbe)
		exports.bone_attach:detachElementFromBone(getElementData(client, "torba"))
		destroyElement(getElementData(client, "torba"))
		setElementData(client, "torbawreku", false)
		setElementData(client, "torba", false)
		exports["smta_base_notifications"]:noti("Chowasz torbe R1", client)
	end
end)

addEvent("wezLP:"..frakcja.."", true)
addEventHandler("wezLP:"..frakcja.."", root, function()
	if not getElementData(client, "lpwreku") then
		local lp = createObject(2035, 0, 0, 0)
		exports.bone_attach:attachElementToBone(lp, client, 12, 0, 0.05, 0.27, 270, 180, 0)
		setElementData(client, "lpwreku", true)
		setElementData(client, "lp", lp)
		exports["smta_base_notifications"]:noti("Wyciągasz LifePack", client)
	else
		exports.bone_attach:detachElementFromBone(getElementData(client, "lp"))
		destroyElement(getElementData(client, "lp"))
		setElementData(client, "lpwreku", false)
		setElementData(client, "lp", false)
		exports["smta_base_notifications"]:noti("Chowasz LifePack", client)
	end
end)

addEvent("wezSzyny:"..frakcja.."", true)
addEventHandler("wezSzyny:"..frakcja.."", root, function()
	if not getElementData(client, "szynywreku") then
		local szyna = createObject(2880, 0, 0, 0)
		exports.bone_attach:attachElementToBone(szyna, client, 12, 0, 0.05, 0.22, 0, 180, 90)
		setElementData(client, "szynywreku", true)
		setElementData(client, "szyna", szyna)
		exports["smta_base_notifications"]:noti("Wyciągasz torbe szyn Kramera", client)
		bindKey(client, "z", "down", postawszyny)
	else
		unbindKey(client, "z", "down", postawszyny)
		exports.bone_attach:detachElementFromBone(getElementData(client, "szyna"))
		destroyElement(getElementData(client, "szyna"))
		setElementData(client, "szynywreku", false)
		setElementData(client, "szyna", false)
		exports["smta_base_notifications"]:noti("Chowasz torbe szyn Kramera", client)
	end
end)

function postawtorbe(gracz)
	unbindKey(gracz, "z", "down", postawtorbe)
	setPedAnimation(gracz, "CAMERA", "camstnd_to_camcrch", -1, false, false )
	setElementData(gracz, "torbawreku", false)
	setTimer(function()
		destroyElement(getElementData(gracz, "torba"))
		setElementData(gracz, "torba", false)
		local rotx, roty, rotz = getElementRotation(gracz)
		local torba = createObject(1210, 0, 0, 0)
		attachElements(torba, gracz, 0, 0.5, -0.8, 0, 0, rotz)
		detachElements(torba, gracz)
		setElementRotation(torba, 0, 0, rotz)
		setPedAnimation(gracz, false)
		local x, y, z = getElementPosition(torba)
		cuboid = createColSphere(x, y, z, 1)
		setElementData(cuboid, "torba", torba)
		addEventHandler("onColShapeHit", cuboid, function(hit)
			if getElementData(hit, "user:faction") ~= frakcja then return end
			if getElementData(hit, "torbawreku") then return end
			destroyElement(getElementData(source, "torba"))
			destroyElement(source)
			bindKey(hit, "z", "down", postawtorbe)
			local torba = createObject(1210, 0, 0, 0)
			exports.bone_attach:attachElementToBone(torba, hit, 12, 0, 0.05, 0.27, 0, 180, 90)
			setElementData(hit, "torbawreku", true)
			setElementData(hit, "torba", torba)
			exports["smta_base_notifications"]:noti("Podnosisz torbe R1", hit)
		end)
	end, 700, 1)
end

function postawszyny(gracz)
	unbindKey(gracz, "z", "down", postawszyny)
	setPedAnimation(gracz, "CAMERA", "camstnd_to_camcrch", -1, false, false )
	setElementData(gracz, "szynywreku", false)
	setTimer(function()
		destroyElement(getElementData(gracz, "szyna"))
		setElementData(gracz, "szyna", false)
		local rotx, roty, rotz = getElementRotation(gracz)
		local szyna = createObject(2880, 0, 0, 0)
		attachElements(szyna, gracz, 0, 0.5, -0.8, 0, 0, rotz)
		detachElements(szyna, gracz)
		setElementRotation(szyna, 0, 0, rotz)
		setPedAnimation(gracz, false)
		local x, y, z = getElementPosition(szyna)
		cuboid = createColSphere(x, y, z, 1)
		setElementData(cuboid, "szyna", szyna)
		addEventHandler("onColShapeHit", cuboid, function(hit)
			if getElementData(hit, "user:faction") ~= frakcja then return end
			if getElementData(hit, "szynywreku") then return end
			destroyElement(getElementData(source, "szyna"))
			destroyElement(source)
			bindKey(hit, "z", "down", postawszyny)
			local szyna = createObject(2880, 0, 0, 0)
			exports.bone_attach:attachElementToBone(szyna, hit, 12, 0, 0.05, 0.27, 0, 180, 90)
			setElementData(hit, "szynywreku", true)
			setElementData(hit, "szyna", szyna)
			exports["smta_base_notifications"]:noti("Podnosisz torbe szyne ", hit)
		end)
	end, 700, 1)
end


addEvent("dajSpray:"..frakcja.."", true)
addEventHandler("dajSpray:"..frakcja.."", root, function()
	giveWeapon(client, 41, 9999)
end)

--przebieralnia

local skiny = {
    {274, 2543.4470214844,-1669.3687744141,9916.828125, "Pielęgniarz", 1},
    {275, 2543.7680664063,-1666.7806396484,9916.828125, "Medyk", 1},
	{70, 2543.8559570313,-1663.9409179688,9916.833984375, "Doktor", 1},
	{276, 2543.9504394531,-1660.8752441406,9916.833007812, "Ratownik", 1},
}
     
for i, v in ipairs(skiny) do
	local marker = createMarker(v[2], v[3], v[4]-0.9, "cylinder", 1, 251, 206, 177, 50)
	setElementData(marker, 'marker:icon', 'przebieralnia')
    setElementInterior(marker, v[6])
    setElementData(marker, "skin", v[1])
    local napis = createElement("text")
    setElementPosition(napis, v[2], v[3], v[4])
	setElementData(napis, "text", v[5])
	setElementInterior(napis, 1)
    addEventHandler("onMarkerHit", marker, function(gracz)
        if getElementType(gracz) ~= "player" then return end
        if getElementData(gracz, "user:faction") == frakcja then
            setElementModel(gracz, getElementData(source, "skin"))
        end
    end)
end

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

local wejscie = createMarker(1176.0524902344,-1308.7047119141,14.19941444397-0.95, 'cylinder', 2.2, 212, 0, 0)
setElementData(wejscie, 'marker:icon', 'brak')

function wejscie_tp( hitElement, matchingDimension ) 
if isElement(hitElement) and getElementType(hitElement) == "player" then
if not isPedInVehicle(hitElement) then
setElementPosition ( hitElement, -1743.4858398438,982.11614990234,17.69652557373) 
else
	local veh = getPedOccupiedVehicle(hitElement)
	setElementPosition ( hitElement, -1743.4858398438,982.11614990234,17.69652557373) 
	setElementPosition ( veh, -1743.4858398438,982.11614990234,17.69652557373) 
	setElementRotation(veh, 0, 0, 270)
end 
end 
end
addEventHandler( "onMarkerHit", wejscie, wejscie_tp )

local wyjscie = createMarker(-1765.8597412109,984.82019042969,22.565860748291-0.95, 'cylinder', 2.2, 212, 0, 0)
setElementData(wyjscie, 'marker:icon', 'brak')

function wyjscie_tp( hitElement, matchingDimension ) 
if isElement(hitElement) and getElementType(hitElement) == "player" then
if not isPedInVehicle(hitElement) then
setElementPosition ( hitElement, 1183.1499023438,-1308.5148925781,13.259363174438) 
else
	local veh = getPedOccupiedVehicle(hitElement)
	setElementPosition ( hitElement, 1183.1499023438,-1308.5148925781,13.259363174438) 
	setElementPosition ( veh, 1183.1499023438,-1308.5148925781,13.259363174438) 
	setElementRotation(veh, 0, 0, 270)
end 
end 
end
addEventHandler( "onMarkerHit", wyjscie, wyjscie_tp )