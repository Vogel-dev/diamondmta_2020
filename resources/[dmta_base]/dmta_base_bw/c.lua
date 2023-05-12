--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local dxLibary = exports['dxLibary']

local sw,sh = guiGetScreenSize()
local baseX = 1920
local scale = 1
local minScale = 2
if sw < baseX then
    scale = math.min(minScale, baseX/sw)
end

local bw = {
	time = 300,
  rot = 0,
}


function getPointFromDistanceRotation(x, y, dist, cam)
    local a = math.rad(270 - cam)
    local dx = math.cos(a) * dist;
    local dy = math.sin(a) * dist;
    return x+dx, y+dy;
end

setTimer(function()
	if getElementData(localPlayer, 'bw:time') then
		setElementData(localPlayer, 'bw:time', (getElementData(localPlayer, 'bw:time'))+1)
		if getElementData(localPlayer, 'bw:time') == bw['time'] then
			setElementData(localPlayer, 'player:blackwhite', false)
			triggerServerEvent('bw:koniec', resourceRoot)
			setElementData(localPlayer, 'bw:time', false)
			showPlayerHudComponent('radar', true)
			removeEventHandler('onClientRender', root, gui)
			setElementData(localPlayer, 'pokaz:hud', true)
			--showChat(true)
      setCameraTarget(localPlayer)
		end
	end
end, 1000, 0)

addEventHandler('onClientPlayerWasted', getLocalPlayer(), function()
	if not getElementData(localPlayer, 'rank:duty') or getElementData(localPlayer, 'rank:duty') and getElementData(localPlayer, 'rank:duty') <= 3 and getElementData(localPlayer, 'user:logged') then
		setElementData(localPlayer, 'player:blackwhite', true)
		setElementData(localPlayer, 'bw:time', 0)
		addEventHandler('onClientRender', root, gui)
		setElementData(localPlayer, 'pokaz:hud', false)
		showPlayerHudComponent('radar', false)
		--showChat(false)
	else
		triggerServerEvent('bw:koniec', resourceRoot)
	end
end)

function gui()
  bw['rot'] = bw['rot'] + 0.15

  local xx,yy,zz = getElementPosition(localPlayer)
	zz = zz + 5

	local x,y = getPointFromDistanceRotation(xx, yy, 2, bw['rot'])
	setCameraMatrix(x, y, zz, xx, yy, zz - 5)
	--dxDrawRectangle(0, 0, 1920, 1080, tocolor(15, 15, 15, 200), false)
  dxLibary:dxLibary_text('Twoja postać jest nieprzytomna.\nPodniesie się za: '..(bw['time']-(getElementData(localPlayer, 'bw:time') or 0))..'s', 0 + 1, 0 + 1, sw + 1, sh + 1, tocolor(0, 0, 0, 255), 11, 'default', 'center', 'center', false, false, false, true, false)
  dxLibary:dxLibary_text('#69bcebTwoja postać jest nieprzytomna.#ffffff\nPodniesie się za: #69bceb'..(bw['time']-(getElementData(localPlayer, 'bw:time') or 0))..'s', 0, 0, sw, sh, tocolor(255, 255, 255, 255), 11, 'default', 'center', 'center', false, false, false, true, false)

  dxLibary:dxLibary_text('\n\n\n\n\n\n\nAby wysłać zgłoszenie do pomocy medycznej wpisz /ems', 0 + 1, 0 + 1, sw + 1, sh + 1, tocolor(0, 0, 0, 255), 6, 'default', 'center', 'center', false, false, false, true, false)
  dxLibary:dxLibary_text('\n\n\n\n\n\n\n#69bcebAby wysłać zgłoszenie do pomocy medycznej wpisz #969696/ems', 0, 0, sw, sh, tocolor(255, 255, 255, 255), 6, 'default', 'center', 'center', false, false, false, true, false)
end
