--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local vhs = exports['dmta_veh_base']
local noti = exports['dmta_base_notifications']
local db = exports['dmta_base_connect']
local ghosts = exports['dmta_veh_ghosts']
local duty = exports['dmta_base_duty']

local markers = {}
local vehicles = {}
local vehs = {}

local costs = {}
local normal_cost = 5
local przechowalnie = {
	['LS-PARKING/MARKET'] = {
		odbior = {1009.1525268555,-1368.1472167969,13.342638015747},
		zostaw = {1007.7551879883,-1351.8413085938,13.43615398407},
		oddaj = {1009.0405273438,-1370.3392333984,13.34211730957},
	},
}

local parkingi = {
	{2348.6979980469,-1266.3815917969,22.238376617432,88.947387695313},
	{2348.7741699219,-1262.4417724609,22.23549079895,88.486999511719},
	{2348.5766601563,-1256.1171875,22.227083206177,90.069458007813},
	{2348.5668945313,-1252.3015136719,22.227081298828,89.44873046875},
	{2348.7907714844,-1246.2075195313,22.227079391479,89.362182617188},
	{2348.8063964844,-1243.2056884766,22.227081298828,89.506652832031},
	{2349.0266113281,-1237.3309326172,22.227079391479,87.911804199219},
	{2348.7316894531,-1233.7763671875,22.227081298828,90.653686523438},
	{2348.2219238281,-1227.8116455078,22.227079391479,89.018005371094},
	{2348.5456542969,-1224.5017089844,22.227075576782,89.577392578125},
	{2348.8173828125,-1221.3499755859,22.227081298828,90.606323242188},
	{2348.4816894531,-1217.9907226563,22.227079391479,88.056640625},
}

