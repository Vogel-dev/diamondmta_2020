--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local dx = exports.dxLibary
local noti = exports['dmta_base_notifications']

local sw,sh = guiGetScreenSize()
local zoom = 1920/sw

local MECH = {}

MECH.places = {
    {marker={1730.904296875,-1745.3092041016,13.538461685181}, shape={1735.5051269531,-1747.7734375,13.528231620789}}
}

for i,v in pairs(MECH.places) do
    local marker = createMarker(v.marker[1], v.marker[2], v.marker[3]-1, "cylinder", 1.2, 255, 191, 0, 255)
    local shape = createColSphere(v.shape[1], v.shape[2], v.shape[3], 5)
    setElementData(marker, "shape", shape, false)
    setElementData(marker, 'marker:icon', 'mechanic')
end

-- useful function created by Asper

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

-- klasy

local class = {
    {"Infernus", "S2"},
    {"Turismo", "S2"},
    {"Bullet", "S2"},
    {"Cheetah", "S2"},
    {"Banshee", "S2"},
    {"NRG-500", "S2"},
    {"Comet", "S2"},
    
	{"ZR-350", "S1"},
    {"Super GT", "S1"},
    {"Pheonix", "S1"},
    {"Buffalo", "S1"},
    {"Windsore", "S1"},
    {"Euros", "S1"},
    {"Alpha", "S1"},
    {"Jester", "S1"},
    {"Elegy", "S1"},
    {"Sultan", "S1"},
    {"Flash", "S1"},
    {"Stratum", "S1"},
    {"Uranus", "S1"},
    {"FCR-900", "S1"},

    {"Huntley", "A"},
    {"Sentinel", "A"},
    {"Feltzer", "A"},
    {"Phoenix", "A"},
    {"Elegant", "A"},
    {"Admiral", "A"},
    {"Metit", "A"},
    {"Stafford", "A"},
    {"Washington", "A"},
    {"Slamvan", "A"},
    {"Remington", "A"},
    {"Blade", "A"},
    {"Brodway", "A"},
    {"Savanna", "A"},
    {"Sandking", "A"},
    {"Yosemite", "A"},
    {"Hermes", "A"},
    {"Stretch", "A"},
    {"Journey", "A"},
    {"BF-400", "A"},
    {"PCJ-600", "A"},

    {"Landstalker", "B"},
    {"Rancher", "B"},
    {"Mesa", "B"},
    {"Tahoma", "B"},
    {"Tornado", "B"},
    {"Voodoo", "B"},
    {"Blista Compact", "B"},
    {"Buccaneer", "B"},
    {"Cadrona", "B"},
    {"Esperanto", "B"},
    {"Virgo", "B"},
    {"Fortune", "B"},
    {"Klub", "B"},
    {"Stallion", "B"},
    {"Sabre", "B"},
    {"Majestic", "B"},
    {"Greenwood", "B"},
    {"Nebula", "B"},
    {"Premier", "B"},
    {"Primo", "B"},
    {"Sunrise", "B"},
    {"Oceanic", "B"},
    {"Camper", "B"},
    {"Wayfarer", "B"},
    {"Sanchez", "B"},
    {"Freeway", "B"},

    {"Walton", "D"},
    {"Sadler", "D"},
    {"Bobcat", "D"},
    {"Moonbeam", "D"},
    {"Bravura", "D"},
    {"Clover", "D"},
    {"Previon", "D"},
    {"Tampa", "D"},
    {"Manana", "D"},
    {"Emperor", "D"},
    {"Glendale", "D"},
    {"Intruder", "D"},
    {"Perennial", "D"},
    {"Regina", "D"},
    {"Solair", "D"},
    {"Vincent", "D"},
    {"Willard", "D"},
    {"Faggio", "D"},
    {"596", "D"},
}   

