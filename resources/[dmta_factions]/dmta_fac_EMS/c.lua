--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local screenW, screenH = guiGetScreenSize()
local noti = exports.dmta_base_notifications

local screenW, screenH = guiGetScreenSize()
local sx, sy = guiGetScreenSize()
local px, py = screenW/1440, screenH/900

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

local frakcja = "EMS"
local lider = "Dyrektor_Szpitala"
local vlider = "Zastepca_Dyrektora"

local sx, sy = guiGetScreenSize()
local px, py = sx/1440, sy/900
local topka = { }
local pracownicy = { }
local font1 = dxCreateFont("cz.ttf", 14)
local font2 = dxCreateFont("cz.ttf", 14)
local dx = exports.dxLibary

local okno1 = false
local okno2 = false
local lista = false
local edytowanie = false
local dodawanie = false

function scale_x(value)
    local result = (value / 1440) * sx

    return result
end

function scale_y(value)
    local result = (value / 900) * sy

    return result
end

function gsluzby()
    dxDrawImage(screenW * 0.3821, screenH * 0.2604, screenW * 0.2365, screenH * 0.4805, ":dmta_fac_EMS/bg.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
    local sluzba = getElementData(localPlayer, 'user:faction')
    if getElementData(localPlayer, "user:faction") then
    dx:dxLibary_createButton("Zakończ", screenW * 0.4714, screenH * 0.6888, screenW * 0.0571, screenH * 0.0391, tocolor(255, 255, 255, 255), false)
    else
    dx:dxLibary_createButton("Rozpocznij", screenW * 0.4714, screenH * 0.6888, screenW * 0.0571, screenH * 0.0391, tocolor(255, 255, 255, 255), false)
    end
    local x,y,w,h = exports['dxLibary']:dxLibary_formatTextPosition(1148/scale, 291/scale, 22/scale, 22/scale)
		if mysz(1148/scale, 291/scale, 22/scale, 22/scale) then
			exports['dxLibary']:dxLibary_text('  X', x, y, w, h, tocolor(255, 0, 0, a), 5, 'default', 'center', 'center', false, false, false, false, false)
		else
			exports['dxLibary']:dxLibary_text('  X', x, y, w, h, tocolor(150, 150, 150, a), 5, 'default', 'center', 'center', false, false, false, false, false)
		end
    for i, v in ipairs(topka) do
    	local dodatekY = (scale_y(43))*(i-1)
    	local czas = ""..mth(v.minuty)[1].."h "..mth(v.minuty)[2].."m"
    	shadowText(v.nick, screenW * 0.4019, screenH * 0.4531+(dodatekY*2), screenW * 0.5190, screenH * 0.4857, tocolor(150, 150, 150, 255), 1.00, font2, "left", "center", false, false, false, false, false)
    	shadowText(czas, screenW * 0.5249, screenH * 0.4518+(dodatekY*2), screenW * 0.5944, screenH * 0.4870, tocolor(150, 150, 150, 255), 1.00, font2, "left", "center", false, false, false, false, false)
    end
end

addEvent("gui:sluzba:"..frakcja.."", true)
addEventHandler("gui:sluzba:"..frakcja.."", root, function(tabelka)
	topka = tabelka
	addEventHandler("onClientRender", root, gsluzby)
	okno1 = true
    showCursor(true)
    setElementData(localPlayer, "hud", true)
    showChat(false)
    executeCommandHandler("radar")
    setElementData(localPlayer, "player:blackwhite", true)
end)


addEventHandler("onClientClick", root, function(btn, state)
  if btn == "left" and state == "down" then
    if mysz(screenW * 0.4714, screenH * 0.6888, screenW * 0.0571, screenH * 0.0391) and okno1 == true then
        triggerServerEvent("rozpocznijSluzbe:"..frakcja.."", localPlayer)
        removeEventHandler("onClientRender", root, gsluzby)
        showCursor(false)
        setElementData(localPlayer, "hud", false)
        showChat(true)
        executeCommandHandler("radar")
        setElementData(localPlayer, "player:blackwhite", false)
        okno1 = false
    elseif mysz(1148/scale, 291/scale, 22/scale, 22/scale) and okno1 == true then
        removeEventHandler("onClientRender", root, gsluzby)
        showCursor(false)
        setElementData(localPlayer, "hud", false)
        showChat(true)
        executeCommandHandler("radar")
        setElementData(localPlayer, "player:blackwhite", false)
        okno1 = false
    end
  end
end)

-- panel lidera

local k = 1
local n = 5
local m = 5

edit1 = guiCreateEdit(0.443, 0.52, 0.11, 0.04, "", true)
edit2 = guiCreateEdit(0.443, 0.57, 0.11, 0.04, "", true)  
guiSetVisible(edit1, false) 
guiSetVisible(edit2, false) 

function glidera()
    dxDrawImage(screenW * 0.2789, screenH * 0.2682, screenW * 0.4429, screenH * 0.4635, ":dmta_fac_EMS/bg2.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
    if lista == true then
        dx:dxLibary_createButton("Dodaj", screenW * 0.6545, screenH * 0.6719, screenW * 0.0571, screenH * 0.0391, tocolor(255, 255, 255, 255), false)
    elseif edytowanie ~= false then
        dx:dxLibary_createButton("Edytuj", screenW * 0.6545, screenH * 0.6719, screenW * 0.0571, screenH * 0.0391, tocolor(255, 255, 255, 255), false)
    elseif dodawanie == true then
        dx:dxLibary_createButton("Potwierdź", screenW * 0.6545, screenH * 0.6719, screenW * 0.0571, screenH * 0.0391, tocolor(255, 255, 255, 255), false)
    end
    local x,y,w,h = exports['dxLibary']:dxLibary_formatTextPosition(screenW * 0.7035, screenH * 0.2813, screenW * 0.0110, screenH * 0.024)
		if mysz(screenW * 0.7035, screenH * 0.2813, screenW * 0.0110, screenH * 0.024) then
			exports['dxLibary']:dxLibary_text(' X', x, y, w, h, tocolor(255, 0, 0, a), 5, 'default', 'center', 'center', false, false, false, false, false)
		else
			exports['dxLibary']:dxLibary_text(' X', x, y, w, h, tocolor(150, 150, 150, a), 5, 'default', 'center', 'center', false, false, false, false, false)
		end
    
    if lista == true then
    	local x = 0
        for i, v in ipairs(pracownicy) do
        	if i >= k and i <= n then 
        		x = x+1
                local dodatekY = (60*py)*(x-1)
                local dodatekY2 = (120*py)*(x-1)
            	local czas = ""..mth(v.minuty)[1].."h "..mth(v.minuty)[2].."m"

        		dxDrawText(v.nick, screenW * 0.2899, screenH * 0.3438+(dodatekY*2), screenW * 0.4334, screenH * 0.3867, tocolor(150, 150, 150, 255), 1.00, font2, "left", "center", false, false, false, false, false)
        		dxDrawText(v.ranga, screenW * 0.4407, screenH * 0.3438+(dodatekY*2), screenW * 0.5586, screenH * 0.3867, tocolor(150, 150, 150, 255), 1.00, font2, "left", "center", false, false, false, false, false)
        		dxDrawText(v.wyplata, screenW * 0.5659, screenH * 0.3438+(dodatekY*2), screenW * 0.6332, screenH * 0.3867, tocolor(150, 150, 150, 255), 1.00, font2, "left", "center", false, false, false, false, false)
        		dxDrawText(czas, screenW * 0.6471, screenH * 0.3438+(dodatekY*2), screenW * 0.6991, screenH * 0.3867, tocolor(150, 150, 150, 255), 1.00, font2, "left", "center", false, false, false, false, false)
                dx:dxLibary_createButton("X", screenW * 0.6969, screenH * 0.3477+dodatekY, screenW * 0.0146, screenH * 0.0260, 5)
                dx:dxLibary_createButton("X", screenW * 0.6969, screenH * 0.3477+dodatekY, screenW * 0.0146, screenH * 0.0260, 5)
                dx:dxLibary_createButton("Edytuj", screenW * 0.7321, screenH * 0.3477+dodatekY, screenW * 0.0571, screenH * 0.0391, tocolor(255, 255, 255, 255), false)
        	end
        end
    end
    if edytowanie ~= false then
        shadowText("Edytujesz pracownika: "..edytowanie.."", scale_x(401), scale_y(288), scale_x(1038), scale_y(455), tocolor(255, 255, 255, 255), 1.00, font2, "center", "bottom", false, false, false, false, false)
        shadowText("Wypłata (150-500 $):", scale_x(488), scale_y(464), scale_x(621), scale_y(501), tocolor(255, 255, 255, 255), 1.00, font2, "right", "center", false, false, false, false, false)
        shadowText("Ranga:", scale_x(488), scale_y(510), scale_x(621), scale_y(547), tocolor(255, 255, 255, 255), 1.00, font2, "right", "center", false, false, false, false, false)
    end
    if dodawanie == true then
        shadowText("Dodawanie nowych pracowników do frakcji", scale_x(401), scale_y(288), scale_x(1038), scale_y(455), tocolor(255, 255, 255, 255), 1.00, font2, "center", "bottom", false, false, false, false, false)
        shadowText("Nazwa użytkownika: ", scale_x(488), scale_y(464), scale_x(621), scale_y(501), tocolor(255, 255, 255, 255), 1.00, font2, "right", "center", false, false, false, false, false)
    end
end

addEvent("gui:lidera:"..frakcja.."", true)
addEventHandler("gui:lidera:"..frakcja.."", root, function(tab)
    pracownicy = tab
    addEventHandler("onClientRender", root, glidera)
    okno2 = true
    lista = true
    showCursor(true)
    setElementData(localPlayer, "hud", true)
    showChat(false)
    executeCommandHandler("radar")
    setElementData(localPlayer, "player:blackwhite", true)
end)

addEventHandler("onClientClick", root, function(btn, state)
  if btn == "left" and state == "down" then
  	local x = 0
    for i,v in ipairs(pracownicy) do
        if i >= k and i <= n then 
           x = x+1
            local dodatekY = (60*py)*(x-1)
            if mysz(screenW * 0.7321, screenH * 0.3477+dodatekY, screenW * 0.0571, screenH * 0.0391) and okno2 == true and lista == true then
                if getElementData(localPlayer, "frakcja:ranga") == vlider then 
                    if v.ranga == lider or v.ranga == vlider then
                        noti:addNotification('Nie możesz edytować vlidera/lidera.', 'error')
                    return end
                end
                lista = false
                edytowanie = v.nick
                guiSetVisible(edit1, true)
                guiSetVisible(edit2, true)
                guiSetText(edit1, v.wyplata)
                guiSetText(edit2, v.ranga)
            elseif mysz(screenW * 0.6969, screenH * 0.3477+dodatekY, screenW * 0.0146, screenH * 0.0260) and okno2 == true and lista == true then
                if v.ranga == lider then noti:addNotification('Nie możesz usunąć lidera z frakcji.', 'error') return end
                if v.ranga == vlider then
                    if getElementData(localPlayer, "frakcja:ranga") == lider then
                        triggerServerEvent("usunPracownika:"..frakcja.."", localPlayer, v.nick)
                        noti:addNotification('Usunięto '..v.nick..' z frakcji.', 'info')
                        table.remove(pracownicy, i)
                    else
                        noti:addNotification('Nie możesz usunąć vlidera z frakcji.', 'error')
                        return end
                end
                triggerServerEvent("usunPracownika:"..frakcja.."", localPlayer, v.nick)
                noti:addNotification('Usunięto '..v.nick..' z frakcji.', 'error')
                table.remove(pracownicy, i)
            end
        end
    end         
    if mysz(scale_x(1015), scale_y(256), scale_x(16), scale_y(16)) and okno2 == true then
        removeEventHandler("onClientRender", root, glidera)
        showCursor(false)
        setElementData(localPlayer, "hud", false)
        showChat(true)
        executeCommandHandler("radar")
        setElementData(localPlayer, "player:blackwhite", false)
        okno1 = false
        lista = false
        edytowanie = false
        dodawanie = false
        guiSetVisible(edit1, false)
        guiSetVisible(edit2, false)
    elseif mysz(screenW * 0.6545, screenH * 0.6719, screenW * 0.0571, screenH * 0.0391) and okno2 == true and edytowanie ~= false then
        if not tonumber(guiGetText(edit1)) then noti:addNotification('Wypłata nie jest liczbą!', 'error') return end
        if tonumber(guiGetText(edit1)) > 500 or tonumber(guiGetText(edit1)) < 150 then 
            noti:addNotification('Wypłata musi być wieksza niż 150 $ i mniejsza niż 500 $', 'error')
        return end
        triggerServerEvent("edytujPracownika:"..frakcja.."", localPlayer, edytowanie, guiGetText(edit1), guiGetText(edit2))
        noti:addNotification('Edytowano pracownika: '..edytowanie..'.', 'info')
    elseif mysz(screenW * 0.6545, screenH * 0.6719, screenW * 0.0571, screenH * 0.0391) and okno2 == true and lista == true then
        lista = false
        dodawanie = true
        guiSetText(edit1, "")
        guiSetVisible(edit1, true)
    elseif mysz(screenW * 0.6545, screenH * 0.6719, screenW * 0.0571, screenH * 0.0391) and okno2 == true and dodawanie == true then
        triggerServerEvent("dodajPracownika:"..frakcja.."", localPlayer, guiGetText(edit1))
    end
  end
end)

bindKey("mouse_wheel_down", "both", function()
	if okno2 ~= true then return end
	if n >= #pracownicy then return end
	k = k+1
	n = n+1
end)

bindKey("mouse_wheel_up", "both", function()
	if okno2 ~= true then return end
	if n == m then return end
	k = k-1
	n = n-1
end)



--opcje

function mth(minutes)
	local h = math.floor(minutes/60)
	local m = minutes - (h*60)
	return {h,m}
end

function shadowText(text,x,y,w,h,color,size,font,xx,yy,x1,x2,x3,x4,x5)
    dxDrawText(text,x+1,y+1,w+1,h+1,tocolor(0,0,0),size,font,xx,yy,x1,x2,x3,x4,x5)
    dxDrawText(text,x,y,w,h,color,size,font,xx,yy,x1,x2,x3,x4,x5)
end

function mysz(psx,psy,pssx,pssy,abx,aby)
    if not isCursorShowing() then return end
    cx,cy=getCursorPosition()
    cx,cy=cx*sx,cy*sy
    if cx >= psx and cx <= psx+pssx and cy >= psy and cy <= psy+pssy then
        return true,cx,cy
    else
        return false
    end
end

-- bagaznik

local okno3 = false

function gbagaznik()
    dxDrawImage(screenW * 0.3638, screenH * 0.3411, screenW * 0.2731, screenH * 0.3190, ":dmta_fac_EMS/bg3.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
    if mysz(screenW * 0.3953, screenH * 0.4310, screenW * 0.0754, screenH * 0.0521) then
        dxDrawImage(screenW * 0.3953, screenH * 0.4310, screenW * 0.0754, screenH * 0.0521, ":smta_base_businesses/gfx/button_on.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
    else
        dxDrawImage(screenW * 0.3953, screenH * 0.4310, screenW * 0.0754, screenH * 0.0521, ":smta_base_businesses/gfx/button_off.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
    end
    if mysz(screenW * 0.5315, screenH * 0.4310, screenW * 0.0754, screenH * 0.0521) then
        dxDrawImage(screenW * 0.5315, screenH * 0.4310, screenW * 0.0754, screenH * 0.0521, ":smta_base_businesses/gfx/button_on.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
    else
        dxDrawImage(screenW * 0.5315, screenH * 0.4310, screenW * 0.0754, screenH * 0.0521, ":smta_base_businesses/gfx/button_off.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
    end
    if mysz(screenW * 0.3953, screenH * 0.5352, screenW * 0.0754, screenH * 0.0521) then
        dxDrawImage(screenW * 0.3953, screenH * 0.5352, screenW * 0.0754, screenH * 0.0521, ":smta_base_businesses/gfx/button_on.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
    else
        dxDrawImage(screenW * 0.3953, screenH * 0.5352, screenW * 0.0754, screenH * 0.0521, ":smta_base_businesses/gfx/button_off.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
    end
    if mysz(screenW * 0.5315, screenH * 0.5352, screenW * 0.0754, screenH * 0.0521) then
        dxDrawImage(screenW * 0.5315, screenH * 0.5352, screenW * 0.0754, screenH * 0.0521, ":smta_base_businesses/gfx/button_on.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
    else
        dxDrawImage(screenW * 0.5315, screenH * 0.5352, screenW * 0.0754, screenH * 0.0521, ":smta_base_businesses/gfx/button_off.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
    end
    if mysz(screenW * 0.6186, screenH * 0.3542, screenW * 0.0110, screenH * 0.0247) then
        dxDrawImage(screenW * 0.6186, screenH * 0.3542, screenW * 0.0110, screenH * 0.0247, ":smta_veh_stations/gfx/close_on.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
    else
        dxDrawImage(screenW * 0.6186, screenH * 0.3542, screenW * 0.0110, screenH * 0.0247, ":smta_veh_stations/gfx/close_off.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
    end
    shadowText("Nosze", screenW * 0.3960, screenH * 0.4310, screenW * 0.4707, screenH * 0.4831, tocolor(150, 150, 150, 255), 1.00, font2, "center", "center", false, false, false, false, false)
    shadowText("Torba R1", screenW * 0.5315, screenH * 0.4310, screenW * 0.6061, screenH * 0.4831, tocolor(150, 150, 150, 255), 1.00, font2, "center", "center", false, false, false, false, false)
    shadowText("Spray", screenW * 0.3960, screenH * 0.5352, screenW * 0.4707, screenH * 0.5872, tocolor(150, 150, 150, 255), 1.00, font2, "center", "center", false, false, false, false, false)
    shadowText("Blokady", screenW * 0.5315, screenH * 0.5352, screenW * 0.6061, screenH * 0.5872, tocolor(150, 150, 150, 255), 1.00, font2, "center", "center", false, false, false, false, false)
end

addEvent("pokazBagaznik:"..frakcja.."", true)
addEventHandler("pokazBagaznik:"..frakcja.."", root, function(mark)
    okno3 = true
    showCursor(true)
    addEventHandler("onClientRender", root, gbagaznik)
    marker = mark
end)

addEvent("usunBagaznik:"..frakcja.."", true)
addEventHandler("usunBagaznik:"..frakcja.."", root, function()
    okno3 = false
    showCursor(false)
    removeEventHandler("onClientRender", root, gbagaznik)
    marker = false
end)

addEventHandler("onClientClick", root, function(btn, state)
  if btn == "left" and state == "down" then
    if mysz(screenW * 0.3953, screenH * 0.4310, screenW * 0.0754, screenH * 0.0521) and okno3 == true then
        triggerServerEvent("wezNosze:"..frakcja.."", localPlayer, getElementData(marker, "nosze"), getElementData(marker, "pojazd"), marker)
    --elseif mysz(935*px, 508*py, 143*px, 52*py) and okno3 == true then
        --triggerServerEvent("wezSzyny:"..frakcja.."", localPlayer)
    elseif mysz(screenW * 0.5315, screenH * 0.4310, screenW * 0.0754, screenH * 0.0521) and okno3 == true then
        triggerServerEvent("wezTorbe:"..frakcja.."", localPlayer)
    elseif mysz(screenW * 0.6186, screenH * 0.3542, screenW * 0.0110, screenH * 0.0247) and okno3 == true then
        removeEventHandler("onClientRender", root, gbagaznik)
        showCursor(false)
        okno3 = false
        triggerServerEvent("zamknijDrzwi:"..frakcja.."", localPlayer, getElementData(marker, "pojazd"))
    elseif mysz(screenW * 0.3953, screenH * 0.5352, screenW * 0.0754, screenH * 0.0521) and okno3 == true then
    	triggerServerEvent("dajSpray:"..frakcja.."", localPlayer)
    	exports["smta_base_nofications"]:noti("Bierzesz spray z bagażnika")
    --elseif mysz(935*px, 446*py, 143*px, 52*py) and okno3 == true then
    	--triggerServerEvent("wezLP:"..frakcja.."", localPlayer)
    elseif mysz(screenW * 0.5315, screenH * 0.5352, screenW * 0.0754, screenH * 0.0521) and okno3 == true then
    	if getElementData(localPlayer, "maBlokady") then
        	triggerEvent("schowaj:blokady", localPlayer)
    	else
       		triggerEvent("daj:blokady", localPlayer)
    	end
    end
  end
end)

------- NOSZE -----------

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
    if 
        type( sEventName ) == 'string' and 
        isElement( pElementAttachedTo ) and 
        type( func ) == 'function' 
    then
        local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
        if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
            for i, v in ipairs( aAttachedFunctions ) do
                if v == func then
                    return true
                end
            end
        end
    end

    return false
end
--


local data = {object = nil, player = nil}

function deleteRotation()
    if isEventHandlerAdded( 'onClientPreRender', root, changeRotation ) then
        removeEventHandler( 'onClientPreRender', root, changeRotation )
    end
end
addEvent("nosze:usunRotacje", true)
addEventHandler("nosze:usunRotacje", root, deleteRotation)

function changeRotation()
    if not data.player then deleteRotation() end
    if not data.object then deleteRotation() end
    local rotation = {getElementRotation(data.object)}
    data.player.rotation = Vector3(rotation[1], rotation[2], rotation[3]+90)
end



addEvent("nosze:rotacja", true)
addEventHandler("nosze:rotacja", root, function(player, object)
    data.object = object
    data.player = player
    addEventHandler("onClientPreRender", root, changeRotation)
end)

--opcje

function mth(minutes)
	local h = math.floor(minutes/60)
	local m = minutes - (h*60)
	return {h,m}
end

function shadowText(text,x,y,w,h,color,size,font,xx,yy,x1,x2,x3,x4,x5)
    dxDrawText(text,x+1,y+1,w+1,h+1,tocolor(0,0,0),size,font,xx,yy,x1,x2,x3,x4,x5)
    dxDrawText(text,x,y,w,h,color,size,font,xx,yy,x1,x2,x3,x4,x5)
end

function mysz(psx,psy,pssx,pssy,abx,aby)
    if not isCursorShowing() then return end
    cx,cy=getCursorPosition()
    cx,cy=cx*sx,cy*sy
    if cx >= psx and cx <= psx+pssx and cy >= psy and cy <= psy+pssy then
        return true,cx,cy
    else
        return false
    end
end