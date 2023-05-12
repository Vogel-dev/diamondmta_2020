
addEvent("broadcastSound3D", true)
addEventHandler("broadcastSound3D", root, function(sound,range,minrange, bliskiKomunikat, dalekiKomunikat)
	local el=source
	if getElementDimension(localPlayer)~=getElementDimension(el) then return end
	if getElementInterior(localPlayer)~=getElementInterior(el) then return end
	local x,y,z=getElementPosition(localPlayer)
	local x2,y2,z2=getElementPosition(el)
	local dist=getDistanceBetweenPoints3D(x,y,z,x2,y2,z2)
	if dist<range*2 then
		if bliskiKomunikat and minrange and dist<minrange then
			triggerEvent("onCaptionedEvent", root, bliskiKomunikat, 10)
			--outputChatBox(" * " .. bliskiKomunikat)
		elseif dalekiKomunikat and dist<range then
			triggerEvent("onCaptionedEvent", root, dalekiKomunikat, 10)
			--outputChatBox(" * " .. dalekiKomunikat)
		end
		local s=playSound3D(sound, x2,y2,z2)
		setSoundMinDistance(s, minrange or 5)
		setSoundMaxDistance(s, range)
	end
end)


local soundTrigger_lu=getTickCount()-2800
local function soundTrigger()
	if getTickCount()-soundTrigger_lu<2800 then return end
	soundTrigger_lu=getTickCount()
	local pojazd=getPedOccupiedVehicle(localPlayer)
	if pojazd and getVehicleController(pojazd)==localPlayer then
		local em=getElementModel(pojazd)
		if getElementData(pojazd,"veh:frakcja") == "SAPD" then -- radiowoz lspd
			if getKeyState("lalt") or getKeyState("ralt") then
				sfile="pd-syrena2.ogg"
			else
				sfile="pd-syrena.ogg"
			end
			triggerServerEvent("broadcastSound3D", pojazd, sfile, 125)
			cancelEvent()
			return
		elseif em==407 or em==544 then -- ciezki woz fd oraz woz z drabina
			if getKeyState("lalt") or getKeyState("ralt") then
				sfile="fd-syrena2.ogg"
			else
				sfile="fd-syrena2.ogg"
			end
			triggerServerEvent("broadcastSound3D", pojazd, sfile, 125)
			cancelEvent()
			return
		end
	end
end

bindKey("1", "down", soundTrigger)


local soundSwitch_lu=getTickCount()-2000
local function soundSwitch()
	if getTickCount()-soundSwitch_lu<2000 then return end
	soundSwitch_lu=getTickCount()
	local pojazd=getPedOccupiedVehicle(localPlayer)

	if pojazd and getVehicleController(pojazd)==localPlayer then
		local em=getElementModel(pojazd)
		if getElementData(pojazd,"veh:frakcja") == "SAPD" then -- WOZY SAPD
			triggerServerEvent("toggleVehicleSound", pojazd, "syrena.ogg", 225)
			cancelEvent()
			return
			elseif em==544 or em==407 then -- WOZY FDSA
			triggerServerEvent("toggleVehicleSound", pojazd, "fd-syrena3.ogg", 225)
			cancelEvent()
			return
			elseif em==416 then -- AMBULANSY
			triggerServerEvent("toggleVehicleSound", pojazd, "syrenaSAMA.ogg", 225)
			cancelEvent()
			return
		end
	end
end

bindKey("2", "down", soundSwitch)


local soundSwitch_lu=getTickCount()-2000
local function soundSwitch()
	if getTickCount()-soundSwitch_lu<2000 then return end
	soundSwitch_lu=getTickCount()
	local pojazd=getPedOccupiedVehicle(localPlayer)

	if pojazd and getVehicleController(pojazd)==localPlayer then
		local em=getElementModel(pojazd)
		if getElementData(pojazd,"veh:frakcja") == "SAPD" then --WOZY SAPD
			triggerServerEvent("toggleVehicleSound", pojazd, "syrena2.ogg", 155)
			cancelEvent()
			return
			elseif em==544 or em==407 then -- WOZY FDSA
			triggerServerEvent("toggleVehicleSound", pojazd, "fd-syrena4.ogg", 155)
			cancelEvent()
			return
		end
	end
end
bindKey("3", "down", soundSwitch)

local soundSwitch_lu=getTickCount()-2000
local function soundSwitch()

	if getTickCount()-soundSwitch_lu<2000 then return end
	soundSwitch_lu=getTickCount()
	local pojazd=getPedOccupiedVehicle(localPlayer)

	if pojazd and getVehicleController(pojazd)==localPlayer then
		local em=getElementModel(pojazd)
		if em==442 then -- wozy frakcji publicznych
			triggerServerEvent("toggleVehicleSound", pojazd, "march.ogg", 125)
			cancelEvent()
			return
		end
	end
end
bindKey("4", "down", soundSwitch)

addEvent("createVehicleSound", true)
addEventHandler("createVehicleSound", root, function(dzwiek,range)
	local snd=playSound3D(dzwiek, 0,0,0,true)
	setSoundMaxDistance(snd, range or 125)
	attachElements(snd, source)
end)

addEvent("destroyVehicleSound", true)
addEventHandler("destroyVehicleSound", root, function()
	local el=getAttachedElements(source)
	for i,v in ipairs(el) do
		if getElementType(v)=="sound" then
			destroyElement(v)
		end
	end
end)

addEvent("odtworzDzwiek", true)
addEventHandler("odtworzDzwiek", resourceRoot, function(dzwiek)
	if fileExists("audio/"..dzwiek..".ogg") then
		playSound("audio/"..dzwiek..".ogg")
	elseif fileExists("audio/"..dzwiek..".mp3") then
		playSound("audio/"..dzwiek..".mp3")
	end
end)