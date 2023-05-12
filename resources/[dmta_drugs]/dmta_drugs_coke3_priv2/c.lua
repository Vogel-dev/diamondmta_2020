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

function coke3_priv2_pasek()
local rh = interpolateBetween(0, 0, 0, screenW * 0.2884, 0, 0, (getTickCount()-tick)/2000, "Linear")
dxLibary:dxLibary_createWindow(653/scale, 20/scale, 614/scale, 54/scale)
dxDrawRectangle(653/scale, 20/scale, rh, 54/scale, tocolor(105, 188, 235, 33), false)
dxLibary:dxLibary_text('Trwa sprzedawanie paczki kokainy...', 653/scale+1, 19/scale+1, 1267/scale+1, 74/scale+1, tocolor(0, 0, 0, 255), 8, 'center', 'center', 'center', false, false, false, false, false)
dxLibary:dxLibary_text('Trwa sprzedawanie paczki kokainy...', 653/scale, 19/scale, 1267/scale, 74/scale, tocolor(150, 150, 150, 255), 8, 'center', 'center', 'center', false, false, false, false, false)
    end

local coke3_priv2_start = createMarker(-34.986156463623,1408.0369873047,1084.4296875-0.95, "cylinder", 1.3, 255, 255, 255)
setElementInterior(coke3_priv2_start, 8)
setElementDimension(coke3_priv2_start, 1073)
setElementData(coke3_priv2_start, 'marker:icon', 'drugs')

local coke3_priv2_miejsca = {
    {-39.235260009766,1410.111328125,1084.4370117188},
    {-39.235260009766,1410.111328125,1084.4370117188},
    {-39.235260009766,1410.111328125,1084.4370117188},
}

addEventHandler("onClientMarkerHit", pracaM, function(el, md)
    if not md or getElementType(el) ~= "player" then return end
    if el ~= localPlayer then return end
    outputChatBox("#ff0000● #ffffffNie możesz tego wykonać będąc w pojeździe.", 255, 255, 255, true)
end)

bindKey("e", "down", function()
    if not isElementWithinMarker(localPlayer, coke3_priv2_start) then return end
    if getElementDimension(localPlayer) ~= 1073 then return end
    -- if getElementData(localPlayer, "user:level") > 29 then
    -- else
        -- outputChatBox("#ff0000● #ffffffNie posiadasz 30 poziomu postaci.", 255, 255, 255, true)
        -- return end
        if getElementData(localPlayer, "user:coke2") < 1 then 
            outputChatBox("#ff0000● #ffffffNie posiadasz więcej towaru do sprzedania.", 255, 255, 255, true)
                return end
    if not getElementData(localPlayer, "user:illegal") then
        local coke3_priv2_losuj = math.random(2, #coke3_priv2_miejsca)
        setElementData(localPlayer, "user:illegal", true)
        outputChatBox("#69bceb● #ffffffUdaj się sprzedać paczkę kokainy.", 255, 255, 255, true)
        toggleControl("sprint", false) 
        toggleControl("jump", false)
        
        local coke3_priv2_cel = createMarker(coke3_priv2_miejsca[coke3_priv2_losuj][1], coke3_priv2_miejsca[coke3_priv2_losuj][2], coke3_priv2_miejsca[coke3_priv2_losuj][3]-0.95, "cylinder", 1.0, 255, 255, 255, 90)
        local coke3_priv2_blip = createBlipAttachedTo(coke3_priv2_cel, 41)
        setElementData(coke3_priv2_cel, 'marker:icon', 'drugs')
        setElementInterior(coke3_priv2_cel, 8)
        setElementDimension(coke3_priv2_cel, 1073)

        addEventHandler("onClientMarkerHit", coke3_priv2_cel, function(el, md)
            if not md or getElementType(el) ~= "player" then return end
            if el ~= localPlayer then return end

            if getPedOccupiedVehicle(el) then
                outputChatBox("#ff0000● #ffffffNie możesz tego wykonać będąc w pojeździe.", 255, 255, 255, true)
                return
            end
            destroyElement(coke3_priv2_blip)
            setElementFrozen(el, true)
            triggerServerEvent ("coke3_priv2:animacja", localPlayer)
			addEventHandler("onClientRender",root,coke3_priv2_pasek) 
			tick = getTickCount()
            setTimer(function()
                setElementFrozen(el, false)
                destroyElement(coke3_priv2_cel)
                triggerServerEvent ("coke3_priv2:zanimacja", localPlayer)
                setPedAnimation(localPlayer, false)
                toggleControl("sprint", true) 
                toggleControl("jump", true)
                setElementData(el, "user:illegal", false)
                removeEventHandler("onClientRender",root,coke3_priv2_pasek)
                triggerServerEvent("daj:coke3_priv2", localPlayer)
                setElementData(localPlayer, "user:coke2", getElementData(localPlayer, "user:coke2")-1)
                setElementData(localPlayer, "user:sold_drugs", getElementData(localPlayer, "user:sold_drugs")+1)
                 setElementData(localPlayer, 'user:roleplay', 1)
			end, 2000, 1)
        end)
    else
    end
end)