function engine_cost(veh, class)
    if(class == "S1")then
        return (getElementHealth(veh) < 1000 and getElementHealth(veh) > 800) and 100 or (getElementHealth(veh) < 800 and getElementHealth(veh) > 500) and 150 or (getElementHealth(veh) < 500 and getElementHealth(veh) > 300) and 200 or (getElementHealth(veh) < 300 and getElementHealth(veh) > 0) and 250
    elseif(class == "S2")then
        return (getElementHealth(veh) < 1000 and getElementHealth(veh) > 800) and 70 or (getElementHealth(veh) < 800 and getElementHealth(veh) > 500) and 120 or (getElementHealth(veh) < 500 and getElementHealth(veh) > 300) and 170 or (getElementHealth(veh) < 300 and getElementHealth(veh) > 0) and 220
    elseif(class == "A")then
        return (getElementHealth(veh) < 1000 and getElementHealth(veh) > 800) and 40 or (getElementHealth(veh) < 800 and getElementHealth(veh) > 500) and 90 or (getElementHealth(veh) < 500 and getElementHealth(veh) > 300) and 140 or (getElementHealth(veh) < 300 and getElementHealth(veh) > 0) and 190
    elseif(class == "B")then
        return (getElementHealth(veh) < 1000 and getElementHealth(veh) > 800) and 30 or (getElementHealth(veh) < 800 and getElementHealth(veh) > 500) and 70 or (getElementHealth(veh) < 500 and getElementHealth(veh) > 300) and 110 or (getElementHealth(veh) < 300 and getElementHealth(veh) > 0) and 150
    elseif(class == "D")then
        return (getElementHealth(veh) < 1000 and getElementHealth(veh) > 800) and 20 or (getElementHealth(veh) < 800 and getElementHealth(veh) > 500) and 50 or (getElementHealth(veh) < 500 and getElementHealth(veh) > 300) and 70 or (getElementHealth(veh) < 300 and getElementHealth(veh) > 0) and 100
    end
    return 0
end

function wheel_state(veh)
    local state = 1
    local x1,x2,x3,x4 = getVehicleWheelStates(veh)
    if(x1 > 0 or x2 > 0 or x3 > 0 or x4 > 0)then
        state = 0
    end
    return state
end

