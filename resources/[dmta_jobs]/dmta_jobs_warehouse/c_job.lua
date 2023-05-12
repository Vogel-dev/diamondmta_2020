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

JOB.marker = createMarker(2176.4187011719,-2258.8825683594,14.7734375-1, "cylinder", 1.2, 123, 182, 97)
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

JOB.markerObject = false
JOB.blipObject = false

JOB.markerPoint = false
JOB.blip = false

JOB.points = {
    {2141.623046875,-2250.4680175781,13.306007385254},
    {2146.5720214844,-2249.4172363281,13.301968574524},
    {2149.1188964844,-2261.4460449219,13.300958633423},
    {2142.7768554688,-2261.8815917969,13.296878814697},
    {2140.6557617188,-2263.9328613281,13.296831130981},
    {2154.392578125,-2259.9289550781,13.299437522888},
    {2161.1630859375,-2252.55078125,13.299227714539},
    {2153.7275390625,-2248.8852539063,13.29546546936},
    {2167.1467285156,-2255.6325683594,13.302358627319},
    {2155.1606445313,-2239.1867675781,13.30366897583},
    {2148.2849121094,-2247.2373046875,13.302452087402},
}

JOB.start = function()
    local random = math.random(1,#JOB.points)
    JOB.markerPoint = createMarker(JOB.points[random][1], JOB.points[random][2], JOB.points[random][3]-1, "cylinder", 1.2, 49, 140, 231, 255)
    setElementData(JOB.markerPoint, 'marker:icon', 'target')
    JOB.blip = createBlipAttachedTo(JOB.markerPoint, 41)
end

JOB.onRender = function()
    dxDrawRectangle(0, 0, 1920, 1080, tocolor(15, 15, 15, 200), false)
    dx:dxLibary_createWindow(714/zoom, 307/zoom, 493/zoom, 467/zoom)
    dx:dxLibary_text("Praca dorywcza - Magazynier", 724/zoom, 317/zoom, 1197/zoom, 373/zoom, tocolor(105, 188, 235, 255), 10, "default", "center", "center", false, false, false, false, false)
    dx:dxLibary_text("Jako magazynier twoim zadaniem jest roznoszenie skrzynek po półkach.", 738/zoom, 485/zoom, 1187/zoom, 569/zoom, tocolor(255, 255, 255, 255), 5, "default", "center", "center", false, true, false, false, false)
    dx:dxLibary_createButton(getElementData(localPlayer, "user:job") == "Magazynier" and "Zakończ" or "Rozpocznij", 748/zoom, 678/zoom, 202/zoom, 51/zoom, 3)
    dx:dxLibary_createButton("Anuluj", 985/zoom, 678/zoom, 202/zoom, 51/zoom, 3)

    onClick(748/zoom, 678/zoom, 202/zoom, 51/zoom, function()
        if(not getElementData(localPlayer, "user:job"))then
            noti:addNotification('Rozpocząłeś pracę jako magazynier.', 'info')

            JOB.markerObject = createMarker(2172.9519042969,-2256.298828125,13.3045940399173-1, "cylinder", 1.5, 0, 106, 78, 255)
            setElementData(JOB.markerObject, 'marker:icon', 'target')
            JOB.blipMarker = createBlipAttachedTo(JOB.markerObject, 41)

            setElementData(localPlayer, "user:job", "Magazynier", false)

            removeEventHandler("onClientRender", root, JOB.onRender)
            showCursor(false)

            JOB.gui = false

            toggleControl("jump", false)
            toggleControl("sprint", false)
            toggleControl("crouch", false)
        elseif(getElementData(localPlayer, "user:job") == "Magazynier")then
            setElementData(localPlayer, "user:job", false)

            removeEventHandler("onClientRender", root, JOB.onRender)
            showCursor(false)

            JOB.gui = false

            noti:addNotification('Zakończyłeś prace.', 'info')

            if(JOB.markerObject and isElement(JOB.markerObject))then
                destroyElement(JOB.markerObject)
                destroyElement(JOB.blipMarker)
            end

            if(JOB.markerPoint and isElement(JOB.markerPoint))then
                destroyElement(JOB.markerPoint)
                destroyElement(JOB.blip)
            end

            triggerServerEvent("magazyn.stop", resourceRoot)

            toggleControl("jump", true)
            toggleControl("sprint", true)
            toggleControl("crouch", true)
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

addEventHandler("onClientMarkerHit", resourceRoot, function(hit, dim)
    if getPedOccupiedVehicle(localPlayer) then return end
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
    elseif(source == JOB.markerObject)then -- get object
        noti:addNotification('Odnieś skrzynke na półke.', 'info')

        triggerServerEvent("magazyn.object", resourceRoot)

        destroyElement(JOB.markerObject)
        destroyElement(JOB.blipMarker)

        JOB.start()
    elseif(source == JOB.markerPoint)then -- marker point
        JOB.markerObject = createMarker(2172.9519042969,-2256.298828125,13.3045940399173-1, "cylinder", 1.5, 0, 106, 78, 255)
        setElementData(JOB.markerObject, 'marker:icon', 'target')
        JOB.blipMarker = createBlipAttachedTo(JOB.markerObject, 41)

        destroyElement(JOB.markerPoint)
        destroyElement(JOB.blip)

        local money = math.random(10,35)
        local nagroda = math.random(1, 5)
                    if tonumber(nagroda) == 5 then
                        local los2 = math.random(1,3)
                        if getElementData(localPlayer, "user:premium") then
                            los2 = math.random(3, 6)
                        end
                        local rep = getElementData(localPlayer, 'user:reputation') or 0
                        setElementData(localPlayer, "user:reputation", rep+los2)
                        noti:addNotification('Za dobrą prace otrzymujesz '..los2..' punktów respektu.', 'success')
                    end
       -- noti:addNotification('Za odłożenie paczki w prawidłowe miejsce otrzymujesz '..money..' $\nUdaj się po kolejna paczkę', 'success')

        triggerServerEvent("magazyn.stop", resourceRoot)

        triggerServerEvent("magazyn.money", resourceRoot, money)
    end
end)

if(getElementData(localPlayer, "user:job") == "Magazynier")then
    setElementData(localPlayer, "user:job", false)
    toggleControl("jump", true)
    toggleControl("sprint", true)
    toggleControl("crouch", true)
end