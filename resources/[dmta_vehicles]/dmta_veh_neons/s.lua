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
	
	__init__ = function(self, vehicle, neonName)
		local neon_id = self.neons[neonName]
		if neon_id then
			self:destroy(vehicle)
			
			local x,y,z = getElementPosition(vehicle)
			
			local neon_1 = createObject(neon_id, x, y, z)
			local neon_2 = createObject(neon_id, x, y, z)
			setElementAlpha(neon_1, 0)
			setElementAlpha(neon_2, 0)

			attachElements(neon_1, vehicle, 0.3, 0, -0.5)
			attachElements(neon_2, vehicle, -0.3, 0, -0.5)

			setElementData(vehicle, 'neons', {neon_1, neon_2})		
		end
	end,
	
	destroy = function(self, vehicle)
		local neons = getElementData(vehicle, 'neons') or {}
		for i,v in ipairs(neons) do
			if v and isElement(v) then
				destroyElement(v)
				v = nil
			end
		end
		setElementData(vehicle, 'neons', false)
	end,
}

addCommandHandler('neon', function(player, _, name)
	local v = getPedOccupiedVehicle(player)
  	if not name or not v then return end
	neon(v, name)
end)

addEventHandler('onElementDestroy', root, function()
  if getElementType(source) == 'vehicle' then
    neon:destroy(source)
  end
end)

function createNeon(vehicle, neonName)
  neon(v, name)
end

function destroyNeon(vehicle)
  neon:destroy(vehicle)
end