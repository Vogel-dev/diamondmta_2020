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

function isMouseIn(x, y, w, h)
	if not isCursorShowing() then return end

	local pos = {getCursorPosition()}
	pos[1],pos[2] = (pos[1]*sw),(pos[2]*sh)

	if pos[1] >= x and pos[1] <= (x+w) and pos[2] >= y and pos[2] <= (y+h) then
		return true
	end
	return false
end

function formatMoney(money)
    while true do
        money, i = string.gsub(money, '^(-?%d+)(%d%d%d)', '%1,%2')
        if i == 0 then
            break
        end
    end
    return money
end

local dxLibary = exports.dxLibary
local noti = exports.dmta_base_notifications
local editbox = exports.editbox

function gui()
	if not isPedInVehicle(localPlayer) then
	    showCursor(false)
	    removeEventHandler('onClientRender', root, gui)
	    removeEventHandler('onClientClick', root, clicked)
	    editbox:destroyCustomEditbox('EDITBOX:GIELDA')
		return
	end
	dxDrawRectangle(0, 0, 1920, 1080, tocolor(15, 15, 15, 200), false)

    dxLibary:dxLibary_createWindow(667/scale, 411/scale, 586/scale, 260/scale, 255)
    dxLibary:dxLibary_text('#69bcebGiełda pojazdów', 667/scale, 411/scale, 1253/scale, 459/scale, tocolor(0, 100, 255, 255), 6, 'default', 'center', 'center', false, false, false, true, false)
    dxLibary:dxLibary_text('Poniżej wprowadź cene, za którą chcesz\nwystawić swój pojazd na giełdzie.', 667/scale, 469/scale, 1253/scale, 550/scale, tocolor(255, 255, 255, 255), 2, 'default', 'center', 'center', false, false, false, false, false)
    dxLibary:dxLibary_createButton('Wystaw pojazd', 782/scale, 615/scale, 174/scale, 40/scale, 2)
    dxLibary:dxLibary_createButton('Anuluj', 974/scale, 615/scale, 174/scale, 40/scale, 2)
end

local info = {
	owner = '',
	text = '',
	veh = nil,
}

function info_panel()
	dxDrawRectangle(0, 0, 1920, 1080, tocolor(15, 15, 15, 200), false)
	if not info.veh or info.veh and not isElement(info.veh) or info.veh and isElement(info.veh) and not getElementData(info.veh, 'vehicle:sell') then
		removeEventHandler('onClientRender', root, info_panel)
		removeEventHandler('onClientClick', root, click_panel)
		setElementFrozen(localPlayer, false)
		showCursor(false)	
		showChat(true)
		setElementData(localPlayer, 'grey_shader', 0)
		setElementData(localPlayer, 'pokaz:hud', true)
		return
	end

    dxLibary:dxLibary_createWindow(738/scale, 330/scale, 444/scale, 421/scale, 255)
    dxLibary:dxLibary_text('#69bcebPanel sprzedaży', 811/scale, 340/scale, 1109/scale, 381/scale, tocolor(255, 255, 255, 255), 5, 'default', 'center', 'center', false, false, false, true, false)
    dxLibary:dxLibary_text('#939393Informacje dt. pojazdu:#ffffff\n'..info.text, 748/scale, 380/scale, 1172/scale, 668/scale, tocolor(255, 255, 255, 255), 1, 'default', 'center', 'center', false, false, false, true, false)
    
    local text = info.owner == getPlayerName(localPlayer) and 'Zabierz pojazd' or 'Zakup pojazd'
    dxLibary:dxLibary_createButton(text, 765/scale, 678/scale, 188/scale, 47/scale, 2, 255)
    dxLibary:dxLibary_createButton('Anuluj', 974/scale, 678/scale, 188/scale, 47/scale, 2, 255)
end

function click_panel(button, state)
	if button ~= 'left' or state ~= 'down' then return end

	local text = info.owner == getPlayerName(localPlayer) and 'Zabierz pojazd' or 'Zakup pojazd'
	if isMouseIn(974/scale, 678/scale, 188/scale, 47/scale) then
		removeEventHandler('onClientRender', root, info_panel)
		removeEventHandler('onClientClick', root, click_panel)
		setElementFrozen(localPlayer, false)
		showCursor(false)
		showChat(true)
		setElementData(localPlayer, 'grey_shader', 0)
		setElementData(localPlayer, 'pokaz:hud', true)
	elseif isMouseIn(765/scale, 678/scale, 188/scale, 47/scale) then
		if text == 'Zabierz pojazd' then
			setElementPosition(info.veh, 1818.2474365234,-2054.8342285156,13.3828125)
			setElementRotation(info.veh, 0, 0, 180)	
			setElementData(info.veh, 'vehicle:sell', false)
			triggerServerEvent('destroy', resourceRoot, info.veh)
		elseif text == 'Zakup pojazd' then
			triggerServerEvent('kup:pojazd', resourceRoot, info.veh)
		end

		removeEventHandler('onClientRender', root, info_panel)
		removeEventHandler('onClientClick', root, click_panel)
		setElementFrozen(localPlayer, false)
		showCursor(false)
		showChat(true)
		setElementData(localPlayer, 'grey_shader', 0)
		setElementData(localPlayer, 'pokaz:hud', true)
	end
