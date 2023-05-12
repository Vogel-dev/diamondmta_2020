--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local noti = exports['dmta_base_notifications']
local db = exports['dmta_base_connect']
local vehicles = exports['dmta_veh_base']
local duty = exports['dmta_base_duty']

local blip1 = createBlip(1111.2958984375,-1372.830078125,13.984375, 55)
local blip2 = createBlip(543.63854980469,-1285.4106445313,19.234375, 55)
local blip3 = createBlip(2528.4501953125,-1537.2049560547,23.511486053467, 14)
setBlipVisibleDistance(blip1, 300)
setBlipVisibleDistance(blip2, 300)
setBlipVisibleDistance(blip3, 300)

local salon = {}

function salon:Load()
    self['marker_hit-fnc'] = function(...) self:MarkerHit(...) end
    self['test_ride-fnc'] = function(info) self:TestRide(info) end
    self['stop_test_ride-fnc'] = function() self:Stop_TestDrive() end
    self['exit_fnc'] = function(...) self:Exit(...) end
    self['buy_vehicle-fnc'] = function(...) self:BuyVehicle(...) end

    self['vehicles'] = {}
    self['markers'] = {}

    self['respawn_time'] = 5000 -- in ms

    self['places'] = {
        ['Los Santos - Cygan [El Corona]'] = {
            {pos={2507.5573730469,-1519.7009277344,23.719057846069,229.72242736816},
            vehicles={
                {name='Perennial', cost=8750, distance=math.random(250000,300000), engine='1.2', type='Diesel', lpg='nie'},
                {name='Moonbeam', cost=6500, distance=math.random(250000,300000), engine='1.2', type='Diesel', lpg='nie'},
                {name='Manana', cost=11750, distance=math.random(250000,300000), engine='1.2', type='Diesel', lpg='nie'}
            },
            registration='CYGAN',
            test_pos={2517.7778320313,-1515.9793701172,23.776306915283,356.88983154297},
            salon=false},

            {pos={2506.4829101563,-1529.1475830078,23.731121063232,269.28335571289},
            vehicles={
                {name='Walton', cost=5000, distance=math.random(250000,300000), engine='1.2', type='Diesel', lpg='nie'},
                {name='Club', cost=13000, distance=math.random(250000,300000), engine='1.4', type='Diesel', lpg='nie'},
                {name='Uranus', cost=12500, distance=math.random(250000,300000), engine='1.2', type='Diesel', lpg='nie'}
            },
            registration='CYGAN',
            test_pos={2517.7778320313,-1515.9793701172,23.776306915283,356.88983154297},
            salon=false},

            {pos={2507.4475097656,-1537.3049316406,23.594011306763,309.47155761719},
            vehicles={
                {name='Manana', cost=17999, distance=math.random(250000,300000), engine='1.6', type='Diesel', lpg='nie'},
                {name='Cadrona', cost=13150, distance=math.random(250000,300000), engine='1.4', type='Diesel', lpg='nie'},
                {name='Blista Compact', cost=9000, distance=math.random(250000,300000), engine='1.2', type='Diesel', lpg='nie'}
            },
            registration='CYGAN',
            test_pos={2517.7778320313,-1515.9793701172,23.776306915283,356.88983154297},
            salon=false},

            {pos={2532.8532714844,-1531.6955566406,23.797794342041,73.704086303711},
            vehicles={
                {name='Vincent', cost=12999, distance=math.random(250000,300000), engine='1.4', type='Diesel', lpg='nie'},
                {name='Sunrise', cost=19999, distance=math.random(250000,300000), engine='1.6', type='Diesel', lpg='nie'},
                {name='Uranus', cost=15250, distance=math.random(250000,300000), engine='1.4', type='Diesel', lpg='nie'}
            },
            registration='CYGAN',
            test_pos={2517.7778320313,-1515.9793701172,23.776306915283,356.88983154297},
            salon=false},
            
            {pos={2532.3286132813,-1523.5471191406,23.77113609314,106.85285186768},
            vehicles={
                {name='Previon', cost=11000, distance=math.random(250000,300000), engine='1.2', type='Diesel', lpg='nie'},
                {name='Majestic', cost=9600, distance=math.random(250000,300000), engine='1.2', type='Diesel', lpg='nie'},
                {name='Regina', cost=8600, distance=math.random(250000,300000), engine='1.2', type='Diesel', lpg='nie'}
            },
            registration='CYGAN',
            test_pos={2517.7778320313,-1515.9793701172,23.776306915283,356.88983154297},
            salon=false},
        },
        ['Los Santos - Luxury [Modded]'] = {
            {pos={2478.2236328125,-1655.5594482422,1022.7204711914,270.23718261719},
            vehicles={
                {name='Premier', cost=565000, distance=math.random(0,10), engine='2.4', type='Benzyna', lpg='nie'},
                {name='Premier', cost=615000, distance=math.random(0,10), engine='2.2', type='Benzyna', lpg='nie'},
                {name='Premier', cost=795000, distance=math.random(0,10), engine='2.6', type='Benzyna', lpg='nie'}
            },
            registration='LUXURY',
            test_pos={1123.9619140625,-1325.6408691406,13.418662071228,359.47448730469},
            salon=true},

            {pos={2486.529296875,-1663.9653320313,1022.6204711914,359.22463989258},
            vehicles={
                {name='Glendale', cost=375000, distance=math.random(0,10), engine='2.0', type='Benzyna', lpg='nie'},
                {name='Glendale', cost=420000, distance=math.random(0,10), engine='2.4', type='Benzyna', lpg='nie'},
                {name='Glendale', cost=565000, distance=math.random(0,10), engine='2.8', type='Benzyna', lpg='nie'}
            },
            registration='LUXURY',
            test_pos={1123.9619140625,-1325.6408691406,13.418662071228,359.47448730469},
            salon=true},

            {pos={2495.5732421875,-1663.3460693359,1022.6204711914,359.22463989258},
            vehicles={
                {name='Super GT', cost=1250000, distance=math.random(0,10), engine='2.0', type='Benzyna', lpg='nie'},
                {name='Super GT', cost=1320000, distance=math.random(0,10), engine='2.4', type='Benzyna', lpg='nie'},
                {name='Super GT', cost=1405000, distance=math.random(0,10), engine='2.8', type='Benzyna', lpg='nie'}
            },
            registration='LUXURY',
            test_pos={1123.9619140625,-1325.6408691406,13.418662071228,359.47448730469},
            salon=true},

            {pos={2503.2133789063,-1655.7447509766,1022.9204711914,88.525482177734},
            vehicles={
                {name='Huntley', cost=1150000, distance=math.random(0,10), engine='2.0', type='Benzyna', lpg='nie'},
                {name='Huntley', cost=1250000, distance=math.random(0,10), engine='2.8', type='Benzyna', lpg='nie'},
                {name='Huntley', cost=1320000, distance=math.random(0,10), engine='2.4', type='Benzyna', lpg='nie'}
            },
            registration='LUXURY',
            test_pos={1123.9619140625,-1325.6408691406,13.418662071228,359.47448730469},
            salon=true},

            {pos={2502.9624023438,-1646.4914550781,1022.7504711914,90.092086791992},
            vehicles={
                {name='Elegant', cost=565000, distance=math.random(0,10), engine='2.6', type='Benzyna', lpg='nie'},
                {name='Elegant', cost=565000, distance=math.random(0,10), engine='2.4', type='Benzyna', lpg='nie'},
                {name='Elegant', cost=685000, distance=math.random(0,10), engine='3.0', type='Benzyna', lpg='nie'}
            },
            registration='LUXURY',
            test_pos={1123.9619140625,-1325.6408691406,13.418662071228,359.47448730469},
            salon=true},

            {pos={2495.2985839844,-1639.2130126953,1022.6783325195,181.89964294434},
            vehicles={
                {name='Slamvan', cost=215000, distance=math.random(0,10), engine='1.4', type='Benzyna', lpg='nie'},
                {name='Slamvan', cost=350000, distance=math.random(0,10), engine='1.6', type='Benzyna', lpg='nie'},
                {name='Slamvan', cost=410000, distance=math.random(0,10), engine='1.9', type='Benzyna', lpg='nie'}
            },
            registration='LUXURY',
            test_pos={1123.9619140625,-1325.6408691406,13.418662071228,359.47448730469},
            salon=true},
        },

        ['Los Santos - Salon [Rodeo]'] = {
            {pos={559.97570800781,-1300.4810791016,16.888254165649,52.273315429688},
            vehicles={
                {name='Cadrona', cost=30000, distance=math.random(0,10), engine='1.6', type='Benzyna', lpg='nie'},
                {name='Stallion', cost=25000, distance=math.random(0,10), engine='1.8', type='Diesel', lpg='nie'},
                {name='Hermes', cost=32000, distance=math.random(0,10), engine='1.6', type='Diesel', lpg='nie'}
            },
            registration='SALON',
            test_pos={514.5859375,-1309.2454833984,17.2421875,0.9137812256813},
            salon=true},
            
            {pos={526.10076904297,-1299.9045410156,20.880268096924,347.12103271484},
            vehicles={
                {name='Blade', cost=25000, distance=math.random(0,10), engine='1.8', type='Benzyna', lpg='nie'},
                {name='Stratum', cost=31000, distance=math.random(0,10), engine='1.8', type='Diesel', lpg='nie'},
                {name='Voodoo', cost=19000, distance=math.random(0,10), engine='1.6', type='Diesel', lpg='nie'}
            },
            registration='SALON',
            test_pos={514.5859375,-1309.2454833984,17.2421875,0.9137812256813},
            salon=true},

            {pos={531.51177978516,-1300.3636474609,20.880342483521,347.13623046875},
            vehicles={
                {name='Mesa', cost=40000, distance=math.random(0,10), engine='1.8', type='Diesel', lpg='nie'},
                {name='Yosemite', cost=37000, distance=math.random(0,10), engine='1.8', type='Benzyna', lpg='nie'},
                {name='Mesa', cost=46000, distance=math.random(0,10), engine='1.8', type='Benzyna', lpg='nie'}
            },
            registration='SALON',
            test_pos={514.5859375,-1309.2454833984,17.2421875,0.9137812256813},
            salon=true},

            {pos={536.974609375,-1300.4560546875,20.880300521851,350.46447753906},
            vehicles={
                {name='Greenwood', cost=45000, distance=math.random(0,10), engine='1.6', type='Benzyna', lpg='nie'},
                {name='Virgo', cost=53000, distance=math.random(0,10), engine='1.6', type='Diesel', lpg='nie'},
                {name='Remington', cost=33000, distance=math.random(0,10), engine='1.6', type='Diesel', lpg='nie'}
            },
            registration='SALON',
            test_pos={514.5859375,-1309.2454833984,17.2421875,0.9137812256813},
            salon=true},
            {pos={523.51416015625,-1300.1196289063,16.914600372314,331.75756835938},
            vehicles={
                {name='Greenwood', cost=60000, distance=math.random(0,10), engine='1.8', type='Diesel', lpg='nie'},
                {name='Virgo', cost=65000, distance=math.random(0,10), engine='1.8', type='Benzyna', lpg='nie'},
                {name='Remington', cost=45000, distance=math.random(0,10), engine='1.8', type='Diesel', lpg='nie'}
            },
            registration='SALON',
            test_pos={514.5859375,-1309.2454833984,17.2421875,0.9137812256813},
            salon=true},

            {pos={529.65307617188,-1300.0498046875,16.929599761963,341.12365722656},
            vehicles={
                {name='Phoenix', cost=65000, distance=math.random(0,10), engine='1.8', type='Benzyna', lpg='nie'},
                {name='Euros', cost=50000, distance=math.random(0,10), engine='1.8', type='Benzyna', lpg='nie'},
                {name='Intruder', cost=70000, distance=math.random(0,10), engine='1.8', type='Diesel', lpg='nie'}
            },
            registration='SALON',
            test_pos={514.5859375,-1309.2454833984,17.2421875,0.9137812256813},
            salon=true},

            {pos={534.78997802734,-1300.3643798828,16.939853668213,344.13464355469},
            vehicles={
                {name='Jester', cost=85000, distance=math.random(0,10), engine='1.8', type='Benzyna', lpg='nie'},
                {name='Stafford', cost=85000, distance=math.random(0,10), engine='1.8', type='Benzyna', lpg='nie'},
                {name='Washington', cost=75000, distance=math.random(0,10), engine='1.8', type='Diesel', lpg='nie'}
            },
            registration='SALON',
            test_pos={514.5859375,-1309.2454833984,17.2421875,0.9137812256813},
            salon=true},--[[
            {pos={554.80584716797,-1301.4427490234,16.861810684204,33.983276367188},
            vehicles={
                {name='BF-400', cost=8000, distance=math.random(0,10), engine='1.2', type='Benzyna', lpg='nie'},
                {name='BF-400', cost=13000, distance=math.random(0,10), engine='1.4', type='Diesel', lpg='nie'},
                {name='BF-400', cost=19000, distance=math.random(0,10), engine='1.6', type='Diesel', lpg='nie'}
            },
            registration='SALON',
            test_pos={514.5859375,-1309.2454833984,17.2421875,0.9137812256813},
            salon=true},

            {pos={548.69000244141,-1301.6286621094,16.803573608398,33.420288085938},
            vehicles={
                {name='Freeway', cost=9000, distance=math.random(0,10), engine='1.2', type='Diesel', lpg='nie'},
                {name='Freeway', cost=14000, distance=math.random(0,10), engine='1.4', type='Diesel', lpg='nie'},
                {name='Freeway', cost=20000, distance=math.random(0,10), engine='1.6', type='Benzyna', lpg='nie'}
            },
            registration='SALON',
            test_pos={514.5859375,-1309.2454833984,17.2421875,0.9137812256813},
            salon=true},

            {pos={542.35327148438,-1301.5695800781,16.882869720459,26.719177246094},
            vehicles={
                {name='PCJ-600', cost=10000, distance=math.random(0,10), engine='1.2', type='Diesel', lpg='nie'},
                {name='PCJ-600', cost=15500, distance=math.random(0,10), engine='1.4', type='Benzyna', lpg='nie'},
                {name='PCJ-600', cost=22200, distance=math.random(0,10), engine='1.6', type='Diesel', lpg='nie'}
            },
            registration='SALON',
            test_pos={514.5859375,-1309.2454833984,17.2421875,0.9137812256813},
            salon=true},--]]
        }
    }

    for i,v in pairs(self['places']) do
        outputDebugString('DMTA/VEH/SHOP Wczytano salon: '..i)
        self:CreateVehicles(v, i)
    end

    addEvent('TestRide', true)
    addEventHandler('TestRide', resourceRoot, self['test_ride-fnc'])

    addEvent('BuyVehicle', true)
    addEventHandler('BuyVehicle', resourceRoot, self['buy_vehicle-fnc'])

    addEvent('Stop:TestRide', true)
    addEventHandler('Stop:TestRide', resourceRoot, self['stop_test_ride-fnc'])
