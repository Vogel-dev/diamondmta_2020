--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--


local sw,sh = guiGetScreenSize()
local zoom = 1920/sw

local dx = exports.dxLibary
local noti = exports.dmta_base_notifications

local JOB = {}

JOB.gui = false

JOB.marker = createMarker(2288.3154296875,-2420.2307128906,3-0.98, "cylinder", 1.7, 123, 182, 97)
setElementData(JOB.marker, 'marker:icon', 'job')

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

JOB.depositMarker = false
JOB.depositBlip = false

JOB.depositPoints = {
    {2322.9562988281,-2385.1569824219,0.55000001192093},
    {2279.5434570313,-2434.7165527344,0.55000001192093}
}

JOB.fill = 0
JOB.markers = {}

JOB.fish = {
    {2318.708984375,-2432.95703125,-0.55000001192093},
    {2331.0927734375,-2483.3122558594,-0.55000001192093},
    {2380.009765625,-2459.4978027344,-0.55000001192093},
    {2291.2995605469,-2490.1650390625,-0.55000001192093},
    {2324.2922363281,-2431.0183105469,-0.55000001192093},
    {2370.1669921875,-2483.1000976563,-0.55000001192093}
}

JOB.rt = dxCreateRenderTarget(300, 300, true)

JOB.images = {
    dxCreateTexture("images/siatka.png", "argb", true, "clamp"),
    dxCreateTexture("images/strzalka.png", "argb", true, "clamp"),
}

