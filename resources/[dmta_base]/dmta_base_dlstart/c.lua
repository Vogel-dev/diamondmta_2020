--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local load = exports.dmta_base_loading

addEventHandler('onClientResourceStart', resourceRoot, function()
	load:createLoadingScreen('Pobieranie zasobów')
	showChat(false)
end)

function stopDownloading()
	load:destroyLoadingScreen()
end