end

function salon:CreateVehicles(data, name)
    local x = 0
    for _,v in ipairs(data) do
        x = x + 1

        i = x .. name

        local row = v['vehicles'][math.random(1,#v['vehicles'])]

        row['driveType'] = getModelHandling(getVehicleModelFromName(row['name']))['driveType']

        self['vehicles'][i] = createVehicle(getVehicleModelFromName(row['name']), v['pos'][1], v['pos'][2], v['pos'][3], 0, 0, v['pos'][4])

        v['pos'][3] = v['pos'][3] + 0.275

        setElementFrozen(self['vehicles'][i], true)
        setVehiclePlateText(self['vehicles'][i], v['registration'])
        setElementData(self['vehicles'][i], 'vehicle:ghost', true)
        setElementData(self['vehicles'][i], 'vehicle:salon', true)

        local random = {math.random(0,255),math.random(0,255),math.random(0,255)}
        setVehicleColor(self['vehicles'][i], 35, 35, 35, 35, 35, 35)
        setVehicleLocked(self['vehicles'][i], true)

        row['color'] = random
        row['test_pos'] = v['test_pos']
        row['id'] = i
        row['salon'] = v['salon']
        row['pos'] = v['pos']
		    row['tank'] = 25

        self['markers'][i] = createMarker(v['pos'][1], v['pos'][2], v['pos'][3] - 0.97, 'cylinder', 3, 105, 188, 235)
        setElementData(self['markers'][i], 'info', row)
        setElementData(self['markers'][i], 'data', {name, x})
        setElementData(self.markers[i], 'marker:icon', 'brak')

        addEventHandler('onMarkerHit', self['markers'][i], self['marker_hit-fnc'])
    end
end

function salon:CreateVehicle(name, i)
    local v = self['places'][name][i]
    if not v then return end

    local row = v['vehicles'][math.random(1,#v['vehicles'])]

    row['driveType'] = getModelHandling(getVehicleModelFromName(row['name']))['driveType']

    self['vehicles'][i] = createVehicle(getVehicleModelFromName(row['name']), v['pos'][1], v['pos'][2], v['pos'][3], 0, 0, v['pos'][4])

    setElementFrozen(self['vehicles'][i], true)
    setVehicleLocked(self['vehicles'][i], true)
    setVehiclePlateText(self['vehicles'][i], v['registration'])
    setElementData(self['vehicles'][i], 'vehicle:ghost', true)
    setElementData(self['vehicles'][i], 'vehicle:salon', true)

    local random = {math.random(0,255),math.random(0,255),math.random(0,255)}
    setVehicleColor(self['vehicles'][i], 35, 35, 35, 35, 35, 35)
    setVehicleLocked(self['vehicles'][i], true)

    row['color'] = random
    row['test_pos'] = v['test_pos']
    row['id'] = i
    row['salon'] = v['salon']
    row['pos'] = v['pos']

    self['markers'][i] = createMarker(v['pos'][1], v['pos'][2], v['pos'][3] - 0.97, 'cylinder', 3, 105, 188, 235)
    setElementData(self['markers'][i], 'info', row)
    setElementData(self['markers'][i], 'data', {name, i})
    setElementData(self.markers[i], 'marker:icon', 'brak')

    addEventHandler('onMarkerHit', self['markers'][i], self['marker_hit-fnc'])
end

function salon:TestRide(info)
    if not vehicles:isPlayerHavePJ(client, getVehicleModelFromName(info['name'])) then return end

	local pos = {getElementPosition(client)}
	setElementData(client, 'salon:pos', pos)

    local vehicle = createVehicle(getVehicleModelFromName(info['name']), info['test_pos'][1], info['test_pos'][2], info['test_pos'][3], 0, 0, info['test_pos'][4])

    setVehicleEngineState(vehicle, false)
    setVehicleColor(vehicle, 35, 35, 35)
    setVehicleLocked(vehicle, true)
    setElementData(vehicle, 'vehicle:distance', info['distance'])
    setElementData(vehicle, 'vehicle:fuel', 100)
    setVehiclePlateText(vehicle, 'TESTRIDE')
    setElementData(vehicle, 'vehicle:ghost', true)

    warpPedIntoVehicle(client, vehicle)

    noti:addNotification(client, 'Wysiądź z pojazdu, aby zaprzestać jazde próbną.', 'info')

    triggerClientEvent(client, 'TestDrive:Time', resourceRoot, true, 120)

    setElementData(client, 'test:drive', {vehicle, info})

    addEventHandler('onVehicleExit', vehicle, self['exit_fnc'])
    addEventHandler('onVehicleStartEnter', vehicle, function() cancelEvent() end)
end

function salon:BuyVehicle(info, color)
    if not vehicles:isPlayerHavePJ(client, getVehicleModelFromName(info['name'])) then return end

	triggerClientEvent(root, 'gui:off', resourceRoot, info['id'])

    takePlayerMoney(client, info['cost'])
    setElementData(client, 'user:salonachv', true)
    db:query('update db_users set money=? where login=?', getPlayerMoney(client), getPlayerName(client))

    local type = info['lpg'] == 'tak' and 'LPG' or info['type']
    local pos = {info['test_pos'][1], info['test_pos'][2], info['test_pos'][3]}
    local rot_z = info['test_pos'][4]
    if not info['salon'] then
        pos = {info['pos'][1], info['pos'][2], info['pos'][3]}
        rot_z = info['pos'][4]
    end

    local veh = self['vehicles'][info['id']]
    if veh and isElement(veh) then
        destroyElement(veh)
        veh = false
    end

    local marker = self['markers'][info['id']]
    if marker and isElement(marker) then
        local data = getElementData(marker, 'data')
        if data then
            setTimer(function()
                self:CreateVehicle(data[1], data[2])
            end, self['respawn_time'], 1)
        end

        removeEventHandler('onMarkerHit', marker, self['marker_hit-fnc'])
        destroyElement(marker)
        marker = false
    end
    local text_log = ''..getPlayerName(client)..' zakupił pojazd '..info['name']..' za '..info['cost']..' $'
		duty:addLogsDuty(text_log)
		duty:addLogs('veh', text_log, client, 'SHOP/BUY')

    vehicles:addVehicleToTable(getVehicleModelFromName(info['name']), pos, {0, 0, rot_z}, getElementData(client, 'user:dbid'), getPlayerName(client), true, info['distance'], info['tank'], type, color, info['driveType'], info['engine'], client)
end

function salon:Stop_TestDrive()
	local player = client

    local data = getElementData(player, 'test:drive')
	local pos = getElementData(player, 'salon:pos')
    if not data or not pos then return end

    removeEventHandler('onVehicleExit', data[1], self['exit_fnc'])
    removeEventHandler('onVehicleStartEnter', data[1], function() cancelEvent() end)
    destroyElement(data[1])
    setElementData(client, 'test:drive', false)
    triggerClientEvent(client, 'TestDrive:Time', resourceRoot, false)

	fadeCamera(player, false, 0.25)
	setElementData(player, 'pokaz:hud', false)
	showChat(player, false)
	setTimer(function()
		fadeCamera(player, true, 0.25)
		setElementData(player, 'pokaz:hud', true)
		showChat(player, true)
        setElementPosition(player, pos[1], pos[2], pos[3])
        noti:addNotification(player, 'Twoja jazda próbna została zakończona.', 'info')
	end, 300, 1)
end

function salon:Exit(player)
    local data = getElementData(player, 'test:drive')
	local pos = getElementData(player, 'salon:pos')
    if not data or not pos then return end

    if source == data[1] then
        removeEventHandler('onVehicleExit', source, self['exit_fnc'])
        removeEventHandler('onVehicleStartEnter', source, function() cancelEvent() end)
        destroyElement(source)
        setElementData(player, 'test:drive', false)
        triggerClientEvent(player, 'TestDrive:Time', resourceRoot, false)

		fadeCamera(player, false, 0.25)
		setElementData(player, 'pokaz:hud', false)
		showChat(player, false)
		setTimer(function()
			fadeCamera(player, true, 0.25)
			setElementData(player, 'pokaz:hud', true)
			showChat(player, true)
        	setElementPosition(player, pos[1], pos[2], pos[3])
        	noti:addNotification(player, 'Twoja jazda próbna została zakończona.', 'info')
		end, 300, 1)
    end
end

function salon:MarkerHit(hit, dim)
	if not hit or hit and not isElement(hit) or hit and isElement(hit) and getElementType(hit) ~= 'player' or hit and isElement(hit) and getElementType(hit) == 'player' and isPedInVehicle(hit) or not dim then return end

    local info = getElementData(source, 'info')
    if info then
        local veh = self['vehicles'][info['id']]
        if veh and isElement(veh) then
			local r1,g1,b1,r2,g2,b2 = getVehicleColor(veh, true)
            triggerClientEvent(hit, 'OpenGui', resourceRoot, info, {r1,g1,b1,r2,g2,b2})
        end
    end
end

addEventHandler('onResourceStart', resourceRoot, function()
    salon:Load()
end)
