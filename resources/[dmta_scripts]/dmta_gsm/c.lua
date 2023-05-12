--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

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

local dxLibary = exports.dxLibary

local okno = false

local rzeczy = {
	{"Nokia 3310", "", 55, 1, 1},
	{"Siemens C65", "", 85, 1, 1},
	{"Motorola XT 1771", "", 169, 1, 1},
	{"Samsung Galaxy A10", "", 699, 1, 1},
	{"Apple iPhone 6S", "", 1499, 1, 1},
	{"Xiaomi MI 9", "", 1849, 1, 1},
	{"Apple iPhone 8", "", 2499, 1, 1},
	{"Huawei P30 PRO", "", 3099, 1, 1},
	{"Apple iPhone XR", "", 3199, 1, 1},
	{"Apple iPhone XS", "", 4499, 1, 1},
	{"Samsung Galaxy S10", "", 4599, 1, 1},
	{"Apple iPhone XS Max", "", 4799, 1, 1},
	{"Apple iPhone 11 Pro", "", 5999, 1, 1},
	{"Apple iPhone 11 Pro Max", "", 7299, 1, 1},
}

function gui()
	dxDrawImage(724/scale, 114/scale, 473/scale, 852/scale, ":dmta_gsm/gfx/bg.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	local x,y,w,h = exports['dxLibary']:dxLibary_formatTextPosition(1148/scale, 291/scale, 22/scale, 22/scale)
    for i, v in ipairs(rzeczy) do
    	local dodatekY = (45*py)*(i-1)
		local dodatekY2 = (146*py)*(i-1)
		dxLibary:dxLibary_createButton("Kup", 1139/scale, 208/scale+dodatekY, 38/scale, 25/scale, tocolor(255, 255, 255, 255), false)
		dxLibary:dxLibary_createButton("X", 1164/scale, 126/scale, 23/scale, 23/scale, tocolor(255, 255, 255, 255), false)
   	end
end

addEventHandler("onClientClick", root, function(btn, state)
  if btn == "left" and state == "down" then
  	for i,v in ipairs(rzeczy) do
  		local dodatekY = (45*py)*(i-1)
  		if mysz(1139/scale, 208/scale+dodatekY, 38/scale, 25/scale) and okno == true then
			if getPlayerMoney(localPlayer) < tonumber(v[3]) then
				exports['dmta_base_notifications']:addNotification( "Brakuje Ci pieniędzy na zakupienie tego.", "error" );
				return;
			end
  			exports["dmta_base_notifications"]:addNotification("Kupujesz "..v[1].." za "..v[3].." USD")
			triggerServerEvent("daj:telefon", localPlayer, v[1])
			triggerServerEvent("zabierz:hajs-food1", localPlayer, v[3])
  		end
  	end
    if mysz(1164/scale, 126/scale, 23/scale, 23/scale) and okno == true then
    	removeEventHandler("onClientRender", root, gui)
    	okno = false
    	showCursor(false)
	setElementData(localPlayer, "hud", false)
	showChat(true)
	executeCommandHandler("radar")
	setElementData(localPlayer, "player:blackwhite", false)
    end
  end
end)

addEventHandler("onClientMarkerHit", resourceRoot, function(gracz)
	if getElementInterior(localPlayer) ~= 1 then return end
	if gracz ~= localPlayer then return end
  	if getPedOccupiedVehicle(localPlayer) then return end
  	if getElementData(localPlayer, "bw") then return end
	addEventHandler("onClientRender", root, gui)
	okno = true
	showCursor(true)
	setElementData(localPlayer, "hud", true)
	showChat(false)
	executeCommandHandler("radar")
	setElementData(localPlayer, "player:blackwhite", true)
end)

addEventHandler("onClientMarkerLeave", resourceRoot, function(gracz)
  if gracz ~= localPlayer then return end
  removeEventHandler("onClientRender", root, gui)
  okno = false
  showCursor(false)
setElementData(localPlayer, "hud", false)
showChat(true)
--executeCommandHandler("radar")
setElementData(localPlayer, "player:blackwhite", false)
end)

function mysz(psx,psy,pssx,pssy,abx,aby)
    if not isCursorShowing() then return end
    cx,cy=getCursorPosition()
    cx,cy=cx*sx,cy*sy
    if cx >= psx and cx <= psx+pssx and cy >= psy and cy <= psy+pssy then
        return true,cx,cy
    else
        return false
    end
end