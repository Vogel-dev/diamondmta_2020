--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--


local screenW,screenH = guiGetScreenSize()

local dxLibary = exports.dxLibary

local f = dxCreateFont("cz.ttf", 16)

local grid = guiCreateGridList(0.35, 0.08, 0.30, 0.21, true)   
guiGridListAddColumn(grid, "Nick", 0.4)
guiGridListAddColumn(grid, "Status", 0.15)
guiGridListAddColumn(grid, "Ranga", 0.3)
guiSetVisible(grid, false)

local edit = guiCreateEdit(0.41, 0.11, 0.17, 0.05, "", true)
guiSetVisible(edit, false)

local combo = guiCreateComboBox(0.41, 0.08, 0.17, 0.12, "Wybierz range", true)    
guiSetVisible(combo, false)

function mysz(psx,psy,pssx,pssy,abx,aby)
    if not isCursorShowing() then return end
    cx,cy=getCursorPosition()
    cx,cy=cx*screenW,cy*screenH
    if cx >= psx and cx <= psx+pssx and cy >= psy and cy <= psy+pssy then
        return true,cx,cy
    else
        return false
    end
end

function main_gui()  
	dxDrawImage(screenW * 0.3380, screenH * 0.0241, screenW * 0.3245, screenH * 0.3352, "window.png")
	dxLibary:dxLibary_createButton('', screenW * 0.4714, screenH * 0.3047, screenW * 0.0571, screenH * 0.0391, tocolor(255, 255, 255, 255), false)
	dxLibary:dxLibary_createButton('', screenW * 0.4070, screenH * 0.3047, screenW * 0.0571, screenH * 0.0391, tocolor(255, 255, 255, 255), false)
	dxLibary:dxLibary_createButton('', screenW * 0.5359, screenH * 0.3047, screenW * 0.0571, screenH * 0.0391, tocolor(255, 255, 255, 255), false)
	dxDrawText("Wyrzuć", screenW * 0.4070, screenH * 0.3047, screenW * 0.4641, screenH * 0.3438, tocolor(150, 150, 150, 255), 1.00, f, "center", "center", false, false, false, false, false)
    dxDrawText("Edytuj", screenW * 0.4714, screenH * 0.3047, screenW * 0.5286, screenH * 0.3438, tocolor(150, 150, 150, 255), 1.00, f, "center", "center", false, false, false, false, false)
    dxDrawText("Dodaj", screenW * 0.5359, screenH * 0.3047, screenW * 0.5930, screenH * 0.3438, tocolor(150, 150, 150, 255), 1.00, f, "center", "center", false, false, false, false, false)
end

function add_gui()
	local txt = guiGetText(edit) or ""
	local search = findPlayer(localPlayer,txt)
	if txt:len() < 1 or not search then
		txt = "nie znaleziono"
	else
		txt = getPlayerName(search).." ["..getElementData(search, "user:id").."]"
	end
	dxDrawImage(screenW * 0.3380, screenH * 0.0241, screenW * 0.3245, screenH * 0.3352, "window-dodaj.png")
	dxLibary:dxLibary_createButton('', screenW * 0.4714, screenH * 0.2643, screenW * 0.0571, screenH * 0.0391, tocolor(255, 255, 255, 255), false)
	dxLibary:dxLibary_createButton(' X', screenW * 0.6442, screenH * 0.0378, screenW * 0.0110, screenH * 0.0247, tocolor(255, 255, 255, 255), false)
    dxDrawText("Dodaj", screenW * 0.4707, screenH * 0.2643, screenW * 0.5286, screenH * 0.3034, tocolor(150, 150, 150, 255), 1.00, f, "center", "center", false, false, false, false, false)
	dxDrawText("Nick gracza:", screenW * 0.4092, screenH * 0.0781, screenW * 0.5813, screenH * 0.1068, tocolor(150, 150, 150, 255), 1.00, f, "center", "center", false, false, false, false, false)
    dxDrawText("Znaleziony gracza: "..txt, screenW * 0.4092, screenH * 0.1641, screenW * 0.5813, screenH * 0.2565, tocolor(150, 150, 150, 255), 1.00, f, "center", "center", false, false, false, false, false)
end

function edit_gui()
	dxDrawImage(screenW * 0.3380, screenH * 0.0241, screenW * 0.3245, screenH * 0.3352, "window-edytuj.png")
	dxLibary:dxLibary_createButton('', screenW * 0.4714, screenH * 0.2643, screenW * 0.0571, screenH * 0.0391, tocolor(255, 255, 255, 255), false)
	dxLibary:dxLibary_createButton(' X', screenW * 0.6442, screenH * 0.0378, screenW * 0.0110, screenH * 0.0247, tocolor(255, 255, 255, 255), false)
    dxDrawText("Dodaj", screenW * 0.4707, screenH * 0.2643, screenW * 0.5286, screenH * 0.3034, tocolor(150, 150, 150, 255), 1.00, f, "center", "center", false, false, false, false, false)
