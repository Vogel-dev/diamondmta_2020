--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

class 'neon'
{
	neons = {
		['white'] = 3923,
		['blue'] = 3917,
		['green'] = 3911,
		['red'] = 3907,
		['yellow'] = 3906,
		['pink'] = 3905,
		['orange'] = 3903,
		['lightblue'] = 3902,
		['rasta'] = 3900,
		['ice'] = 3899
		--3923, 3917, 3911, 3907, 3906, 3905, 3903, 3902, 3900, 3899, 3898, 3897, 3895, 3894, 3893
    },

    __init__ = function(self)
    	local col = engineLoadCOL('replaces/neonCollision.col')
    	for i,v in pairs(self.neons) do
    		local dff = engineLoadDFF('replaces/'..i..'.dff')
    		engineReplaceModel(dff, v)

    		engineReplaceCOL(col, v)
    	end
    end,
}

addEventHandler('onClientResourceStart', resourceRoot, function()
	neon()
end)