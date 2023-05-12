--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local screenW, screenH = guiGetScreenSize()
local sx, sy = guiGetScreenSize()
local px, py = screenW/1440, screenH/900
local font = dxCreateFont("cz.ttf", 13)
local font2 = dxCreateFont("cz.ttf", 21)
--local font = dxCreateFont("cz2.ttf", 25)
--local font2 = dxCreateFont("cz2.ttf", 21)

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

local eq = false
local branie = false
local usuwanie = false
--[[
function info(tekst, rodzaj)
	exports["smta_base_notifications"]:noti(tekst, rodzaj)
end
--]]
local przedmioty = {}

local width = screenW * 0.1852
local height = screenH * 0.2083
local scrollPos = 0
local scrollOffset = 38*py

local maxRender = dxCreateRenderTarget(width, height, true) -- True daje alphe / false - nie daje

function gui()
  exports['dxLibary']:dxLibary_createWindow(25/scale, 462/scale, 399/scale, 313/scale, false)
	dxDrawImage(25/scale, 462/scale, 399/scale, 313/scale, ":dmta_base_eq/gfx/bg.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
    dxSetRenderTarget(maxRender, true)
    for i, v in ipairs(przedmioty) do
    	local dodatekY = (38*py)*(i-1)
    	local dodatekY2 = (76*py)*(i-1)
    	local scroll = scrollPos * scrollOffset
      local scroll2 = (scrollPos * scrollOffset) * 2
      -- if isMouseIn(375/scale, (548/scale+dodatekY)-scroll, 21/scale, 21/scale) then
        -- exports['dxLibary']:dxLibary_text('X', 240/scale, (7/scale+dodatekY)-scroll, 21/scale, 21/scale, tocolor(255, 0, 0, a), 5, 'default', 'center', 'center', false, false, false, false, false)
      -- else
        -- exports['dxLibary']:dxLibary_text('X', 375/scale, (548/scale+dodatekY)-scroll, 21/scale, 21/scale, tocolor(150, 150, 150, a), 5, 'default', 'center', 'center', false, false, false, false, false)
      -- end
      --dxDrawImage(240*px, (7*py+dodatekY)-scroll, 20*px, 20*py, ":smta_base_admin/kosz.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
      shadowText(v.nazwa, 0*px, (0*py+dodatekY2)-scroll2, 286*px, 30*py, tocolor(105, 188, 235, 255), 1.00, font2, "left", "center", false, false, false, false, false)
    end
    dxSetRenderTarget(false)
	dxDrawImage(screenW * 0.0242, screenH * 0.4974, width, height, maxRender)
end

function branieitka()
  --dxDrawImage(screenW * 0.0146, screenH * 0.3307, screenW * 0.1947, screenH * 0.1081, ":dmta_base_eq/gfx/bg2.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
  exports['dxLibary']:dxLibary_createWindow(25/scale, 647/scale, 399/scale, 128/scale, false)
  exports['dxLibary']:dxLibary_createButton(przedmiot_corobic, 61/scale, 711/scale, 125/scale, 50/scale, tocolor(255, 255, 255, 255), false)
  exports['dxLibary']:dxLibary_createButton('Anuluj', 266/scale, 711/scale, 125/scale, 50/scale, tocolor(255, 255, 255, 255), false)
  shadowText(przedmiot_nazwa, screenW * 0.0328, screenH * 0.6093, screenW * 0.2036, screenH * 0.6546, tocolor(150, 150, 150, 255), 1.00, font, "center", "center", false, false, false, false, false)
end

function usuwanieitka()
  --dxDrawImage(screenW * 0.0146, screenH * 0.3307, screenW * 0.1947, screenH * 0.1081, ":dmta_base_eq/gfx/bg2.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
  exports['dxLibary']:dxLibary_createWindow(25/scale, 647/scale, 399/scale, 128/scale, false)
  exports['dxLibary']:dxLibary_createButton('Wyrzuć', 61/scale, 711/scale, 125/scale, 50/scale, tocolor(255, 255, 255, 255), false)
  exports['dxLibary']:dxLibary_createButton('Anuluj', 266/scale, 711/scale, 125/scale, 50/scale, tocolor(255, 255, 255, 255), false)
  shadowText("Potwierdź wyrzucenie przedmiotu:\n "..przedmiot_nazwa, screenW * 0.0328, screenH * 0.6093, screenW * 0.2036, screenH * 0.6546, tocolor(150, 150, 150, 255), 1.00, font, "center", "center", false, false, false, false, false)
end

addEventHandler("onClientClick", root, function(btn, state)
  if btn == "left" and state == "down" then
  	for i,v in ipairs(przedmioty) do
  		local dodatekY = (38*py)*(i-1)
  		local scroll = scrollPos * scrollOffset
  		if mysz(screenW * 0.0176, (screenH * 0.4948+dodatekY)-scroll, screenW * 0.1728, screenH * 0.0443) and mysz(25/scale, 462/scale, 399/scale, 313/scale) and eq == true and branie == false and usuwanie == false then
  			setTimer(function()
  			przedmiot_nazwa = v.nazwa
  			przedmiot_id = v.id
  			branie = true
  			eq = false
  			addEventHandler("onClientRender", root, branieitka)
  			removeEventHandler("onClientRender", root, gui)
  			if przedmiot_nazwa == "Hamburger" or przedmiot_nazwa == "Hotdog" or przedmiot_nazwa == "Kebab" or przedmiot_nazwa == "Kiepowa" or przedmiot_nazwa == "Kanapka z kurczakiem" or przedmiot_nazwa == "Buraki" or przedmiot_nazwa == "Kotlet Schabowy" or przedmiot_nazwa == "Pasta Gringciosso" or przedmiot_nazwa == "Pizza Gringolonni" or przedmiot_nazwa == "Gringamisu" then
  				przedmiot_corobic = "Zjedź"
  			elseif przedmiot_nazwa == "Papieros 'Marlboro Red'" or przedmiot_nazwa == "Cygaretka" then
  				przedmiot_corobic = "Zapal"
        elseif przedmiot_nazwa == "Woda" or przedmiot_nazwa == "Cola" or przedmiot_nazwa == "Wódka 'Rogówka'" or przedmiot_nazwa == "Gringola" then
          przedmiot_corobic = "Wypij"
        elseif przedmiot_nazwa == "Wędka drewniana" or przedmiot_nazwa == "Wędka plastikowa" or przedmiot_nazwa == "Wędka aluminiowa" or przedmiot_nazwa == "Wędka metalowa" then
          if getElementData(localPlayer, "wedka") then
            przedmiot_corobic = "Schowaj"
          else
            przedmiot_corobic = "Wyciągnij"
          end
        elseif przedmiot_nazwa == "Kij baseballowy" then
          if getElementData(localPlayer, "kij") then
            przedmiot_corobic = "Schowaj"
          else
            przedmiot_corobic = "Wyciągnij"
          end
        elseif przedmiot_nazwa == "Noz wojskowy" then
          if getElementData(localPlayer, "noz") then
            przedmiot_corobic = "Schowaj"
          else
            przedmiot_corobic = "Wyciągnij"
          end
        elseif przedmiot_nazwa == "Deagle" then
          if getElementData(localPlayer, "deagle") then
            przedmiot_corobic = "Schowaj"
          else
            przedmiot_corobic = "Wyciągnij"
          end
        elseif przedmiot_nazwa == "Colt 45" then
          if getElementData(localPlayer, "colt45") then
            przedmiot_corobic = "Schowaj"
          else
            przedmiot_corobic = "Wyciągnij"
          end
        elseif przedmiot_nazwa == "Uzi" then
          if getElementData(localPlayer, "uzi") then
            przedmiot_corobic = "Schowaj"
          else
            przedmiot_corobic = "Wyciągnij"
          end
        elseif przedmiot_nazwa == "AK-47" then
          if getElementData(localPlayer, "ak47") then
            przedmiot_corobic = "Schowaj"
          else
            przedmiot_corobic = "Wyciągnij"
          end
        elseif przedmiot_nazwa == "Kastet" then
          if getElementData(localPlayer, "kastet") then
            przedmiot_corobic = "Schowaj"
          else
            przedmiot_corobic = "Wyciągnij"
          end
        elseif przedmiot_nazwa == "Obrzyn" then
          if getElementData(localPlayer, "obrzyn") then
            przedmiot_corobic = "Schowaj"
          else
            przedmiot_corobic = "Wyciągnij"
          end
        elseif przedmiot_nazwa == "Karabin snajperski" then
          if getElementData(localPlayer, "sniper") then
            przedmiot_corobic = "Schowaj"
          else
            przedmiot_corobic = "Wyciągnij"
          end
        elseif przedmiot_nazwa == "Wyrzutnia rakiet" then
          if getElementData(localPlayer, "rakieta") then
            przedmiot_corobic = "Schowaj"
          else
            przedmiot_corobic = "Wyciągnij"
          end
        elseif przedmiot_nazwa == "Molotov" then
          if getElementData(localPlayer, "molotov") then
            przedmiot_corobic = "Schowaj"
          else
            przedmiot_corobic = "Wyciągnij"
          end
        elseif przedmiot_nazwa == "Bomba" then
          if getElementData(localPlayer, "bomba") then
            przedmiot_corobic = "Schowaj"
          else
            przedmiot_corobic = "Wyciągnij"
          end
  			else
  				przedmiot_corobic = "UŻYJ"
  			end
  			end, 50, 1)
      elseif mysz(375/scale, (548/scale+dodatekY)-scroll, 21/scale, 21/scale) and mysz(25/scale, 462/scale, 399/scale, 313/scale) and eq == true and branie == false and usuwanie == false then
        setTimer(function()
          usuwanie = true
          eq = false
          przedmiot_nazwa = v.nazwa
          przedmiot_id = v.id
          addEventHandler("onClientRender", root, usuwanieitka)
          removeEventHandler("onClientRender", root, gui)
        end, 50, 1)
  		end
  	end
    if mysz(266/scale, 711/scale, 125/scale, 50/scale) and branie == true and eq == false and usuwanie == false then
    	removeEventHandler("onClientRender", root, branieitka)
    	branie = false
    	addEventHandler("onClientRender", root, gui)
    	eq = true
    elseif mysz(61/scale, 711/scale, 125/scale, 50/scale) and branie == true and eq == false and usuwanie == false then
    	uzyjPrzedmiot(przedmiot_nazwa, przedmiot_id)
    	removeEventHandler("onClientRender", root, branieitka)
    	branie = false
    	addEventHandler("onClientRender", root, gui)
    	eq = true
    	triggerServerEvent("pokazPrzedmioty:eq", localPlayer)
    elseif mysz(266/scale, 711/scale, 125/scale, 50/scale) and usuwanie == true and eq == false and branie == false then
      removeEventHandler("onClientRender", root, usuwanieitka)
      usuwanie = false
      addEventHandler("onClientRender", root, gui)
      eq = true
    elseif mysz(61/scale, 711/scale, 125/scale, 50/scale) and usuwanie == true and eq == false and branie == false then
      triggerServerEvent("usunPrzedmiot:eq", localPlayer, przedmiot_id)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." wyrzuca na ziemię "..przedmiot_nazwa..".")
      removeEventHandler("onClientRender", root, usuwanieitka)
      usuwanie = false
      addEventHandler("onClientRender", root, gui)
      eq = true
      triggerServerEvent("pokazPrzedmioty:eq", localPlayer)
    end
  end
end)

function uzyjPrzedmiot(nazwa, id)
  if nazwa == "Hamburger" then
    jeszCos(22)
    triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." je hamburgera.")
    if not isPedInVehicle(localPlayer) then
      
    end
    triggerServerEvent("usunPrzedmiot:eq", localPlayer, id)
  elseif nazwa == "Buraki" then
    jeszCos(12)
    triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." je buraki.")
    if not isPedInVehicle(localPlayer) then
      
    end
    triggerServerEvent("usunPrzedmiot:eq", localPlayer, id)
  elseif nazwa == "Kanapka z kurczakiem" then
    jeszCos(25)
    triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." je kanapke z kurczakiem.")
    if not isPedInVehicle(localPlayer) then
      
    end
    triggerServerEvent("usunPrzedmiot:eq", localPlayer, id)
  elseif nazwa == "Kebab" then
    jeszCos(25)
    triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." je kebaba.")
    if not isPedInVehicle(localPlayer) then
      
    end
    triggerServerEvent("usunPrzedmiot:eq", localPlayer, id)
  elseif nazwa == "Hotdog" then
    jeszCos(15)
    triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." je hotdoga.")
    if not isPedInVehicle(localPlayer) then
      
    end
    triggerServerEvent("usunPrzedmiot:eq", localPlayer, id)
  elseif nazwa == "Kotlet Schabowy" then
    jeszCos(51)
    triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." je kotleta schabowego.")
    if not isPedInVehicle(localPlayer) then
      
    end
    triggerServerEvent("usunPrzedmiot:eq", localPlayer, id)
  elseif nazwa == "Kiepowa" then
    jeszCos(51)
    triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." je kiepową.")
    if not isPedInVehicle(localPlayer) then
      
    end
    triggerServerEvent("usunPrzedmiot:eq", localPlayer, id)
  elseif nazwa == "Pasta Gringciosso" then
    jeszCos(39)
    triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." je paste gringciosso.")
    if not isPedInVehicle(localPlayer) then
      
    end
    triggerServerEvent("usunPrzedmiot:eq", localPlayer, id)
  elseif nazwa == "Pizza Gringolonni" then
    jeszCos(65)
    triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." je pizze gringolonni.")
    if not isPedInVehicle(localPlayer) then
      
    end
    triggerServerEvent("usunPrzedmiot:eq", localPlayer, id)
  elseif nazwa == "Gringamisu" then
    jeszCos(18)
    triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." je gringamisu.")
    if not isPedInVehicle(localPlayer) then
      
    end
    triggerServerEvent("usunPrzedmiot:eq", localPlayer, id)
  elseif nazwa == "'Srickers'" then
    jeszCos(18)
    triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." je srickersa.")
    if not isPedInVehicle(localPlayer) then
      
    end
    triggerServerEvent("usunPrzedmiot:eq", localPlayer, id)
  elseif nazwa == "Chipsy 'Stolarvalue'" then
    jeszCos(18)
    triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." je chipsy 'Stolarvalue'.")
    if not isPedInVehicle(localPlayer) then
      
    end
    triggerServerEvent("usunPrzedmiot:eq", localPlayer, id)
  elseif nazwa == "Woda" then
    pijeszCos(20)
    triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." pije wode.")
    if not isPedInVehicle(localPlayer) then
      
    end
    triggerServerEvent("usunPrzedmiot:eq", localPlayer, id)
  elseif nazwa == "Cola" then
    pijeszCos(33)
    triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." otwiera puszkę coli.")
    if not isPedInVehicle(localPlayer) then
      
    end
    triggerServerEvent("usunPrzedmiot:eq", localPlayer, id)
  elseif nazwa == "Piwo 'Kuflowe'" then
    pijeszCos(13)
    triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." otwiera Kuflowe.")
    if not isPedInVehicle(localPlayer) then
      triggerServerEvent("pijButla:eq", localPlayer, localPlayer)
    end
    triggerServerEvent("usunPrzedmiot:eq", localPlayer, id)
  elseif nazwa == "Piwo 'Zubr'" then
    pijeszCos(13)
    triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." otwiera Żubra.")
    if not isPedInVehicle(localPlayer) then
      triggerServerEvent("pijButla:eq", localPlayer, localPlayer)
    end
    triggerServerEvent("usunPrzedmiot:eq", localPlayer, id)
  elseif nazwa == "Piwo 'Desperados'" then
    pijeszCos(13)
    triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." otwiera Desperadosa.")
    if not isPedInVehicle(localPlayer) then
      triggerServerEvent("pijButla:eq", localPlayer, localPlayer)
    end
    triggerServerEvent("usunPrzedmiot:eq", localPlayer, id)
  elseif nazwa == "Wódka 'Rogówka'" then
    pijeszCos(13)
    triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." otwiera 'Rogówkę'.")
    if not isPedInVehicle(localPlayer) then
      triggerServerEvent("pijButla:eq", localPlayer, localPlayer)
    end
    triggerServerEvent("usunPrzedmiot:eq", localPlayer, id)
  elseif nazwa == "'Moet&Chandon'" then
    pijeszCos(13)
    triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." otwiera 'Moet&Chandon'.")
    if not isPedInVehicle(localPlayer) then
      triggerServerEvent("pijButla:eq", localPlayer, localPlayer)
    end
    triggerServerEvent("usunPrzedmiot:eq", localPlayer, id)
  elseif nazwa == "'Jack Daniels'" then
    pijeszCos(13)
    triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." otwiera Jack Daniels'a")
    if not isPedInVehicle(localPlayer) then
      triggerServerEvent("pijButla:eq", localPlayer, localPlayer)
    end
    triggerServerEvent("usunPrzedmiot:eq", localPlayer, id)
  elseif nazwa == "'Finlandia'" then
    pijeszCos(13)
    triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." otwiera Finlandie.")
    if not isPedInVehicle(localPlayer) then
      
    end
    triggerServerEvent("usunPrzedmiot:eq", localPlayer, id)
  elseif nazwa == "Gringola" then
    pijeszCos(45)
    triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." otwiera puszkę gringoli.")
    if not isPedInVehicle(localPlayer) then
      
    end
    triggerServerEvent("usunPrzedmiot:eq", localPlayer, id)
	elseif nazwa == "Papieros 'Marlboro Red'" then
		info("Aby strzepnąć papierosa kliknij 'prawy przycisk myszy'")
    --triggerServerEvent("zapalPapierosa:eq", localPlayer, localPlayer)
    setPedAnimation ( localPlayer, "SMOKING", "M_smk_in", 5400, false, false )
	  setTimer(function () setPedAnimation(localPlayer,false) end,5400,1)
    triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." odpala papierosa Marlboro Red.")
    if not isPedInVehicle(localPlayer) then
      triggerServerEvent("palPeta:eq", localPlayer, localPlayer)
    end
    triggerServerEvent("usunPrzedmiot:eq", localPlayer, id)
  elseif nazwa == "Cygaretka" then
		--info("Aby strzepnąć papierosa kliknij 'prawy przycisk myszy'")
    --triggerServerEvent("zapalPapierosa:eq", localPlayer, localPlayer)
    setPedAnimation ( localPlayer, "SMOKING", "M_smk_in", 5400, false, false )
	  setTimer(function () setPedAnimation(localPlayer,false) end,5400,1)
    triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." odpala cygaretke.")
    if not isPedInVehicle(localPlayer) then
      triggerServerEvent("palPeta:eq", localPlayer, localPlayer)
    end
		triggerServerEvent("usunPrzedmiot:eq", localPlayer, id)

  elseif nazwa == "Wędka drewniana" then
    if getElementData(localPlayer, "wedka") then
      setElementData(localPlayer, "wedka", false)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." chowa wędkę.")
      triggerServerEvent("dajWedke:eq", localPlayer, true)
    else
      setElementData(localPlayer, "wedka", "drewniana")
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." wyciąga i rozkłada wędkę.")
      triggerServerEvent("dajWedke:eq", localPlayer)
    end
  elseif nazwa == "Wędka plastikowa" then
    if getElementData(localPlayer, "wedka") then
      setElementData(localPlayer, "wedka", false)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." chowa wędkę.")
      triggerServerEvent("dajWedke:eq", localPlayer, true)
    else
      setElementData(localPlayer, "wedka", "plastikowa")
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." wyciąga i rozkłada wędkę.")
      triggerServerEvent("dajWedke:eq", localPlayer)
    end
  elseif nazwa == "Wędka aluminiowa" then
    if getElementData(localPlayer, "wedka") then
      setElementData(localPlayer, "wedka", false)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." chowa wędkę.")
      triggerServerEvent("dajWedke:eq", localPlayer, true)
    else
      setElementData(localPlayer, "wedka", "aluminiowa")
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." wyciąga i rozkłada wędkę.")
      triggerServerEvent("dajWedke:eq", localPlayer)
    end
  elseif nazwa == "Wędka metalowa" then
    if getElementData(localPlayer, "wedka") then
      setElementData(localPlayer, "wedka", false)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." chowa wędkę.")
      triggerServerEvent("dajWedke:eq", localPlayer, true)
    else
      setElementData(localPlayer, "wedka", "metalowa")
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." wyciąga i rozkłada wędkę.")
      triggerServerEvent("dajWedke:eq", localPlayer)
    end
  elseif nazwa == "Kominiarka" then
    if getElementData(localPlayer, "kominiarka") then
      setElementData(localPlayer, "kominiarka", false)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." ściąga kominiarkę.")
      triggerServerEvent("dajKij:eq", localPlayer, true)
    else
      setElementData(localPlayer, "kominiarka", true)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." zakłada kominiarkę.")
      triggerServerEvent("dajKij:eq", localPlayer)
    end
  elseif nazwa == "Kij baseballowy" then
    if getElementData(localPlayer, "kij") then
      setElementData(localPlayer, "kij", false)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." chowa kij baseballowy.")
      triggerServerEvent("dajKij:eq", localPlayer, true)
    else
      setElementData(localPlayer, "kij", true)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." wyciąga kij baseballowy.")
      triggerServerEvent("dajKij:eq", localPlayer)
    end
  elseif nazwa == "Noz wojskowy" then
    if getElementData(localPlayer, "noz") then
      setElementData(localPlayer, "noz", false)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." chowa Noz wojskowy.")
      triggerServerEvent("dajNoz:eq", localPlayer, true)
    else
      setElementData(localPlayer, "noz", true)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." wyciąga Noz wojskowy.")
      triggerServerEvent("dajNoz:eq", localPlayer)
    end
  elseif nazwa == "Deagle" then
    if getElementData(localPlayer, "deagle") then
      setElementData(localPlayer, "deagle", false)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." chowa Deagle'a.")
      triggerServerEvent("dajDeagle:eq", localPlayer, true)
    else
      setElementData(localPlayer, "deagle", true)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." wyciąga Deagle'a.")
      triggerServerEvent("dajDeagle:eq", localPlayer)
    end
  elseif nazwa == "Colt 45" then
    if getElementData(localPlayer, "colt45") then
      setElementData(localPlayer, "colt45", false)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." chowa Colt'a 45.")
      triggerServerEvent("dajColt45:eq", localPlayer, true)
    else
      setElementData(localPlayer, "colt45", true)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." wyciąga Colt'a 45.")
      triggerServerEvent("dajColt45:eq", localPlayer)
    end
  elseif nazwa == "Uzi" then
    if getElementData(localPlayer, "uzi") then
      setElementData(localPlayer, "uzi", false)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." chowa Uzi.")
      triggerServerEvent("dajUzi:eq", localPlayer, true)
    else
      setElementData(localPlayer, "uzi", true)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." wyciąga Uzi.")
      triggerServerEvent("dajUzi:eq", localPlayer)
    end
  elseif nazwa == "AK-47" then
    if getElementData(localPlayer, "ak47") then
      setElementData(localPlayer, "ak47", false)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." chowa AK-47.")
      triggerServerEvent("dajAK47:eq", localPlayer, true)
    else
      setElementData(localPlayer, "ak47", true)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." wyciąga AK-47.")
      triggerServerEvent("dajAK47:eq", localPlayer)
    end
  elseif nazwa == "Kastet" then
    if getElementData(localPlayer, "kastet") then
      setElementData(localPlayer, "kastet", false)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." chowa kastet.")
      triggerServerEvent("dajKastet:eq", localPlayer, true)
    else
      setElementData(localPlayer, "kastet", true)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." wyciąga kastet.")
      triggerServerEvent("dajKastet:eq", localPlayer)
    end
  elseif nazwa == "Obrzyn" then
    if getElementData(localPlayer, "obrzyn") then
      setElementData(localPlayer, "obrzyn", false)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." chowa obrzyna.")
      triggerServerEvent("dajObrzyn:eq", localPlayer, true)
    else
      setElementData(localPlayer, "obrzyn", true)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." wyciąga obrzyna.")
      triggerServerEvent("dajObrzyn:eq", localPlayer)
    end
  elseif nazwa == "Karabin snajperski" then
    if getElementData(localPlayer, "sniper") then
      setElementData(localPlayer, "sniper", false)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." chowa karabin snajperski.")
      triggerServerEvent("dajSniper:eq", localPlayer, true)
    else
      setElementData(localPlayer, "sniper", true)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." wyciąga karabin snajperski.")
      triggerServerEvent("dajSniper:eq", localPlayer)
    end
  elseif nazwa == "Wyrzutnia rakiet" then
    if getElementData(localPlayer, "rakieta") then
      setElementData(localPlayer, "rakieta", false)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." chowa wyrzutnie rakiet.")
      triggerServerEvent("dajWyrzutnia:eq", localPlayer, true)
    else
      setElementData(localPlayer, "rakieta", true)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." wyciąga wyrzutnie rakiet.")
      triggerServerEvent("dajWyrzutnia:eq", localPlayer)
    end
  elseif nazwa == "Molotov" then
    if getElementData(localPlayer, "molotov") then
      setElementData(localPlayer, "molotov", false)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." chowa koktajl molotov'a.")
      triggerServerEvent("dajMolotov:eq", localPlayer, true)
    else
      setElementData(localPlayer, "molotov", true)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." wyciąga koktajl molotov'a.")
      triggerServerEvent("dajMolotov:eq", localPlayer)
    end
  elseif nazwa == "Bomba" then
    if getElementData(localPlayer, "bomba") then
      setElementData(localPlayer, "bomba", false)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." chowa bombe przylepną.")
      triggerServerEvent("dajBomba:eq", localPlayer, true)
    else
      setElementData(localPlayer, "bomba", true)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." wyciąga bombe przylepną.")
      triggerServerEvent("dajBomba:eq", localPlayer)
    end
  elseif nazwa == "Nokia 3310" then
    if getElementData(localPlayer, "user:sms") then
      setElementData(localPlayer, "user:sms", false)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." wyłącza telefon 'Nokia 3310'.")
    else
      setElementData(localPlayer, "user:sms", true)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." włącza telefon 'Nokia 3310'.")
    end
  elseif nazwa == "Siemens C65" then
    if getElementData(localPlayer, "user:sms") then
      setElementData(localPlayer, "user:sms", false)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." wyłącza telefon 'Siemens C65'.")
    else
      setElementData(localPlayer, "user:sms", true)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." włącza telefon 'Siemens C65'.")
    end
  elseif nazwa == "Motorola XT 1771" then
    if getElementData(localPlayer, "user:sms") then
      setElementData(localPlayer, "user:sms", false)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." wyłącza telefon 'Motorola XT 1771'.")
    else
      setElementData(localPlayer, "user:sms", true)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." włącza telefon 'Motorola XT 1771'.")
    end
  elseif nazwa == "Samsung Galaxy A10" then
    if getElementData(localPlayer, "user:sms") then
      setElementData(localPlayer, "user:sms", false)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." wyłącza telefon 'Samsung Galaxy A10'.")
    else
      setElementData(localPlayer, "user:sms", true)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." włącza telefon 'Samsung Galaxy A10'.")
    end
  elseif nazwa == "Apple iPhone 6S" then
    if getElementData(localPlayer, "user:sms") then
      setElementData(localPlayer, "user:sms", false)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." wyłącza telefon 'Apple iPhone 6S'.")
    else
      setElementData(localPlayer, "user:sms", true)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." włącza telefon 'Apple iPhone 6S'.")
    end
  elseif nazwa == "Xiaomi MI 9" then
    if getElementData(localPlayer, "user:sms") then
      setElementData(localPlayer, "user:sms", false)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." wyłącza telefon 'Xiaomi MI 9'.")
    else
      setElementData(localPlayer, "user:sms", true)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." włącza telefon 'Xiaomi MI 9'.")
    end
  elseif nazwa == "Apple iPhone 8" then
    if getElementData(localPlayer, "user:sms") then
      setElementData(localPlayer, "user:sms", false)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." wyłącza telefon 'Apple iPhone 8'.")
    else
      setElementData(localPlayer, "user:sms", true)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." włącza telefon 'Apple iPhone 8'.")
    end
  elseif nazwa == "Huawei P30 PRO" then
    if getElementData(localPlayer, "user:sms") then
      setElementData(localPlayer, "user:sms", false)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." wyłącza telefon 'Huawei P30 PRO'.")
    else
      setElementData(localPlayer, "user:sms", true)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." włącza telefon 'Huawei P30 PRO'.")
    end
  elseif nazwa == "Apple iPhone XR" then
    if getElementData(localPlayer, "user:sms") then
      setElementData(localPlayer, "user:sms", false)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." wyłącza telefon 'Apple iPhone XR'.")
    else
      setElementData(localPlayer, "user:sms", true)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." włącza telefon 'Apple iPhone XR'.")
    end
  elseif nazwa == "Apple iPhone XS" then
    if getElementData(localPlayer, "user:sms") then
      setElementData(localPlayer, "user:sms", false)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." wyłącza telefon 'Apple iPhone XS'.")
    else
      setElementData(localPlayer, "user:sms", true)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." włącza telefon 'Apple iPhone XS'.")
    end
  elseif nazwa == "Samsung Galaxy S10" then
    if getElementData(localPlayer, "user:sms") then
      setElementData(localPlayer, "user:sms", false)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." wyłącza telefon 'Samsung Galaxy S10'.")
    else
      setElementData(localPlayer, "user:sms", true)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." włącza telefon 'Samsung Galaxy S10'.")
    end
  elseif nazwa == "Apple iPhone XS Max" then
    if getElementData(localPlayer, "user:sms") then
      setElementData(localPlayer, "user:sms", false)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." wyłącza telefon 'Apple iPhone XS Max'.")
    else
      setElementData(localPlayer, "user:sms", true)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." włącza telefon 'Apple iPhone XS Max'.")
    end
  elseif nazwa == "Apple iPhone 11 Pro" then
    if getElementData(localPlayer, "user:sms") then
      setElementData(localPlayer, "user:sms", false)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." wyłącza telefon 'Apple iPhone 11 Pro'.")
    else
      setElementData(localPlayer, "user:sms", true)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." włącza telefon 'Apple iPhone 11 Pro'.")
    end
  elseif nazwa == "Apple iPhone 11 Pro Max" then
    if getElementData(localPlayer, "user:sms") then
      setElementData(localPlayer, "user:sms", false)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." wyłącza telefon 'Apple iPhone 11 Pro Max'.")
    else
      setElementData(localPlayer, "user:sms", true)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." włącza telefon 'Apple iPhone 11 Pro Max'.")
    end

  elseif nazwa == "Rolex Day-Date Gold Diamond Bezel" then
    triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." sprawdza godzinę na zegarku 'Rolex Day-Date Gold Diamond Bezel'.")
    local timehour, timeminute = getTime()
    outputChatBox("* Na zegarku wskazuje godzine "..timehour..":"..timeminute.."",61, 112, 255, true)
  elseif nazwa == "Casio Classic" then
    triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." sprawdza godzinę na zegarku 'Casio Classic'.")
    local timehour, timeminute = getTime()
    outputChatBox("* Na zegarku wskazuje godzine "..timehour..":"..timeminute.."",61, 112, 255, true)
  elseif nazwa == "Casio G-Shock" then
    triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." sprawdza godzinę na zegarku 'Casio G-Shock'.")
    local timehour, timeminute = getTime()
    outputChatBox("* Na zegarku wskazuje godzine "..timehour..":"..timeminute.."",61, 112, 255, true)
  elseif nazwa == "Apple Watch 5" then
    triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." sprawdza godzinę na zegarku 'Apple Watch 5'.")
    local timehour, timeminute = getTime()
    outputChatBox("* Na zegarku wskazuje godzine "..timehour..":"..timeminute.."",61, 112, 255, true)
  elseif nazwa == "Emporio Armani Black" then
    triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." sprawdza godzinę na zegarku 'Emporio Armani Black'.")
    local timehour, timeminute = getTime()
    outputChatBox("* Na zegarku wskazuje godzine "..timehour..":"..timeminute.."",61, 112, 255, true)
  elseif nazwa == "Michael Kors Rose Gold" then
    triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." sprawdza godzinę na zegarku 'Michael Kors Rose Gold'.")
    local timehour, timeminute = getTime()
    outputChatBox("* Na zegarku wskazuje godzine "..timehour..":"..timeminute.."",61, 112, 255, true)
  elseif nazwa == "Gucci GG Supreme Canvasc" then
    triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." sprawdza godzinę na zegarku 'Gucci GG Supreme Canvas'.")
    local timehour, timeminute = getTime()
    outputChatBox("* Na zegarku wskazuje godzine "..timehour..":"..timeminute.."",61, 112, 255, true)
  elseif nazwa == "Hugo Boss Ocean Edition" then
    triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." sprawdza godzinę na zegarku 'Hugo Boss Ocean Edition'.")
    local timehour, timeminute = getTime()
    outputChatBox("* Na zegarku wskazuje godzine "..timehour..":"..timeminute.."",61, 112, 255, true)
  elseif nazwa == "Omega Black Stainless Steel" then
    triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." sprawdza godzinę na zegarku 'Omega Black Stainless Steel'.")
    local timehour, timeminute = getTime()
    outputChatBox("* Na zegarku wskazuje godzine "..timehour..":"..timeminute.."",61, 112, 255, true)
  elseif nazwa == "Casio Classic" then
    triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." sprawdza godzinę na zegarku 'Casio Classic'.")
    local timehour, timeminute = getTime()
    outputChatBox("* Na zegarku wskazuje godzine "..timehour..":"..timeminute.."",61, 112, 255, true)
  elseif nazwa == "Cartier White 18K Yellow Gold" then
    triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." sprawdza godzinę na zegarku 'Cartier White 18K Yellow Gold'.")
    local timehour, timeminute = getTime()
    outputChatBox("* Na zegarku wskazuje godzine "..timehour..":"..timeminute.."",61, 112, 255, true)
  elseif nazwa == "Hublot Big Bang Black" then
    triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." sprawdza godzinę na zegarku 'Hublot Big Bang Black'.")
    local timehour, timeminute = getTime()
    outputChatBox("* Na zegarku wskazuje godzine "..timehour..":"..timeminute.."",61, 112, 255, true)
  elseif nazwa == "Rolex Blue Gold Submariner" then
    triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." sprawdza godzinę na zegarku 'Rolex Blue Gold Submariner'.")
    local timehour, timeminute = getTime()
    outputChatBox("* Na zegarku wskazuje godzine "..timehour..":"..timeminute.."",61, 112, 255, true)
  elseif nazwa == "Louis Vuitton 18K White Gold" then
    triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." sprawdza godzinę na zegarku 'Louis Vuitton 18K White Gold'.")
    local timehour, timeminute = getTime()
    outputChatBox("* Na zegarku wskazuje godzine "..timehour..":"..timeminute.."",61, 112, 255, true)
  elseif nazwa == "Patek Philippe 18K Rose Gold" then
    triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." sprawdza godzinę na zegarku 'Patek Philippe 18K Rose Gold'.")
    local timehour, timeminute = getTime()
    outputChatBox("* Na zegarku wskazuje godzine "..timehour..":"..timeminute.."",61, 112, 255, true)
  elseif nazwa == "Rolex Tridor Gold Diamonds" then
    triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." sprawdza godzinę na zegarku 'Rolex Tridor Gold Diamonds'.")
    local timehour, timeminute = getTime()
    outputChatBox("* Na zegarku wskazuje godzine "..timehour..":"..timeminute.."",61, 112, 255, true)
  elseif nazwa == "Zestaw naprawczy" then
    if isPedInVehicle(localPlayer) then
      local auto = getPedOccupiedVehicle(localPlayer)
      triggerServerEvent("odegrajRp:eq", localPlayer, localPlayer, "#969696* "..getPlayerName(localPlayer).." używa podręczny zestaw naprawczy.")
      setElementRotation(auto, 0, 0, 0)
      fixVehicle(auto)
      end
      triggerServerEvent("usunPrzedmiot:eq", localPlayer, id)
	end
	triggerServerEvent("pokazPrzedmioty:eq", localPlayer)
