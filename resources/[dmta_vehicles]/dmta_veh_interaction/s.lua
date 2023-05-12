--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local tick = {}

local noti = exports['dmta_base_notifications']
local core = exports['dmta_base_core']
local radio = exports.radio

addEvent('switchENGINE', true)
addEventHandler('switchENGINE', resourceRoot, function(veh)
	setVehicleEngineState(veh, not getVehicleEngineState(veh))

	if not tick[client] or tick[client] and (getTickCount() - tick[client]) > 3000 then
        tick[client] = getTickCount()
    elseif tick[client] and (getTickCount() - tick[client]) < 3000 then
        return
	end
	
	local text = getVehicleEngineState(veh) ~= true and 'gasi' or 'odpala'
	core:outputChatWithDistance(client, text..' silnik w pojeździe.', 5)
end)

addEvent('switchLIGHT', true)
addEventHandler('switchLIGHT', resourceRoot, function(veh)
	setVehicleOverrideLights(veh, (getVehicleOverrideLights(veh) == 2 and 1 or 2))
end)

addEvent('switchHANDBRAKE', true)
addEventHandler('switchHANDBRAKE', resourceRoot, function(veh, _)
	--if getElementData(veh, 'vehicle:owner') then
		if getElementData(veh, 'vehicle:salon') then outputChatBox('#ff0000● #ffffffNie możesz odciągnąc ręcznego w tym pojeździe.', client, 255, 255, 255, true) return end
		if getElementData(veh, 'vehicle:handbrake') and not _ then
			setControlState(client, 'handbrake', false)
			setElementData(veh, 'vehicle:handbrake', false)
			setElementFrozen(veh, false)

			if not tick[client] or tick[client] and (getTickCount() - tick[client]) > 3000 then
				tick[client] = getTickCount()
			elseif tick[client] and (getTickCount() - tick[client]) < 3000 then
				return
			end

			core:outputChatWithDistance(client, 'spuszcza hamulec ręczny w pojeździe.', 5)
		else
			setControlState(client, 'handbrake', true)
			setElementData(veh, 'vehicle:handbrake', true)

			if not tick[client] or tick[client] and (getTickCount() - tick[client]) > 3000 then
				tick[client] = getTickCount()
			elseif tick[client] and (getTickCount() - tick[client]) < 3000 then
				return
			end

			core:outputChatWithDistance(client, 'zaciąga hamulec ręczny w pojeździe.', 5)
		end
	--else
		--noti:addNotification(client, 'Nie możesz zaciągąć hamulca ręcznego w tym pojeździe.', 'error')
	--end
end)

addEvent('changeLOCKED', true)
addEventHandler('changeLOCKED', resourceRoot, function(veh)
	if isVehicleLocked(veh) == true then
		setVehicleLocked(veh, false)

		if not tick[client] or tick[client] and (getTickCount() - tick[client]) > 3000 then
			tick[client] = getTickCount()
		elseif tick[client] and (getTickCount() - tick[client]) < 3000 then
			return
		end

		core:outputChatWithDistance(client, 'otwiera zamek w pojeździe.', 5)
	else
		for i = 0,5 do
			setVehicleDoorOpenRatio(veh, i, 0, 2500)
		end

		setVehicleLocked(veh, true)

		if not tick[client] or tick[client] and (getTickCount() - tick[client]) > 3000 then
			tick[client] = getTickCount()
		elseif tick[client] and (getTickCount() - tick[client]) < 3000 then
			return
		end

		core:outputChatWithDistance(client, 'zamyka zamek w pojeździe.', 5)
	end
end)

addEvent('changeTYPE', true)
addEventHandler('changeTYPE', resourceRoot, function(veh)
	local newType = getElementData(veh, 'vehicle:actualType') == 'Benzyna' and 'LPG' or 'Benzyna'
	setElementData(veh, 'vehicle:actualType', newType)
end)

addEvent('kickOCCUPANTS', true)
addEventHandler('kickOCCUPANTS', resourceRoot, function(veh)
	local occupants = getVehicleOccupants(veh)
	for i,v in pairs(occupants) do
		if v ~= client then
			setControlState(v, 'enter_exit', true)
			setTimer(function()
				setControlState(v, 'enter_exit', false)
			end, 200, 1)

			if not tick[client] or tick[client] and (getTickCount() - tick[client]) > 3000 then
				tick[client] = getTickCount()
			elseif tick[client] and (getTickCount() - tick[client]) < 3000 then
				return
			end

			core:outputChatWithDistance(client, 'wysadza pasażerów z pojazdu.', 5)
		end
	end
end)

addEventHandler('onVehicleEnter', root, function(player, seat)
	if seat ~= 0 then return end

	if getElementData(source, 'vehicle:handbrake') then
		setControlState(player, 'handbrake', true)
		setElementFrozen(source, false)
	end

	if getVehicleName(source) == 'Bike' or getVehicleName(source) == 'BMX' or getVehicleName(source) == 'Mountain Bike' then
		setVehicleEngineState(source, true)
		setElementData(source, 'vehicle:handbrake', false)
		setControlState(player, 'handbrake', false)
	end
end)

addEventHandler('onVehicleStartEnter', root, function(player, seat)
	if seat ~= 0 then return end
	
	if getVehicleController(source) == player then
		setVehicleLocked(source, false)
	end
end)

addEventHandler('onVehicleExit', root, function(player, seat)
	for i = 0,5 do
		if i == 2 then
			setVehicleDoorOpenRatio(source, i, 0, 1000)
		end
	end

	if seat == 0 and getElementData(source, 'vehicle:handbrake') then
		setControlState(player, 'handbrake', false)
		setElementFrozen(source, true)
		setVehicleLocked(source, false)
	end
end)

addEvent('wiecejOpcji', true)
addEventHandler('wiecejOpcji', resourceRoot, function(veh, x)
	if x == 1 then
		if getVehicleDoorOpenRatio(veh, 0) == 0 then
			setVehicleDoorOpenRatio(veh, 0, 1, 1000)
		else
			setVehicleDoorOpenRatio(veh, 0, 0, 1000)
		end
	elseif x == 2 then
		if getVehicleDoorOpenRatio(veh, 1) == 0 then
			setVehicleDoorOpenRatio(veh, 1, 1, 1000)
		else
			setVehicleDoorOpenRatio(veh, 1, 0, 1000)
		end

		radio:createCuboidRadio(veh)
	elseif x == 3 then
		if getVehicleDoorOpenRatio(veh, 2) == 0 then
			setVehicleDoorOpenRatio(veh, 2, 1, 1000)
		else
			setVehicleDoorOpenRatio(veh, 2, 0, 1000)
		end
	elseif x == 4 then
		if getVehicleDoorOpenRatio(veh, 3) == 0 then
			setVehicleDoorOpenRatio(veh, 3, 1, 1000)
		else
			setVehicleDoorOpenRatio(veh, 3, 0, 1000)
		end
	elseif x == 5 then
		if getVehicleDoorOpenRatio(veh, 4) == 0 then
			setVehicleDoorOpenRatio(veh, 4, 1, 1000)
		else
			setVehicleDoorOpenRatio(veh, 4, 0, 1000)
		end
	elseif x == 6 then
		if getVehicleDoorOpenRatio(veh, 5) == 0 then
			setVehicleDoorOpenRatio(veh, 5, 1, 1000)
		else
			setVehicleDoorOpenRatio(veh, 5, 0, 1000)
		end
	end
end)
