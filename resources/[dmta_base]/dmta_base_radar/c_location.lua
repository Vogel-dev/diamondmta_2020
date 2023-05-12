--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

function getZone()
    local x,y,z = getElementPosition(localPlayer)

	if last_location ~= getZoneName(x,y,z,false) then
		last_location = getZoneName(x,y,z,false)
		location_tick = getTickCount()
		location_back = false
	end

	if last_location2 ~= getZoneName(x,y,z,true) then
		last_location2 = getZoneName(x,y,z,true)
		location2_tick = getTickCount()
		location2_back = false
	end

	if (getTickCount() - location_tick) > 2500 and location_back ~= true then
		location_back = true
		location_tick = getTickCount()
	end

	if (getTickCount() - location2_tick) > 3000 then
		location2_back = true
	end

	if location_back == true then
		a, a2 = interpolateBetween(255, 235, 0, 0, 0, 0, (getTickCount() - location_tick)/500, 'Linear')
	else
		a, a2 = interpolateBetween(0, 0, 0, 255, 235, 0, (getTickCount() - location_tick)/500, 'Linear')
	end
	
	local loc = last_location
	if last_location2 ~= '' and location2_back ~= true then
		if not string.find(last_location, 'Los Santos') then
			loc = last_location..', '..last_location2
		end
	else
		loc = last_location
	end

	dxDrawRectangle(Minimap['PosX'] + 4.5/scale, Minimap['PosY'] + (Minimap['Height']/1.2), Minimap['Width'] - 8/scale, Minimap['Height']/7, tocolor(0, 0, 0, a2), false)

	exports['dxLibary']:dxLibary_text(loc, Minimap['PosX'] + 1, Minimap['PosY'] + (Minimap['Height']/1.2) + 1, Minimap['Width'] + Minimap['PosX'] + 1, Minimap['Height']/6.5 + Minimap['PosY'] + (Minimap['Height']/1.2) + 1, tocolor(0, 0, 0, a), 3, font, 'center', 'center', false, false, false, false, false)
	exports['dxLibary']:dxLibary_text(loc, Minimap['PosX'], Minimap['PosY'] + (Minimap['Height']/1.2), Minimap['Width'] + Minimap['PosX'], Minimap['Height']/7 + Minimap['PosY'] + (Minimap['Height']/1.2), tocolor(255, 255, 255, a), 3, font, 'center', 'center', false, false, false, false, false)

	dxDrawImage(Minimap['PosX'], Minimap['PosY'], Minimap['Width'], Minimap['Height'], radarSettings['radarBackground'])
end