end

addEvent('open:gui', true)
addEventHandler('open:gui', resourceRoot, function()
	local veh = getPedOccupiedVehicle(localPlayer)

	if getElementData(veh, 'vehicle:sell') then
		noti:addNotification('Pojazd w którym się znajdujesz, został już wystawiony na giełdzie.', 'error')
		return
	end

	if not getElementData(veh, 'vehicle:id') then
		noti:addNotification('Pojazd w którym się znajdujesz, nie jest prywatny.', 'error')
	   	return
	end

	if getElementHealth(veh) < 1000 then
	    noti:addNotification('Nie możesz wystawić niesprawnego pojazdu.', 'error')
		return
	end

	if (getElementData(localPlayer, 'user:dbid') ~= getElementData(veh, 'vehicle:owner')) then
	    noti:addNotification('Pojazd w którym się znajdujesz, nie należy do Ciebie.', 'error')
	    return
	end

	editbox:createCustomEditbox('EDITBOX:GIELDA', 'Wprowadź cene...', 825/scale, 551/scale, 271/scale, 35/scale, false, '', true)
	addEventHandler('onClientRender', root, gui)
	addEventHandler('onClientClick', root, clicked)
	showCursor(true)
	setElementFrozen(veh, true)
end)

addEvent('show:gui', true)
addEventHandler('show:gui', resourceRoot, function(veh)
	local sell = getElementData(veh, 'vehicle:sell')
	if not sell then return end

	info = {
		owner = sell.owner,
		text = '- ID: #69bceb'..getElementData(veh, 'vehicle:id')..'#ffffff\n- Model: #69bceb'..getVehicleName(veh)..'#ffffff\n- Cena: #69bceb'..formatMoney(sell.cost)..'$#ffffff\n- Przebieg: #69bceb'..string.format('%.1f', getElementData(veh, 'vehicle:distance'))..'km#ffffff\n- Bak: #69bceb'..getElementData(veh, 'vehicle:bak')..'L#ffffff\n- Pojemność silnika: #69bceb'..getElementData(veh, 'vehicle:engine')..'dm³#ffffff\n- Rodzaj silnika: #69bceb'..(getElementData(veh, 'vehicle:type') == 'LPG' and 'Benzyna' or getElementData(veh, 'vehicle:type'))..'#ffffff\n- Instalacja LPG:#69bceb '..(getElementData(veh, 'vehicle:type') == 'LPG' and 'tak' or 'nie')..'#ffffff\n- Napęd: #69bceb'..getVehicleHandling(veh).driveType..'#ffffff\n- Właściciel: #69bceb'..sell.owner,
		veh = veh,
	}

	addEventHandler('onClientRender', root, info_panel)
	addEventHandler('onClientClick', root, click_panel)
	setElementFrozen(localPlayer, true)
	showCursor(true)
	showChat(false)
	setElementData(localPlayer, 'grey_shader', 1)
	setElementData(localPlayer, 'pokaz:hud', false)
end)

function clicked(btn, state)
	if btn ~= 'left' or state ~= 'down' then return end

	local v = getPedOccupiedVehicle(localPlayer)
    if isMouseIn(974/scale, 615/scale, 174/scale, 46/scale) and v then
      	showCursor(false)
     	removeEventHandler('onClientRender', root, gui)
      	removeEventHandler('onClientClick', root, clicked)
      	editbox:destroyCustomEditbox('EDITBOX:GIELDA')
      	setElementFrozen(v, false)
    elseif isMouseIn(782/scale, 615/scale, 174/scale, 46/scale) and v then
	  	local cena = editbox:getCustomEditboxText('EDITBOX:GIELDA') or ''
		if not tonumber(cena) then
			noti:addNotification('Wprowadź poprawną cene.', 'error')
			return
		end

		if cena:len() < 2 then
			noti:addNotification('Cena pojazdu powinna zawierać minimum 2 liczby.', 'error')
			return
		end

		if cena:len() > 7 then
	    	noti:addNotification('Cena pojazdu powinna zawierać minimum 7 liczb.', 'error')
			return
		end

		if tonumber(cena) <= 1 then
			noti:addNotification('Cena pojazdu powinna zawierać minimum 1 liczbe.', 'error')
			return
		end

		triggerServerEvent('wystaw:pojazd', resourceRoot, v, cena)

	    showCursor(false)
	    removeEventHandler('onClientRender', root, gui)
	    removeEventHandler('onClientClick', root, clicked)
	    editbox:destroyCustomEditbox('EDITBOX:GIELDA')
	    setElementFrozen(v, false)
    end
end

addEventHandler('onClientResourceStop', resourceRoot, function()
    editbox:destroyCustomEditbox('EDITBOX:GIELDA')
end)