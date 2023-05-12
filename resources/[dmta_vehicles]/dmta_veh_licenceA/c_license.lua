--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local noti = exports.dmta_base_notifications

local sw,sh = guiGetScreenSize()
local zoom = 1920/sw

local dx = exports.dxLibary

local PJA = {}

function isMouseInPosition(x, y, w, h)
    if not isCursorShowing() then return end
        
    local mouse = {getCursorPosition()}
    local myX, myY = (mouse[1] * sw), (mouse[2] * sh)
    if (myX >= x and myX <= (x + w)) and (myY >= y and myY <= (y + h)) then
        return true
    end
        
    return false
end
    
local click = false
function onClick(x, y, w, h, called)
    if(isMouseInPosition(x, y, w, h) and not click and getKeyState("mouse1"))then
        click = true
        called()
    elseif(not getKeyState("mouse1") and click)then
        click = false
    end
end
    
--

PJA.marker = false
PJA.point = 1
PJA.type = false
PJA.blip = false

PJA.licenses = {
    A = {
        points = {
            {1765.3458251953, -1692.5474853516, 13.132768630981},
            {1751.3427734375, -1651.8500976563, 13.087889671326},
            {1728.2415771484, -1593.7418212891, 13.07227230072},
            {1632.7375488281, -1590.9038085938, 13.210167884827},
            {1465.2232666016, -1590.1533203125, 13.08670425415},
            {1332.0891113281, -1572.5028076172, 13.060164451599},
            {1327.0125732422, -1519.6577148438, 13.09140586853},
            {1359.1365966797, -1418.7598876953, 13.087822914124},
            {1289.6994628906, -1393.2060546875, 12.953981399536},
            {1219.8796386719, -1393.8648681641, 12.932028770447},
            {1206.1437988281, -1332.7741699219, 13.103827476501},
            {1165.4168701172, -1278.5745849609, 13.226073265076},
            {1094.2102050781, -1279.0164794922, 13.207551002502},
            {1056.7404785156, -1291.6983642578, 13.425003051758},
            {1008.58203125, -1320.4916992188, 13.086775779724},
            {927.70697021484, -1319.7416992188, 13.123304367065},
            {915.24084472656, -1378.7438964844, 12.970808029175},
            {979.48626708984, -1403.0004882813, 12.792372703552},
            {1138.1715087891, -1402.8114013672, 13.195190429688},
            {1300.7071533203, -1403.0634765625, 12.925303459167},
            {1341.1622314453, -1456.8731689453, 13.078912734985},
            {1300.4194335938, -1585.9323730469, 13.088257789612},
            {1299.6257324219, -1760.3409423828, 13.085782051086},
            {1313.7043457031, -1825.5841064453, 13.080604553223},
            {1345.0615234375, -1734.1751708984, 13.096210479736},
            {1424.8599853516, -1734.6401367188, 13.083766937256},
            {1431.0137939453, -1654.0668945313, 13.08798789978},
            {1489.9907226563, -1593.7922363281, 13.086163520813},
            {1640.3123779297, -1593.7760009766, 13.151963233948},
            {1744.4678955078, -1603.6971435547, 13.087940216064},
            {1747.3122558594, -1682.3421630859, 13.089703559875},
            {1766.2327880859, -1698.6442871094, 13.172088623047},
            {1775.2272949219, -1701.9144287109, 13.208334922791},
        },

        cost = 2000,

        pos = {2443.9191894531,-1648.1834716797,1016.1433105469-1},

        marker = false,

        veh = {463, 1782.712890625,-1701.3446044922,13.16057491302,0,0,0},
    },
}

for i,v in pairs(PJA.licenses) do
    v.marker = createMarker(v.pos[1], v.pos[2], v.pos[3]+0.01, "cylinder", 1.2, 172, 229, 238)
    setElementDimension(v.marker, 0)
    setElementInterior(v.marker, 1)
    setElementData(v.marker, 'marker:icon', 'brak')
