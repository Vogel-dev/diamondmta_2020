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

function meth3_pasek()
local rh = interpolateBetween(0, 0, 0, screenW * 0.2884, 0, 0, (getTickCount()-tick)/2000, "Linear")
dxLibary:dxLibary_createWindow(653/scale, 20/scale, 614/scale, 54/scale)
dxDrawRectangle(653/scale, 20/scale, rh, 54/scale, tocolor(105, 188, 235, 33), false)
dxLibary:dxLibary_text('Trwa sprzedawanie paczki metamfetaminy...', 653/scale+1, 19/scale+1, 1267/scale+1, 74/scale+1, tocolor(0, 0, 0, 255), 8, 'center', 'center', 'center', false, false, false, false, false)
dxLibary:dxLibary_text('Trwa sprzedawanie paczki metamfetaminy...', 653/scale, 19/scale, 1267/scale, 74/scale, tocolor(150, 150, 150, 255), 8, 'center', 'center', 'center', false, false, false, false, false)
    end

local meth3_start = createMarker(2794.8037109375,-2484.6240234375,13.641711235046-0.95, 'cylinder', 1.0, 124, 185, 232)
setElementData(meth3_start, 'marker:icon', 'drugs')

local meth3_miejsca = {
    {2800.2553710938,-2492.22265625,13.635055541992},
    {2800.4938964844,-2493.4111328125,13.634763717651},
    {2800.4946289063,-2495.6708984375,13.634762763977},
}

addEventHandler("onClientMarkerHit", pracaM, function(el, md)
    if not md or getElementType(el) ~= "player" then return end
    if el ~= localPlayer then return end
    outputChatBox("#ff0000● #ffffffNie możesz tego wykonać będąc w pojeździe.", 255, 255, 255, true)
end)

bindKey("e", "down", function()
    if not isElementWithinMarker(localPlayer, meth3_start) then return end
    -- if getElementData(localPlayer, "user:level") > 19 then
    -- else
        -- outputChatBox("#ff0000● #ffffffNie posiadasz 20 poziomu postaci.", 255, 255, 255, true)
        -- return end
        if getElementData(localPlayer, "user:meth2") < 1 then 
            outputChatBox("#ff0000● #ffffffNie posiadasz więcej towaru do sprzedania.", 255, 255, 255, true)
                return end
    if not getElementData(localPlayer, "user:illegal") then
        local meth3_losuj = math.random(2, #meth3_miejsca)
        setElementData(localPlayer, "user:illegal", true)
        outputChatBox("#69bceb● #ffffffUdaj się sprzedać paczkę metamfetaminy.", 255, 255, 255, true)
        toggleControl("sprint", false) 
        toggleControl("jump", false)
        
        local meth3_cel = createMarker(meth3_miejsca[meth3_losuj][1], meth3_miejsca[meth3_losuj][2], meth3_miejsca[meth3_losuj][3]-0.95, "cylinder", 1.0, 124, 185, 232)
        local meth3_blip = createBlipAttachedTo(meth3_cel, 41)
        setElementData(meth3_cel, 'marker:icon', 'drugs')

        addEventHandler("onClientMarkerHit", meth3_cel, function(el, md)
            if not md or getElementType(el) ~= "player" then return end
            if el ~= localPlayer then return end

            if getPedOccupiedVehicle(el) then
                outputChatBox("#ff0000● #ffffffNie możesz tego wykonać będąc w pojeździe.", 255, 255, 255, true)
                return
            end
            destroyElement(meth3_blip)
            setElementFrozen(el, true)
            triggerServerEvent ("meth3:animacja", localPlayer)
			addEventHandler("onClientRender",root,meth3_pasek) 
			tick = getTickCount()
            setTimer(function()
                setElementFrozen(el, false)
                destroyElement(meth3_cel)
                triggerServerEvent ("meth3:zanimacja", localPlayer)
                setPedAnimation(localPlayer, false)
                toggleControl("sprint", true) 
                toggleControl("jump", true)
                setElementData(el, "user:illegal", false)
                removeEventHandler("onClientRender",root,meth3_pasek)
                triggerServerEvent("daj:meth3", localPlayer)
                setElementData(localPlayer, "user:meth2", getElementData(localPlayer, "user:meth2")-1)
                setElementData(localPlayer, "user:sold_drugs", getElementData(localPlayer, "user:sold_drugs")+1)
                 setElementData(localPlayer, 'user:roleplay', 1)
			end, 2000, 1)
        end)
    else
    end
end)