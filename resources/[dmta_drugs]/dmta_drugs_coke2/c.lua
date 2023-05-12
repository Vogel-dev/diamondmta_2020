--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local screenW, screenH = guiGetScreenSize()
local sw,sh = guiGetScreenSize()
local baseX = 1920
local scale = 1
local minScale = 2
if sw < baseX then
    scale = math.min(minScale, baseX/sw)
end

local dxLibary = exports['dxLibary']

function coke2_pasek()
local rh = interpolateBetween(0, 0, 0, screenW * 0.2884, 0, 0, (getTickCount()-tick)/5000, "Linear")
dxLibary:dxLibary_createWindow(653/scale, 20/scale, 614/scale, 54/scale)
dxDrawRectangle(653/scale, 20/scale, rh, 54/scale, tocolor(105, 188, 235, 33), false)
dxLibary:dxLibary_text('Trwa przerabianie liści kokainy...', 653/scale+1, 19/scale+1, 1267/scale+1, 74/scale+1, tocolor(0, 0, 0, 255), 8, 'center', 'center', 'center', false, false, false, false, false)
dxLibary:dxLibary_text('Trwa przerabianie liści kokainy...', 653/scale, 19/scale, 1267/scale, 74/scale, tocolor(150, 150, 150, 255), 8, 'center', 'center', 'center', false, false, false, false, false)
    end

local coke2_start = createMarker(2576.7819824219,-1636.6796875,17158.857421875-0.95, 'cylinder', 1.2, 255, 255, 255)
setElementInterior(coke2_start, 1)
setElementData(coke2_start, 'marker:icon', 'drugs')

local coke2_miejsca = {
    {2577.8676757813,-1640.2689208984,17158.857421875},
    {2577.0798339844,-1644.4979248047,17158.857421875},
    {2577.1149902344,-1643.5037841797,17158.857421875},
    {2577.1154785156,-1645.6733398438,17158.857421875},
    {2577.1071777344,-1638.0715332031,17158.857421875},
    {2576.9519042969,-1635.1146240234,17158.857421875},
    {2567.4892578125,-1636.4274902344,17158.857421875},
    {2565.5673828125,-1636.30859375,17158.857421875},
    {2563.9370117188,-1635.4780273438,17158.857421875},
    {2563.9328613281,-1637.0942382813,17158.857421875},
    {2563.1220703125,-1643.3151855469,17158.857421875},
    {2564.0395507813,-1643.2274169922,17158.857421875},
    {2565.2778320313,-1643.6779785156,17159.12109375},
    {2567.7004394531,-1642.8452148438,17158.857421875},
}

addEventHandler("onClientMarkerHit", pracaM, function(el, md)
    if not md or getElementType(el) ~= "player" then return end
    if el ~= localPlayer then return end
    outputChatBox("#ff0000● #ffffffNie możesz tego wykonać będąc w pojeździe.", 255, 255, 255, true)
end)

bindKey("e", "down", function()
    if not isElementWithinMarker(localPlayer, coke2_start) then return end
    -- if getElementData(localPlayer, "user:level") > 29 then
    -- else
        -- outputChatBox("#ff0000● #ffffffNie posiadasz 30 poziomu postaci.", 255, 255, 255, true)
        -- return end
        if getElementData(localPlayer, "user:coke1") < 1 then 
            outputChatBox("#ff0000● #ffffffNie posiadasz więcej liści kokainy do przerobienia.", 255, 255, 255, true)
                return end
        if getElementData(localPlayer, "user:coke2") > 99 then 
            outputChatBox("#ff0000● #ffffffPosiadasz przy sobie za dużo towaru.", 255, 255, 255, true)
            return end
    if not getElementData(localPlayer, "user:illegal") then
        local coke2_losuj = math.random(2, #coke2_miejsca)
        setElementData(localPlayer, "user:illegal", true)
        outputChatBox("#69bceb● #ffffffUdaj się przerobić liście kokainy na czystą kokaine.", 255, 255, 255, true)
        toggleControl("sprint", false) 
        toggleControl("jump", false)
        
        local coke2_cel = createMarker(coke2_miejsca[coke2_losuj][1], coke2_miejsca[coke2_losuj][2], coke2_miejsca[coke2_losuj][3]-0.95, "cylinder", 1.0, 255, 255, 255, 90)
        local coke2_blip = createBlipAttachedTo(coke2_cel, 41)
        setElementInterior(coke2_cel, 1)
        setElementData(coke2_cel, 'marker:icon', 'drugs')

        addEventHandler("onClientMarkerHit", coke2_cel, function(el, md)
            if not md or getElementType(el) ~= "player" then return end
            if el ~= localPlayer then return end

            if getPedOccupiedVehicle(el) then
                outputChatBox("#ff0000● #ffffffNie możesz tego wykonać będąc w pojeździe.", 255, 255, 255, true)
                return
            end
            destroyElement(coke2_blip)
            setElementFrozen(el, true)
            triggerServerEvent ("coke2:animacja", localPlayer)
			addEventHandler("onClientRender",root,coke2_pasek) 
			tick = getTickCount()
            setTimer(function()
                setElementFrozen(el, false)
                destroyElement(coke2_cel)
                triggerServerEvent ("coke2:zanimacja", localPlayer)
                setPedAnimation(localPlayer, false)
                toggleControl("sprint", true) 
                toggleControl("jump", true)
                setElementData(el, "user:illegal", false)
                removeEventHandler("onClientRender",root,coke2_pasek)
                local dodano = math.random(2,4)
                setElementData(localPlayer, "user:coke2", getElementData(localPlayer, "user:coke2")+dodano)
                setElementData(localPlayer, "user:coke1", getElementData(localPlayer, "user:coke1")-1)
                 setElementData(localPlayer, 'user:roleplay', 1)
                outputChatBox("#00ff00● #ffffffPomyślnie przerobiłeś jeden liść kokainy na #969696"..dodano.." #ffffffpaczki kokainy.", 255, 255, 255, true)
			end, 5000, 1)
        end)
    else
    end
end)