--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local screenW, screenH = guiGetScreenSize()

local wybrana_opcja = 0
local alpha = 0
local music = false

local opcjeNumber = {
[1] = {"Radio ZET", "http://zet-net-01.cdn.eurozet.pl:8400/listen.pls"},
[2] = {"HitsFM", "https://www.internet-radio.com/servers/tools/playlistgenerator/?u=http://us3.internet-radio.com:8317/live.m3u&t=.pls"},
[3] = {"AntyRadio", "http://ant-waw-01.cdn.eurozet.pl:8602/listen.pls"},
[4] = {"RMF FM", "http://www.rmfon.pl/n/rmffm.pls"},
[5] = {"Radio wyłączone", false},
}

addEventHandler("onClientRender", root, function()
setRadioChannel(0)
end)

local minwybor, maxwybor = 1,#opcjeNumber

local font = dxCreateFont(":dmta_base_eq/cz.ttf", 22)
if not font then
	font = "default"
end

local tick = getTickCount()

function opcjaPrawo()
	wybrana_opcja = wybrana_opcja -1

	local veh = getPedOccupiedVehicle(localPlayer)
	if(wybrana_opcja < minwybor)then
		wybrana_opcja = maxwybor
	end

	if music ~= false then
		destroyElement(music)
		music = false
	end
	if opcjeNumber[wybrana_opcja][2] == false then return end
	music = playSound(opcjeNumber[wybrana_opcja][2])
	setSoundVolume(music, 1)
end

function opcjaLewo()
	local veh = getPedOccupiedVehicle(localPlayer)
	wybrana_opcja = wybrana_opcja +1

	if(wybrana_opcja > maxwybor)then
		wybrana_opcja = minwybor
	end

	if music ~= false then
		destroyElement(music)
		music = false
	end
	if opcjeNumber[wybrana_opcja][2] == false then return end
	music = playSound(opcjeNumber[wybrana_opcja][2])
	setSoundVolume(music, 1)
end

bindKey("mouse_wheel_up", "down", function()
	if not getPedOccupiedVehicle(localPlayer) then return end
	opcjaPrawo() 
	if alpha ~= 255 then
		alpha = 255
		tick = getTickCount()
	end
end)

bindKey("mouse_wheel_down", "down", function()
	if not getPedOccupiedVehicle(localPlayer) then return end
	opcjaLewo()
	if alpha ~= 255 then
		alpha = 255
		tick = getTickCount()
	end
end)

addEventHandler("onClientRender", root, function()
	local veh = getPedOccupiedVehicle(localPlayer)
	if music ~= false and not veh then
		destroyElement(music)
		music = false
	end
	if veh then
		local now_time = getTickCount()
		if tick ~= 0 and now_time > tick+2000 then
			local Progress = (now_time-tick)/10000
			alpha = interpolateBetween(alpha,0,0,0,0,0,Progress,"InOutQuad")
		end
		if alpha < 1 then return end
        dxDrawText(opcjeNumber[wybrana_opcja][1], (screenW * 0.0000) + 1, (screenH * 0.0625) + 1, (screenW * 1.0000) + 1, (screenH * 0.1289) + 1, tocolor(0, 0, 0, alpha), 1, font, "center", "center", false, false, false, false, false)
        dxDrawText(opcjeNumber[wybrana_opcja][1], screenW * 0.0000, screenH * 0.0625, screenW * 1.0000, screenH * 0.1289, tocolor(180, 180, 180, alpha), 1, font, "center", "center", false, false, false, false, false)
	end
end)

addEventHandler("onClientVehicleExit", root, function(player, seat)
	if player ~= localPlayer then return end
	if music ~= false then
		destroyElement(music)
		music = false
	end
end)

addEventHandler("onClientVehicleEnter", root, function(player, seat)
	if player ~= localPlayer then return end
	if alpha ~= 255 then
		alpha = 255
		tick = getTickCount()
	end
	if wybrana_opcja == 0 then
		wybrana_opcja = #opcjeNumber
	end
	if opcjeNumber[wybrana_opcja][2] == false then return end
	music = playSound(opcjeNumber[wybrana_opcja][2])
	setSoundVolume(music, 1)
end)