local costs = {
    ["S1"] = {
        {"Silnik", 1, function(veh) if getElementHealth(veh) > 999 then return 1 end return 0 end, 0},
        {"Maska", 2, function(veh) if getVehicleDoorState(veh, 0) == 0 then return 1 end return 0 end, 40},
        {"Bagażnik", 3, function(veh) if getVehicleDoorState(veh, 1) == 0 then return 1 end return 0 end, 45},
        {"Drzwi lewy przód", 4, function(veh) if getVehicleDoorState(veh, 2) == 0 then return 1 end return 0 end, 21},
        {"Drzwi prawy przód", 5, function(veh) if getVehicleDoorState(veh, 3) == 0 then return 1 end return 0 end, 21},
        {"Drzwi lewy tył", 6, function(veh) if getVehicleDoorState(veh, 4) == 0 then return 1 end return 0 end, 25},
        {"Drzwi prawy tył", 7, function(veh) if getVehicleDoorState(veh, 5) == 0 then return 1 end return 0 end, 25},
        {"Szyba przednia", 8, function(veh) if getVehiclePanelState(veh, 4) == 0 then return 1 end return 0 end, 20},
        {"Zderzak przedni", 9, function(veh) if getVehiclePanelState(veh, 5) == 0 then return 1 end return 0 end, 30},
        {"Zderzak tylni", 10, function(veh) if getVehiclePanelState(veh, 6) == 0 then return 1 end return 0 end, 30},
        {"Światła", 11, function(veh) if getVehicleLightState(veh, 0) == 0 and getVehicleLightState(veh, 1) == 0 and getVehicleLightState(veh, 2) == 0 and getVehicleLightState(veh, 3) == 0 then return 1 end return 0 end, 30},
        {"Koła pojazdu", 12, function(veh) if(wheel_state(veh) == 0)then return 0 else return 1 end end, 10},
    },
 
    ["S2"] = {
         {"Silnik", 1, function(veh) if getElementHealth(veh) > 999 then return 1 end return 0 end, 0},
        {"Maska", 2, function(veh) if getVehicleDoorState(veh, 0) == 0 then return 1 end return 0 end, 50},
        {"Bagażnik", 3, function(veh) if getVehicleDoorState(veh, 1) == 0 then return 1 end return 0 end, 55},
        {"Drzwi lewy przód", 4, function(veh) if getVehicleDoorState(veh, 2) == 0 then return 1 end return 0 end, 21},
        {"Drzwi prawy przód", 5, function(veh) if getVehicleDoorState(veh, 3) == 0 then return 1 end return 0 end, 21},
        {"Drzwi lewy tył", 6, function(veh) if getVehicleDoorState(veh, 4) == 0 then return 1 end return 0 end, 30},
        {"Drzwi prawy tył", 7, function(veh) if getVehicleDoorState(veh, 5) == 0 then return 1 end return 0 end, 30},
        {"Szyba przednia", 8, function(veh) if getVehiclePanelState(veh, 4) == 0 then return 1 end return 0 end, 20},
        {"Zderzak przedni", 9, function(veh) if getVehiclePanelState(veh, 5) == 0 then return 1 end return 0 end, 40},
        {"Zderzak tylni", 10, function(veh) if getVehiclePanelState(veh, 6) == 0 then return 1 end return 0 end, 40},
        {"Światła", 11, function(veh) if getVehicleLightState(veh, 0) == 0 and getVehicleLightState(veh, 1) == 0 and getVehicleLightState(veh, 2) == 0 and getVehicleLightState(veh, 3) == 0 then return 1 end return 0 end, 30},
        {"Koła pojazdu", 12, function(veh) if(wheel_state(veh) == 0)then return 0 else return 1 end end, 10},
    },
 
    ["A"] = {
        {"Silnik", 1, function(veh) if getElementHealth(veh) > 999 then return 1 end return 0 end, 0},
        {"Maska", 2, function(veh) if getVehicleDoorState(veh, 0) == 0 then return 1 end return 0 end, 25},
        {"Bagażnik", 3, function(veh) if getVehicleDoorState(veh, 1) == 0 then return 1 end return 0 end, 25},
        {"Drzwi lewy przód", 4, function(veh) if getVehicleDoorState(veh, 2) == 0 then return 1 end return 0 end, 18},
        {"Drzwi prawy przód", 5, function(veh) if getVehicleDoorState(veh, 3) == 0 then return 1 end return 0 end, 15},
        {"Drzwi lewy tył", 6, function(veh) if getVehicleDoorState(veh, 4) == 0 then return 1 end return 0 end, 15},
        {"Drzwi prawy tył", 7, function(veh) if getVehicleDoorState(veh, 5) == 0 then return 1 end return 0 end, 15},
        {"Szyba przednia", 8, function(veh) if getVehiclePanelState(veh, 4) == 0 then return 1 end return 0 end, 13},
        {"Zderzak przedni", 9, function(veh) if getVehiclePanelState(veh, 5) == 0 then return 1 end return 0 end, 16},
        {"Zderzak tylni", 10, function(veh) if getVehiclePanelState(veh, 6) == 0 then return 1 end return 0 end, 16},
        {"Światła", 11, function(veh) if getVehicleLightState(veh, 0) == 0 and getVehicleLightState(veh, 1) == 0 and getVehicleLightState(veh, 2) == 0 and getVehicleLightState(veh, 3) == 0 then return 1 end return 0 end, 20},
        {"Koła pojazdu", 12, function(veh) if(wheel_state(veh) == 0)then return 0 else return 1 end end, 10},
    },
 
    ["B"] = {
        {"Silnik", 1, function(veh) if getElementHealth(veh) > 999 then return 1 end return 0 end, 0},
        {"Maska", 2, function(veh) if getVehicleDoorState(veh, 0) == 0 then return 1 end return 0 end, 20},
        {"Bagażnik", 3, function(veh) if getVehicleDoorState(veh, 1) == 0 then return 1 end return 0 end, 20},
        {"Drzwi lewy przód", 4, function(veh) if getVehicleDoorState(veh, 2) == 0 then return 1 end return 0 end, 14},
        {"Drzwi prawy przód", 5, function(veh) if getVehicleDoorState(veh, 3) == 0 then return 1 end return 0 end, 13},
        {"Drzwi lewy tył", 6, function(veh) if getVehicleDoorState(veh, 4) == 0 then return 1 end return 0 end, 12},
        {"Drzwi prawy tył", 7, function(veh) if getVehicleDoorState(veh, 5) == 0 then return 1 end return 0 end, 12},
        {"Szyba przednia", 8, function(veh) if getVehiclePanelState(veh, 4) == 0 then return 1 end return 0 end, 13},
        {"Zderzak przedni", 9, function(veh) if getVehiclePanelState(veh, 5) == 0 then return 1 end return 0 end, 11},
        {"Zderzak tylni", 10, function(veh) if getVehiclePanelState(veh, 6) == 0 then return 1 end return 0 end, 11},
        {"Światła", 11, function(veh) if getVehicleLightState(veh, 0) == 0 and getVehicleLightState(veh, 1) == 0 and getVehicleLightState(veh, 2) == 0 and getVehicleLightState(veh, 3) == 0 then return 1 end return 0 end, 15},
        {"Koła pojazdu", 12, function(veh) if(wheel_state(veh) == 0)then return 0 else return 1 end end, 10},
    },
 
    ["D"] = {
        {"Silnik", 1, function(veh) if getElementHealth(veh) > 999 then return 1 end return 0 end, 0},
        {"Maska", 2, function(veh) if getVehicleDoorState(veh, 0) == 0 then return 1 end return 0 end, 30},
        {"Bagażnik", 3, function(veh) if getVehicleDoorState(veh, 1) == 0 then return 1 end return 0 end, 35},
        {"Drzwi lewy przód", 4, function(veh) if getVehicleDoorState(veh, 2) == 0 then return 1 end return 0 end, 18},
        {"Drzwi prawy przód", 5, function(veh) if getVehicleDoorState(veh, 3) == 0 then return 1 end return 0 end, 18},
        {"Drzwi lewy tył", 6, function(veh) if getVehicleDoorState(veh, 4) == 0 then return 1 end return 0 end, 20},
        {"Drzwi prawy tył", 7, function(veh) if getVehicleDoorState(veh, 5) == 0 then return 1 end return 0 end, 20},
        {"Szyba przednia", 8, function(veh) if getVehiclePanelState(veh, 4) == 0 then return 1 end return 0 end, 17},
        {"Zderzak przedni", 9, function(veh) if getVehiclePanelState(veh, 5) == 0 then return 1 end return 0 end, 20},
        {"Zderzak tylni", 10, function(veh) if getVehiclePanelState(veh, 6) == 0 then return 1 end return 0 end, 20},
        {"Światła", 11, function(veh) if getVehicleLightState(veh, 0) == 0 and getVehicleLightState(veh, 1) == 0 and getVehicleLightState(veh, 2) == 0 and getVehicleLightState(veh, 3) == 0 then return 1 end return 0 end, 25},
        {"Koła pojazdu", 12, function(veh) if(wheel_state(veh) == 0)then return 0 else return 1 end end, 10},
    }
}

