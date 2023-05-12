--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local engines = {
	["1.2"] = {-20,-2},
	["1.4"] = {-10,-1},
	["1.6"] = {5,0},
	["1.8"] = {10,1},
	["1.9"] = {15,1},
	["2.0"] = {20,2},
	["2.2"] = {30,3},
	["2.4"] = {40,4},
	["2.6"] = {50,5},
	["2.8"] = {60,6},
	["3.0"] = {70,7},
	["6.0"] = {180,18},
}

function setVehicleEngine(vehicle)
	local engine = getElementData(vehicle, "vehicle:engine") or "1.6"
	local newEngine = engines[engine]
	if(newEngine)then
		setVehicleHandling(vehicle, "maxVelocity", getVehicleHandling(vehicle).maxVelocity+newEngine[1])
		setVehicleHandling(vehicle, "engineAcceleration", getVehicleHandling(vehicle).engineAcceleration+newEngine[2])
	end
end