--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local noti = exports['dmta_base_notifications']
local duty = exports['dmta_base_duty']

local markers = {
{1734.7529296875,-1765.0770263672,13.4921875},
}

local timer = {}

addEventHandler("onResourceStart",resourceRoot,function()
	for i,v in ipairs(markers) do
		if i and i > 0 then
			local marker = createMarker(v[1],v[2],v[3]-0.95,"cylinder",2.3,50,100,200,50,root)
			setElementData(marker, 'marker:icon', 'mechanic')
			setElementData(marker,"tuning:i",i)
			napis = createElement("text")
    		setElementPosition(napis, v[1], v[2], v[3])
    		setElementData(napis, "text", "Tuning wizualny")
		end
	end
end)

addEventHandler("onMarkerHit",resourceRoot,function(plr)
	if plr and isElement(plr) and getElementType(plr) == "player" then
		if isPedInVehicle(plr) then
			if getPedOccupiedVehicle(plr) then
				if getVehicleController(getPedOccupiedVehicle(plr)) and getVehicleController(getPedOccupiedVehicle(plr)) == plr then
					if getElementData(getPedOccupiedVehicle(plr),"vehicle:id") then
						if getElementData(getPedOccupiedVehicle(plr),"vehicle:owner") == getElementData(plr,"user:dbid") then
							local markertysieczny = createColCuboid(1730.0543212891, -1767.9681396484, 13.4921875, 15.25, 7.75, 3)
							local pojazdy = getElementsWithinColShape(markertysieczny,"vehicle")
							if #pojazdy > 1 then
								noti:addNotification(plr, 'Na stanowisku do tuningu pojazdu znajduje się więcej niż jeden pojazd!', 'error')
								if markertysieczny and isElement(markertysieczny) then
									destroyElement(markertysieczny)
								end
								return
							end
							if markertysieczny and isElement(markertysieczny) then
								destroyElement(markertysieczny)
							end
							setElementFrozen(plr,false)
							setElementFrozen(getPedOccupiedVehicle(plr),true)
							setElementData(getPedOccupiedVehicle(plr),"tuning:veh",true)
							timer[plr] = setTimer(function(plr)
								if plr and isElement(plr) then
									triggerClientEvent(plr,"tuning:otworzGUI",plr,plr)
								end
							end,100,1,plr)
							else
								noti:addNotification(plr, 'Ten pojazd nie należy do Ciebie!', 'error')
						end
					end
				end
			end
		end
	end
end)

addEventHandler("onVehicleStartEnter",resourceRoot,function(plr,seat)
	if seat == 0 then
		cancelEvent()
	end
end)

addEventHandler("onMarkerLeave",resourceRoot,function(veh)
	if veh and isElement(veh) and getElementType(veh) == "vehicle" then
		if getElementData(veh,"tuning:veh") == true then
			if getElementData(veh,"vehicle:id") then
				setElementData(veh,"tuning:veh",false)
				--setVehicleHeadLightColor(veh,getElementData(veh,"veh:r") or 255,getElementData(veh,"veh:g") or 255,getElementData(veh,"veh:b") or 255)
			end
		end
	end
end)

addEvent("tuning:tuningujPojazd",true)
addEventHandler("tuning:tuningujPojazd",root,function(plr,kategoria_id,id,cena)
	if plr and isElement(plr) and getPedOccupiedVehicle(plr) then
		if kategoria_id then
			if id and tonumber(id) and tonumber(id) > 1000 and tonumber(id) < 2000 then
				if cena then
					local veh = getPedOccupiedVehicle(plr)
					if veh and isElement(veh) then
						if getVehicleUpgradeOnSlot(veh, tonumber(kategoria_id)) ~= 0 then
							local upgrades = getVehicleUpgrades(getPedOccupiedVehicle(plr))
							for _,v in ipairs(upgrades) do
								if v == tonumber(id) then
									removeVehicleUpgrade(veh,id)
									givePlayerMoney(plr, cena)
									local id_pojazdu = getElementData(veh, "vehicle:id") or 0
									noti:addNotification(plr, 'Zdemontowałeś część o id '..id..'. Otrzymujesz '..cena..' $', 'success')
									local text_log = getPlayerName(plr)..' zdemontował '..id..' (ID) za '..cena..' $ do pojazdu ID: '..id_pojazdu
									duty:addLogsDuty(text_log)
									duty:addLogs('veh', text_log, plr, 'TUNING/DEMONT')
									--triggerClientEvent(plr,"tuning:zamknijGUI",plr,plr)
								end
							end
						else
							if getPlayerMoney(plr)  >= tonumber(cena) then
								addVehicleUpgrade(veh,id)
								takePlayerMoney(plr, cena)
								local id_pojazdu = getElementData(veh, "vehicle:id") or 0
								noti:addNotification(plr, 'Zamontowałeś część o id '..id..' za '..cena..' $', 'success')
								local text_log = getPlayerName(plr)..' zamontował '..id..' (ID) za '..cena..' $ do pojazdu ID: '..id_pojazdu
									duty:addLogsDuty(text_log)
									duty:addLogs('veh', text_log, plr, 'TUNING/MONTAŻ')
							else
								noti:addNotification(plr, 'Nie posiadasz wystarczającej ilości pieniędzy, by móc zamontować tą część!.', 'error')
							end
						end
					end
				end
			end
		end
	end
end)

addEventHandler("onVehicleStartExit", root, function(kierowca)
	if getElementData(getPedOccupiedVehicle(kierowca), "tuning:veh") then cancelEvent() end
end)