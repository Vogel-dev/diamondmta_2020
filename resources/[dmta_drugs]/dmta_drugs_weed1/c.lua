--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local weed1_blip = createBlip(-570.24005126953,-1500.4215087891,9.4737815856934, 16)
setBlipVisibleDistance(weed1_blip, 300)
local screenW, screenH = guiGetScreenSize()
local sw,sh = guiGetScreenSize()
local baseX = 1920
local scale = 1
local minScale = 2
if sw < baseX then
    scale = math.min(minScale, baseX/sw)
end

local dxLibary = exports['dxLibary']

function weed1_pasek()
local rh = interpolateBetween(0, 0, 0, screenW * 0.2884, 0, 0, (getTickCount()-tick)/10000, "Linear")
dxLibary:dxLibary_createWindow(653/scale, 20/scale, 614/scale, 54/scale)
dxDrawRectangle(653/scale, 20/scale, rh, 54/scale, tocolor(105, 188, 235, 33), false)
dxLibary:dxLibary_text('Trwa zbieranie suszu konopnego...', 653/scale+1, 19/scale+1, 1267/scale+1, 74/scale+1, tocolor(0, 0, 0, 255), 8, 'center', 'center', 'center', false, false, false, false, false)
dxLibary:dxLibary_text('Trwa zbieranie suszu konopnego...', 653/scale, 19/scale, 1267/scale, 74/scale, tocolor(150, 150, 150, 255), 8, 'center', 'center', 'center', false, false, false, false, false)
    end

local weed1_start = createMarker(-570.24005126953,-1500.4215087891,9.4737815856934-0.95, "cylinder", 1.3, 0, 128, 0)
setElementData(weed1_start, 'marker:icon', 'weed')

local weed1_miejsca = {
    {-566.47741699219,-1501.8111572266,9.327995300293},
    {-564.19079589844,-1500.3455810547,9.2433500289917},
    {-562.40362548828,-1499.2537841797,9.1771011352539},
    {-561.91302490234,-1497.3587646484,9.1616439819336},
    {-559.357421875,-1496.8135986328,9.2187767028809},
    {-557.77862548828,-1496.7788085938,9.2723150253296},
    {-556.29095458984,-1501.517578125,9.2294778823853},
    {-557.55993652344,-1503.3562011719,9.1728744506836},
    {-559.90246582031,-1503.5583496094,9.1561365127563},
    {-560.49792480469,-1505.0219726563,9.1508474349976},
    {-563.05364990234,-1507.0841064453,9.1884841918945},
}

addEventHandler("onClientMarkerHit", pracaM, function(el, md)
    if not md or getElementType(el) ~= "player" then return end
    if el ~= localPlayer then return end
    outputChatBox("#ff0000● #ffffffNie możesz tego wykonać będąc w pojeździe.", 255, 255, 255, true)
end)

bindKey("e", "down", function()
    if not isElementWithinMarker(localPlayer, weed1_start) then return end
    -- if getElementData(localPlayer, "user:level") > 9 then
    -- else
        -- outputChatBox("#ff0000● #ffffffNie posiadasz 10 poziomu postaci.", 255, 255, 255, true)
        -- return end
        if getElementData(localPlayer, "user:weed1") > 24 then 
            outputChatBox("#ff0000● #ffffffPosiadasz przy sobie za dużo towaru.", 255, 255, 255, true)
            return end
    if not getElementData(localPlayer, "user:illegal") then
        local weed1_losuj = math.random(2, #weed1_miejsca)
        setElementData(localPlayer, "user:illegal", true)
        outputChatBox("#69bceb● #ffffffUdaj się zerwać liść konopii.", 255, 255, 255, true)
        toggleControl("sprint", false) 
        toggleControl("jump", false)
        
        local weed1_cel = createMarker(weed1_miejsca[weed1_losuj][1], weed1_miejsca[weed1_losuj][2], weed1_miejsca[weed1_losuj][3]-0.95, "cylinder", 1.0, 0, 128, 0, 90)
        local weed1_blip = createBlipAttachedTo(weed1_cel, 41)
        setElementData(weed1_cel, 'marker:icon', 'weed')

        addEventHandler("onClientMarkerHit", weed1_cel, function(el, md)
            if not md or getElementType(el) ~= "player" then return end
            if el ~= localPlayer then return end

            if getPedOccupiedVehicle(el) then
                outputChatBox("#ff0000● #ffffffNie możesz tego wykonać będąc w pojeździe.", 255, 255, 255, true)
                return
            end
            destroyElement(weed1_blip)
            setElementFrozen(el, true)
            triggerServerEvent ("weed1:animacja", localPlayer)
			addEventHandler("onClientRender",root,weed1_pasek) 
			tick = getTickCount()
            setTimer(function()
                setElementFrozen(el, false)
                destroyElement(weed1_cel)
                triggerServerEvent ("weed1:zanimacja", localPlayer)
                setPedAnimation(localPlayer, false)
                toggleControl("sprint", true) 
                toggleControl("jump", true)
                setElementData(el, "user:illegal", false)
                removeEventHandler("onClientRender",root,weed1_pasek)
                local dodano = math.random(1,1)
                 setElementData(localPlayer, "user:weed1", getElementData(localPlayer, "user:weed1")+dodano)
                 setElementData(localPlayer, 'user:roleplay', 1)
                outputChatBox("#00ff00● #ffffffPomyślnie zerwałeś jeden liść konopii.", 255, 255, 255, true)
			end, 10000, 1)
        end)
    else
    end
end)