end


addEvent("pokazPrzedmioty:eq:client", true)
addEventHandler("pokazPrzedmioty:eq:client", root, function(tabelka)
  przedmioty = tabelka
end)

function jeszCos(ile)
  local najedzenie = getElementData(localPlayer, "user:food") or 0
  setElementData(localPlayer, "user:food", tonumber(najedzenie)+tonumber(ile))
  if tonumber(najedzenie) >= 85 then
    setElementData(localPlayer, "user:food", 99)
  end
end

function pijeszCos(ile)
  local najedzenie = getElementData(localPlayer, "user:drink") or 0
  setElementData(localPlayer, "user:drink", tonumber(najedzenie)+tonumber(ile))
  if tonumber(najedzenie) >= 85 then
    setElementData(localPlayer, "user:drink", 99)
  end
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

bindKey("i","down", function()
  if not getElementData(localPlayer, "user:dbid") then return end
  if getElementData(localPlayer, "user:job") == "smieciarki" then return end
  if getElementData(localPlayer, "bw:time") then return end
	if eq == true then
		eq = false
		removeEventHandler("onClientRender", root, gui)
		branie = false
		removeEventHandler("onClientRender", root, branieitka)
		showCursor(false)
	else
		eq = true
		addEventHandler("onClientRender", root, gui)
		showCursor(true)
		triggerServerEvent("pokazPrzedmioty:eq", localPlayer)
	end
end)

bindKey("mouse_wheel_up", "down", function()
	if eq == true then
    	if scrollPos > 0 then
           	scrollPos = scrollPos-1
   		end
   	end
end)

bindKey("mouse_wheel_down", "down", function()
	if eq == true then
	   --if scrollPos >= #przedmioty-7 then return end
       scrollPos = scrollPos+1
    end
end)

function shadowText(text,x,y,w,h,color,size,font,xx,yy,x1,x2,x3,x4,x5)
	dxDrawText(text,x+1,y+1,w+1,h+1,tocolor(0,0,0),size,font,xx,yy,x1,x2,x3,x4,x5)
	dxDrawText(text,x,y,w,h,color,size,font,xx,yy,x1,x2,x3,x4,x5)
end