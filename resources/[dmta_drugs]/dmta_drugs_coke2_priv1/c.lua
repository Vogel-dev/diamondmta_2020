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

function coke2_priv1_pasek()
local rh = interpolateBetween(0, 0, 0, screenW * 0.2884, 0, 0, (getTickCount()-tick)/5000, "Linear")
dxLibary:dxLibary_createWindow(653/scale, 20/scale, 614/scale, 54/scale)
dxDrawRectangle(653/scale, 20/scale, rh, 54/scale, tocolor(105, 188, 235, 33), false)
dxLibary:dxLibary_text('Trwa przerabianie liści kokainy...', 653/scale+1, 19/scale+1, 1267/scale+1, 74/scale+1, tocolor(0, 0, 0, 255), 8, 'center', 'center', 'center', false, false, false, false, false)
dxLibary:dxLibary_text('Trwa przerabianie liści kokainy...', 653/scale, 19/scale, 1267/scale, 74/scale, tocolor(150, 150, 150, 255), 8, 'center', 'center', 'center', false, false, false, false, false)
    end

local coke2_priv1_start = createMarker(-45.755683898926,1403.8934326172,1084.4370117188-0.95, 'cylinder', 1.2, 255, 255, 255)
setElementInterior(coke2_priv1_start, 8)
setElementDimension(coke2_priv1_start, 1072)
setElementData(coke2_priv1_start, 'marker:icon', 'drugs')

local coke2_priv1_miejsca = {
    {-50.448574066162,1410.3579101563,1084.4296875},
    {-50.448574066162,1410.3579101563,1084.4296875},
    {-50.448574066162,1410.3579101563,1084.4296875},
}

addEventHandler("onClientMarkerHit", pracaM, function(el, md)
    if not md or getElementType(el) ~= "player" then return end
    if el ~= localPlayer then return end
    outputChatBox("#ff0000● #ffffffNie możesz tego wykonać będąc w pojeździe.", 255, 255, 255, true)
end)

bindKey("e", "down", function()
    if not isElementWithinMarker(localPlayer, coke2_priv1_start) then return end
    if getElementDimension(localPlayer) ~= 1072 then return end
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
        local coke2_priv1_losuj = math.random(2, #coke2_priv1_miejsca)
        setElementData(localPlayer, "user:illegal", true)
        outputChatBox("#69bceb● #ffffffUdaj się przerobić liście kokainy na czystą kokaine.", 255, 255, 255, true)
        toggleControl("sprint", false) 
        toggleControl("jump", false)
        
        local coke2_priv1_cel = createMarker(coke2_priv1_miejsca[coke2_priv1_losuj][1], coke2_priv1_miejsca[coke2_priv1_losuj][2], coke2_priv1_miejsca[coke2_priv1_losuj][3]-0.95, "cylinder", 1.0, 255, 255, 255, 90)
        local coke2_priv1_blip = createBlipAttachedTo(coke2_priv1_cel, 41)
        setElementInterior(coke2_priv1_cel, 8)
        setElementDimension(coke2_priv1_cel, 1072)
        setElementData(coke2_priv1_cel, 'marker:icon', 'drugs')

        addEventHandler("onClientMarkerHit", coke2_priv1_cel, function(el, md)
            if not md or getElementType(el) ~= "player" then return end
            if el ~= localPlayer then return end

            if getPedOccupiedVehicle(el) then
                outputChatBox("#ff0000● #ffffffNie możesz tego wykonać będąc w pojeździe.", 255, 255, 255, true)
                return
            end
            destroyElement(coke2_priv1_blip)
            setElementFrozen(el, true)
            triggerServerEvent ("coke2_priv1:animacja", localPlayer)
			addEventHandler("onClientRender",root,coke2_priv1_pasek) 
			tick = getTickCount()
            setTimer(function()
                setElementFrozen(el, false)
                destroyElement(coke2_priv1_cel)
                triggerServerEvent ("coke2_priv1:zanimacja", localPlayer)
                setPedAnimation(localPlayer, false)
                toggleControl("sprint", true) 
                toggleControl("jump", true)
                setElementData(el, "user:illegal", false)
                removeEventHandler("onClientRender",root,coke2_priv1_pasek)
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