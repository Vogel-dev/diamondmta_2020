--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local dxLibary = exports['dxLibary']

local markers = {}

function markers:ReplaceTextures()
	self['icons'] = {
		['default'] = dxLibary:createTexture(':dmta_base_markers/images/default.png', 'dxt5', false, 'clamp'),
		['door_enter'] = dxLibary:createTexture(':dmta_base_markers/images/door_enter.png', 'dxt5', false, 'clamp'),
		['door_exit'] = dxLibary:createTexture(':dmta_base_markers/images/door_exit.png', 'dxt5', false, 'clamp'),
		['diamondbank_konto'] = dxLibary:createTexture(':dmta_base_markers/images/diamondbank_konto.png', 'dxt5', false, 'clamp'),
		['diamondbank_transakcje'] = dxLibary:createTexture(':dmta_base_markers/images/diamondbank_transakcje.png', 'dxt5', false, 'clamp'),
		['diamondbank_przelewy'] = dxLibary:createTexture(':dmta_base_markers/images/diamondbank_przelewy.png', 'dxt5', false, 'clamp'),
		['przebieralnia'] = dxLibary:createTexture(':dmta_base_markers/images/przebieralnia.png', 'dxt5', false, 'clamp'),
		['lpg'] = dxLibary:createTexture(':dmta_base_markers/images/lpg.png', 'dxt5', false, 'clamp'),
		['on'] = dxLibary:createTexture(':dmta_base_markers/images/on.png', 'dxt5', false, 'clamp'),
		['pb-95'] = dxLibary:createTexture(':dmta_base_markers/images/pb-95.png', 'dxt5', false, 'clamp'),
		['recepcja'] = dxLibary:createTexture(':dmta_base_markers/images/recepcja.png', 'dxt5', false, 'clamp'),
		['stand'] = dxLibary:createTexture(':dmta_base_markers/images/stand.png', 'dxt5', false, 'clamp'),
		['basket'] = dxLibary:createTexture(':dmta_base_markers/images/basket.png', 'dxt5', false, 'clamp'),
		['automat'] = dxLibary:createTexture(':dmta_base_markers/images/automat.png', 'dxt5', false, 'clamp'),
		['payfuel'] = dxLibary:createTexture(':dmta_base_markers/images/payfuel.png', 'dxt5', false, 'clamp'),
		['salon'] = dxLibary:createTexture(':dmta_base_markers/images/salon.png', 'dxt5', false, 'clamp'),
		['car'] = dxLibary:createTexture(':dmta_base_markers/images/car.png', 'dxt5', false, 'clamp'),
		['mechanic'] = dxLibary:createTexture(':dmta_base_markers/images/mechanic.png', 'dxt5', false, 'clamp'),
		['job'] = dxLibary:createTexture(':dmta_base_markers/images/job.png', 'dxt5', false, 'clamp'),
		['target'] = dxLibary:createTexture(':dmta_base_markers/images/target.png', 'dxt5', false, 'clamp'),
		['fly'] = dxLibary:createTexture(':dmta_base_markers/images/fly.png', 'dxt5', false, 'clamp'),
		['paint'] = dxLibary:createTexture(':dmta_base_markers/images/paint.png', 'dxt5', false, 'clamp'),
		['drugs'] = dxLibary:createTexture(':dmta_base_markers/images/drugs.png', 'dxt5', false, 'clamp'),
		['weed'] = dxLibary:createTexture(':dmta_base_markers/images/weed.png', 'dxt5', false, 'clamp'),
		['gun'] = dxLibary:createTexture(':dmta_base_markers/images/gun.png', 'dxt5', false, 'clamp'),
		['faction'] = dxLibary:createTexture(':dmta_base_markers/images/faction.png', 'dxt5', false, 'clamp'),
	}

	self['tick'] = getTickCount()
	self['icon'] = dxLibary:createTexture(':dmta_base_markers/images/marker.png', 'dxt5', false, 'clamp')

	self.rot = 0
end

function markers:IconImage(element)
	local x, y, z = getElementPosition(element)
	local size = getMarkerSize(element)
	local r,g,b = getMarkerColor(element)
	local icon = getElementData(element, 'marker:icon') or 'default'

	if self['icons'][icon] then
		z = (z + 1) - math.sin(getTickCount() / 500) * 0.02

		local plus = (size/9)
		dxDrawMaterialLine3D(x, y, z+1+plus, x, y, z, self['icons'][icon], 1+plus, tocolor(r, g, b, 255))
	end
end

function markers:Render()
	self.rot = self.rot + 0.005

	for i,v in ipairs(getElementsByType('marker', root, true)) do
		if getMarkerType(v) == 'cylinder' and getElementDimension(v) == getElementDimension(localPlayer) and getElementInterior(v) == getElementInterior(localPlayer) then

			if getElementAlpha(v) ~= 0 then
				setElementAlpha(v, 0)
			end

			if(not getElementData(v, "visibled"))then
				dxSetRenderTarget()

				local x,y,z = getElementPosition(v)
				if x ~= 0 and y ~= 0 and z ~= 0 then
					local size = getMarkerSize(v)
					local r,g,b = getMarkerColor(v)

					markers:IconImage(v)

					z = z + 0.001
					size = size - 0.25
					size = size + 2 * (math.sin(getTickCount() / 500) * 0.02)

					local rotX, rotY = math.cos(self.rot) * size,  math.sin(self.rot) * size
					dxDrawMaterialLine3D(x + rotX, y + rotY, z, x - rotX, y - rotY, z + 0.01, self.icon, 2 * size, tocolor(r, g, b, 255), x, y, z + 1)
				end
			end
		elseif getMarkerType(v) == 'corona' and getElementDimension(v) == getElementDimension(localPlayer) and getElementInterior(v) == getElementInterior(localPlayer) then
			local a = interpolateBetween(50, 0, 0, 70, 0, 0, (getTickCount()-self['tick'])/1500, 'SineCurve')
			setElementAlpha(v, a)
		end
	end
end

addEventHandler('onClientResourceStart', resourceRoot, function()
	markers:ReplaceTextures()

	local fnc = function() markers:Render() end
	addEventHandler('onClientRender', root, fnc)
end)