end

local orgname = ""
local players = false
local zapro = false

function gui_add()
	dxDrawImage(screenW * 0.3380, screenH * 0.0241, screenW * 0.3245, screenH * 0.3352, "window-zaproszenie.png")
	dxDrawText("Otrzymałeś propozycję dołączenia do organizacji: \n"..orgname, screenW * 0.4130, screenH * 0.1176, screenW * 0.5844, screenH * 0.2139, tocolor(150, 150, 150, 255), 1.00, f, "center", "center", false, false, false, false, false)
	dxLibary:dxLibary_createButton('', screenW * 0.4714, screenH * 0.2643, screenW * 0.0571, screenH * 0.0391, tocolor(255, 255, 255, 255), false)
	dxLibary:dxLibary_createButton(' X', screenW * 0.6442, screenH * 0.0378, screenW * 0.0110, screenH * 0.0247, tocolor(255, 255, 255, 255), false)
    dxDrawText("Akceptuj", screenW * 0.4707, screenH * 0.2643, screenW * 0.5286, screenH * 0.3034, tocolor(150, 150, 150, 255), 1.00, f, "center", "center", false, false, false, false, false)
end

addEvent("zaproszenie:org", true)
addEventHandler("zaproszenie:org", resourceRoot, function(player, org, thisPlayer)
	addEventHandler("onClientRender", root, gui_add)
	orgname = org
	players = thisPlayer
	zapro = true
	showCursor(true)
	setElementData(localPlayer, "pokaz:hud", false)
	showChat(false)
	showPlayerHudComponent('radar', false)
	setElementData(localPlayer, "player:blackwhite", true)
end)

addEventHandler("onClientClick", root, function(b, s)
	if b ~= "state" and s ~= "down" then return end
	if not zapro then return end
	if mysz(screenW * 0.6442, screenH * 0.0378, screenW * 0.0110, screenH * 0.0247) then
		zapro = false
		showCursor(false)
		setElementData(localPlayer, "pokaz:hud", true)
		showChat(true)
		showPlayerHudComponent('radar', true)
		setElementData(localPlayer, "player:blackwhite", false)
		removeEventHandler("onClientRender", root, gui_add)
		triggerServerEvent("zaproszenie:org", resourceRoot, localPlayer, orgname, players, true)
		orgname = ""
	elseif mysz(screenW * 0.4714, screenH * 0.2643, screenW * 0.0571, screenH * 0.0391) then
		zapro = false
		showCursor(false)
		setElementData(localPlayer, "pokaz:hud", true)
		showChat(true)
		showPlayerHudComponent('radar', true)
		setElementData(localPlayer, "player:blackwhite", false)
		removeEventHandler("onClientRender", root, gui_add)
		triggerServerEvent("zaproszenie:org", resourceRoot, localPlayer, orgname, players, false)
		orgname = ""
	end
end)

bindKey("f5", "down", function()
	if getElementData(localPlayer, "account:panelfaction") then return end
	   if not getElementData(localPlayer, "user:oname") then
		exports["dmta_base_notifications"]:addNotification("Nie jestes w grupie przestępczej." , "error")
      	return
   	end
   	if getElementData(localPlayer, "account:panelorg") then
		  showCursor(false)
		  setElementData(localPlayer, "pokaz:hud", true)
		showChat(true)
		showPlayerHudComponent('radar', true)
		setElementData(localPlayer, "player:blackwhite", false)
  		guiSetVisible(grid, false)
  		setElementData(localPlayer, "account:panelorg", false)
  		removeEventHandler("onClientRender", root, main_gui)
 		if guiGetVisible(edit) == true then
  			removeEventHandler("onClientRender", root, add_gui)
  			guiSetVisible(edit, false)
 		end
  		if guiGetVisible(combo) == true then
  			removeEventHandler("onClientRender", root, edit_gui)
  			guiSetVisible(combo, false)
  		end
  	else
	    guiSetVisible(grid, true)
	    addEventHandler("onClientRender", root, main_gui)
	    guiGridListClear(grid)
	    guiComboBoxClear(combo)
	    guiSetText(edit, "")
		setElementData(localPlayer, "account:panelorg", true)
		showCursor(true)
		setElementData(localPlayer, "pokaz:hud", false)
		showChat(false)
		showPlayerHudComponent('radar', false)
		setElementData(localPlayer, "player:blackwhite", true)
	    triggerServerEvent("orgGetPlayers", localPlayer, getElementData(localPlayer, "user:oname"))
	end
end)

