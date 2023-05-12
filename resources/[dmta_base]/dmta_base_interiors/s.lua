--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local db = exports.dmta_base_connect

addEventHandler('onResourceStart', resourceRoot, function()
	db:query('set names utf8')
	local query = db:query('select * from db_interiors')
	for i,v in ipairs(query) do
		local wejscie_pos = split(v['wejscie'], ',')
		local wejscie = createMarker(wejscie_pos[1], wejscie_pos[2], wejscie_pos[3]-0.97, 'cylinder', 1.3, 105, 188, 235)
		setElementData(wejscie, 'marker:data', {query=v,type='wejscie'})
		setElementData(wejscie, 'text', v.nazwa)
		setElementData(wejscie, 'marker:icon', 'door_enter')
		local tw=createElement("text")
		setElementData(tw, "text", v.nazwa)
		setElementPosition(tw, wejscie_pos[1], wejscie_pos[2], wejscie_pos[3])

		local wyjscie_pos = split(v['wyjscie'], ',')
		local wyjscie = createMarker(wyjscie_pos[1], wyjscie_pos[2], wyjscie_pos[3]-0.97, 'cylinder', 1.3, 255, 0, 0)
		setElementData(wyjscie, 'marker:data', {query=v,type='wyjscie'})
		setElementInterior(wyjscie, v['interior'])
		setElementDimension(wyjscie, v['dimension'])
		setElementData(wyjscie, 'text', 'Wyjście')
		setElementData(wyjscie, 'marker:icon', 'door_exit')
		local tw=createElement("text")
		setElementData(tw, "text", 'Wyjście')
		setElementPosition(tw, wyjscie_pos[1], wyjscie_pos[2], wyjscie_pos[3])
		setElementInterior(tw, v['interior'])
		setElementDimension(tw, v['dimension'])
	end
end)

addEventHandler('onMarkerHit', resourceRoot, function(hit, dim)
	if not hit or hit and not isElement(hit) or hit and isElement(hit) and getElementType(hit) ~= 'player' or hit and isElement(hit) and getElementType(hit) == 'player' and isPedInVehicle(hit) or not dim then return end

	local data = getElementData(source, 'marker:data')
	if not data then return end

	if data['type'] == 'wejscie' then
		setElementFrozen(hit, true)
		triggerClientEvent(hit, 'load:interior', resourceRoot, 'Wczytywanie wnętrza', 'join')
		setTimer(function()
			if hit and isElement(hit) then
				local pos = split(data['query']['wejscie_teleport'], ',')
				setElementPosition(hit, pos[1], pos[2], pos[3])
				setElementInterior(hit, data['query']['interior'])
				setElementDimension(hit, data['query']['dimension'])

				setTimer(function()
					if hit and isElement(hit) then
						setElementFrozen(hit, false)
					end
				end, 3000, 1)
			end
		end, 550, 1)
	elseif data['type'] == 'wyjscie' then
		setElementFrozen(hit, true)
		triggerClientEvent(hit, 'load:interior', resourceRoot, 'Wczytywanie świata')
		setTimer(function()
			if hit and isElement(hit) then
				local pos = split(data['query']['wyjscie_teleport'], ',')
				setElementPosition(hit, pos[1], pos[2], pos[3])
				setElementInterior(hit, 0)
				setElementDimension(hit, 0)
				
				setTimer(function()
					if hit and isElement(hit) then
						setElementFrozen(hit, false)
					end
				end, 3000, 1)
			end
		end, 550, 1)
	end
end)