end

PJA.onRender = function()
    local cost = ""
    if(PJA.licenses[PJA.type].cost > 0)then
        cost = "\n\nCena: "..PJA.licenses[PJA.type].cost.." $"
    end
    dxDrawRectangle(0, 0, 1920, 1080, tocolor(15, 15, 15, 200), false)
    dx:dxLibary_createWindow(714/zoom, 307/zoom, 493/zoom, 467/zoom)
    dx:dxLibary_text("Prawo jazdy kat.A", 724/zoom, 317/zoom, 1197/zoom, 373/zoom, tocolor(105, 188, 235, 255), 10, "default", "center", "center", false, false, false, false, false)
    dx:dxLibary_text("Posiadając prawo jazdy kat.A możesz kierować jedno lub dwuśladowym mechanicznym pojazdem drogowym o masie własnej do 400 kg."..cost, 738/zoom, 485/zoom, 1187/zoom, 569/zoom, tocolor(255, 255, 255, 255), 5, "default", "center", "center", false, true, false, false, false)
    dx:dxLibary_createButton("Rozpocznij", 748/zoom, 678/zoom, 202/zoom, 51/zoom, 3)
    dx:dxLibary_createButton("Anuluj", 985/zoom, 678/zoom, 202/zoom, 51/zoom, 3)

    onClick(748/zoom, 678/zoom, 202/zoom, 51/zoom, function()
        removeEventHandler("onClientRender", root, PJA.onRender)
        showCursor(false)

        for i,v in pairs(PJA.licenses) do
            if(isElementWithinMarker(localPlayer, v.marker))then
                triggerServerEvent("start.PJA", resourceRoot, v, i)
            end
        end
    end)

    onClick(985/zoom, 678/zoom, 202/zoom, 51/zoom, function()
        removeEventHandler("onClientRender", root, PJA.onRender)
        showCursor(false)
    end)
end

addEventHandler("onClientMarkerHit", resourceRoot, function(hit, dim)
    if(hit ~= localPlayer or not dim)then return end

    for i,v in pairs(PJA.licenses) do
        if(source == v.marker)then
            addEventHandler("onClientRender", root, PJA.onRender)
            showCursor(true)
            PJA.type = i
            return
        end
    end

    if(source == PJA.marker)then
        destroyElement(PJA.marker)
        destroyElement(PJA.blip)
        
        PJA.point = PJA.point+1

        for i,v in pairs(PJA.licenses) do
            if(i == PJA.type)then
                if(PJA.point == #v.points)then
                    triggerServerEvent("stop.PJA", resourceRoot, i)
                    noti:addNotification('Zdałeś egzamin, gratulacje.', 'success')
                
                    setTimer(function()
                        setElementPosition(localPlayer, 1776.6812744141,-1721.8638916016,13.546875)
                        setElementInterior(localPlayer, 0)
                    end, 500, 1)
                else
                    PJA.marker = createMarker(v.points[PJA.point][1], v.points[PJA.point][2], v.points[PJA.point][3], "checkpoint", 2, 105, 188, 235, 255)
                    PJA.blip = createBlipAttachedTo(PJA.marker, 41)
                end
            end
        end
    end
end)

addEvent("start.PJA", true)
addEventHandler("start.PJA", resourceRoot, function(v, type)
    PJA.point = 1
    PJA.type = type
    for i,v in pairs(PJA.licenses) do
        if(i == type)then
            PJA.marker = createMarker(v.points[1][1], v.points[1][2], v.points[1][3], "checkpoint", 2, 105, 188, 235, 255)
            PJA.blip = createBlipAttachedTo(PJA.marker, 41)
        end
    end
end)

addEvent("stop.PJA", true)
addEventHandler("stop.PJA", resourceRoot, function(v, type)
    if(PJA.marker and isElement(PJA.marker))then
        destroyElement(PJA.marker)
        destroyElement(PJA.blip)
    end
end)