addEventHandler("onClientClick", root, function(b, s)
	if b ~= "state" and s ~= "down" then return end
	if not getElementData(localPlayer, "account:panelorg") then return end
	local rank = getElementData(localPlayer, "user:oranga") or "1"
	rank = tonumber(rank)
	if mysz(screenW * 0.5359, screenH * 0.3047, screenW * 0.0571, screenH * 0.0391) and guiGetVisible(edit) ~= true and guiGetVisible(combo) ~= true and rank >= 3 then
		guiSetVisible(edit, true)
		addEventHandler("onClientRender", root, add_gui)
		guiSetVisible(grid, false)
		removeEventHandler("onClientRender", root, main_gui)
	elseif mysz(screenW * 0.6442, screenH * 0.0378, screenW * 0.0110, screenH * 0.0247) and guiGetVisible(edit) == true and rank >= 3 then
		guiSetVisible(edit, false)
		removeEventHandler("onClientRender", root, add_gui)
		addEventHandler("onClientRender", root, main_gui)
		guiSetVisible(grid, true)
	elseif mysz(screenW * 0.4714, screenH * 0.3047, screenW * 0.0571, screenH * 0.0391) and guiGetVisible(combo) ~= true and guiGetVisible(edit) ~= true and guiGridListGetSelectedItem(grid) ~= -1 and rank >= 3 then
		guiSetVisible(combo, true)
		addEventHandler("onClientRender", root, edit_gui)
		guiSetVisible(grid, false)
		removeEventHandler("onClientRender", root, main_gui)
	elseif mysz(screenW * 0.4070, screenH * 0.3047, screenW * 0.0571, screenH * 0.0391) and guiGetVisible(grid) == true then
		local id = guiGridListGetSelectedItem(grid)
		if id ~= -1 then
			local nick = guiGridListGetItemText(grid, id, 1)
			triggerServerEvent("org:kickgracz", resourceRoot, localPlayer, nick)
		end
	elseif mysz(screenW * 0.4714, screenH * 0.2643, screenW * 0.0571, screenH * 0.0391) and guiGetVisible(edit) == true then
		local text = guiGetText(edit)
		if text:len() < 1 then return end
		triggerServerEvent("org:addgracz", resourceRoot, localPlayer, text)
	elseif mysz(screenW * 0.4714, screenH * 0.2643, screenW * 0.0571, screenH * 0.0391) and guiGetVisible(combo) == true then
		local selected = guiComboBoxGetSelected(combo)
		local selected2 = guiGridListGetSelectedItem(grid)
		if selected ~= -1 and selected2 ~= -1 then
			local nick = guiGridListGetItemText(grid, selected2, 1)
			triggerServerEvent("org:editgracz", resourceRoot, localPlayer, selected+1, nick, guiComboBoxGetItemText(combo, selected))
		end
	elseif mysz(screenW * 0.6442, screenH * 0.0378, screenW * 0.0110, screenH * 0.0247) and guiGetVisible(combo) == true and rank >= 3 then
		guiSetVisible(combo, false)
		removeEventHandler("onClientRender", root, edit_gui)
		addEventHandler("onClientRender", root, main_gui)
		guiSetVisible(grid, true)
	end
end)

function resultRank(id,q2)
	if id == 1 then return q2["rank_1"] end
	if id == 2 then return q2["rank_2"] end
	if id == 3 then return q2["rank_3"] end
	if id == 4 then return q2["rank_4"] end
end

function uzupelnijListe(q,q2,q3)
	for i,v in ipairs(q) do
		local row = guiGridListAddRow(grid)
		guiGridListSetItemText(grid, row, 1, v["login"], false, false)
		guiGridListSetItemText(grid, row, 2, v["lastlogin"], false, false)
		if getPlayerFromName(v["login"]) then
			guiGridListSetItemText(grid, row, 2, "ONLINE", false, false)
			guiGridListSetItemColor(grid, row, 2, 21, 101, 192)
		else
			guiGridListSetItemText(grid, row, 2, "OFFLINE", false, false)
			guiGridListSetItemColor(grid, row, 2, 185, 43, 39)
		end
		local ranga = resultRank(v["orank"],q2)
		guiGridListSetItemText(grid, row, 3, ranga, false, false)
	end
	for i = 1,3 do
		guiComboBoxAddItem(combo, resultRank(i,q2))
	end
end
addEvent("uzupelnijListe", true)
addEventHandler("uzupelnijListe", getRootElement(), uzupelnijListe)

function findPlayer(player, toPlayer)
	for i,v in ipairs(getElementsByType("player")) do
		if tonumber(toPlayer) then
			if getElementData(v, "user:id") == tonumber(toPlayer) then
				return v
			end
		else
			if string.find(string.gsub(getPlayerName(v):lower(),"#%x%x%x%x%x%x", ""), toPlayer:lower(), 1, true) then
				return v
			end
		end
	end
end