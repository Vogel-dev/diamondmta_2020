--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local dx = exports.dxLibary

local showed = false

local screenW, screenH = guiGetScreenSize()
local sx, sy = guiGetScreenSize()

function isMouseIn(psx,psy,pssx,pssy,abx,aby)
    if not isCursorShowing() then return end
    cx,cy=getCursorPosition()
    cx,cy=cx*sx,cy*sy
    if cx >= psx and cx <= psx+pssx and cy >= psy and cy <= psy+pssy then
        return true,cx,cy
    else
        return false
    end
end

panelOrg = guiCreateGridList(0.38, 0.31, 0.24, 0.34, true)
guiGridListAddColumn(panelOrg, "ID", 0.1)
guiGridListAddColumn(panelOrg, "Model", 0.3)
guiGridListAddColumn(panelOrg, "Organizacja", 0.3)
guiSetVisible(panelOrg, false)

function gui()
	dxDrawRectangle(0, 0, 1920, 1080, tocolor(15, 15, 15, 200), false)
	dx:dxLibary_createWindow(screenW * 0.3599, screenH * 0.2417, screenW * 0.2802, screenH * 0.5176, tocolor(255, 255, 255, 255), false)
	dx:dxLibary_text("Przepisywanie pojazdów na organizacje", screenW * 0.3599, screenH * 0.26, screenW * 0.2802+screenW * 0.3599, screenH * 0.5176, tocolor(105, 188, 235, 255), 10, "default", "center", "top", false, false, false, false, false)
	dx:dxLibary_createButton("Przepisz/Wypisz", screenW * 0.386, screenH * 0.68, screenW * 0.102, screenH * 0.044, tocolor(255, 255, 255, 255), false)
	dx:dxLibary_createButton("Anuluj", screenW * 0.511, screenH * 0.68, screenW * 0.102, screenH * 0.044, tocolor(255, 255, 255, 255), false)
end

function otworz()
	if showed then return end
	addEventHandler("onClientRender", getRootElement(), gui)
	showCursor(true)
	showed = true
	guiSetVisible(panelOrg, true)
end

addEvent("showOrgWindow", true)
addEventHandler("showOrgWindow", root, function(result, id)
	guiGridListClear(panelOrg)
	if not result then return end
	for i,v in pairs(result) do
		local sprawdz = guiGridListAddRow(panelOrg)
		otworz(localPlayer)
		guiGridListSetItemText(panelOrg, sprawdz, 1, v["id"], false, false)
		guiGridListSetItemText(panelOrg, sprawdz, 2, getVehicleNameFromModel(v["model"]), false, false)
		guiGridListSetItemText(panelOrg, sprawdz, 3, v["organization"], false, false)
	end
end)

function zamknij()
	removeEventHandler("onClientRender", getRootElement(), gui)
	showCursor(false)
	guiSetVisible(panelOrg, false)
	showed = false
end
addEvent("destroyOrgWindow", true)
addEventHandler("destroyOrgWindow", root, zamknij)

addEventHandler("onClientClick", root, function(btn, state)
	if btn == "left" and state == "down" then
		if isMouseIn(screenW * 0.386, screenH * 0.68, screenW * 0.102, screenH * 0.044) and guiGetVisible(panelOrg) then
			local wybral = guiGridListGetSelectedItem(panelOrg) or 0
			local uid = guiGridListGetItemText(panelOrg, wybral, 1)
			if wybral < 0 then return end
			triggerServerEvent("przepisz", localPlayer, localPlayer, tonumber(uid))
			zamknij(localPlayer)
		elseif isMouseIn(screenW * 0.511, screenH * 0.68, screenW * 0.102, screenH * 0.044) and guiGetVisible(panelOrg) then
			zamknij(localPlayer)
		end
	end
end)