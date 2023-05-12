--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local marker = createMarker(2592.6218261719,-1664.5966796875,20002.2578125-0.95, 'cylinder', 1.3, 150, 17, 25)
setElementInterior(marker, 1)
setElementData(marker, 'marker:icon', 'brak')

local koszt = 150

addEventHandler('onMarkerHit', marker, function(hit, dim)
	if not hit or hit and not isElement(hit) or hit and isElement(hit) and getElementType(hit) ~= 'player' or hit and isElement(hit) and getElementType(hit) == 'player' and isPedInVehicle(hit) or not dim then return end

	if getPlayerMoney(hit) > koszt then
		setElementHealth(hit, 100)
		outputChatBox("#00ff00● #ffffffZakupiłeś potrzebne leki za #969696"..koszt.." #00ff00$", hit, 255, 255, 255, true)
		triggerEvent("odegrajRp:eq", hit, hit, "#969696*"..getPlayerName(hit).." otwiera pudełko z lekami, poczym zażywa wymaganą ilość.") 
		takePlayerMoney(hit, koszt)
	else
		outputChatBox("#ff0000● #ffffffNie stać cię na potrzebne leki i pomoc medyczną.", hit, 255, 255, 255, true) 
	end
end)
