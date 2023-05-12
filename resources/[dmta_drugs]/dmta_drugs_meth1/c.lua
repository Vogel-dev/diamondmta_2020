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

function meth1_pasek()
local rh = interpolateBetween(0, 0, 0, screenW * 0.2884, 0, 0, (getTickCount()-tick)/10000, "Linear")
dxLibary:dxLibary_createWindow(653/scale, 20/scale, 614/scale, 54/scale)
dxDrawRectangle(653/scale, 20/scale, rh, 54/scale, tocolor(105, 188, 235, 33), false)
dxLibary:dxLibary_text('Trwa zbieranie metyloaminy...', 653/scale+1, 19/scale+1, 1267/scale+1, 74/scale+1, tocolor(0, 0, 0, 255), 8, 'center', 'center', 'center', false, false, false, false, false)
dxLibary:dxLibary_text('Trwa zbieranie metyloaminy...', 653/scale, 19/scale, 1267/scale, 74/scale, tocolor(150, 150, 150, 255), 8, 'center', 'center', 'center', false, false, false, false, false)
    end

local meth1_start = createMarker(219.68838500977,-226.81910705566,1.778618812561-0.95, 'cylinder', 1.0, 124, 185, 232)
setElementData(meth1_start, 'marker:icon', 'drugs')

local meth1_miejsca = {
    {221.33236694336,-229.03497314453,1.778618812561},
    {220.78968811035,-233.92910766602,1.778618812561},
    {208.84240722656,-234.65031433105,1.778618812561},
    {207.0623626709,-226.25173950195,1.778618812561},
    {203.48606872559,-231.76527404785,1.778618812561},
    {196.95085144043,-225.92266845703,1.778618812561},
    {195.53135681152,-227.10943603516,1.778618812561},
    {195.14669799805,-228.71272277832,1.778618812561},
}

addEventHandler("onClientMarkerHit", pracaM, function(el, md)
    if not md or getElementType(el) ~= "player" then return end
    if el ~= localPlayer then return end
    outputChatBox("#ff0000● #ffffffNie możesz tego wykonać będąc w pojeździe.", 255, 255, 255, true)
end)

bindKey("e", "down", function()
    if not isElementWithinMarker(localPlayer, meth1_start) then return end
    -- if getElementData(localPlayer, "user:level") > 19 then
    -- else
        -- outputChatBox("#ff0000● #ffffffNie posiadasz 20 poziomu postaci.", 255, 255, 255, true)
        -- return end
        if getElementData(localPlayer, "user:meth1") > 24 then 
            outputChatBox("#ff0000● #ffffffPosiadasz przy sobie za dużo towaru.", 255, 255, 255, true)
            return end
    if not getElementData(localPlayer, "user:illegal") then
        local meth1_losuj = math.random(2, #meth1_miejsca)
        setElementData(localPlayer, "user:illegal", true)
        outputChatBox("#69bceb● #ffffffUdaj się zebrać roztwór metyloaminy.", 255, 255, 255, true)
        toggleControl("sprint", false) 
        toggleControl("jump", false)
        
        local meth1_cel = createMarker(meth1_miejsca[meth1_losuj][1], meth1_miejsca[meth1_losuj][2], meth1_miejsca[meth1_losuj][3]-0.95, "cylinder", 1.2, 124, 185, 232)
        local meth1_blip = createBlipAttachedTo(meth1_cel, 41)
        setElementData(meth1_cel, 'marker:icon', 'drugs')

        addEventHandler("onClientMarkerHit", meth1_cel, function(el, md)
            if not md or getElementType(el) ~= "player" then return end
            if el ~= localPlayer then return end

            if getPedOccupiedVehicle(el) then
                outputChatBox("#ff0000● #ffffffNie możesz tego wykonać będąc w pojeździe.", 255, 255, 255, true)
                return
            end
            destroyElement(meth1_blip)
            setElementFrozen(el, true)
            triggerServerEvent ("meth1:animacja", localPlayer)
			addEventHandler("onClientRender",root,meth1_pasek) 
			tick = getTickCount()
            setTimer(function()
                setElementFrozen(el, false)
                destroyElement(meth1_cel)
                triggerServerEvent ("meth1:zanimacja", localPlayer)
                setPedAnimation(localPlayer, false)
                toggleControl("sprint", true) 
                toggleControl("jump", true)
                setElementData(el, "user:illegal", false)
                removeEventHandler("onClientRender",root,meth1_pasek)
                local dodano = math.random(1,1)
                 setElementData(localPlayer, "user:meth1", getElementData(localPlayer, "user:meth1")+dodano)
                 setElementData(localPlayer, 'user:roleplay', 1)
                outputChatBox("#00ff00● #ffffffPomyślnie zebrałeś jeden roztwór metyloaminy.", 255, 255, 255, true)
			end, 10000, 1)
        end)
    else
    end
end)