function searchClass(veh)
    for i,v in pairs(class) do
        if(veh == v[1])then
            return v[2]
        end
    end
end

function searchCosts(class)
    if(costs[class])then
        return costs[class]
    end
end

function fillVehicleData(veh)
    MECH.dxGridListItems = {}

    local class = searchClass(getVehicleName(veh))
    local costs = searchCosts(class)
    for i,v in pairs(costs) do
        if(v[1] == "Silnik")then
            local cost = engine_cost(veh, class)
            table.insert(MECH.dxGridListItems, {name=v[1], cost=cost or 0, id=v[2]})
        else
            if(v[3](veh) == 0)then
                table.insert(MECH.dxGridListItems, {name=v[1], cost=v[4], id=v[2]})
            end
        end
    end
end

--

MECH.rt = dxCreateRenderTarget(454/zoom, 274/zoom, true)

MECH.posY = 0
MECH.vehicle = false

MECH.onRender = function()
    dx:dxLibary_createWindow(714/zoom, 307/zoom, 493/zoom, 467/zoom)
    dx:dxLibary_text("Panel naprawy", 724/zoom, 317/zoom, 1197/zoom, 373/zoom, tocolor(105, 188, 235, 255), 10, "default", "center", "center", false, false, false, false, false)
    dx:dxLibary_createButton("Napraw", 748/zoom, 710/zoom, 202/zoom, 51/zoom, 3)
    dx:dxLibary_createButton("Anuluj", 985/zoom, 710/zoom, 202/zoom, 51/zoom, 3)

    dx:dxLibary_text("Lp.", 750/zoom+20/zoom, 390/zoom-20/zoom, 0, 0, tocolor(255, 255, 255, 255), 1, "default", "left", "top", false)
    dx:dxLibary_text("Nazwa części", 850/zoom+20/zoom, 390/zoom-20/zoom, 0, 0, tocolor(255, 255, 255, 255), 1, "default", "left", "top", false)
    dx:dxLibary_text("Cena części", 1050/zoom+20/zoom, 390/zoom-20/zoom, 0, 0, tocolor(255, 255, 255, 255), 1, "default", "left", "top", false)
    dxDrawRectangle(745/zoom+20/zoom, 407/zoom-20/zoom, 400/zoom, 2/zoom, tocolor(105, 188, 235))

    local costAll = 0
    dxSetRenderTarget(MECH.rt, true)
        for i,v in pairs(MECH.dxGridListItems) do
            local sY = (35/zoom)*(i-1)

            onClick(750/zoom+20/zoom, MECH.posY+410/zoom-20/zoom+sY, 390/zoom, 30/zoom, function()
                if(isMouseInPosition(750/zoom+20/zoom, 410/zoom-20/zoom, 454/zoom, 274/zoom))then
                    v.selected = not v.selected
                end
            end)

            if(v.selected)then
                dxDrawRectangle(0, MECH.posY+sY, 390/zoom, 30/zoom, tocolor(105, 188, 235, 255))
                costAll = costAll+v.cost
            else
                dxDrawRectangle(0, MECH.posY+sY, 390/zoom, 30/zoom, tocolor(20, 20, 20, 255))
            end

            dx:dxLibary_text(i, 5/zoom, MECH.posY+5/zoom+sY, 390/zoom, 30/zoom, tocolor(255, 255, 255, 255), 1, "default", "left", "top", false)
            dx:dxLibary_text(v.name, 100/zoom, MECH.posY+5/zoom+sY, 390/zoom, 30/zoom, tocolor(255, 255, 255, 255), 1, "default", "left", "top", false)
            dx:dxLibary_text(v.cost.." $", 300/zoom, MECH.posY+5/zoom+sY, 390/zoom, 30/zoom, tocolor(255, 255, 255, 255), 1, "default", "left", "top", false)
        end
    dxSetRenderTarget()
    dxDrawImage(750/zoom+20/zoom, 410/zoom-20/zoom, 454/zoom, 274/zoom, MECH.rt, 0, 0, 0, tocolor(255, 255, 255, 255), false)

    onClick(748/zoom, 710/zoom, 202/zoom, 51/zoom, function()
        for i,v in pairs(MECH.dxGridListItems) do
            triggerServerEvent("mechanic.repair", resourceRoot, MECH.vehicle, v.id, v.cost, v.name)

            removeEventHandler("onClientRender", root, MECH.onRender)
            removeEventHandler("onClientKey", root, MECH.onKey)

            showCursor(false)
        end
    end)

    onClick(985/zoom, 710/zoom, 202/zoom, 51/zoom, function()
        removeEventHandler("onClientRender", root, MECH.onRender)
        removeEventHandler("onClientKey", root, MECH.onKey)

        showCursor(false)
    end)

    dx:dxLibary_text("Koszt za naprawę wybranych części: "..costAll.." $", 850/zoom+20/zoom, 700/zoom-20/zoom, 0, 0, tocolor(255, 255, 255, 255), 1, "default", "left", "top", false)
end

MECH.onKey = function(key, press)
    if(press)then
        if(key == "mouse_wheel_up")then
            MECH.posY = MECH.posY+10
            if(MECH.posY > 0)then
                MECH.posY = 0
            end
        elseif(key == "mouse_wheel_down")then
            MECH.posY = MECH.posY-10
        end
    end
end

addEventHandler("onClientMarkerHit", resourceRoot, function(hit, dim)
    if(hit ~= localPlayer or not dim or isPedInVehicle(hit))then return end

    local shape = getElementData(source, "shape")
    local veh = getElementsWithinColShape(shape, "vehicle")
    if(#veh > 0 and #veh < 2)then
        if(not getElementData(veh[1], "vehicle:handbrake"))then
            noti:addNotification('Najpierw zaciągnij ręczny w pojeździe!', 'error')
        else   
            showCursor(true)

            addEventHandler("onClientRender", root, MECH.onRender)
            addEventHandler("onClientKey", root, MECH.onKey)

            fillVehicleData(veh[1])

            MECH.vehicle = veh[1]
        end
    else
        noti:addNotification('Na stanowisku nie znajduje się żaden pojazd, lub jest więcej niż jeden.', 'error')
    end
end)