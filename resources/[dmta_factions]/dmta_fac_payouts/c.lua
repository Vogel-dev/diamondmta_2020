--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local screenW, screenH = guiGetScreenSize()
local sx, sy = guiGetScreenSize()
local px,py = sx/1440, sy/900

local sw,sh = guiGetScreenSize()
local baseX = 1920
local scale = 1
local minScale = 2
if sw < baseX then
    scale = math.min(minScale, baseX/sw)
end

local font = dxCreateFont("cz.ttf", 14)
local dxLibary = exports.dxLibary

local okno = false

local miejsca = {
	{362.09216308594,173.78352355957,1008.3828125, 3},
}

for i, v in ipairs(miejsca) do
    local marker = createMarker(v[1], v[2], v[3]-.95, "cylinder", 1.1, 59, 122, 87, 100)
    setElementData(marker, 'marker:icon', 'job')
	setElementInterior(marker, v[4])
	addEventHandler("onClientMarkerHit", marker, function(gracz)
		if gracz ~= localPlayer then return end
        if getElementData(localPlayer, "user:fname") then
		  addEventHandler("onClientRender", root, gui)
		  okno = true
          showCursor(true)
            showChat(false)
        end
	end)
end


function gui()
	local wyplata = (getElementData(localPlayer, "user:ftime") or 0) * (getElementData(localPlayer, "frakcja:wyplata") or 0)
    dxDrawImage(832/scale, 459/scale, 256/scale, 163/scale, ":dmta_fac_payouts/gfx/bg.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
    dxLibary:dxLibary_createButton('Odbierz', 873/scale, 578/scale, 81/scale, 34/scale, tocolor(255, 255, 255, 255), false)
    dxLibary:dxLibary_createButton('Anuluj', 964/scale, 578/scale, 81/scale, 34/scale, tocolor(255, 255, 255, 255), false)
    shadowText("Wypłata: "..wyplata.." $", 835/scale, 494/scale, 1084/scale, 578/scale, tocolor(150, 150, 150, 255), 1.00, font, "center", "center", false, false, false, false, false)
end


addEventHandler("onClientClick", root, function(btn, state)
  if btn == "left" and state == "down" then
    if mysz(873/scale, 578/scale, 81/scale, 34/scale) and okno == true then
        removeEventHandler("onClientRender", root, gui)
        showCursor(false)
        showChat(true)
        okno = false
        local wyplata = getElementData(localPlayer, "user:ftime")*getElementData(localPlayer, "frakcja:wyplata")
        if getElementData(localPlayer, 'user:premium') then
            wyplata = wyplata*1.5
        end
        triggerServerEvent("dodaj:hajs", localPlayer,wyplata)
        exports["dmta_base_notifications"]:addNotification("Odebrałeś wypłatę z frakcji w wysokości "..wyplata.." $", "success")
        setElementData(localPlayer, "user:ftime", 0)
    elseif mysz(964/scale, 578/scale, 81/scale, 34/scale) and okno == true then
        removeEventHandler("onClientRender", root, gui)
        showCursor(false)
        showChat(true)
        okno = false
    end
  end
end)

function shadowText(text,x,y,w,h,color,size,font,xx,yy,x1,x2,x3,x4,x5)
    dxDrawText(text,x+1,y+1,w+1,h+1,tocolor(0,0,0),size,font,xx,yy,x1,x2,x3,x4,x5)
    dxDrawText(text,x,y,w,h,color,size,font,xx,yy,x1,x2,x3,x4,x5)
end

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