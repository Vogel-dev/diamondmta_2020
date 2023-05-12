--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local font = dxCreateFont("cz.ttf", 18)
local screenW, screenH = guiGetScreenSize()
local sx, sy = guiGetScreenSize()
local px, py = screenW/1440, screenH/900

setTimer(function()
    if getElementData(localPlayer, "user:faction") then
    	if getElementData(localPlayer, "user:afk") then return end
        local sluzba = tonumber(getElementData(localPlayer, "user:ftime")) or 0
        setElementData(localPlayer, "user:ftime", sluzba+1)
       	triggerServerEvent("minuty:frakcji", localPlayer)
    end
end, 60000, 0)

local marker = { }
local blip = { }

addEvent("stworz:wezwanie:oz", true)
addEventHandler("stworz:wezwanie:oz", root, function(x, y, z, id, gracz)
	marker[id] = createMarker(x, y, z-0.95, "cylinder", 3, 212, 0, 0, 60)
	setElementData(marker[id], 'marker:icon', 'brak')
	blip[id] = createBlipAttachedTo(marker[id], 41)
	setElementData(marker[id], "blip", blip[id])
	setElementData(marker[id], "id", id)
	local napis = createElement("text")
	setElementData(napis, "text" , "Zgłoszenie od gracza "..getPlayerName(gracz))
	setElementPosition(napis, x, y, z)
	setElementData(marker[id], "tekst", napis)
	addEventHandler("onClientMarkerHit", marker[id], function(gracz)
		if gracz ~= localPlayer then return end
		triggerServerEvent("usun:marker:zglo", localPlayer, getElementData(source, "id"))
		destroyElement(getElementData(source, "blip"))
		destroyElement(getElementData(source, "tekst"))
		destroyElement(source)
		outputChatBox("#00ff00● #ffffffDojechałeś na miejsce zgłoszenia.", 255, 255, 255, true)
	end)		
end)

addEvent("usun:markerek:zglo", true)
addEventHandler("usun:markerek:zglo", root, function(id)
	if isElement(marker[id]) then
		destroyElement(getElementData(marker[id], "blip"))
		destroyElement(getElementData(marker[id], "tekst"))
		destroyElement(marker[id])
	end
end)

addEventHandler( "onClientElementStreamIn",root,function()
    if getElementType( source ) == "object" then
		setObjectBreakable(source, false)
	end
end)

addEvent("niedozniszczenia",true)
addEventHandler("niedozniszczenia",root,function(obj)
	if obj then
		setObjectBreakable(obj, false)
	end
end)

addEvent("daj:blokady", true)
addEventHandler("daj:blokady", root, function()
	local x, y, z = getElementPosition (localPlayer)
	local rotX,rotY,rotZ = getElementRotation(localPlayer)
	setElementData(localPlayer, "maBlokady", true)
	setElementData(localPlayer, "co", "brak")
	addEventHandler("onClientRender", root, gui)
	bindKey("mouse_wheel_down", "both", function()
		if getElementData(localPlayer, "maBlokady") then
			local jaki = getElementData(localPlayer, "co")
			if isElement(objekt) then
				destroyElement(objekt)
			end
			if jaki == "brak" then
				objekt = createObject(1238, x, y, z-0.65, 0, 0, 0)
				setElementData(localPlayer, "co", "pacholek")
				setElementCollisionsEnabled(objekt, false)
				attachElements(objekt, localPlayer, 0, 1, -0.65, 0, 0, 90)
			elseif jaki == "pacholek" then
				objekt = createObject(1228, x, y, z-0.65,0,0, 0)
				setElementData(localPlayer, "co", "barierka")
				setElementCollisionsEnabled(objekt, false)
				attachElements(objekt, localPlayer, 0, 1, -0.65, 0, 0, 90)
			elseif jaki == "barierka" then
				setElementData(localPlayer, "co", "linnia")
			--elseif jaki == "linnia" then
				--if isElement(objekt) then
					--destroyElement(objekt)
				--end
				setElementData(localPlayer, "co", "brak")
			end
		end
	end)
end)

addEvent("schowaj:blokady", true)
addEventHandler("schowaj:blokady", root, function()
	setElementData(localPlayer, "maBlokady", false)
	setElementData(localPlayer, "co", "brak")
	removeEventHandler("onClientRender", root, gui)
	if isElement(objekt) then
		destroyElement(objekt)
	end
end)

function gui()
	dxDrawText("Aktualnie trzymasz: "..getElementData(localPlayer, "co").."\nAby zmienić używany obiekt użyj scrolla", 571*px, 741*py, 871*px, 814*py, tocolor(0, 0, 0, 255), 1.00, font, "center", "center", false, false, false, false, false)
    dxDrawText("Aktualnie trzymasz: "..getElementData(localPlayer, "co").."\nAby zmienić używany obiekt użyj scrolla", 570*px, 740*py, 870*px, 813*py, tocolor(255, 255, 255, 255), 1.00, font, "center", "center", false, false, false, false, false)
end

-- linnie 

