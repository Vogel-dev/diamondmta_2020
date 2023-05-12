--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]-- i wyłączone prawo do używania kodu ma serwer WestRPG oraz autor skryptu. (Asper)


local download = exports.dmta_base_dlstart

addEventHandler('onClientResourceStart', resourceRoot, function()
	download:stopDownloading()
end)