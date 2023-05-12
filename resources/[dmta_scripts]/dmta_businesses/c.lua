--[[
@Author: Vogel
@Copyright: Vogel / Society MTA // 2019-2020
@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local screenW, screenH = guiGetScreenSize()
local sx, sy = guiGetScreenSize()
local px, py = screenW/1440, screenH/900
local okno = false

local sw,sh = guiGetScreenSize()
local baseX = 1920
local scale = 1
local minScale = 2
if sw < baseX then
    scale = math.min(minScale, baseX/sw)
end

local font = dxCreateFont("cz.ttf", 16)

function shadowText(text,x,y,w,h,color,size,font,xx,yy,x1,x2,x3,x4,x5)
	dxDrawText(text,x+1,y+1,w+1,h+1,tocolor(0,0,0),size,font,xx,yy,x1,x2,x3,x4,x5)
	dxDrawText(text,x,y,w,h,color,size,font,xx,yy,x1,x2,x3,x4,x5)
end

addEvent("gui:otworz", true) 
addEventHandler("gui:otworz", getRootElement(), function(hitElement,owner,name,id,cost,saldo,data)
    if hitElement ~= localPlayer then return end
    biznes_wlasciciel = owner
    biznes_name = name
    biznes_id = id
    biznes_cost = cost
    biznes_saldo = saldo
    biznes_data = data
    addEventHandler("onClientRender", root, gui)
    okno = true
    showCursor(true)
end)


function gui()
        dxDrawImage(724/scale, 382/scale, 473/scale, 316/scale, ":dmta_businesses/bg.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
        exports['dxLibary']:dxLibary_createButton('Kup', 747/scale, 642/scale, 85/scale, 38/scale, tocolor(255, 255, 255, 255), false)
        exports['dxLibary']:dxLibary_createButton('Wypłać', 865/scale, 642/scale, 85/scale, 38/scale, tocolor(255, 255, 255, 255), false)
        exports['dxLibary']:dxLibary_createButton('Sprzedaj', 979/scale, 642/scale, 85/scale, 38/scale, tocolor(255, 255, 255, 255), false)
        exports['dxLibary']:dxLibary_createButton('Opłać', 1091/scale, 642/scale, 85/scale, 38/scale, tocolor(255, 255, 255, 255), false)
        exports['dxLibary']:dxLibary_createButton(' X', 1166/scale, 392/scale, 20/scale, 20/scale, tocolor(255, 255, 255, 255), false)
    	  shadowText("Właściciel (PID): "..biznes_wlasciciel.."\nNazwa biznesu: "..biznes_name.."\nCena za 3 doby: "..biznes_cost.." $\nSaldo biznesu: "..biznes_saldo.." $\nOpłacony do: "..biznes_data.."", 724/scale, 452/scale, 1197/scale, 632/scale, tocolor(150, 150, 150, 255), 1.00, font, "center", "center", false, false, false, false, false)
end

addEventHandler("onClientClick", root, function(btn, state)
  if btn == "left" and state == "down" then
    if mysz(1166/scale, 392/scale, 20/scale, 20/scale) and okno == true then
    	removeEventHandler("onClientRender", root, gui)
    	okno = false
    	showCursor(false)
    elseif mysz(865/scale, 642/scale, 85/scale, 38/scale) and okno == true then
    	triggerServerEvent("wyplac:biznesy", localPlayer, localPlayer)
    elseif mysz(747/scale, 642/scale, 85/scale, 38/scale) and okno == true then
		triggerServerEvent("kup:biznesy", localPlayer, localPlayer)
    elseif mysz(1091/scale, 642/scale, 85/scale, 38/scale) and okno == true then
    	triggerServerEvent("oplac:biznesy", localPlayer, localPlayer)
    elseif mysz(979/scale, 642/scale, 85/scale, 38/scale) and okno == true then
    	triggerServerEvent("sprzedaj:biznesy", localPlayer, localPlayer)
    end
  end
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