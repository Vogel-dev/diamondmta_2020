--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

-- Async:setDebug(true)
Async:setPriority('medium')

local db = exports['dmta_base_connect']

function loadVehicle(id, warp)
	local result = db:query('select * from db_vehicles where id=? and (parking=0 or parking=2) and garage=0 limit 1', id)
	local tick = getTickCount()
	if result and #result > 0 then
		for i,v in ipairs(result) do
			local position = fromJSON(v['position']) or {0,0,0}

			local vehicle = createVehicle(v['model'], unpack(position))
			if vehicle and isElement(vehicle) then
				outputDebugString('DMTA/VEH/BASE - Pomyślne załadowanie pojazdu (id: '..id..') w '..(getTickCount() - tick)..'ms')
				
				local rotation = fromJSON(v['rotation']) or {0,0,0}
				local color = fromJSON(v['color']) or {255,255,255,255,255,255}
				local lightColor = fromJSON(v['lightColor']) or {255,255,255}
				local wheelColor = fromJSON(v['wheelColor']) or {255,255,255}
				local tuning = fromJSON(v['tuning']) or {}
				local panelState = fromJSON(v['panelState']) or {}
				local doorState = fromJSON(v['doorState']) or {}

				setVehicleColor(vehicle, unpack(color))
				setVehicleHeadLightColor(vehicle, unpack(lightColor))
				setElementData(vehicle, 'vehicle:wheel' ,unpack(wheelColor))

				setElementRotation(vehicle, unpack(rotation))

				setVehiclePaintjob(vehicle, (v['paint'] == 0 and 3 or v['paint']))
				setVehiclePlateText(vehicle, 'LS '..v['id'])
				
				setElementHealth(vehicle, v['health'])

				for i,v in ipairs(panelState) do
					i = i - 1
					setVehiclePanelState(vehicle, i, tonumber(v))
				end

				for i,v in ipairs(doorState) do
					i = i - 1
					setVehicleDoorState(vehicle, i, tonumber(v))
				end

				for i,v in ipairs(tuning) do
					addVehicleUpgrade(vehicle, tonumber(v))
				end

				v['type'] = v['type'] == '' and 'Benzyna' or v['type']

				setElementData(vehicle, 'vehicle:owner', v['owner'])
				setElementData(vehicle, 'vehicle:ownerName', v['ownerName'])
				setElementData(vehicle, 'vehicle:id', v['id'])
				setElementData(vehicle, 'vehicle:distance', v['distance'])
				setElementData(vehicle, 'vehicle:fuel', v['fuel'])
				setElementData(vehicle, 'vehicle:type', v['type'])
				setElementData(vehicle, 'vehicle:actualType', (v['type'] == 'LPG' and 'Benzyna' or v['type']))
				setElementData(vehicle, 'vehicle:engine', string.format('%.1f', v['engine']))

				if v['type'] == 'LPG' then
					setElementData(vehicle, 'vehicle:gas', v['gas'])
				end

				setElementData(vehicle, 'vehicle:bak', v['bak'])
				setElementData(vehicle, 'vehicle:lastDriver', v['lastDriver'])

				setVehicleHandling(vehicle, 'driveType', v['driveType'])

				if v['neon'] ~= '' then
					exports['neons']:createNeon(vehicle, v['neon'])
				end

				exports['dmta_base_blips']:createBlipAttachedVehicle(v['id'])

				if warp then
					warpPedIntoVehicle(warp, vehicle)
				end
				
				setVehicleEngine(vehicle)

				return vehicle
			end
		end
	end
	return false
end

