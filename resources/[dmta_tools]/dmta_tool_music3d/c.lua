--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local muzyka = {
	{1480.5845947266,-1717.6164550781,19.386875152588, "https://www.internet-radio.com/servers/tools/playlistgenerator/?u=http://us3.internet-radio.com:8317/live.m3u&t=.pls"},
	{994.73101806641,-1311.1893310547,23.546875, "https://www.internet-radio.com/servers/tools/playlistgenerator/?u=http://us3.internet-radio.com:8317/live.m3u&t=.pls"},
	{-1949.8449707031,567.11114501953,-55.791248321533, "https://www.internet-radio.com/servers/tools/playlistgenerator/?u=http://us3.internet-radio.com:8317/live.m3u&t=.pls"},
	{1001.6492919922,-1356.3757324219,16.883476257324, "https://www.internet-radio.com/servers/tools/playlistgenerator/?u=http://us3.internet-radio.com:8317/live.m3u&t=.pls"},
}

local sound = { }

for i, v in ipairs(muzyka) do
	sound[i] = playSound3D(v[4], v[1], v[2], v[3], true)
    setSoundMaxDistance(sound[i], 50) 
   	if v[5] then
   		setElementDimension(sound[i], v[5])
   	end
end

addEvent("wylacz:muzyke", true)
addEventHandler("wylacz:muzyke", root, function(liczba)
	if liczba == 2 then
		for i, v in ipairs(sound) do
			if isElement(v) then
				destroyElement(v)
			end
		end
	elseif liczba == 1 then
		for i, v in ipairs(muzyka) do
			sound[i] = playSound3D(v[4], v[1], v[2], v[3], true)
    		setSoundMaxDistance(sound[i], 50) 
   			if v[5] then
   				setElementDimension(sound[i], v[5])
   			end
		end
	end
end)