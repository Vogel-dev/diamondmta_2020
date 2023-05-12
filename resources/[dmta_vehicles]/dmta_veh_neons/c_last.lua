--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

veh=createVehicle(411,1804.5541992188,-2031.9770507813,13.525403022766,0,0,171.22613525391)
setElementData(veh,'neons',{0,0,255})

class 'neon'
{
	neon_txd = dxCreateTexture('images/neon.png'),

	render = function(self)
		for i,v in ipairs(getElementsByType('vehicle', true)) do
			local neon = getElementData(v, 'neons')
			if neon then
				local x,y,z = getElementPosition(v)
				local rx,ry,rz = getElementRotation(v)
				local a = getElementAlpha(v)

			    local pos_1 = Vector3( (1.6 * math.sin((math.rad(math.abs(rz - 390) - 60))) + x), (1.6 * math.cos((math.rad(math.abs(rz - 390) - 60))) + y), 0)
				pos_1.z = getGroundPosition(pos_1.x, pos_1.y, z)

			    local pos_2 = Vector3( (1.6 * math.sin((math.rad(math.abs(rz - 510) - 300))) + x), (1.6 * math.cos((math.rad(math.abs(rz - 510) - 300))) + y), 0)
				pos_2.z = getGroundPosition(pos_2.x, pos_2.y, z)

			    local pos_3 = Vector3( (1.6 * math.sin((math.rad(math.abs(rz - 390)))) + x), (1.6 * math.cos((math.rad(math.abs(rz - 390)))) + y), 0)
				pos_3.z = getGroundPosition(pos_3.x, pos_3.y, z)

			    local pos_4 = Vector3( (1.6 * math.sin((math.rad(math.abs(rz - 510)))) + x), (1.6 * math.cos((math.rad(math.abs(rz - 510)))) + y), 0)
				pos_4.z = getGroundPosition(pos_4.x, pos_4.y, z)

			    local pos_5 = Vector3( (1.6 * math.sin(1500) + x), (1.6 * math.cos((math.rad(math.abs(rz - 390) - 60))) + y), 0)
				pos_5.z = getGroundPosition(pos_5.x, pos_5.y, z)

			    dxDrawMaterialLine3D(pos_1.x, pos_1.y, pos_1.z + 0.05, pos_2.x, pos_2.y, pos_2.z + 0.05, self.neon_txd, 0.8, tocolor(neon[1], neon[2], neon[3], a), pos_1.x, pos_1.y, z + 4)
			    dxDrawMaterialLine3D(pos_3.x, pos_3.y, pos_3.z + 0.05, pos_4.x, pos_4.y, pos_4.z + 0.05, self.neon_txd, 0.8, tocolor(neon[1], neon[2], neon[3], a), pos_3.x, pos_3.y, pos_3.z + 4)

			    dxDrawMaterialLine3D(pos_5.x, pos_5.y, pos_5.z + 0.05, pos_2.x, pos_2.y, pos_2.z + 0.05, self.neon_txd, 0.8, tocolor(neon[1], neon[2], neon[3], a), pos_5.x, pos_5.y, z + 4)
			    dxDrawMaterialLine3D(pos_3.x, pos_3.y, pos_3.z + 0.05, pos_4.x, pos_4.y, pos_4.z + 0.05, self.neon_txd, 0.8, tocolor(neon[1], neon[2], neon[3], a), pos_3.x, pos_3.y, pos_3.z + 4)
			end
		end
	end,
}

addEventHandler('onClientResourceStart', resourceRoot, function()
	local render = function() neon:render() end
  	addEventHandler('onClientPreRender', root, render)
end)