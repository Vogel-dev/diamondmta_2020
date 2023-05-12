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
	--- nazwa, tekst, cena, %najedzenia, grafika
	{"Kastet", "", 2000, 51, 1},
	{"Noz wojskowy", "", 4000, 39, 2},
	{"Kij baseballowy", "", 6000, 65, 3},
	{"Colt 45", "", 25000, 18, 7},
}

function gui()
	dxDrawImage(724/scale, 382/scale, 473/scale, 316/scale, ":dmta_fac_gunshop/gfx/bg.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
    for i, v in ipairs(rzeczy) do
    	local dodatekY = (45*py)*(i-1)
		local dodatekY2 = (146*py)*(i-1)
		dxLibary:dxLibary_createButton("Kup", 1122/scale, 475/scale+dodatekY, 52/scale, 28/scale, tocolor(255, 255, 255, 255), false)
		dxLibary:dxLibary_createButton("X", 1164/scale, 392/scale, 20/scale, 20/scale, tocolor(255, 255, 255, 255), false)
   	end
end

addEventHandler("onClientClick", root, function(btn, state)
  if btn == "left" and state == "down" then
  	for i,v in ipairs(rzeczy) do
  		local dodatekY = (45*py)*(i-1)
  		if mysz(1122/scale, 475/scale+dodatekY, 52/scale, 28/scale) and okno == true then
			  if getElementData(localPlayer, 'user:licencjaB') ~=1 then
				exports['dmta_base_notifications']:addNotification( "Nie posiadasz licencji na broń.", "error" )
				return end
			  if getElementData(localPlayer, "user:online") < 1200 then
				exports['dmta_base_notifications']:addNotification( "Nie posiadasz przegranych 20 godzin na serwerze.", "error" );
				return;
			end
			if getPlayerMoney(localPlayer) < tonumber(v[3]) then
				exports['dmta_base_notifications']:addNotification( "Brakuje Ci pieniędzy na zakupienie tego.", "error" );
				return;
			end
  			exports["dmta_base_notifications"]:addNotification("Kupujesz "..v[1].." za "..v[3].." USD")
			triggerServerEvent("daj:bron2", localPlayer, v[1])
			triggerServerEvent("zabierz:hajs", localPlayer, v[3])
  		end
  	end
    if mysz(1164/scale, 392/scale, 20/scale, 20/scale) and okno == true then
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