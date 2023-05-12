local cub = createColCuboid(188.17994689941, 156.58531188965, 1003.0234375, 16.25, 25, 2)
setElementInterior(cub,3)

function u(e)
getElementData(e, "user:id")
end

local cele = { -- x,y,z,int,dim
{198.67, 162.33, 1003.03, 3, 0},
{197.66, 173.89, 1003.02, 3, 0},
{192.81, 174.38, 1003.02, 3, 0},
}
local x,y,z = 205.47, 174.29, 1003.03
local function wypusc(plr)
setElementDimension(plr,0)
setElementInterior(plr,3)
setElementPosition(plr,x,y,z)
outputChatBox("* Zostałeś wypuszczony z więzienia.",plr, 0, 150, 20)
end

function getPlayerName2(plr)
if not plr then return end
return getPlayerName(plr):gsub("#%x%x%x%x%x%x","")
end

local function sprawdz(plr)
if not plr then return end
if not getElementData(plr,"user:id") then return end
local x = exports["dmta_base_connect"]:query("SELECT * FROM db_jail WHERE Serial=?",getPlayerSerial(plr))
if not x or #x < 1 then return end
local x2=exports["dmta_base_connect"]:query("SELECT Termin FROM db_jail WHERE Serial=? and Termin < NOW()",getPlayerSerial(plr))
if x2 and #x2 > 0 then
exports["dmta_base_connect"]:query("DELETE FROM db_jail WHERE Serial=?", getPlayerSerial(plr))
wypusc(plr)
return end
if isElementWithinColShape(plr,cub) then return end
setElementPosition(plr,cele[x[1].Cela][1],cele[x[1].Cela][2],cele[x[1].Cela][3])
setElementDimension(plr, 0)
end

local function sprawdzczas(plr)
if not plr then return end
if not getElementData(plr,"user:id") then return end
local x = exports["dmta_base_connect"]:query("SELECT * FROM db_jail WHERE Serial=?",getPlayerSerial(plr))
if not x or #x < 1 then return end
local x2=exports["dmta_base_connect"]:query("SELECT Termin FROM db_jail WHERE Serial=? and Termin < NOW()",getPlayerSerial(plr))
if x2 and #x2 > 0 then
exports["dmta_base_connect"]:query("DELETE FROM db_jail WHERE Serial=?", getPlayerSerial(plr))
wypusc(plr)
return end
outputChatBox("* Jesteś uwięziony w więzieniu do: "..x[1].Termin.." za: "..x[1].Powod.."", plr, 255, 0, 0)
end

function ajotceju(plr,cmd,cel,ile,typ,zaco)
	if getElementData(plr, "user:faction")=="SAPD" then
		if not cel or not ile or not typ or not zaco then
			exports["dmta_base_notifications"]:addNotification(plr, "* Użycie: /zamknij <gracz/ID> <czas> <m/h> <powód>.", "error")
		return
	end
	local target=findPlayer(plr,cel)
	if not target then
		exports["dmta_base_notifications"]:addNotification(source, "* Nie znaleziono podanego gracza.", "error")
		return
	end
    x1,x2,x3 = getElementPosition(plr)
    y1,y2,y3 = getElementPosition(target)
    dystans = getDistanceBetweenPoints3D(x1,x2,x3,y1,y2,y3)
    if dystans > 20.0 then exports["dmta_base_notifications"]:addNotification(plr, "* Ten gracz znajduje się zbyt daleko.", "error") return end
	local cela=math.random(1, #cele)
	if typ=="m" or typ=="h" then
		if typ=="m"then
			exports["dmta_base_connect"]:query("INSERT INTO db_jail (Serial,Termin,Cela,Powod) VALUES (?,NOW() + INTERVAL ?? minute,??,?)", getPlayerSerial(target), ile,cela, zaco)
			outputChatBox("* Zostałeś uwięziony w więzieniu przez "..getPlayerName(plr):gsub("#%x%x%x%x%x%x","").." za "..zaco.." na "..ile.." minut(-a/-y)", target, 255, 0, 0)
			outputChatBox("* Uwięziono gracza "..getPlayerName(target):gsub("#%x%x%x%x%x%x","").." w więzieniu za "..zaco.." na "..ile.." minut(-a/-y)", plr, 255, 0, 0)
			--local ww= "JAIL/SAPD > " ..getPlayerName(plr).." (PID:"..getElementData(plr,"user:id")..") zamyka w wiezieniu "..getPlayerName(target).." za "..zaco.." na "..ile.. " minut"
			--triggerClientEvent("dLogi", root, ww)
			sprawdz(plr)
		end
		if typ=="h" then
			exports["dmta_base_connect"]:query("INSERT INTO db_jail (Serial,Termin,Cela,Powod) VALUES (?,NOW() + INTERVAL ?? hour,??,?)", getPlayerSerial(target), ile,cela, zaco)
			outputChatBox("* Zostałeś uwięziony w więzieniu przez "..getPlayerName(plr):gsub("#%x%x%x%x%x%x","").." za "..zaco.." na "..ile.." godzin(-a/-y)", target, 255, 0, 0)
			outputChatBox("* Uwięziono gracza "..getPlayerName(target):gsub("#%x%x%x%x%x%x","").." w więzieniu za "..zaco.." na "..ile.." godzin(-a/-y)", plr, 255, 0, 0)
			--local ee= "JAIL/SAPD > " ..getPlayerName(plr).." (PID:"..getElementData(plr,"user:id")..") zamyka w wiezieniu "..getPlayerName(target).." za "..zaco.." na "..ile.. " godzin"
			--triggerClientEvent("dLogi", root, ee)
			sprawdz(plr)
		end
	end
	sprawdz(plr)
	cela=math.random(1, #cele)
	sprawdzczas(plr)
end
end
addCommandHandler("zamknij", ajotceju)

function unaj(plr,cmd,cel)
if getElementData(plr, "user:faction")=="SAPD" then
	local target=findPlayer(plr,cel)
	if not target then
		exports["dmta_base_notifications"]:addNotification(source, "* Nie znaleziono podanego gracza.", 'error')
		return
	end
	local jebnijsie=exports["dmta_base_connect"]:query("SELECT Termin FROM db_jail WHERE Serial=? and Termin > NOW()",getPlayerSerial(target))
	if jebnijsie and #jebnijsie <= 0 then outputChatBox("* Ten gracz nie jest w więzieniu! ("..getPlayerName(target)..")", plr,255,0,0) return end
	exports["dmta_base_connect"]:query("DELETE FROM db_jail WHERE Serial=?", getPlayerSerial(target))
	exports["dmta_base_notifications"]:addNotification(source, "* Gracz został uwolniony z więzienia.", 'info')
	--local qq= "JAIL/SAPD > " ..getPlayerName(target)..": (PID:"..getElementData(target,"user:id")..") zostal wypuszczony z wiezienia"
	--triggerClientEvent("dLogi", root, qq)
	triggerEvent("admin:faction", root, qq)
	sprawdz(target)
	wypusc(target)
end
end
addCommandHandler("wypusc", unaj)

setTimer(function()
for _,p in pairs(getElementsByType("player")) do
sprawdz(p)
end
 end,1000,0)

function spawn()
local x=exports["dmta_base_connect"]:query("SELECT Termin FROM db_jail WHERE Serial=? and Termin > NOW()",getPlayerSerial(source))
if x and #x <= 0 then return end
sprawdzczas(source)
end
addEventHandler("onPlayerSpawn", getRootElement(), spawn)

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
