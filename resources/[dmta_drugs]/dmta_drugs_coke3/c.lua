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

function coke3_pasek()
local rh = interpolateBetween(0, 0, 0, screenW * 0.2884, 0, 0, (getTickCount()-tick)/2000, "Linear")
dxLibary:dxLibary_createWindow(653/scale, 20/scale, 614/scale, 54/scale)
dxDrawRectangle(653/scale, 20/scale, rh, 54/scale, tocolor(105, 188, 235, 33), false)
dxLibary:dxLibary_text('Trwa sprzedawanie paczki kokainy...', 653/scale+1, 19/scale+1, 1267/scale+1, 74/scale+1, tocolor(0, 0, 0, 255), 8, 'center', 'center', 'center', false, false, false, false, false)
dxLibary:dxLibary_text('Trwa sprzedawanie paczki kokainy...', 653/scale, 19/scale, 1267/scale, 74/scale, tocolor(150, 150, 150, 255), 8, 'center', 'center', 'center', false, false, false, false, false)
    end

local coke3_start = createMarker(2606.45703125,2806.5356445313,10.8203125-0.95, "cylinder", 1.3, 255, 255, 255)
setElementData(coke3_start, 'marker:icon', 'drugs')

local coke3_miejsca = {
    {2606.2666015625,2810.0939941406,10.8203125},
    {2605.4260253906,2811.5234375,10.8203125},
    {2612.0422363281,2809.2062988281,10.8203125},
    {2612.0720214844,2807.927734375,10.8203125},
    {2611.9025878906,2806.4248046875,10.8203125},
}

addEventHandler("onClientMarkerHit", pracaM, function(el, md)
    if not md or getElementType(el) ~= "player" then return end
    if el ~= localPlayer then return end
    outputChatBox("#ff0000● #ffffffNie możesz tego wykonać będąc w pojeździe.", 255, 255, 255, true)
end)

bindKey("e", "down", function()
    if not isElementWithinMarker(localPlayer, coke3_start) then return end
    -- if getElementData(localPlayer, "user:level") > 29 then
    -- else
        -- outputChatBox("#ff0000● #ffffffNie posiadasz 30 poziomu postaci.", 255, 255, 255, true)
        -- return end
        if getElementData(localPlayer, "user:coke2") < 1 then 
            outputChatBox("#ff0000● #ffffffNie posiadasz więcej towaru do sprzedania.", 255, 255, 255, true)
                return end
    if not getElementData(localPlayer, "user:illegal") then
        local coke3_losuj = math.random(2, #coke3_miejsca)
        setElementData(localPlayer, "user:illegal", true)
        outputChatBox("#69bceb● #ffffffUdaj się sprzedać paczkę kokainy.", 255, 255, 255, true)
        toggleControl("sprint", false) 
        toggleControl("jump", false)
        
        local coke3_cel = createMarker(coke3_miejsca[coke3_losuj][1], coke3_miejsca[coke3_losuj][2], coke3_miejsca[coke3_losuj][3]-0.95, "cylinder", 1.0, 255, 255, 255, 90)
        local coke3_blip = createBlipAttachedTo(coke3_cel, 41)
        setElementData(coke3_cel, 'marker:icon', 'drugs')

        addEventHandler("onClientMarkerHit", coke3_cel, function(el, md)
            if not md or getElementType(el) ~= "player" then return end
            if el ~= localPlayer then return end

            if getPedOccupiedVehicle(el) then
                outputChatBox("#ff0000● #ffffffNie możesz tego wykonać będąc w pojeździe.", 255, 255, 255, true)
                return
            end
            destroyElement(coke3_blip)
            setElementFrozen(el, true)
            triggerServerEvent ("coke3:animacja", localPlayer)
			addEventHandler("onClientRender",root,coke3_pasek) 
			tick = getTickCount()
            setTimer(function()
                setElementFrozen(el, false)
                destroyElement(coke3_cel)
                triggerServerEvent ("coke3:zanimacja", localPlayer)
                setPedAnimation(localPlayer, false)
                toggleControl("sprint", true) 
                toggleControl("jump", true)
                setElementData(el, "user:illegal", false)
                removeEventHandler("onClientRender",root,coke3_pasek)
                triggerServerEvent("daj:coke3", localPlayer)
                setElementData(localPlayer, "user:coke2", getElementData(localPlayer, "user:coke2")-1)
                setElementData(localPlayer, "user:sold_drugs", getElementData(localPlayer, "user:sold_drugs")+1)
                 setElementData(localPlayer, 'user:roleplay', 1)
			end, 2000, 1)
        end)
    else
    end
end)