function getRespawnPos()
	local rnd = math.random(1,#parkingi)
	local pos = parkingi[rnd]
	return parkingi[rnd][1], parkingi[rnd][2], parkingi[rnd][3], parkingi[rnd][4]
end

local parking = createColCuboid(2313.73145, -1276.13342, 21.29089, 46.940673828125, 62.256591796875, 5)
local marker_1 = createMarker(2316.0844726563,-1217.8238525391,23.696102142334, 'corona', 3, 105, 188, 235, 100)
local marker_2 = createMarker(2357.1638183594,-1272.0625,23.366167068481, 'corona', 3, 105, 188, 235, 100)

for i,v in pairs(przechowalnie) do
	outputDebugString('DMTA/VEH/PARKING Pomyślnie utworzono przechowalnie: '..i)

	local odbior = createMarker(v['odbior'][1], v['odbior'][2], v['odbior'][3]-1, 'cylinder', 1.2, 55, 125, 25, 75)
	local oddaj = createMarker(v['oddaj'][1], v['oddaj'][2], v['oddaj'][3]-1, 'cylinder', 1.2, 150, 22, 25, 75)
	local zostaw = createMarker(v['zostaw'][1], v['zostaw'][2], v['zostaw'][3]-1, 'cylinder', 3, 105, 188, 235, 75)
	local cs_zostaw = createColSphere(v['zostaw'][1], v['zostaw'][2], v['zostaw'][3]-1, 3)

	setElementData(oddaj, 'oddaj', cs_zostaw)
	setElementData(odbior, 'odbior', true)
	setElementData(zostaw, 'zostaw', true)
	setElementData(oddaj, 'marker:icon', 'car')
	setElementData(odbior, 'marker:icon', 'car')
	setElementData(zostaw, 'marker:icon', 'car')
	local tw=createElement("text")
	setElementData(tw, "text", 'Oddaj pojazd na parking strzeżony')
	setElementPosition(tw, 1009.0405273438,-1370.3392333984,13.34211730957)
	local tw=createElement("text")
	setElementData(tw, "text", 'Odbierz pojazd z parkingu strzeżonego')
	setElementPosition(tw, 1009.1525268555,-1368.1472167969,13.342638015747)
end

function isVehicleExists(id)
	local q = db:query('select * from db_vehicles where parking=0 and garage=0 and id=?', id)
	if q and #q > 0 then
		return true
	end
	return false
end

addEvent('wyjmij:auto', true)
addEventHandler('wyjmij:auto', resourceRoot, function(player, vehID, cost)
	if not markers[player] then return end

	if isVehicleExists(vehID) then
		noti:addNotification(player, 'Podany pojazd już istnieje.', 'error')
		return
	end

	db:query('update db_vehicles set parking=0 where id=?', vehID)

	noti:addNotification(player, 'Udaj się do wyjazdu, aby opłacić usługę i wyciągnąć pojazd.', 'success')
	local vehicle = vhs:loadVehicle(vehID)
	if vehicle and isElement(vehicle) then
		local x,y,z,rz = getRespawnPos()
		setElementPosition(vehicle, x, y, z)
		setElementRotation(vehicle, 0, 0, rz)
		warpPedIntoVehicle(player, vehicle)
		setElementData(vehicle, 'parking', cost)
	end
end)

addEvent('wloz:auto', true)
addEventHandler('wloz:auto', resourceRoot, function(veh)
	local id = getElementData(veh, 'vehicle:id')
	if not id then return end

	local cost = costs[getVehicleName(veh)] or normal_cost
	db:query('update db_vehicles set parking=1, parking_takedate=now(), parking_date=now(), parking_cost=? where id=?', cost, id)
	vhs:saveVehicle(veh)
	noti:addNotification(client, 'Twój pojazd został oddany na parking strzeżony.', 'success')

	local time = 500
	setVehicleLocked(veh, true)
	setElementFrozen(veh, true)
	ghosts:alphaDown(veh, time, 255)
	setTimer(function()
		if veh and isElement(veh) then
			destroyElement(veh)
		end
	end, time, 1)
end)

addEventHandler('onMarkerHit', resourceRoot, function(hit, dim)
	if not hit or hit and not isElement(hit) or hit and isElement(hit) and getElementType(hit) ~= 'player' or not dim then return end

	local odbior = getElementData(source, 'odbior')
	local oddaj = getElementData(source, 'oddaj')
	local zostaw = getElementData(source, 'zostaw')
	local veh = getPedOccupiedVehicle(hit)
	if odbior and not isPedInVehicle(hit) then
		markers[hit] = source

		local vehicles = db:query('select timediff(now(), parking_date), parking_cost, id, model from db_vehicles where ownerName=? and parking=1', getPlayerName(hit))
		for i,v in ipairs(vehicles) do
			local hours = string.format('%1d', string.sub(v['timediff(now(), parking_date)'], 1, 2))
			hour = tonumber(hours) > 336 and 336 or hours -- jesli auto stoi wiecej niz 2 tygodnie nie nalicza dalej.

			local cost = costs[getVehicleNameFromModel(v['model'])] or normal_cost
			db:query('update db_vehicles set parking_cost=parking_cost+?*?, parking_date=now() where id=?', cost, hours, v['id'])
		end

		vehicles = db:query('select * from db_vehicles where ownerName=? and parking=1', getPlayerName(hit)) -- update po dodaniu ceny ;x
		if #vehicles > 0 then
			triggerClientEvent(hit, 'lista:aut', resourceRoot, vehicles)
		else
			noti:addNotification(hit, 'Nie posiadasz pojazdów do odebrania.', 'error')
		end
	elseif oddaj and isElement(oddaj) and not isPedInVehicle(hit) then
		local vehicles = getElementsWithinColShape(oddaj, 'vehicle')
		local vehicle = vehicles[1]
		if vehicle and isElement(vehicle) then
			local id = getElementData(vehicle, 'vehicle:id')
			local owner = getElementData(vehicle, 'vehicle:ownerName')
			if id and owner and owner == getPlayerName(hit) then
				local cost = costs[getVehicleName(vehicle)] or normal_cost
				triggerClientEvent(hit, 'gui:show', resourceRoot, vehicle, cost)
			else
				noti:addNotification(hit, 'Ten pojazd nie należy do ciebie.', 'error')
			end
		end
	elseif zostaw then
		if isPedInVehicle(hit) then
			noti:addNotification(hit, 'Udaj się do punktu obok, aby oddać pojazd.', 'info')
		else
			noti:addNotification(hit, 'W tym miejscu pozostaw pojazd.', 'info')
		end
	elseif source == marker_1 or source == marker_2 and veh and isElement(veh) then
		local veh = getPedOccupiedVehicle(hit)
		local cost = getElementData(veh, 'parking')
		local id = getElementData(veh, 'vehicle:id')
		if not cost or not id or not veh or veh and not isElement(veh) then return end

		if cost <= getPlayerMoney(hit) then
			takePlayerMoney(hit, cost)
			local text_log = getPlayerName(hit)..' wyciąga pojazd '..getVehicleName(veh)..' (ID) '..id..' za koszt: '..cost..' $'
			duty:addLogs('veh', text_log, hit, 'PARKING/WYCIAG')
			db:query('update db_users set money=? where login=?', getPlayerMoney(hit), getPlayerName(hit))
			db:query('update db_vehicles set parking_cost=0 where id=?', id)
			noti:addNotification(hit, 'Wyciągnąłeś swój pojazd z parkingu za opłatą '..math.floor(cost)..'$.', 'success')
			setElementData(veh, 'parking', false)

			setElementFrozen(veh, true)
			showChat(hit, false)
			setElementData(hit, 'pokaz:hud', false)
			fadeCamera(hit, false, 0.25)
			setTimer(function()
				if veh and isElement(veh) and hit and isElement(hit) then
					local x,y,z,rz = 1006.3422851563,-1344.3212890625,13.356576919556,89.189865112305
					setElementPosition(veh, x, y, z)
					setElementRotation(veh, 0, 0, rz)
					setElementFrozen(veh, false)
					showChat(hit, true)
					setElementData(hit, 'pokaz:hud', true)
					fadeCamera(hit, true, 0.25)
				end
			end, 2000, 1)
		else
			noti:addNotification(hit, 'Nie posiadasz wystarczających funduszy.', 'error')	

			db:query('update db_vehicles set parking=1 where id=?', id)
			destroyElement(veh)

			showChat(hit, false)
			setElementData(hit, 'pokaz:hud', false)
			fadeCamera(hit, false, 0.25)
			setTimer(function()
				if not hit or hit and not isElement(hit) then return end
				showChat(hit, true)
				setElementData(hit, 'pokaz:hud', true)
				fadeCamera(hit, true, 0.25)
				setElementPosition(hit, 997.98999023438,-1373.0114746094,13.271255493164)		
			end, 2000, 1)
		end
	end
end)

addEventHandler('onColShapeLeave', parking, function(hit, dim)
	if not hit or hit and not isElement(hit) or hit and isElement(hit) and getElementType(hit) ~= 'player' or hit and isElement(hit) and getElementType(hit) == 'player' and not isPedInVehicle(hit) or not dim then return end
		
	local veh = getPedOccupiedVehicle(hit)
	local cost = getElementData(veh, 'parking')
	local id = getElementData(veh, 'vehicle:id')
	if not cost or not id or not veh or veh and not isElement(veh) then return end
		
	if cost <= getPlayerMoney(hit) then
		takePlayerMoney(hit, cost)
		db:query('update db_users set money=? where login=?', getPlayerMoney(hit), getPlayerName(hit))
		db:query('update db_vehicles set parking_cost=0 where id=?', id)
		noti:addNotification(hit, 'Wyciągnąłeś swój pojazd z parkingu za opłatą '..math.floor(cost)..'$.', 'success')
		setElementData(veh, 'parking', false)

		setElementFrozen(veh, true)
		showChat(hit, false)
		setElementData(hit, 'pokaz:hud', false)
		fadeCamera(hit, false, 0.25)
		setTimer(function()
			if veh and isElement(veh) and hit and isElement(hit) then
				local x,y,z,rz = 1006.3422851563,-1344.3212890625,13.356576919556,89.189865112305
				setElementPosition(veh, x, y, z)
				setElementRotation(veh, 0, 0, rz)
				setElementFrozen(veh, false)
				showChat(hit, true)
				setElementData(hit, 'pokaz:hud', true)
				fadeCamera(hit, true, 0.25)
			end
		end, 2000, 1)
	else
		noti:addNotification(hit, 'Nie posiadasz wystarczających funduszy.', 'error')	
		
		db:query('update db_vehicles set parking=1 where id=?', id)
		destroyElement(veh)

		showChat(hit, false)
		setElementData(hit, 'pokaz:hud', false)
		fadeCamera(hit, false, 0.25)
		setTimer(function()
			if not hit or hit and not isElement(hit) then return end
			showChat(hit, true)
			setElementData(hit, 'pokaz:hud', true)
			fadeCamera(hit, true, 0.25)
			setElementPosition(hit, 997.98999023438,-1373.0114746094,13.271255493164)		
		end, 2000, 1)
	end
end)

addEventHandler('onPlayerQuit', root, function()
	local veh = getPedOccupiedVehicle(source)
	if not veh then return end
		
	local parking = getElementData(veh, 'parking')
	local id = getElementData(veh, 'vehicle:id')
	if not parking or not id then return end
		
	db:query('update db_vehicles set parking=1 where id=?', id)
	destroyElement(veh)
end)

function createParkingVehicle(vehicles, player)
	vehicles[player] = {}
	for i,v in ipairs(vehicles) do
		table.insert(vehicles[player], v)
	end

	selectParkingVehicle(player, vehicles[1]['id'])
end
addEvent('createParkingVehicle', true)
addEventHandler('createParkingVehicle', resourceRoot, createParkingVehicle)

function selectParkingVehicle(player, vehID)
	local vehicles = db:query('select * from db_vehicles where ownerName=? and parking=1', getPlayerName(player))

	destroyParkingVehicle(player)

	for i,v in ipairs(vehicles) do
		if v['id'] == vehID then
			local color = fromJSON(v['color']) or {255,255,255,255,255,255}
			local tuning = fromJSON(v['tuning']) or {}

			vehs[player] = createVehicle(v['model'], 0, 0, 0)

			setElementDimension(vehs[player], 9999)
			setElementAlpha(vehs[player], 0)
			setElementCollisionsEnabled(vehs[player], false)
			setElementFrozen(vehs[player], true)
			setVehicleColor(vehs[player], unpack(color))

			for i,v in ipairs(tuning) do
				addVehicleUpgrade(vehs[player], tonumber(v))
			end

			triggerClientEvent(player, 'lista:aut', resourceRoot, '_', vehs[player])
		end
	end
end
addEvent('selectParkingVehicle', true)
addEventHandler('selectParkingVehicle', resourceRoot, selectParkingVehicle)

function destroyParkingVehicle(player)
	setElementDimension(player, 0)

	if vehs[player] and isElement(vehs[player]) then
		destroyElement(vehs[player])
		vehs[player] = false
	end

	setCameraTarget(player, player)
end
addEvent('destroyParkingVehicle', true)
addEventHandler('destroyParkingVehicle', resourceRoot, destroyParkingVehicle)

addEventHandler('onPlayerQuit', root, function()
	destroyParkingVehicle(source)
end)