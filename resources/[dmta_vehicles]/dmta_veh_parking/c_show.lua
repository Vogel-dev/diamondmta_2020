--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local sw,sh = guiGetScreenSize()
local baseX = 1920
local scale = 1
local minScale = 2
if sw < baseX then
    scale = math.min(minScale, baseX/sw)
end

local vehicle = false

local function gui()
    if not vehicle or vehicle and not isElement(vehicle) then
        removeEventHandler('onClientRender', root, gui)
        removeEventHandler('onClientClick', root, clicked)
        showCursor(false)
        vehicle = false
        return
    end
    dxDrawRectangle(0, 0, 1920, 1080, tocolor(15, 15, 15, 200), false)
    exports['dxLibary']:dxLibary_createWindow(710/scale, 319/scale, 501/scale, 442/scale, false)

    exports['dxLibary']:dxLibary_text('#69bcebParking strzeżony', 710/scale, 319/scale, 1211/scale, 378/scale, tocolor(255, 255, 255, 255), 8, 'default', 'center', 'center', false, false, false, true, false)
    exports['dxLibary']:dxLibary_text('Oddawanie pojazdu', 858/scale, 367/scale, 1062/scale, 390/scale, tocolor(255, 255, 255, 255), 3, 'default', 'center', 'top', false, false, false, false, false)

    exports['dxLibary']:dxLibary_createButton('Oddaj pojazd', 730/scale, 697/scale, 190/scale, 46/scale, tocolor(255, 255, 255, 255), false)
    exports['dxLibary']:dxLibary_createButton('Anuluj', 1001/scale, 697/scale, 190/scale, 46/scale, tocolor(255, 255, 255, 255), false)

    local id = getElementData(vehicle, 'vehicle:id') or 0
    local model = getVehicleName(vehicle)
    local cost = 10
    local plate = getVehiclePlateText(vehicle)
    local owner = getElementData(vehicle, 'vehicle:ownerName') or '?'
    exports['dxLibary']:dxLibary_text('Informacje dot. pojazdu:\nID pojazdu: '..id..'\nModel: '..model..'\nOpłata: '..cost..'$\nRejestracja: '..plate..'\nWłaściciel: '..owner..'\n\nPamiętaj że opłata jest liczona\nza jedną godzinę przechowywania.', 720/scale + 1, 610/scale + 1, 1201/scale + 1, 475/scale + 1, tocolor(0, 0, 0, 255), 2, 'default', 'center', 'center', false, false, false, true, false)  
    exports['dxLibary']:dxLibary_text('#939393Informacje dot. pojazdu:\n#ffffffID pojazdu: #69bceb'..id..'#ffffff\nModel: #69bceb'..model..'#ffffff\nOpłata: #69bceb'..cost..'$#ffffff\nRejestracja: #69bceb'..plate..'#ffffff\nWłaściciel: #69bceb'..owner..'\n\nPamiętaj że opłata jest liczona\nza jedną godzinę przechowywania.', 720/scale, 610/scale, 1201/scale, 475/scale, tocolor(255, 255, 255, 255), 2, 'default', 'center', 'center', false, false, false, true, false)  
end

local function clicked(btn,state)
    if btn ~= 'state' and state ~= 'down' then return end
    
    if isMouseIn(730/scale, 697/scale, 190/scale, 46/scale) then
        if vehicle and isElement(vehicle) then
            removeEventHandler('onClientRender', root, gui)
            removeEventHandler('onClientClick', root, clicked)
            showCursor(false)
            triggerServerEvent('wloz:auto', resourceRoot, vehicle)
            vehicle = false
            setElementData(localPlayer, 'grey_shader', 0)
            setElementData(localPlayer, 'pokaz:hud', true)
            showChat(true)
        end
    elseif isMouseIn(1001/scale, 697/scale, 190/scale, 46/scale) then
        removeEventHandler('onClientRender', root, gui)
        removeEventHandler('onClientClick', root, clicked)
        showCursor(false)
        vehicle = false
        setElementData(localPlayer, 'grey_shader', 0)
        setElementData(localPlayer, 'pokaz:hud', true)
        showChat(true)
    end
end

addEvent('gui:show', true)
addEventHandler('gui:show', resourceRoot, function(v, cost)
    vehicle = v

    addEventHandler('onClientRender', root, gui)
    addEventHandler('onClientClick', root, clicked)
    showCursor(true)
    setElementData(localPlayer, 'grey_shader', 1)
    setElementData(localPlayer, 'pokaz:hud', false)
    showChat(false)
end)