JOB.onGui = function()
    local veh = getPedOccupiedVehicle(localPlayer)
    if(not veh or veh and getElementModel(veh) ~= 453)then return end

    local playerPos = {getElementPosition(localPlayer)}
    local camera = {getCameraMatrix()}
    local rotation = findRotation(camera[1], camera[2], camera[4], camera[5])
    local playerRotation = getElementRotation(localPlayer)

    dx:dxLibary_shadowText2("Zapełnienie podkładu: "..string.format("%.1f", JOB.fill).."%", sw-320/zoom, sh-350/zoom, sw-320/zoom+300/zoom, 300/zoom, tocolor(255, 255, 255, 255), 3, "default", "center", "top", false, true, false, false, false)
    
    dxDrawRectangle(sw-320/zoom, sh-320/zoom, 300/zoom, 300/zoom, tocolor(0, 0, 0, 150), false)

    dxDrawImage(sw-320/zoom+(300/2/zoom)-15/zoom, sh-320/zoom+(300/2/zoom)-15/zoom, 30/zoom, 30/zoom, JOB.images[2], 0, 0, 0, tocolor(150, 150, 150, 255), false)

    dxSetRenderTarget(JOB.rt, true)
        for i,v in pairs(getElementsByType("colshape", resourceRoot)) do
            local id = getElementData(v, "marker:job")
            if(id)then
                local x,y = getElementPosition(v)
                local distance = getDistanceBetweenPoints2D(playerPos[1], playerPos[2], x, y)
                local angler = 180-rotation+findRotation(playerPos[1], playerPos[2], x, y)
                local pX, pY = getPointFromDistanceRotation(0, 0, distance, angler)

                dxDrawImage((300/2/zoom)-20/zoom/2+pX, (300/zoom/2)-10/zoom+pY, 20/zoom, 20/zoom, JOB.images[1], 0, 0, 0, tocolor(255, 255, 255, 255), false)

                if(distance > 100)then
                    destroyElement(JOB.markers[id])
                    JOB.markers[id] = nil

                    local rot = getPedCameraRotation(localPlayer)
                    local rx,ry = getPointFromDistanceRotation_(camera[1], camera[2], math.random(60,100), rot, math.random(-90,90))
                    local marker = createColSphere(rx, ry, playerPos[3], 5)
                    setElementData(marker, "marker:job", #JOB.markers+1, false)
                    JOB.markers[#JOB.markers+1] = marker
                end
            end
        end
    dxSetRenderTarget()
    dxDrawImage(sw-320/zoom, sh-320/zoom, 300/zoom, 300/zoom, JOB.rt)
end

JOB.onRender = function()
    dxDrawRectangle(0, 0, 1920, 1080, tocolor(15, 15, 15, 200), false)
    dx:dxLibary_createWindow(714/zoom, 307/zoom, 493/zoom, 467/zoom)
    dx:dxLibary_text("Praca dorywcza - Rybak", 724/zoom, 317/zoom, 1197/zoom, 373/zoom, tocolor(105, 188, 235, 255), 10, "default", "center", "center", false, false, false, false, false)
    dx:dxLibary_text("Do rozpoczęcia pracy wymagana jest\n#69bcebkarta wędkarska\n\n#ffffffJako rybak twoim zadaniem jest połów ryb\nna morzach #69bcebSan Andreas#ffffff.", 738/zoom, 485/zoom, 1187/zoom, 569/zoom, tocolor(255, 255, 255, 255), 5, "default", "center", "center", false, true, false, true, false)
    dx:dxLibary_createButton(getElementData(localPlayer, "user:job") == "rybak" and "Zakończ" or "Rozpocznij", 748/zoom, 678/zoom, 202/zoom, 51/zoom, 3)
    dx:dxLibary_createButton("Anuluj", 985/zoom, 678/zoom, 202/zoom, 51/zoom, 3)

    onClick(748/zoom, 678/zoom, 202/zoom, 51/zoom, function()
        if getElementData(localPlayer, "user:reputation") < 500 then noti:addNotification('Musisz posiadać 500 respektu, aby rozpocząć pracę tutaj.', 'error')
            return
        end
        if(not getElementData(localPlayer, "user:job"))then
            if getElementData(localPlayer, "user:licencjaR") ~= 1 then
                noti:addNotification('Nie posiadasz karty wędkarskiej.', 'error')
                return
            end


            noti:addNotification('Rozpocząłeś pracę jako rybak.', 'success')

            setElementData(localPlayer, "user:job", "rybak", false)

            removeEventHandler("onClientRender", root, JOB.onRender)
            showCursor(false)

            addEventHandler("onClientRender", root, JOB.onGui)

            JOB.gui = false

            JOB.objects = 5

            triggerServerEvent("rybak.vehicle", resourceRoot)

            for i,v in pairs(JOB.fish) do
                JOB.markers[i] = createColSphere(v[1], v[2], v[3], 5)
                setElementData(JOB.markers[i], "marker:job", i, false)
            end

            JOB.fill = 0
        elseif(getElementData(localPlayer, "user:job") == "rybak")then
            setElementData(localPlayer, "user:job", false, false)

            removeEventHandler("onClientRender", root, JOB.onRender)
            showCursor(false)

            removeEventHandler("onClientRender", root, JOB.onGui)

            JOB.gui = false

            noti:addNotification('Zakończyłeś prace.', 'success')

            triggerServerEvent("rybak.destroyVehicle", resourceRoot)

            if(JOB.depositMarker and isElement(JOB.depositMarker))then
                destroyElement(JOB.depositMarker)
                destroyElement(JOB.depositBlip)
                JOB.depositMarker = false
            end

            for i,v in pairs(JOB.markers) do
                if(isElement(v))then
                    destroyElement(v)
                end
                JOB.markers[i] = nil
            end
        else
            noti:addNotification('Najpierw zakończ pracę!', 'error')
        end
    end)

    onClick(985/zoom, 678/zoom, 202/zoom, 51/zoom, function()
        removeEventHandler("onClientRender", root, JOB.onRender)
        showCursor(false)

        JOB.gui = false
    end)
end

addEventHandler("onClientColShapeHit", resourceRoot, function(hit, dim)
    if(hit ~= localPlayer or not dim)then return end

    local id = getElementData(source, "marker:job")
    local veh = getPedOccupiedVehicle(localPlayer)
    if(not veh or veh and getElementModel(veh) ~= 453)then return end

    if(id)then
        local marker = source
        if(JOB.fill < 100)then
            JOB.fill = JOB.fill+math.random(2,5)

            destroyElement(JOB.markers[id])
            JOB.markers[id] = nil

            if(#JOB.markers < 8)then
                local playerPos = {getElementPosition(localPlayer)}
                local camera = {getCameraMatrix()}
                local rot = getPedCameraRotation(localPlayer)
                local rx,ry = getPointFromDistanceRotation_(camera[1], camera[2], math.random(60,100), rot, math.random(-90,90))
                local marker = createColSphere(rx, ry, playerPos[3], 5)
                setElementData(marker, "marker:job", #JOB.markers+1, false)
                JOB.markers[#JOB.markers+1] = marker
            end

            if(JOB.fill >= 15 and not JOB.depositMarker)then
                local random = math.random(1,#JOB.depositPoints)
                JOB.depositMarker = createMarker(JOB.depositPoints[random][1], JOB.depositPoints[random][2], JOB.depositPoints[random][3]-1, "cylinder", 7, 49, 140, 231, 255)
                setElementData(JOB.depositMarker, 'marker:icon', 'brak')
                JOB.depositBlip = createBlipAttachedTo(JOB.depositMarker, 41)
            end

            if(JOB.fill >= 100)then
                JOB.fill = 100
                noti:addNotification('Twój kuter jest już maksymalnie zapełniony.', 'info')
            end
        else
            noti:addNotification('Posiadasz już pełny kuter!', 'info')
        end
    end
end)

setDevelopmentMode(true)

addEventHandler("onClientMarkerHit", resourceRoot, function(hit, dim)
    if(hit ~= localPlayer or not dim)then return end

    if(source == JOB.marker)then -- marker gui
        if(JOB.gui)then
            removeEventHandler("onClientRender", root, JOB.onRender)
            showCursor(false)

            JOB.gui = false
        else
            addEventHandler("onClientRender", root, JOB.onRender)
            showCursor(true)

            JOB.gui = true
        end
    elseif(source == JOB.depositMarker)then
        local veh = getPedOccupiedVehicle(localPlayer)
        if(not veh or veh and getElementModel(veh) ~= 453)then return end
        
        local money = JOB.fill*10
        local nagroda = math.random(1, 3)
                    if tonumber(nagroda) == 2 then
                        local los2 = math.random(1,3)
                        if getElementData(localPlayer, "user:premium") then
                            los2 = math.random(3, 6)
                        end
                        local rep = getElementData(localPlayer, 'user:reputation') or 0
                        setElementData(localPlayer, "user:reputation", rep+los2)
                        noti:addNotification('Za dobrą prace otrzymujesz '..los2..' punktów respektu.', 'success')
                    end

        triggerServerEvent("rybak.money", resourceRoot, money)

        JOB.fill = 0

        destroyElement(JOB.depositMarker)
        destroyElement(JOB.depositBlip)

        JOB.depositMarker = false
    end
end)

if(getElementData(localPlayer, "user:job") == "rybak")then
    setElementData(localPlayer, "user:job", false, false)
end

-- useful

function getPointFromDistanceRotation(x, y, dist, angle)

    local a = math.rad(90 - angle);
 
    local dx = math.cos(a) * dist;
    local dy = math.sin(a) * dist;
 
    return x+dx, y+dy;
 
end

function findRotation( x1, y1, x2, y2 ) 
    local t = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
    return t < 0 and t + 360 or t
end

function getPointFromDistanceRotation_(x, y, dist, angler, mX)

    local a = math.rad(90-angler);
 
    local dx = (math.cos(a) * dist)-mX;
    local dy = (math.sin(a) * dist)
 
    return x+dx, y+dy;
end

--