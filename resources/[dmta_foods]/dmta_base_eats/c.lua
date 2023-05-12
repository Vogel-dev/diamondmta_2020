--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local noti = exports.dmta_base_notifications

local screenW, screenH = guiGetScreenSize()
local sx, sy = guiGetScreenSize()
local px, py = screenW/1440, screenH/900

local sw,sh = guiGetScreenSize()
local baseX = 1920
local scale = 1
local minScale = 2
if sw < baseX then
    scale = math.min(minScale, baseX/sw)
end

function isMouseIn(x, y, w, h)
	if not isCursorShowing() then return end

	local pos = {getCursorPosition()}
	pos[1],pos[2] = (pos[1]*sw),(pos[2]*sh)

	if pos[1] >= x and pos[1] <= (x+w) and pos[2] >= y and pos[2] <= (y+h) then
		return true
	end
	return false
end

local okno = false

local rzeczy = {
	--- nazwa, tekst, cena, %najedzenia, grafika
	{"Hamburger", "", 15, 20, 1},
	{"Hotdog", "", 5, 15, 2},
	{"Kebab", "", 10, 25, 3},
	{"Woda", "", 3, 5, 7},
	{"Cola", "", 4, 5, 6},
}

function gui()
	exports['dxLibary']:dxLibary_createWindow(715/scale, 316/scale, 496/scale, 345/scale, false)
	dxDrawImage(688/scale, 294/scale, 547/scale, 491/scale, ":dmta_base_eats/gfx/bg.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	for i, v in ipairs(rzeczy) do
		local x,y,w,h = exports['dxLibary']:dxLibary_formatTextPosition(1184/scale, 320/scale, 21/scale, 21/scale)
		if isMouseIn(1184/scale, 320/scale, 21/scale, 21/scale) then
			exports['dxLibary']:dxLibary_text('X', x, y, w, h, tocolor(255, 0, 0, a), 5, 'default', 'center', 'center', false, false, false, false, false)
		else
			exports['dxLibary']:dxLibary_text('X', x, y, w, h, tocolor(150, 150, 150, a), 5, 'default', 'center', 'center', false, false, false, false, false)
		end
		exports['dxLibary']:dxLibary_createButton('Kup', 1106/scale, 375/scale, 91/scale, 36/scale, tocolor(255, 255, 255, 255), false)
		exports['dxLibary']:dxLibary_createButton('Kup', 1106/scale, 429/scale, 91/scale, 36/scale, tocolor(255, 255, 255, 255), false)
		exports['dxLibary']:dxLibary_createButton('Kup', 1106/scale, 483/scale, 91/scale, 36/scale, tocolor(255, 255, 255, 255), false)
		exports['dxLibary']:dxLibary_createButton('Kup', 1106/scale, 537/scale, 91/scale, 36/scale, tocolor(255, 255, 255, 255), false)
		exports['dxLibary']:dxLibary_createButton('Kup', 1106/scale, 591/scale, 91/scale, 36/scale, tocolor(255, 255, 255, 255), false)
   	end
end

addEventHandler("onClientClick", root, function(btn, state)
  if btn == "left" and state == "down" then
  	for i,v in ipairs(rzeczy) do
  		local dodatekY = (50*py)*(i-1)
  		if isMouseIn(826*px, 294*py+dodatekY, 91*px, 36*py) and okno == true then
			  if getPlayerMoney(localPlayer) < tonumber(v[3]) then
				noti:addNotification('Brakuje Ci pieniędzy, na zakupienie tego.', 'error')
				return;
			end
			takePlayerMoney(tonumber(v[3]))
			  noti:addNotification('Kupujesz '..v[1]..' za '..v[3]..' $', 'success')
			triggerServerEvent("daj:fastfoody", localPlayer, v[1])
			triggerServerEvent("zabierz:hajs-food1", localPlayer, v[3])
  		end
  	end
    if isMouseIn(1184/scale, 320/scale, 21/scale, 21/scale) and okno == true then
    	removeEventHandler("onClientRender", root, gui)
    	okno = false
    	showCursor(false)
    end
  end
end)

addEventHandler("onClientMarkerHit", resourceRoot, function(gracz)
	if gracz ~= localPlayer then return end
  	if getPedOccupiedVehicle(localPlayer) then return end
  	if getElementData(localPlayer, "bw:time") then return end
  	if getElementDimension(localPlayer) ~= 0 or getElementInterior(localPlayer) ~= 0 then return end
	addEventHandler("onClientRender", root, gui)
	okno = true
	showCursor(true)
end)

addEventHandler("onClientMarkerLeave", resourceRoot, function(gracz)
  if gracz ~= localPlayer then return end
  removeEventHandler("onClientRender", root, gui)
  okno = false
  showCursor(false)
end)