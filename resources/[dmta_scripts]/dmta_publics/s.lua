--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local noti = exports.dmta_base_notifications

class 'public'
{
	vehicles = {
		['Market'] = {
			{988.22436523438,-1333.5511474609,12.98232460022,27.34130859375},
			{990.33856201172,-1333.44921875,12.981562614441,33.471801757813},
			{991.67626953125,-1332.4725341797,12.982739448547,66.722045898438},
		},
		['Urząd'] = {
			{1487.9349365234,-1713.3918457031,13.645215034485, 90},
			{1487.9349365234,-1710.3918457031,13.645215034485, 90},
			{1487.9349365234,-1707.3918457031,13.645215034485, 90},
			{1487.9349365234,-1705.3918457031,13.645215034485, 90},
			{1487.9349365234,-1702.3918457031,13.645215034485, 90},
			{1487.9349365234,-1698.3918457031,13.645215034485, 90},
		},
	},

	timer = {},
	vehicle = {},

	__init__ = function(self)
		for index,value in pairs(self.vehicles) do
			outputDebugString('DMTA/PUBLICS Pomyślnie utworzono pojazdy w: '..index)
			self:respawnVehicle(value)
		end
	end,

	respawnVehicle = function(self, value, id)
		local faggio = true
		for i,v in ipairs(value) do
			if id and id == i or not id then
				local rnd = math.random(1,3)
				local model = i == math.random(1,#value) and faggio and 'Mountain Bike' or rnd == 1 and 'Mountain Bike' or rnd == 2 and 'Mountain Bike' or rnd == 3 and 'Mountain Bike' or 'Mountain Bike'
				faggio = model == 'Mountain Bike' and false

				local veh = createVehicle(getVehicleModelFromName(model), v[1], v[2], v[3], 0, 0, v[4])
				setVehicleHandling(veh, 'maxVelocity', model == 'Mountain Bike' and 39 or 17)
				setElementFrozen(veh, true)
				setElementData(veh, 'public:vehicle', true)
				setVehicleColor(veh, 105, 188, 235)

				local cs = createColSphere(v[1], v[2], v[3], 1.25)
				setElementData(cs, 'cs:value', {value, i})
			end
		end
	end,

	onStartEnter = function(self, player, seat)
		if seat ~= 0 then return end
		if getElementData(source, 'public:owner') and getElementData(source, 'public:owner') ~= player then
			noti:addNotification(player, 'Ten pojazd publiczny, jest już zajęty.', 'error')
			cancelEvent()
		elseif self.vehicle[player] and self.vehicle[player] ~= source then
			noti:addNotification(player, 'Wziąłeś swój pojazd publiczny.', 'error')
			cancelEvent()
		end
	end,

	onEnter = function(self, player, seat)
		if seat ~= 0 then return end
		setElementData(source, 'public:owner', player)
		toggleControl(player, 'vehicle_secondary_fire', false)
		toggleControl(player, 'vehicle_fire', false)

		if self.timer[player] and isTimer(self.timer[player]) then
			killTimer(self.timer[player])
			self.timer[player] = nil
		end

		self.vehicle[player] = source

		setTimer(function()
			setVehicleEngineState(self.vehicle[player], true)
			setElementFrozen(self.vehicle[player], false)
		end, 500, 1)
	end,

	onExit = function(self, player, seat)
		if seat ~= 0 then return end
		local vehicle = source
		noti:addNotification(player, 'Jeśli nie wrócisz za 15 sekund, twój pojazd publiczny zniknie.', 'info')
		self.timer[player] = setTimer(function()
			destroyElement(vehicle)
			self.timer[player] = nil
			self.vehicle[player] = nil
		end, (1000 * 15), 1)
	end,

	onLeave = function(self, hit, dim)
		if not hit or hit and not isElement(hit) or hit and isElement(hit) and getElementType(hit) ~= 'player' or not dim then return end

		local veh = getPedOccupiedVehicle(hit)
		if not veh or veh and not isElement(veh) or veh and isElement(veh) and not getElementData(veh, 'public:vehicle') then return end

		local v = getElementsWithinColShape(source, 'vehicle')
		local data = getElementData(source, 'cs:value')
		if #v == 1 and v[1] == veh and data then
			local value, id = data[1], data[2]
			self:respawnVehicle(value, id)
			destroyElement(source)
		end
	end,
}

local startEnter_fnc = function(...) public:onStartEnter(...) end
addEventHandler('onVehicleStartEnter', resourceRoot, startEnter_fnc)

local enter_fnc = function(...) public:onEnter(...) end
addEventHandler('onVehicleEnter', resourceRoot, enter_fnc)

local exit_fnc = function(...) public:onExit(...) end
addEventHandler('onVehicleExit', resourceRoot, exit_fnc)

local leave_fnc = function(...) public:onLeave(...) end
addEventHandler('onColShapeLeave', resourceRoot, leave_fnc)

addEventHandler('onResourceStart', resourceRoot, function()
	public()
end)