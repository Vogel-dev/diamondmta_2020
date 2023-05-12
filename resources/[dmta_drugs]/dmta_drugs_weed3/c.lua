--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local weed3_blip = createBlip(1409.4162597656,-1299.0457763672,13.548246383667, 16)
setBlipVisibleDistance(weed3_blip, 300)
local screenW, screenH = guiGetScreenSize()
local sw,sh = guiGetScreenSize()
local baseX = 1920
local scale = 1
local minScale = 2
if sw < baseX then
    scale = math.min(minScale, baseX/sw)
end

local dxLibary = exports['dxLibary']

function weed3_pasek()
local rh = interpolateBetween(0, 0, 0, screenW * 0.2884, 0, 0, (getTickCount()-tick)/2000, "Linear")
dxLibary:dxLibary_createWindow(653/scale, 20/scale, 614/scale, 54/scale)
dxDrawRectangle(653/scale, 20/scale, rh, 54/scale, tocolor(105, 188, 235, 33), false)
dxLibary:dxLibary_text('Trwa sprzedawanie paczki marihuany...', 653/scale+1, 19/scale+1, 1267/scale+1, 74/scale+1, tocolor(0, 0, 0, 255), 8, 'center', 'center', 'center', false, false, false, false, false)
dxLibary:dxLibary_text('Trwa sprzedawanie paczki marihuany...', 653/scale, 19/scale, 1267/scale, 74/scale, tocolor(150, 150, 150, 255), 8, 'center', 'center', 'center', false, false, false, false, false)
    end

local weed3_start = createMarker(1409.4162597656,-1299.0457763672,13.548246383667-0.95, "cylinder", 1.3, 0, 128, 0)
setElementData(weed3_start, 'marker:icon', 'weed')

local weed3_miejsca = {
    {1426.0675048828,-1338.4058837891,13.581255912781},
    {1424.5885009766,-1353.0118408203,13.574438095093},
    {1420.2283935547,-1353.9151611328,13.564635276794},
    {1419.3536376953,-1330.708984375,13.565001487732},
    {1422.7763671875,-1321.5178222656,13.5546875},
    {1420.5822753906,-1317.0341796875,13.5546875},
    {1421.6606445313,-1311.6014404297,13.5546875},
    {1419.9476318359,-1304.1842041016,13.5546875},
    {1415.9486083984,-1301.0941162109,13.545351982117},
    {1410.9144287109,-1299.240234375,13.54824924469},
    {1405.7159423828,-1300.814453125,13.551860809326},
    {1422.470703125,-1291.8806152344,13.560284614563},
    {1423.8669433594,-1295.9302978516,13.55922794342},
}

addEventHandler("onClientMarkerHit", pracaM, function(el, md)
    if not md or getElementType(el) ~= "player" then return end
    if el ~= localPlayer then return end
    outputChatBox("#ff0000● #ffffffNie możesz tego wykonać będąc w pojeździe.", 255, 255, 255, true)
end)

bindKey("e", "down", function()
    if not isElementWithinMarker(localPlayer, weed3_start) then return end
    -- if getElementData(localPlayer, "user:level") > 9 then
    -- else
        -- outputChatBox("#ff0000● #ffffffNie posiadasz 10 poziomu postaci.", 255, 255, 255, true)
        -- return end
        if getElementData(localPlayer, "user:weed2") < 1 then 
            outputChatBox("#ff0000● #ffffffNie posiadasz więcej towaru do sprzedania.", 255, 255, 255, true)
                return end
    if not getElementData(localPlayer, "user:illegal") then
        local weed3_losuj = math.random(2, #weed3_miejsca)
        setElementData(localPlayer, "user:illegal", true)
        outputChatBox("#69bceb● #ffffffUdaj się sprzedać paczkę marihuany.", 255, 255, 255, true)
        toggleControl("sprint", false) 
        toggleControl("jump", false)
        
        local weed3_cel = createMarker(weed3_miejsca[weed3_losuj][1], weed3_miejsca[weed3_losuj][2], weed3_miejsca[weed3_losuj][3]-0.95, "cylinder", 1.0, 0, 128, 0, 90)
        local weed3_blip = createBlipAttachedTo(weed3_cel, 41)
        setElementData(weed3_cel, 'marker:icon', 'weed')

        addEventHandler("onClientMarkerHit", weed3_cel, function(el, md)
            if not md or getElementType(el) ~= "player" then return end
            if el ~= localPlayer then return end

            if getPedOccupiedVehicle(el) then
                outputChatBox("#ff0000● #ffffffNie możesz tego wykonać będąc w pojeździe.", 255, 255, 255, true)
                return
            end
            destroyElement(weed3_blip)
            setElementFrozen(el, true)
            triggerServerEvent ("weed3:animacja", localPlayer)
			addEventHandler("onClientRender",root,weed3_pasek) 
			tick = getTickCount()
            setTimer(function()
                setElementFrozen(el, false)
                destroyElement(weed3_cel)
                triggerServerEvent ("weed3:zanimacja", localPlayer)
                setPedAnimation(localPlayer, false)
                toggleControl("sprint", true) 
                toggleControl("jump", true)
                setElementData(el, "user:illegal", false)
                removeEventHandler("onClientRender",root,weed3_pasek)
                triggerServerEvent("daj:Weed3", localPlayer)
                setElementData(localPlayer, "user:weed2", getElementData(localPlayer, "user:weed2")-1)
                setElementData(localPlayer, "user:sold_drugs", getElementData(localPlayer, "user:sold_drugs")+1)
                 setElementData(localPlayer, 'user:roleplay', 1)
			end, 2000, 1)
        end)
    else
    end
end)