--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local load = exports.dmta_base_loading
local txd = exports.dmta_base_textures

addEvent('load:interior', true)
addEventHandler('load:interior', resourceRoot, function(text, type)
    load:createLoadingScreen(text, 3000)
    
    if type == 'join' then
	    setTimer(function()
	        txd:loadTexturesWithDistance(1000)
	    end, 1000, 1)
	end
end)