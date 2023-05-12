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

function meth2_pasek()
local rh = interpolateBetween(0, 0, 0, screenW * 0.2884, 0, 0, (getTickCount()-tick)/5000, "Linear")
dxLibary:dxLibary_createWindow(653/scale, 20/scale, 614/scale, 54/scale)
dxDrawRectangle(653/scale, 20/scale, rh, 54/scale, tocolor(105, 188, 235, 33), false)
dxLibary:dxLibary_text('Trwa przerabianie metyloaminy...', 653/scale+1, 19/scale+1, 1267/scale+1, 74/scale+1, tocolor(0, 0, 0, 255), 8, 'center', 'center', 'center', false, false, false, false, false)
dxLibary:dxLibary_text('Trwa przerabianie metyloaminy...', 653/scale, 19/scale, 1267/scale, 74/scale, tocolor(150, 150, 150, 255), 8, 'center', 'center', 'center', false, false, false, false, false)
    end

local meth2_start = createMarker(1282.8176269531,300.79400634766,19.5546875-0.95, 'cylinder', 1.2, 124, 185, 232)
setElementData(meth2_start, 'marker:icon', 'drugs')

local meth2_miejsca = {
    {1283.6296386719,302.54086303711,19.5546875},
    {1279.7338867188,304.43515014648,19.561403274536},
    {1275.7493896484,306.16244506836,19.5546875},
    {1276.9234619141,286.83679199219,19.5546875},
    {1273.4989013672,294.43823242188,19.5546875},
    {1271.4102783203,297.47509765625,19.5546875},
    {1270.5014648438,293.59924316406,19.5546875},
    {1281.2785644531,297.36917114258,19.5546875},
}

addEventHandler("onClientMarkerHit", pracaM, function(el, md)
    if not md or getElementType(el) ~= "player" then return end
    if el ~= localPlayer then return end
    outputChatBox("#ff0000● #ffffffNie możesz tego wykonać będąc w pojeździe.", 255, 255, 255, true)
end)

bindKey("e", "down", function()
    if not isElementWithinMarker(localPlayer, meth2_start) then return end
    -- if getElementData(localPlayer, "user:level") > 19 then
    -- else
        -- outputChatBox("#ff0000● #ffffffNie posiadasz 20 poziomu postaci.", 255, 255, 255, true)
        -- return end
        if getElementData(localPlayer, "user:meth1") < 1 then 
            outputChatBox("#ff0000● #ffffffNie posiadasz więcej metyloaminy do przerobienia.", 255, 255, 255, true)
                return end
        if getElementData(localPlayer, "user:meth2") > 99 then 
            outputChatBox("#ff0000● #ffffffPosiadasz przy sobie za dużo towaru.", 255, 255, 255, true)
            return end
    if not getElementData(localPlayer, "user:illegal") then
        local meth2_losuj = math.random(2, #meth2_miejsca)
        setElementData(localPlayer, "user:illegal", true)
        outputChatBox("#69bceb● #ffffffUdaj się przerobić metyloamine na metamfetamine.", 255, 255, 255, true)
        toggleControl("sprint", false) 
        toggleControl("jump", false)
        
        local meth2_cel = createMarker(meth2_miejsca[meth2_losuj][1], meth2_miejsca[meth2_losuj][2], meth2_miejsca[meth2_losuj][3]-0.95, "cylinder", 1.0, 124, 185, 232, 90)
        local meth2_blip = createBlipAttachedTo(meth2_cel, 41)
        setElementData(meth2_cel, 'marker:icon', 'drugs')

        addEventHandler("onClientMarkerHit", meth2_cel, function(el, md)
            if not md or getElementType(el) ~= "player" then return end
            if el ~= localPlayer then return end

            if getPedOccupiedVehicle(el) then
                outputChatBox("#ff0000● #ffffffNie możesz tego wykonać będąc w pojeździe.", 255, 255, 255, true)
                return
            end
            destroyElement(meth2_blip)
            setElementFrozen(el, true)
            triggerServerEvent ("meth2:animacja", localPlayer)
			addEventHandler("onClientRender",root,meth2_pasek) 
			tick = getTickCount()
            setTimer(function()
                setElementFrozen(el, false)
                destroyElement(meth2_cel)
                triggerServerEvent ("meth2:zanimacja", localPlayer)
                setPedAnimation(localPlayer, false)
                toggleControl("sprint", true) 
                toggleControl("jump", true)
                setElementData(el, "user:illegal", false)
                removeEventHandler("onClientRender",root,meth2_pasek)
                local dodano = math.random(2,4)
                setElementData(localPlayer, "user:meth2", getElementData(localPlayer, "user:meth2")+dodano)
                setElementData(localPlayer, "user:meth1", getElementData(localPlayer, "user:meth1")-1)
                 setElementData(localPlayer, 'user:roleplay', 1)
                outputChatBox("#00ff00● #ffffffPomyślnie przerobiłeś jeden roztwór metyloaminy na #969696"..dodano.." #ffffffpaczki metamfetaimny.", 255, 255, 255, true)
			end, 5000, 1)
        end)
    else
    end
end)