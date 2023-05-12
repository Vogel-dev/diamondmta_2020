--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local screenW, screenH = guiGetScreenSize()

window = guiCreateWindow(0.35, 0.30, 0.30, 0.38, "Ustawianie opisu", true)
guiWindowSetSizable(window, false)

label = guiCreateLabel(0.02, 0.07, 0.96, 0.09, "Znajdujesz się w panelu do ustawiania opisu pojazdu, lub swojej postaci.\n Wystarczy że wpiszesz interesujący Cię opis i zatwierdzisz odpowiednim przyciskiem na dole.", true, window)
guiLabelSetHorizontalAlign(label, "center", false)
memo = guiCreateMemo(0.02, 0.18, 0.68, 0.78, "", true, window)
combobox = guiCreateComboBox(0.71, 0.19, 0.26, 0.17, "Pojazd", true, window)
guiComboBoxAddItem(combobox, "Pojazd") -- 0
guiComboBoxAddItem(combobox, "Postać") -- 1
buttoncancel = guiCreateButton(0.71, 0.88, 0.28, 0.08, "Wyjdź", true, window)
buttonmain = guiCreateButton(0.71, 0.77, 0.28, 0.08, "Ustaw opis", true, window)  
guiSetVisible(window, false)

addCommandHandler("opis", function()
	if guiGetVisible(window) == true then
		guiSetVisible(window, false)
		showCursor(false)
		removeEventHandler("onClientGUIClick", buttonmain, main)
		removeEventHandler("onClientGUIClick", buttoncancel, cancel)
	elseif guiGetVisible(window) == false then
		guiSetVisible(window, true)
		showCursor(true)
		addEventHandler("onClientGUIClick", buttonmain, main)
		addEventHandler("onClientGUIClick", buttoncancel, cancel)
	end
end)

function cancel()
	guiSetVisible(window, false)
	showCursor(false)
	removeEventHandler("onClientGUIClick", buttonmain, main)
	removeEventHandler("onClientGUIClick", buttoncancel, cancel)
end

function main()
	local item = guiComboBoxGetSelected(combobox)
	local itemname = guiComboBoxGetItemText(combobox, item)
	local description = guiGetText(memo)
	if itemname == "Postać" then
		if description == "" then
			setElementData(localPlayer, "player:desc", "")
		else
			setElementData(localPlayer, "player:desc", description)
		end
		guiSetVisible(window, false)
		showCursor(false)
		removeEventHandler("onClientGUIClick", buttonmain, main)
		removeEventHandler("onClientGUIClick", buttoncancel, cancel)
	elseif itemname == "Pojazd" then
		local vehicle = getPedOccupiedVehicle(localPlayer)
		if not vehicle then return outputChatBox("Nie znajdujesz się w pojeździe!") end
		if description == "" then
			setElementData(vehicle, "vehicle:desc", "")
		else
			setElementData(vehicle, "vehicle:desc", description)
		end
		guiSetVisible(window, false)
		showCursor(false)
		removeEventHandler("onClientGUIClick", buttonmain, main)
		removeEventHandler("onClientGUIClick", buttoncancel, cancel)
	end
end

local dxLibary = exports.dxLibary

addEventHandler("onClientRender", root, function()
	local cmX,cmY,cmZ = getCameraMatrix()
	
	for i,v in ipairs(getElementsByType("vehicle", root)) do
		local description = getElementData(v, "vehicle:desc")
		if description then
			local x,y,z = getElementPosition(v)
			local distance = getDistanceBetweenPoints3D(cmX,cmY,cmZ,x,y,z)
			if distance <= 20 then
				local wpX,wpY = getScreenFromWorldPosition(x,y,z, 200)
				if wpX and wpY then
					dxLibary:dxLibary_text(description, wpX-(screenW/5)+1,wpY+1,wpX+(screenW/5)+1,wpY+1, tocolor(0, 0, 0, 255), 2.5, 'default', 'center', 'center', false, false, false, true)
					dxLibary:dxLibary_text(description, wpX-(screenW/5),wpY,wpX+(screenW/5),wpY, tocolor(150, 150, 150, 255), 2.5, 'default', 'center', 'center', false, false, false, true)
				end
			end
		end
	end
	for i,v in ipairs(getElementsByType("player", root)) do
		local description = getElementData(v, "player:desc")
		if description then
			local x,y,z = getElementPosition(v)
			local distance = getDistanceBetweenPoints3D(cmX,cmY,cmZ,x,y,z)
			if distance <= 15 then
				local wpX,wpY = getScreenFromWorldPosition(x,y,z, 200)
				if wpX and wpY then
					dxLibary:dxLibary_text(description, wpX-(screenW/5)+1,wpY+1,wpX+(screenW/5)+1,wpY+1, tocolor(0, 0, 0, 255), 2, 'default', 'center', 'center', false, false, false, true)
					dxLibary:dxLibary_text(description, wpX-(screenW/5),wpY,wpX+(screenW/5),wpY, tocolor(150, 150, 150, 255), 2, 'default', 'center', 'center', false, false, false, true)
				end
			end
		end
	end
end)