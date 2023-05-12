--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local sw,sh = guiGetScreenSize()
local zoom = 1920/sw

local dx = exports.dxLibary
local noti = exports.dmta_base_notifications

local cena = 5 -- cena za litr paliwka
local cenap = 2

local places = {
{1939.1500244141,-1773.111328125,13.3828125},
{1007.6624755859,-938.17059326172,42.1796875},
{-2029.5003662109,156.99682617188,28.8359375},
{-1669.7679443359,407.44470214844,7.1796875},
{-1675.6866455078,413.74606323242,7.1796875},
{-1682.7209472656,419.75521850586,7.1796875},
{-2243.8596191406,-2560.9697265625,31.921875},
{-89.112915039063,-1164.3842773438,2.29541015625},
{-93.389511108398,-1174.5717773438,2.2790138721466},
{658.82312011719,-559.62835693359,16.3359375},
{658.91558837891,-569.79620361328,16.3359375},
{1382.3293457031,462.55834960938,20.133834838867},
{2639.7758789063,1097.4998779297,10.8203125},
{2639.7536621094,1106.1917724609,10.8203125},
{2640.1721191406,1116.0526123047,10.8203125},
{2202.5190429688,2475.8581542969,10.8203125},
{2114.7985839844,931.37451171875,10.8203125},
{2114.6186523438,919.05914306641,10.8203125},
{2114.9079589844,910.244140625,10.8203125},
{76.854804992676,1216.7111816406,18.829772949219},
{64.764717102051,1220.5356445313,18.829545974731},
{-736.97674560547,2742.7138671875,47.2265625},
{-1329.0557861328,2671.6166992188,50.0625},
{-1327.6596679688,2682.7976074219,50.0625},
{-1477.9150390625,1863.6164550781,32.6328125},
{-1465.6654052734,1864.5681152344,32.6328125},
{622.05743408203,1680.20703125,6.9921875},
{618.81121826172,1685.1072998047,6.9921875},
{615.25689697266,1690.3088378906,6.9921875},
{611.79351806641,1695.3181152344,6.9921875},
{608.64135742188,1699.7763671875,6.9921875},
{604.63818359375,1705.4332275391,6.9921875},
{602.00152587891,1709.2268066406,6.9921875},
}

for i,v in pairs(places) do
    local marker = createMarker(v[1], v[2], v[3]-1, "cylinder", 2.5, 247, 233, 142)
    setElementData(marker, 'marker:icon', 'brak')
    local blips = createBlip(v[1], v[2], v[3], 40)
    setBlipVisibleDistance(blips, 300)
end

function render()
    local veh = getPedOccupiedVehicle(localPlayer)
    if(veh)then
        local paliwo = getElementData(veh, "vehicle:fuel") or 0
        local bak = getElementData(veh, "vehicle:bak") or 25

        if(paliwo > bak)then paliwo = bak end

        dx:dxLibary_text("Cena za jeden litr paliwa: "..cena.." $", sw/2-300/2/zoom, sh-240/zoom, 300/zoom+sw/2-300/2/zoom, 50/zoom+sh-240/zoom, tocolor(255, 255, 255, 255), 1, "default", "center", "center", false)
        dx:dxLibary_createWindow(sw/2-300/2/zoom, sh-200/zoom, 300/zoom, 50/zoom, 235)
        dxDrawRectangle(sw/2-300/2/zoom+5, sh-200/zoom+5, (300/zoom-10)*(paliwo/bak), 50/zoom-10, tocolor(0, 125, 255, 235), false)
        dx:dxLibary_text("Stan baku: "..math.floor(paliwo).."/"..bak.." litrów", sw/2-300/2/zoom, sh-200/zoom, 300/zoom+sw/2-300/2/zoom, 50/zoom+sh-200/zoom, tocolor(255, 255, 255, 255), 1, "default", "center", "center", false)
    else
        removeEventHandler("onClientRender", root, render)
        showed = false
    end
end

bindKey("space", "down", function()
    local veh = getPedOccupiedVehicle(localPlayer)
    if(veh and showed)then
        local paliwo = getElementData(veh, "vehicle:fuel") or 0
        local bak = getElementData(veh, "vehicle:bak") or 25

        if(paliwo > bak)then paliwo = bak end

        if(paliwo < bak)then
            if(getElementData(veh, "vehicle:handbrake") and not getVehicleEngineState(veh))then
                if(getPlayerMoney(localPlayer) >= cena)then
                    setElementData(veh, "vehicle:fuel", paliwo+1)
                    if getElementData(localPlayer, 'user:premium') then
                    takePlayerMoney(cenap)
                    elseif not getElementData(localPlayer, 'user:premium') then
                    takePlayerMoney(cena)
                    end
                else
                    noti:addNotification('Nie posiadasz wystarczająco pieniędzy.', 'error')
                end
            else
                noti:addNotification('Aby zatankować pojazd, zgaś silnik i zaciągnij ręczny.', 'error')
            end
        end
    end
end)

addEventHandler("onClientMarkerHit", resourceRoot, function(hit, dim)
    if(hit ~= localPlayer or not dim or not isPedInVehicle(hit))then return end

    addEventHandler("onClientRender", root, render)
    showed = true
end)

addEventHandler("onClientMarkerLeave", resourceRoot, function(hit, dim)
    if(hit ~= localPlayer or not dim or not isPedInVehicle(hit))then return end

    removeEventHandler("onClientRender", root, render)
    showed = false
end)