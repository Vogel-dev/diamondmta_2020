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
	{"Casio Classic", "", 225, 1, 1},
	{"Casio G-Shock", "", 405, 1, 1},
	{"Apple Watch 5", "", 2099, 1, 1},
	{"Emporio Armani Black", "", 3000, 1, 1},
	{"Michael Kors Rose Gold", "", 3500, 1, 1},
	{"Gucci GG Supreme Canvas", "", 3959, 1, 1},
	{"Hugo Boss Ocean Edition", "", 5650, 1, 1},
	{"Omega Black Stainless Steel", "", 29000, 1, 1},
	{"Cartier White 18K Yellow Gold", "", 60000, 1, 1},
	{"Hublot Big Bang Black", "", 92000, 1, 1},
	{"Rolex Blue Gold Submariner", "", 95000, 1, 1},
	{"Louis Vuitton 18K White Gold", "", 135000, 1, 1},
	{"Patek Philippe 18K Rose Gold", "", 182000, 1, 1},
	{"Rolex Tridor Gold Diamonds", "", 245000, 1, 1},
}

function gui()
	dxDrawImage(724/scale, 114/scale, 473/scale, 852/scale, ":dmta_jewelery/gfx/bg.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
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
			triggerServerEvent("daj:zegarek", localPlayer, v[1])
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
	if gracz ~= localPlayer then return end
  	if getPedOccupiedVehicle(localPlayer) then return end
  	if getElementData(localPlayer, "bw") then return end
  	--if getElementDimension(localPlayer) ~= 0 or getElementInterior(localPlayer) ~= 0 then return end
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