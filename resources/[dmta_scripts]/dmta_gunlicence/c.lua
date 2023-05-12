--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local dx = exports.dxLibary

local sw,sh = guiGetScreenSize()
local zoom = 1920/sw

local MECH = {}

MECH.marker = createMarker(358.23635864258,166.21125793457,1008.3828125-1, "cylinder", 1.2, 163, 38, 56, 0)
setBlipVisibleDistance(MECH.marker, 10)
setElementInterior(MECH.marker, 3)
setElementData(MECH.marker, 'marker:icon', 'gun')


function isMouseInPosition(x, y, w, h)
    if not isCursorShowing() then return end
        
    local mouse = {getCursorPosition()}
    local myX, myY = (mouse[1] * sw), (mouse[2] * sh)
    if (myX >= x and myX <= (x + w)) and (myY >= y and myY <= (y + h)) then
        return true
    end
        
    return false
end
    
local click = false
function onClick(x, y, w, h, called)
    if(isMouseInPosition(x, y, w, h) and not click and getKeyState("mouse1"))then
        click = true
        called()
    elseif(not getKeyState("mouse1") and click)then
        click = false
    end
end

MECH.onRender = function()
    dxDrawRectangle(0, 0, 1920, 1080, tocolor(15, 15, 15, 200), false)
    dx:dxLibary_createWindow(sw/2-500/2/zoom, sh/2-300/2/zoom, 500/zoom, 300/zoom)
    dx:dxLibary_text("Licencja na broń", 0, 0, sw, sh/1.3, tocolor(105, 188, 235, 255), 10, "default", "center", "center", false, false, false, true, false)
    dx:dxLibary_text("Czy chcesz wyrobić #69bceblicencje na broń#ffffff?\n#ffffffKoszt wyrobienia licencji na broń wynosi #69bceb25000$.", 0, 0, sw, sh, tocolor(255, 255, 255, 255), 3, "default", "center", "center", false, false, false, true, false)
    dx:dxLibary_createButton("Tak", sw/2-210/zoom, sh/2+80/zoom, 200/zoom, 50/zoom, 3)
    dx:dxLibary_createButton("Nie", sw/2+10/zoom, sh/2+80/zoom, 200/zoom, 50/zoom, 3)

    onClick(sw/2-210/zoom, sh/2+80/zoom, 200/zoom, 50/zoom, function()
        if(getElementData(localPlayer, "user:licencjaB") == 1)then
            outputChatBox("#69bceb● #ffffffPosiadasz już wyrobioną licencje na broń.", 255, 255, 255, true)
        else    
            if getElementData(localPlayer, 'user:online') < 1800 then 
                outputChatBox("#ff0000● #ffffffDo wyrobienia licencji na broń musisz posiadać przegrane 30 godzin na serwerze.", 255, 255, 255, true)
                return end
            if(getPlayerMoney(localPlayer) >= 25000)then
                outputChatBox("#00ff00● #ffffffWyrobiłeś licencje na broń za #96969625000 #00ff00$", 255, 255, 255, true) 
                triggerServerEvent("zabierz:hajs-food1", localPlayer, 25000)
                setElementData(localPlayer, "user:licencjaB", 1)
            else
                outputChatBox("#ff0000● #ffffffNie stać Cię na wyrobienie licencji na broń.", 255, 255, 255, true)
            end
        end

        removeEventHandler("onClientRender", root, MECH.onRender)
        removeEventHandler("onClientKey", root, MECH.onKey)

        showCursor(false)
    end)

    onClick(sw/2+10/zoom, sh/2+80/zoom, 200/zoom, 50/zoom, function()
        removeEventHandler("onClientRender", root, MECH.onRender)
        removeEventHandler("onClientKey", root, MECH.onKey)

        showCursor(false)
    end)
end


addEventHandler("onClientMarkerHit", resourceRoot, function(hit, dim)
    if(hit ~= localPlayer or not dim or isPedInVehicle(hit))then return end

    addEventHandler("onClientRender", root, MECH.onRender)
    showCursor(true)
end)