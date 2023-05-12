--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local sound = false
local obrON = false
local shakeBlood = false
local sw,sh = guiGetScreenSize()
local timer = {}
local tick = getTickCount()
local tick2 = getTickCount()

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
     if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
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

function sprawdzajHP()
	local hp = getElementHealth(getLocalPlayer())
	if hp > 15 and sound and isElement(sound) then
		destroyElement(sound)
		removeEventHandler("onClientRender",getRootElement(),sprawdzajHP)
	elseif hp < 15 and sound and isElement(sound) and getElementData(localPlayer, 'pokaz:hud') then
		local a = interpolateBetween(0, 0, 0, 50, 0, 0, (getTickCount() - tick) / 1000, 'SineCurve')
		dxDrawRectangle(0, 0, sw, sh, tocolor(255, 0, 0, a), false)
	end
end

function effectBlooding()
    local czas = 60
	local endTime = czas - getTickCount()
	local timeInt = math.floor(endTime/1000)
    local a = interpolateBetween(80, 0, 0, 140, 0, 0, (getTickCount() - tick) / 2500, 'SineCurve')
    dxDrawRectangle(0, 0, sw, sh, tocolor(255, 0, 0, a), false)
	dxDrawText(timeInt, 877, 494, 1043, 586, tocolor(255, 255, 255, 255), 1.00, "default", "left", "top", false, false, false, false, false)
    if timeInt <= 0 then
    	removeEventHandler("onClientRender",getRootElement(),effectBlooding)
    	effectsFalse()
    	setCameraShakeLevel(0)
    end
end

function regeneracjaHP()
    local hp = getElementHealth(localPlayer)
    local food = getElementData(localPlayer, 'user:food')
    local drink = getElementData(localPlayer, 'user:drink')
    if food >= 40 and drink >= 40 and hp <= 60 then
        local hp = getElementHealth(localPlayer)
        setElementHealth(localPlayer, hp+2)
        setElementData(localPlayer,"user:food",food-1)
        setElementData(localPlayer,"user:drink",drink-1.5)
    else
        killTimer(timer[localPlayer])
    end
end

function effectsFalse()
shakeBlood = false
obrON = false
end

function lowHP(attacker, weapon, bodypart)
	local hp = getElementHealth(getLocalPlayer())
	if hp < 15 and not sound or sound and not isElement(sound) then
		addEventHandler("onClientRender",getRootElement(),sprawdzajHP)
		sound = playSound("https://ia801503.us.archive.org/15/items/BicieSerca/bicie%20serca.ogg", true)
        if not isTimer(timer[localPlayer]) then
        timer[localPlayer] = setTimer(regeneracjaHP,5000,0)
        end
    elseif hp > 11 and hp < 60 then
        if not isTimer(timer[localPlayer]) then
        timer[localPlayer] = setTimer(regeneracjaHP,5000,0)
        end
	end
    if weapon == 24 and math.random(1,10) == 3 and not obrON == true and not shakeBlood == true  then
        if not isEventHandlerAdded("onClientRender",getRootElement(),effectBlooding) then
        	addEventHandler("onClientRender",getRootElement(),effectBlooding)
        	czas = getTickCount()+(21 * 1000)
        	obrON = true
    	end
    elseif weapon == 24 and math.random(1,10) == 5 and not obrON == true and not shakeBlood == true then
        if not isEventHandlerAdded("onClientRender",getRootElement(),effectBlooding) then
        	addEventHandler("onClientRender",getRootElement(),effectBlooding)
        	shakeBlood = true
        	setCameraShakeLevel(140)
        	czas = getTickCount()+(21 * 1000)
    	end
    end
end
addEventHandler("onClientPlayerDamage", getLocalPlayer(), lowHP)





function nadajKrwawienie()
    outputChatBox("true")
    addEventHandler("onClientRender",getRootElement(),effectBlooding)
    setTimer()
end
addCommandHandler("ks",nadajKrwawienie)