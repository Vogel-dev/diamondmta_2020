--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local weed2_blip = createBlip(-399.01031494141,-1434.3244628906,25.7265625, 16)
setBlipVisibleDistance(weed2_blip, 300)
local screenW, screenH = guiGetScreenSize()
local sw,sh = guiGetScreenSize()
local baseX = 1920
local scale = 1
local minScale = 2
if sw < baseX then
    scale = math.min(minScale, baseX/sw)
end

local dxLibary = exports['dxLibary']

function weed2_pasek()
local rh = interpolateBetween(0, 0, 0, screenW * 0.2884, 0, 0, (getTickCount()-tick)/5000, "Linear")
dxLibary:dxLibary_createWindow(653/scale, 20/scale, 614/scale, 54/scale)
dxDrawRectangle(653/scale, 20/scale, rh, 54/scale, tocolor(105, 188, 235, 33), false)
dxLibary:dxLibary_text('Trwa przerabianie suszu konopnego...', 653/scale+1, 19/scale+1, 1267/scale+1, 74/scale+1, tocolor(0, 0, 0, 255), 8, 'center', 'center', 'center', false, false, false, false, false)
dxLibary:dxLibary_text('Trwa przerabianie suszu konopnego...', 653/scale, 19/scale, 1267/scale, 74/scale, tocolor(150, 150, 150, 255), 8, 'center', 'center', 'center', false, false, false, false, false)
    end

local weed2_start = createMarker(-399.01031494141,-1434.3244628906,25.7265625-0.95, "cylinder", 1.3, 0, 128, 0)
setElementData(weed2_start, 'marker:icon', 'weed')

local weed2_miejsca = {
    {-395.11450195313,-1434.2971191406,25.7265625},
    {-393.42834472656,-1435.9007568359,25.7265625},
    {-399.88983154297,-1436.8825683594,25.7265625},
    {-397.04159545898,-1433.7365722656,25.7265625},
    {-400.09146118164,-1434.3243408203,25.7265625},
}

addEventHandler("onClientMarkerHit", pracaM, function(el, md)
    if not md or getElementType(el) ~= "player" then return end
    if el ~= localPlayer then return end
    outputChatBox("#ff0000● #ffffffNie możesz tego wykonać będąc w pojeździe.", 255, 255, 255, true)
end)

bindKey("e", "down", function()
    if not isElementWithinMarker(localPlayer, weed2_start) then return end
    -- if getElementData(localPlayer, "user:level") > 9 then
    -- else
       --  outputChatBox("#ff0000● #ffffffNie posiadasz 10 poziomu postaci.", 255, 255, 255, true)
        -- return end
        if getElementData(localPlayer, "user:weed1") < 1 then 
            outputChatBox("#ff0000● #ffffffNie posiadasz więcej liści do przerobienia.", 255, 255, 255, true)
                return end
        if getElementData(localPlayer, "user:weed2") > 99 then 
            outputChatBox("#ff0000● #ffffffPosiadasz przy sobie za dużo towaru.", 255, 255, 255, true)
            return end
    if not getElementData(localPlayer, "user:illegal") then
        local weed2_losuj = math.random(2, #weed2_miejsca)
        setElementData(localPlayer, "user:illegal", true)
        outputChatBox("#69bceb● #ffffffUdaj się przerobić liść konopii.", 255, 255, 255, true)
        toggleControl("sprint", false) 
        toggleControl("jump", false)
        
        local weed2_cel = createMarker(weed2_miejsca[weed2_losuj][1], weed2_miejsca[weed2_losuj][2], weed2_miejsca[weed2_losuj][3]-0.95, "cylinder", 1.0, 0, 128, 0, 90)
        local weed2_blip = createBlipAttachedTo(weed2_cel, 41)
        setElementData(weed2_cel, 'marker:icon', 'weed')

        addEventHandler("onClientMarkerHit", weed2_cel, function(el, md)
            if not md or getElementType(el) ~= "player" then return end
            if el ~= localPlayer then return end

            if getPedOccupiedVehicle(el) then
                outputChatBox("#ff0000● #ffffffNie możesz tego wykonać będąc w pojeździe.", 255, 255, 255, true)
                return
            end
            destroyElement(weed2_blip)
            setElementFrozen(el, true)
            triggerServerEvent ("weed2:animacja", localPlayer)
			addEventHandler("onClientRender",root,weed2_pasek) 
			tick = getTickCount()
            setTimer(function()
                setElementFrozen(el, false)
                destroyElement(weed2_cel)
                triggerServerEvent ("weed2:zanimacja", localPlayer)
                setPedAnimation(localPlayer, false)
                toggleControl("sprint", true) 
                toggleControl("jump", true)
                setElementData(el, "user:illegal", false)
                removeEventHandler("onClientRender",root,weed2_pasek)
                local dodano = math.random(2,4)
                setElementData(localPlayer, "user:weed2", getElementData(localPlayer, "user:weed2")+dodano)
                setElementData(localPlayer, "user:weed1", getElementData(localPlayer, "user:weed1")-1)
                 setElementData(localPlayer, 'user:roleplay', 1)
                outputChatBox("#00ff00● #ffffffPomyślnie przerobiłeś jeden liść konopii na #969696"..dodano.." #ffffffpaczki marihuany.", 255, 255, 255, true)
			end, 5000, 1)
        end)
    else
    end
end)