elements = {}
elements["position"] = {
	{"EMS", 1179.6784667969,-1308.5556640625,13.725025177002},
	{"SAPD", 1603.6557617188,-1635.4089355469,13.7187},
}

for _,v in ipairs(elements["position"]) do
	Marker(Vector3(v[2], v[3], v[4]-0.95), "cylinder", 2, 232, 204, 7)
--setElementData(Vector3, 'marker:icon', 'mechanic')
	
	local text = Element("text")
	text:setData("text", "\nTylko dla frakcji "..v[1].."")
	text.position = Vector3(v[2], v[3], v[4]+2)
end

addEventHandler("onMarkerHit", resourceRoot, function(player, dimension)
	local vehicle = player.vehicle
	if vehicle then
		if vehicle.health < 1000 then
			--if vehicle:getData("veh:frakcja") then
				for _,v in ipairs(elements["position"]) do
					if vehicle:getData("vehicle:owner") then return end
					if player:getData("user:faction") == v[1] then
						outputChatBox("#00ff00● #ffffffTwój pojazd został naprawiony.", player, 255, 255, 255, true)
						vehicle:fix()
					end
				end
			else
				outputChatBox("#ff0000● #ffffffW tym miejscu można naprawić tylko pojazdy służowe.", player, 255, 255, 255, true)
			end
		else
			outputChatBox("#ff0000● #ffffffTwój pojazd nie posiada uszkodzeń.", player, 255, 255, 255, true)
		--end
	end
end)