function saveVehicle(vehicle)
	if vehicle and isElement(vehicle) then
		local id = getElementData(vehicle, 'vehicle:id')
		if not id then return end

		local position = {getElementPosition(vehicle)} or {0,0,0}
		local rotation = {getElementRotation(vehicle)} or {0,0,0}
		local color = {getVehicleColor(vehicle, true)} or {0,0,0,0,0,0}
		local lightColor = {getVehicleHeadLightColor(vehicle)} or {255,255,255}
		local wheelColor = {getElementData(vehicle, 'vehicle:wheel')} or {255,255,255}
		local tuning = getVehicleUpgrades(vehicle) or {}
		local panelState = {0,0,0,0,0,0,0}
		local doorState = {0,0,0,0,0,0}
		local health = getElementHealth(vehicle)
		local distance = getElementData(vehicle, 'vehicle:distance') or 0
		local fuel = getElementData(vehicle, 'vehicle:fuel') or 0
		local gas = getElementData(vehicle, 'vehicle:gas') or 0
		local lastDriver = getElementData(vehicle, 'vehicle:lastDriver') or ''

		for i = 1,7 do
			panelState[i] = getVehiclePanelState(vehicle, (i - 1))
		end

		for i = 1,6 do
			doorState[i] = getVehicleDoorState(vehicle, (i - 1))
		end
	
		local query = db:query('update db_vehicles set position=?, rotation=?, color=?, lightColor=?, wheelColor=?, tuning=?, panelState=?, doorState=?, health=?, distance=?, fuel=?, gas=?, lastDriver=? where id=? limit 1', toJSON(position), toJSON(rotation), toJSON(color), toJSON(lightColor), toJSON(wheelColor), toJSON(tuning), toJSON(panelState), toJSON(doorState), health, distance, fuel, gas, lastDriver, id)
		if query then
			return true
		end
		return false
	end
end

function loadAllVehicles()
	local result = db:query('select * from db_vehicles where (parking=0 or parking=2)')
	Async:foreach(result, function(v)
		loadVehicle(v['id'])
	end)
end

function saveAllVehicles()
	Async:foreach(getElementsByType('vehicle'), function(v)
		saveVehicle(v)
	end)
end

function addVehicleToTable(model, position, rotation, owner, ownerName, create, distance, bak, type, color, driveType, engine, warp)
	local query, _, id = db:query('insert into db_vehicles (model, position, owner, ownerName, color, lightColor, tuning, panelState, doorState, distance, bak, type, rotation, driveType, engine) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', model, toJSON(position), owner, ownerName, toJSON(color), toJSON({255,255,255}), toJSON({}), toJSON({0, 0, 0, 0, 0, 0, 0}), toJSON({0, 0, 0, 0, 0, 0}), distance, bak, type, toJSON(rotation), driveType, engine)
	if query then
		if create then
			local result = db:query('select * from db_vehicles where id=? limit 1', id)
			if result and #result > 0 then
				loadVehicle(id, warp)
			end
		end
		outputDebugString('DMTA/VEH/SHOP - Pomyślnie dodano nowy pojazd do bazy danych (id: '..id..')')
		return true
	end
	return false
end

addEventHandler('onResourceStart', resourceRoot, function()
	loadAllVehicles()
end)

addEventHandler('onResourceStop', resourceRoot, function()
	saveAllVehicles()
end)

addEventHandler('onVehicleStartEnter', root, function(player, seat)
	if seat ~= 0 then return end
	if getVehicleController(source) ~= player then
		cancelEvent()
	end
end)

setTimer(function()
	for _, v in pairs(getElementsByType('vehicle')) do
		if getElementHealth(v) <= 300 then
			setVehicleEngineState(v,false)
			setElementHealth(v, 325)
		end

		if isElementFrozen(v) == true and not getVehicleController(v) and isVehicleDamageProof(v) ~= true then
			setVehicleDamageProof(v, true)
		elseif isElementFrozen(v) ~= true and getVehicleController(v) and isVehicleDamageProof(v) == true then
			setVehicleDamageProof(v, false)
		end

		if getElementData(v, 'vehicle:nodamaged') then
			setVehicleDamageProof(v, true)
		end
 	end
end, 500, 0)

addEventHandler('onVehicleEnter', root, function(player, seat)
	if seat ~= 0 then return end
	setElementData(source, 'vehicle:lastDriver', getPlayerName(player))
	setVehicleEngineState(source, false)
end)

addEventHandler('onVehicleExit', root, function(player, seat)
	if seat ~= 0 then return end
	--setVehicleEngineState(source, false)
	--setVehicleOverrideLights(source, 1)
end)

local prawko = {
	['A'] = {
		[462] = true,
		[448] = true,
		[581] = true,
		[522] = true,
		[461] = true,
		[521] = true,
		[523] = true,
		[463] = true,
		[586] = true,
		[463] = true,
		[471] = true,
	},
	['C'] = {
		[408] = true,
		[416] = true,
		[433] = true,
		[427] = true,
		[528] = true,
		[407] = true,
		[544] = true,
		[601] = true,
		[428] = true,
		[499] = true,
		[609] = true,
		[498] = true,
		[524] = true,
		[578] = true,
		[573] = true,
		[455] = true,
		[588] = true,
		[423] = true,
		[414] = true,
		[456] = true,
	},
	--reszta to kategoria B :)
}

