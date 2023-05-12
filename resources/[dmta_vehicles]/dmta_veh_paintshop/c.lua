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
local kolor1 = false
local kolor2 = false
local font = dxCreateFont("cz.ttf", 21)
local font2 = dxCreateFont("cz.ttf", 18)
local sw,sh = guiGetScreenSize()
local baseX = 1920
local scale = 1
local minScale = 2
if sw < baseX then
    scale = math.min(minScale, baseX/sw)
end

local r, g, b = 0, 0, 0
local editbox = exports.editbox
local dxLibary = exports.dxLibary

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


function shadowText(text,x,y,w,h,color,size,font,xx,yy,x1,x2,x3,x4,x5)
	dxDrawText(text,x+1,y+1,w+1,h+1,tocolor(0,0,0),size,font,xx,yy,x1,x2,x3,x4,x5)
	dxDrawText(text,x,y,w,h,color,size,font,xx,yy,x1,x2,x3,x4,x5)
end

function gui1()
		dxDrawImage(760/scale, 415/scale, 400/scale, 250/scale, ":dmta_veh_paintshop/gfx/bg.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
		dxDrawRectangle(998/scale, 486/scale, 100/scale, 100/scale, tocolor(r, g, b, 255), false)
		shadowText("Kliknij\n(podgląd)",  998/scale, 485/scale, 1098/scale, 586/scale, tocolor(255, 255, 255, 255), 1.00, font2, "center", "center", false, false, false, false, false)
		dxLibary:dxLibary_createButton('Akceptuj', 787/scale, 606/scale, 124/scale, 40/scale, tocolor(255, 255, 255, 255), false)
		dxLibary:dxLibary_createButton('Anuluj', 984/scale, 606/scale, 124/scale, 40/scale, tocolor(255, 255, 255, 255), false)
end

addEvent("lakernia:kolor1:gui", true)
addEventHandler("lakernia:kolor1:gui", root, function(marker)
	local cuboid = getElementData(marker, "cuboid:kolor1")
	if cuboid then
		vehx = getElementsWithinColShape(cuboid, "vehicle")
		if #vehx < 1 then
			exports["dmta_base_notifications"]:addNotification("Na stanowisku do malowania nie ma żadnego pojazdu.", "error")
			return
		end
		if #vehx > 1 then
			exports["dmta_base_notifications"]:addNotification("Na stanowisku do malowania jest zbyt wiele pojazdów.", "error")
			return
		end
		if getVehicleType(vehx[1]) ~= "Automobile" then return end
		veh = vehx[1]
		setmarker = marker
		if getElementData(veh, "vehicle:owner") ~= getElementData(localPlayer, "user:dbid") then exports["dmta_base_notifications"]:addNotification("Nie jesteś właścicielem tego pojazdu", "error") return end
		showCursor(true)
		setElementData(localPlayer, "hud", true)
		showChat(false)
		executeCommandHandler("radar")
		kolor1 = true
		addEventHandler("onClientRender", root, gui1)
		editbox:createCustomEditbox('r', 'R: 0-255', 777/scale, 460/scale, 143/scale, 36/scale, false, '', true)
		editbox:createCustomEditbox('g', 'G: 0-255', 777/scale, 510/scale, 143/scale, 36/scale, false, '', true)
		editbox:createCustomEditbox('b', 'B: 0-255', 777/scale, 560/scale, 143/scale, 36/scale, false, '', true)
	end
end)


addEventHandler("onClientClick", root, function(btn, state)
if btn == "left" and state == "down" then
	if myszka(984/scale, 606/scale, 124/scale, 40/scale) and kolor1 == true then
		removeEventHandler("onClientRender", root, gui1)
		kolor1 = false
		showCursor(false)
		setElementData(localPlayer, "hud", false)
		showChat(true)
		executeCommandHandler("radar")
		editbox:destroyCustomEditbox('r')	
		editbox:destroyCustomEditbox('g')	
		editbox:destroyCustomEditbox('b')	
	elseif myszka(998/scale, 486/scale, 100/scale, 100/scale) and kolor1 == true then
		r = editbox:getCustomEditboxText('r')
		g = editbox:getCustomEditboxText('g')
		b = editbox:getCustomEditboxText('b')
		
		if r == "" then
			r = 0
		end
		if g == "" then
			g = 0
		end
		if b == "" then
			b = 0
		end
	elseif myszka(787/scale, 606/scale, 124/scale, 40/scale) and kolor1 == true then
		if r == "" then
			r = 0
		end
		if g == "" then
			g = 0
		end
		if b == "" then
			b = 0
		end
		if getElementData(setmarker, "kolor") == 1 then
			triggerServerEvent("lakernia:pomaluj1", localPlayer, veh, r, g, b)
		elseif getElementData(setmarker, "kolor") == 2 then
			triggerServerEvent("lakernia:pomaluj2", localPlayer, veh, r, g, b)
		end
	end
end
end)


function myszka(psx,psy,pssx,pssy,abx,aby)
    if not isCursorShowing() then return end
    cx,cy=getCursorPosition()
    cx,cy=cx*sx,cy*sy
    if cx >= psx and cx <= psx+pssx and cy >= psy and cy <= psy+pssy then
        return true,cx,cy
    else
        return false
    end
end

addEventHandler('onClientResourceStop', resourceRoot, function()
	editbox:destroyCustomEditbox('r')
	editbox:destroyCustomEditbox('g')
	editbox:destroyCustomEditbox('b')
end)