function getElementMatrix(element)
    local rx, ry, rz = getElementRotation(element, "ZXY")
    rx, ry, rz = math.rad(rx), math.rad(ry), math.rad(rz)
    local matrix = {}
    matrix[1] = {}
    matrix[1][1] = math.cos(rz)*math.cos(ry) - math.sin(rz)*math.sin(rx)*math.sin(ry)
    matrix[1][2] = math.cos(ry)*math.sin(rz) + math.cos(rz)*math.sin(rx)*math.sin(ry)
    matrix[1][3] = -math.cos(rx)*math.sin(ry)
    matrix[1][4] = 1
    
    matrix[2] = {}
    matrix[2][1] = -math.cos(rx)*math.sin(rz)
    matrix[2][2] = math.cos(rz)*math.cos(rx)
    matrix[2][3] = math.sin(rx)
    matrix[2][4] = 1
	
    matrix[3] = {}
    matrix[3][1] = math.cos(rz)*math.sin(ry) + math.cos(ry)*math.sin(rz)*math.sin(rx)
    matrix[3][2] = math.sin(rz)*math.sin(ry) - math.cos(rz)*math.cos(ry)*math.sin(rx)
    matrix[3][3] = math.cos(rx)*math.cos(ry)
    matrix[3][4] = 1
	
    matrix[4] = {}
    matrix[4][1], matrix[4][2], matrix[4][3] = getElementPosition(element)
    matrix[4][4] = 1
	
    return matrix
end

function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix ( element )  -- Get the matrix
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z                               -- Return the transformed point
end

-----------------------------

local cfg = {
stojakID = 2590,
material = "linnia.png"
};

local ID = 0;
local stojaki = {}
local polygon = {}

function createLine(plr,value)
	if not value then
		ID = ID + 1
		local ps = plr.position
		local rot = plr.rotation
		stojaki[ID] = {}
		stojaki[ID].start = Object(cfg.stojakID, ps.x,ps.y,ps.z-0.6, rot.x,rot.y,rot.z+90)
		stojaki[ID].endL = Object(cfg.stojakID,ps.x,ps.y,ps.z,rot.x, rot.y,rot.z+90)
		stojaki[ID].start:setCollisionsEnabled(false)
		stojaki[ID].endL:setCollisionsEnabled(false)
		stojaki[ID].endL:setAlpha(0)
		stojaki[ID].endL:attach(plr)
		stojaki[ID].start:setData("owner",plr.name)
		stojaki[ID].endL:setData("owner",plr.name)
	else
		stojaki[ID].endL:setAlpha(255)
		stojaki[ID].endL:detach()
		local ps = plr.position
		local rot = plr.rotation
		stojaki[ID].endL:setPosition(ps.x,ps.y,ps.z-0.6)
		stojaki[ID].endL:setRotation(rot.x,rot.y,rot.z+90)
		local posO = stojaki[ID].start.position
		local rotO = stojaki[ID].start.rotation
		local posO1 = stojaki[ID].endL.position
		local rotO1 = stojaki[ID].endL.rotation
		fx = posO.x + math.cos(rotO.x+90) * 1
		fy = posO.y + math.sin(rotO.y+90) * 1
		fx1 = posO.x + math.sin(rotO.x-90) * 1
		fy1 = posO.y + math.cos(rotO.y-90) * 1
		fx2 = posO1.x + math.cos(rotO1.x+90) * 1
		fy2 = posO1.y + math.sin(rotO1.y+90) * 1
		fx3 = posO1.x + math.sin(rotO1.x-90) * 1
		fy3 = posO1.y + math.cos(rotO1.y-90) * 1
		polygon[ID] = ColShape.Polygon(fx,fy,fx,fy,fx1,fy1,fx3,fy3,fx2,fy2)
		polygon[ID]:setData("line:col",true)
		polygon[ID]:setData("owner",plr.name)
	end
end
addEvent("createLine",true)
addEventHandler("createLine",localPlayer,createLine)

addEventHandler("onClientColShapeHit",root,function(plr,md)
	if source:getData("line:col") then
		if plr:getType() == "player" or plr:getType() == "vehicle" then
			if not plr:getData("user:faction") then
			local x,y,z = getPositionFromElementOffset(plr,0,-2,0)
			plr:setPosition(x,y,z)
			plr:setFrozen(true)
			Timer(function(plr)
				plr:setFrozen(false)
			end, 500,1,plr)
			end
		end
	end
end)

addEventHandler("onClientRender",root,function()
	for i =1, ID do
		if isElement(stojaki[i].start) then
			local ps = stojaki[i].start.position
			local pse = stojaki[i].endL.position
			local tex = DxTexture(cfg.material)
			dxDrawMaterialLine3D(ps.x,ps.y,ps.z+0.2, pse.x,pse.y,pse.z+0.2, tex, 0.1)
		end
	end
end)

function destroy_line(plr)
number = 0;
	for i=1,ID do
		if isElement(stojaki[i].start) then
			if stojaki[i].start:getData("owner") == getPlayerName(plr) then
				stojaki[i].start:destroy()
				stojaki[i].endL:destroy()
				polygon[i]:destroy()
				number = number + 1
			end
		end
	end
end
addEvent("destroyLine",true)
addEventHandler("destroyLine",getRootElement(),destroy_line)