function isPlayerHavePJ(player, vehicle_model)
	--if getElementData(player, 'zpj', true) then
	local q = db:query('select * from db_punishments where (serial=? or ip=? or nick=?) and active=1 and type=? and date>now() limit 1', getPlayerSerial(player), getPlayerIP(player), getPlayerName(player), 'pj')
	if q and #q > 0 then
		outputChatBox('-------------------------------------------', player, 255, 0, 0)
		outputChatBox('Posiadasz zawieszone prawo jazdy!', player, 255, 0, 0)
		outputChatBox('Osoba zawieszająca: '..q[1]['admin'], player, 255, 0, 0)
		outputChatBox('Powód zawieszenia: '..q[1]['reason'], player, 255, 0, 0)
		outputChatBox('Czas zawieszenia: '..q[1]['date'], player, 255, 0, 0)
		outputChatBox('----------------------------------------', player, 255, 0, 0)
		return false
	else
		db:query('update db_punishments set active=0 where (serial=? or ip=? or nick=?) and type=? limit 1',getPlayerSerial(player), getPlayerIP(player), getPlayerName(player), 'pj')
	end

	local result = db:query('select * from db_users where login=? limit 1', getPlayerName(player))
	if result and #result > 0 then
		if prawko['A'][vehicle_model] and result[1]['prawkoA'] ~= 1 then
			exports['dmta_base_notifications']:addNotification(player, 'Aby kierować ten pojazd musisz posiadać prawo jazdy kategorii A.', 'error')
			return false
		elseif (not prawko['A'][vehicle_model] and not prawko['C'][vehicle_model] and result[1]['prawkoB'] ~= 1)then
			exports['dmta_base_notifications']:addNotification(player, 'Aby kierować ten pojazd musisz posiadać prawo jazdy kategorii B.', 'error')
			return false
		elseif prawko['C'][vehicle_model] and result[1]['prawkoC'] ~= 1 then
			exports['dmta_base_notifications']:addNotification(player, 'Aby kierować ten pojazd musisz posiadać prawo jazdy kategorii C.', 'error')
			return false
		end
	end

	return true
end

addEventHandler("onVehicleStartEnter", root, function(g, typ)
	if typ ~= 0 then return end
	local serial = getPlayerSerial(g)
	local q = db:query('select * from db_punishments where (serial=? or ip=? or nick=?) and active=1 and type=? and date>now() limit 1', getPlayerSerial(g), getPlayerIP(g), getPlayerName(g), 'pj')
	if q and #q > 0 then
		outputChatBox('-------------------------------------------', g, 255, 0, 0)
		outputChatBox('Posiadasz zawieszone prawo jazdy!', g, 255, 0, 0)
		outputChatBox('Osoba zawieszająca: '..q[1]['admin'], g, 255, 0, 0)
		outputChatBox('Powód zawieszenia: '..q[1]['reason'], g, 255, 0, 0)
		outputChatBox('Czas zawieszenia: '..q[1]['date'], g, 255, 0, 0)
		outputChatBox('----------------------------------------', g, 255, 0, 0)
		cancelEvent()
		setElementData(g, "block:prawko", true)
	else
		db:query('update db_punishments set active=0 where (serial=? or ip=? or nick=?) and type=? limit 1',getPlayerSerial(g), getPlayerIP(g), getPlayerName(g), 'pj')
		setElementData(g, "block:prawko", false)
	end
end)

addEventHandler('onVehicleStartEnter', root, function(player, seat)
	if seat ~= 0 or getElementData(player, 'rank:duty') and getElementData(player, 'rank:duty') >= 4 then return end

	if not isPlayerHavePJ(player, getElementModel(source)) then
		cancelEvent()
		return
	end

	local id = getElementData(source, "vehicle:id")
	local own = getElementData(player, "user:oname")
	if(id and own)then
		local q = exports.dmta_base_connect:query("select * from db_vehicles where id=?", id)
		if(q[1].organization == own)then
			return
		end
	end

	if getElementData(source, 'vehicle:ownerName') and getElementData(source, 'vehicle:ownerName') ~= getPlayerName(player) then
		exports['dmta_base_notifications']:addNotification(player, 'Nie posiadasz kluczyków do tego pojazdu.', 'error')
		cancelEvent()
	end
end)