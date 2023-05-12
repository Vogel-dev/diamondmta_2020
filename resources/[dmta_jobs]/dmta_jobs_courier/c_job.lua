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

JOB.marker = createMarker(2773.2233886719,-2423.4858398438,13.73722038269-1, "cylinder", 1.3, 123, 182, 97)
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
    {2770.6809082031,-2413.3630371094,13.727556800842},
    {2770.6809082031,-2413.3630371094,13.727556800842},
}

JOB.pointsSkrzynki = {
{2782.6481933594,-2409.6955566406,13.734919166565},
{2782.6174316406,-2426.3525390625,13.734926795959},
{2790.8259277344,-2424.8444824219,13.732922172546},
{2784.9592285156,-2424.6606445313,13.734353637695},
{2790.8259277344,-2412.546875,13.732922172546},
{2790.8259277344,-2409.6865234375,13.732922172546},
{2796.373046875,-2412.5639648438,13.731567001343},
{2796.3862304688,-2409.4645996094,13.73156414032},
{2798.6672363281,-2409.396484375,13.731007194519},
{2793.08984375,-2424.4721679688,13.732369041443},
{2793.095703125,-2427.3608398438,13.732368087769},
}

JOB.objects = 3

JOB.start = function()
    local random = math.random(1,#JOB.points)
    JOB.markerPoint = createMarker(JOB.points[random][1], JOB.points[random][2], JOB.points[random][3]-1, "cylinder", 1.2, 204, 0, 0, 255)
    setElementData(JOB.markerPoint, 'marker:icon', 'target')
    JOB.blip = createBlipAttachedTo(JOB.markerPoint, 41)
end

JOB.clients = {
{1410.6804199219,-1620.6235351563,13.739485931396, 17},
{2521.5090332031,-1483.3891601563,24.103944396973,124.96950531006},
{559.58422851563,-1290.3311767578,17.248237609863,0.99603277444839},
{997.58264160156,-929.95007324219,42.1796875,147.44569396973},
{1144.3310546875,-1377.7139892578,13.803495407104,180.97259521484},
{1273.6727294922,-1363.9904785156,13.45392036438,212.3060760498},
{1714.580078125,-1796.9899902344,13.509592056274,355.01916503906},
{1758.7585449219,-1661.8094482422,13.555478096008,90.081703186035},
{1930.6164550781,-1785.19921875,13.546875,266.00842285156},
{1800.5045166016,-2104.5563964844,13.546875,179.21421813965},
{2822.3981933594,-1610.9221191406,11.087944030762,260.68176269531},
{2023.3393554688,-1127.9020996094,24.849618911743,179.86441040039},
{2090.46875,-1145.0235595703,25.586040496826,91.190338134766},
{2071.7646484375,-1700.7941894531,13.554683685303,268.85208129883},
{2473.1408691406,-1520.8830566406,24.217721939087,269.50219726563},
{2379.6977539063,-1365.0767822266,24,94.97388458252},
{2415.9501953125,-1228.6368408203,24.556360244751,173.76615905762},
{1483.5745849609,-1559.6805419922,13.549827575684,310.21249389648},
{1494.1756591797,-1513.67578125,13.540714263916,171.40451049805},
{960.90173339844,-1312.7064208984,13.528570175171,188.3716583252},
{977.78411865234,-1334.0905761719,13.5352602005,358.80310058594},
{1042.2863769531,-1337.4533691406,13.732515335083,319.94952392578},
{1069.5867919922,-1330.9643554688,13.554672241211,89.670761108398},
{1047.0933837891,-1287.1027832031,13.546875,282.05923461914},
{1069.6843261719,-1259.376953125,14.485057830811,120.69105529785},
{1094.9918212891,-1273.8234863281,13.546875,180.53826904297},
}

JOB.clientMarker = false
JOB.clientBlip = false
JOB.clientPed = false

JOB.vehicleMarker = false

JOB.onRender = function()
    dxDrawRectangle(0, 0, 1920, 1080, tocolor(15, 15, 15, 200), false)
    dx:dxLibary_createWindow(714/zoom, 307/zoom, 493/zoom, 467/zoom)
    dx:dxLibary_text("Praca dorywcza -  Kurier", 724/zoom, 317/zoom, 1197/zoom, 373/zoom, tocolor(105, 188, 235, 255), 10, "default", "center", "center", false, false, false, false, false)
    dx:dxLibary_text("Do pracy jako kurier wymagane jest\n#69bcebprawo jazdy kat.C\n\n#ffffffJako kurier twoim zadaniem jest rozwożenie\npaczek po klientach w Los Santos.", 738/zoom, 485/zoom, 1187/zoom, 569/zoom, tocolor(255, 255, 255, 255), 5, "default", "center", "center", false, true, false, true, false)
    dx:dxLibary_createButton(getElementData(localPlayer, "user:job") == "kurier" and "Zakończ" or "Rozpocznij", 748/zoom, 678/zoom, 202/zoom, 51/zoom, 3)
    dx:dxLibary_createButton("Anuluj", 985/zoom, 678/zoom, 202/zoom, 51/zoom, 3)

    onClick(748/zoom, 678/zoom, 202/zoom, 51/zoom, function()
        if getElementData(localPlayer, 'user:prawkoC') ~= 1 then noti:addNotification('Nie posiadasz prawa jazdy kat.C.', 'error')
            return end
            if getElementData(localPlayer, 'block:prawko', true) then noti:addNotification('Posiadasz zawieszone prawo jazdy.', 'error')
            return end
        if(not getElementData(localPlayer, "user:job"))then
            noti:addNotification('Rozpocząłeś pracę jako kurier.', 'info')

            local random = math.random(1,#JOB.pointsSkrzynki)
            JOB.markerObject = createMarker(JOB.pointsSkrzynki[random][1], JOB.pointsSkrzynki[random][2], JOB.pointsSkrzynki[random][3]-1, "cylinder", 1.2, 204, 0, 0, 255)
            --JOB.markerObject = createMarker(2796.3891601563,-2409.9045410156,13.731563186646-1, "cylinder", 1.5, 105, 188, 235, 255)
            setElementData(JOB.markerObject, 'marker:icon', 'target')
            JOB.blipMarker = createBlipAttachedTo(JOB.markerObject, 41)

            setElementData(localPlayer, "user:job", "kurier", false)

            removeEventHandler("onClientRender", root, JOB.onRender)
            showCursor(false)

            JOB.gui = false

            JOB.objects = 3

            toggleControl("jump", false)
            toggleControl("sprint", false)
            toggleControl("crouch", false)
        elseif(getElementData(localPlayer, "user:job") == "kurier")then
            setElementData(localPlayer, "user:job", false, false)

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

            if(JOB.clientMarker and isElement(JOB.clientMarker))then
                destroyElement(JOB.clientMarker)
                destroyElement(JOB.clientBlip)
                destroyElement(JOB.clientPed)
            end

            if(JOB.vehicleMarker and isElement(JOB.vehicleMarker))then
                destroyElement(JOB.vehicleMarker)
            end

            triggerServerEvent("kurier.stop", resourceRoot)

            triggerServerEvent("kurier.destroyVehicle", resourceRoot)

            toggleControl("jump", true)
            toggleControl("sprint", true)
            toggleControl("crouch", true)
        else
            noti:addNotification('Najpierw zakończ pracę!', 'info')
        end
    end)

    onClick(985/zoom, 678/zoom, 202/zoom, 51/zoom, function()
        removeEventHandler("onClientRender", root, JOB.onRender)
        showCursor(false)

        JOB.gui = false
    end)
end

JOB.haveObject = false

addEvent("kurier.createAttached", true)
addEventHandler("kurier.createAttached", resourceRoot, function(vehicle)
    JOB.vehicleMarker = createMarker(0, 0, 0+0.2, "cylinder", 1.5, 105, 188, 235, 255)
    setElementData(JOB.vehicleMarker, 'marker:icon', 'brak')
    setElementData(JOB.vehicleMarker, "visibled", true, false)
    attachElements(JOB.vehicleMarker, vehicle, 0, -4, -1)
end)

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
    elseif(source == JOB.markerObject)then -- get object
        noti:addNotification('Odnieś skrzynke do pojazdu.', 'info')

        triggerServerEvent("kurier.object", resourceRoot)

        destroyElement(JOB.markerObject)
        destroyElement(JOB.blipMarker)

        JOB.start()
    elseif(source == JOB.markerPoint)then -- marker point
        JOB.objects = JOB.objects-1
        if(JOB.objects == 0)then
            destroyElement(JOB.markerPoint)
            destroyElement(JOB.blip)

            triggerServerEvent("kurier.stop", resourceRoot)

            noti:addNotification('Dostarcz paczki do klienta.', 'info')

            triggerServerEvent("kurier.vehicle", resourceRoot)

            local random = math.random(1,#JOB.clients)
            JOB.clientMarker = createMarker(JOB.clients[random][1], JOB.clients[random][2], JOB.clients[random][3]-1, "cylinder", 1.5, 105, 188, 235, 255)
            setElementData(JOB.clientMarker, 'marker:icon', 'brak')
            JOB.clientBlip = createBlipAttachedTo(JOB.clientMarker, 41)
            JOB.clientPed = createPed(math.random(100,200), JOB.clients[random][1], JOB.clients[random][2], JOB.clients[random][3])
            setPedRotation(JOB.clientPed, JOB.clients[random][4])
            if(not JOB.clientPed)then
                JOB.clientPed = createPed(111, JOB.clients[random][1], JOB.clients[random][2], JOB.clients[random][3])
            end

            JOB.objects = 3
        else
            local random = math.random(1,#JOB.pointsSkrzynki)
            JOB.markerObject = createMarker(JOB.pointsSkrzynki[random][1], JOB.pointsSkrzynki[random][2], JOB.pointsSkrzynki[random][3]-1, "cylinder", 1.2, 204, 0, 0, 255)
            --JOB.markerObject = createMarker(2796.3891601563,-2409.9045410156,13.731563186646-1, "cylinder", 1.5, 105, 188, 235, 255)
            setElementData(JOB.markerObject, 'marker:icon', 'target')
            JOB.blipMarker = createBlipAttachedTo(JOB.markerObject, 41)

            destroyElement(JOB.markerPoint)
            destroyElement(JOB.blip)

            noti:addNotification('Pozostało '..JOB.objects..' paczek do załadowania.', 'info')

            triggerServerEvent("kurier.stop", resourceRoot)
        end
    elseif(source == JOB.vehicleMarker)then -- vehicle marker
        if(JOB.haveObject)then
            JOB.haveObject = false

            triggerServerEvent("kurier.stop", resourceRoot)
        else
            JOB.haveObject = true

            triggerServerEvent("kurier.object", resourceRoot)

            noti:addNotification('Zanieś paczke do klienta.', 'info')
        end
    elseif(source == JOB.clientMarker)then -- client marker
        if(JOB.haveObject)then
            JOB.objects = JOB.objects-1
            if(JOB.objects == 0)then
                local money = math.random(400,500)
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
                triggerServerEvent("kurier.money", resourceRoot, money)

                JOB.haveObject = false

                triggerServerEvent("kurier.stop", resourceRoot)

                destroyElement(JOB.clientMarker)
                destroyElement(JOB.clientBlip)
                destroyElement(JOB.clientPed)

                triggerServerEvent("kurier.destroyVehicle", resourceRoot)

                setTimer(function()
                    setElementPosition(localPlayer, 2773.8317871094,-2427.1040039063,13.737071609497)
                end, 500, 1)

                toggleControl("jump", true)
                toggleControl("sprint", true)
                toggleControl("crouch", true)

                if(JOB.vehicleMarker and isElement(JOB.vehicleMarker))then
                    destroyElement(JOB.vehicleMarker)
                end

                setElementData(localPlayer, "user:job", false, false)
            else
                noti:addNotification('Pozostało do zaniesienia: '..JOB.objects..' paczek.', 'info')

                JOB.haveObject = false

                triggerServerEvent("kurier.stop", resourceRoot)
            end
        else
            noti:addNotification('Nie posiadasz przy sobie paczki!', 'error')
        end
    end
end)

addEventHandler("onClientVehicleEnter", resourceRoot, function(player, seat)
    if(player ~= localPlayer or seat ~= 0)then return end

    if(JOB.vehicleMarker and isElement(JOB.vehicleMarker))then
        setElementData(JOB.vehicleMarker, "visibled", true, false)
    end
end)

addEventHandler("onClientVehicleExit", resourceRoot, function(player, seat)
    if(player ~= localPlayer or seat ~= 0)then return end

    if(JOB.vehicleMarker and isElement(JOB.vehicleMarker))then
        setElementData(JOB.vehicleMarker, "visibled", false, false)
    end
end)

if(getElementData(localPlayer, "user:job") == "kurier")then
    setElementData(localPlayer, "user:job", false, false)
    toggleControl("jump", true)
    toggleControl("sprint", true)
    toggleControl("crouch", true)
end