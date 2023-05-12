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
	{"Kastet", "", 500, 51, 1},
	{"Noz wojskowy", "", 1500, 39, 2},
	{"Kij baseballowy", "", 2000, 65, 3},
	{"Deagle", "", 8000, 18, 7},
	{"Obrzyn", "", 35000, 15, 6},
	{"Uzi", "", 45000, 51, 1},
	{"AK-47", "", 75000, 39, 2},
	{"Karabin snajperski", "", 125000, 65, 3},
	{"Molotov", "", 250000, 15, 6},
}

function gui()
	dxDrawImage(724/scale, 244/scale, 473/scale, 593/scale, ":dmta_fac_blackshop/gfx/bg.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	local x,y,w,h = exports['dxLibary']:dxLibary_formatTextPosition(1148/scale, 291/scale, 22/scale, 22/scale)
    for i, v in ipairs(rzeczy) do
    	local dodatekY = (45*py)*(i-1)
		local dodatekY2 = (146*py)*(i-1)
		dxLibary:dxLibary_createButton("Kup", 1136/scale, 338/scale+dodatekY, 39/scale, 23/scale, tocolor(255, 255, 255, 255), false)
		dxLibary:dxLibary_createButton("X", 1159/scale, 254/scale, 28/scale, 25/scale, tocolor(255, 255, 255, 255), false)
   	end
end

addEventHandler("onClientClick", root, function(btn, state)
  if btn == "left" and state == "down" then
  	for i,v in ipairs(rzeczy) do
  		local dodatekY = (45*py)*(i-1)
  		if mysz(1136/scale, 338/scale+dodatekY, 39/scale, 23/scale) and okno == true then
			  if getElementData(localPlayer, "user:level") > 19 then
			  else
				  outputChatBox("#ff0000● #ffffffNie posiadasz 20 poziomu postaci.", 255, 255, 255, true)
				  return end
				  if getElementData(localPlayer, "user:oname") then
				  else
					  outputChatBox("#ff0000● #ffffffNie posiadasz przynależności do organizacji przestępczej.", 255, 255, 255, true)
					  return end
			if getPlayerMoney(localPlayer) < tonumber(v[3]) then
				outputChatBox("#ff0000● #ffffffBrakuje Ci pieniędzy na zakupienie tego.", 255, 255, 255, true)
				return;
			end
			  outputChatBox("#00ff00● #ffffffKupujesz #969696"..v[1].." #ffffffza #969696"..v[3].." #00ff00$", 255, 255, 255, true)
			triggerServerEvent("daj:bron1", localPlayer, v[1])
			triggerServerEvent("zabierz:hajs-food1", localPlayer, v[3])
  		end
  	end
    if mysz(1159/scale, 254/scale, 28/scale, 25/scale) and okno == true then
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