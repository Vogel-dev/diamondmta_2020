--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local sw,sh = guiGetScreenSize()
local zoom = 1920/sw

local dx = exports.dxLibary
local noti = exports.dmta_base_notifications

local JOB = {}

JOB.gui = false

JOB.marker = createMarker(1998.2813720703,-2248.2526855469,13.546875-0.98, "cylinder", 5, 123, 182, 97)
setElementData(JOB.marker, 'marker:icon', 'job')


function isMouseInPosition(x, y, w, h)
    if not isCursorShowing() then return end
    
    local mouse = {getCursorPosition()}
    local myX, myY = (mouse[1] * sw), (mouse[2] * sh)
    if (myX >= x and myX <= (x + w)) and (myY >= y and myY <= (y + h)) then
        return true
    end
    
    return false
end

local click = false
function onClick(x, y, w, h, called)
    if(isMouseInPosition(x, y, w, h) and not click and getKeyState("mouse1"))then
        click = true
        called()
    elseif(not getKeyState("mouse1") and click)then
        click = false
    end
end

--

JOB.markerPoint = false
JOB.blip = false

JOB.points = {
    {1730.1617431641,-2173.5966796875,73.090286254883},
    {1818.5415039063,-2035.6114501953,73.090286254883},
    {1825.1065673828,-1838.7689208984,73.090286254883},
    {1693.9989013672,-1791.4877929688,73.090286254883},
    {1557.6716308594,-1735.5684814453,73.090286254883},
    {1443.3909912109,-1658.5600585938,73.090286254883},
    {1348.4318847656,-1587.8453369141,73.090286254883},
    {1209.0827636719,-1573.5322265625,73.090286254883},
    {1094.9125976563,-1568.8322753906,73.090286254883},
    {1054.0170898438,-1443.4456787109,73.090286254883},
    {1059.1181640625,-1341.1976318359,73.090286254883},
    {943.92572021484,-1326.369140625,73.090286254883},
    {916.55688476563,-1388.033203125,73.090286254883},
    {831.8505859375,-1394.6573486328,73.090286254883},
    {800.22357177734,-1324.6279296875,73.090286254883},
    {799.55810546875,-1161.9122314453,73.090286254883},
    {944.07873535156,-1152.0161132813,73.090286254883},
    {1321.9655761719,-1143.5200195313,73.090286254883},
    {1327.6309814453,-1052.5968017578,73.090286254883},
    {1155.7635498047,-1037.7336425781,73.090286254883},
}

JOB.object = {}
JOB.timer = false

JOB.start = function()
    local random = math.random(1,#JOB.points)
    JOB.markerPoint = createMarker(JOB.points[random][1], JOB.points[random][2], JOB.points[random][3], "ring", 3, 255, 83, 73, 255)
    JOB.blip = createBlipAttachedTo(JOB.markerPoint, 41)
end

JOB.onRender = function()
    dxDrawRectangle(0, 0, 1920, 1080, tocolor(15, 15, 15, 200), false)
    dx:dxLibary_createWindow(714/zoom, 307/zoom, 493/zoom, 467/zoom)
    dx:dxLibary_text("Praca dorywcza - Rozrzucanie ulotek", 724/zoom, 317/zoom, 1197/zoom, 373/zoom, tocolor(105, 188, 235, 255), 10, "default", "center", "center", false, false, false, true, false)
    dx:dxLibary_text("Do rozpoczęcia pracy wymagana jest\n#69bceblicencja lotnicza\n\n#ffffffTwoim zadaniem jest rozrzucanie ulotek z samolotu w \noznaczonych punktach na mapie.", 738/zoom, 485/zoom, 1187/zoom, 569/zoom, tocolor(255, 255, 255, 255), 5, "default", "center", "center", false, false, false, true, false)
    dx:dxLibary_createButton("Rozpocznij", 748/zoom, 678/zoom, 202/zoom, 51/zoom, 3)
    dx:dxLibary_createButton("Anuluj", 985/zoom, 678/zoom, 202/zoom, 51/zoom, 3)

    onClick(748/zoom, 678/zoom, 202/zoom, 51/zoom, function()

        if getElementData(localPlayer, "user:reputation") < 1000 then noti:addNotification('Musisz posiadać 1000 respektu, aby rozpocząć pracę tutaj.', 'error')
            return
        end
        if(not getElementData(localPlayer, "user:job"))then
            if(not getElementData(localPlayer, "user:prawkoL"))then
                noti:addNotification('Nie posiadasz licencji lotniczej.', 'info')
                return
            end
            noti:addNotification('Rozpocząłeś pracę jako lotnik.', 'info')

            triggerServerEvent("dodo.rozpocznij", resourceRoot)

            JOB.start()

            setElementData(localPlayer, "user:job", "Lotnik", false)

            removeEventHandler("onClientRender", root, JOB.onRender)
            showCursor(false)

            JOB.gui = false

            addEventHandler("onClientVehicleExit", resourceRoot, JOB.onExit)
        else
            noti:addNotification('Najpierw zakończ pracę!', 'info')
        end
    end)

    onClick(985/zoom, 678/zoom, 202/zoom, 51/zoom, function()
        removeEventHandler("onClientRender", root, JOB.onRender)
        showCursor(false)

        JOB.gui = false
    end)
end

addEventHandler("onClientMarkerHit", resourceRoot, function(hit, dim)
    if(hit ~= localPlayer or not dim)then return end

    if(source == JOB.marker)then -- marker gui
        if(JOB.gui)then
            removeEventHandler("onClientRender", root, JOB.onRender)
            showCursor(false)

            JOB.gui = false
        else
            addEventHandler("onClientRender", root, JOB.onRender)
            showCursor(true)

            JOB.gui = true
        end
    elseif(source == JOB.markerPoint)then -- marker point
        destroyElement(JOB.markerPoint)
        destroyElement(JOB.blip)

        JOB.start()

        local money = math.random(85,185)
        local nagroda = math.random(1, 5)
                    if tonumber(nagroda) == 5 then
                        local los2 = math.random(1,3)
                        if getElementData(localPlayer, "user:premium") then
                            los2 = math.random(3, 6)
                        end
                        local rep = getElementData(localPlayer, 'user:reputation') or 0
                        setElementData(localPlayer, "user:reputation", rep+los2)
                        noti:addNotification('Za dobrą prace otrzymujesz '..los2..' punktów respektu.', 'success')
                    end

        triggerServerEvent("dodo.money", resourceRoot, money)

        if(JOB.timer and isTimer(JOB.timer))then
            killTimer(JOB.timer)

            for i,v in pairs(JOB.object) do
                if(isElement(v))then
                    destroyElement(v)
                    JOB.object[i] = nil
                end
            end
        end

        local x,y,z = getElementPosition(localPlayer)
        for i = 1, 15 do
            JOB.object[i] = createObject(2672, x+math.random(-i,i), y+math.random(-i,i), z)
        end

        animate(z, getGroundPosition(x, y, z), 1, 5000, function(a)
            for i,v in pairs(JOB.object) do
                local x,y,z = getElementPosition(v)
                setElementPosition(JOB.object[i], x, y, a+0.1)
            end
        end, function()
            JOB.timer = setTimer(function()
                for i,v in pairs(JOB.object) do
                    if(isElement(v))then
                        destroyElement(v)
                        JOB.object[i] = nil
                    end
                end
            end, 5000, 1) -- delete object for 5s
        end)
    end
end)

JOB.onExit = function(player)
    if(player ~= localPlayer)then return end
    if(getElementData(localPlayer, "user:job") == "Lotnik")then
        if(JOB.timer and isTimer(JOB.timer))then
            killTimer(JOB.timer)

            for i,v in pairs(JOB.object) do
                if(isElement(v))then
                    destroyElement(v)
                    JOB.object[i] = nil
                end
            end
        end

        if(JOB.markerPoint and isElement(JOB.markerPoint))then
            destroyElement(JOB.markerPoint)
            destroyElement(JOB.blip)
        end

        triggerServerEvent("dodo.stop", resourceRoot)

        removeEventHandler("onClientVehicleExit", resourceRoot, JOB.onExit)

        setTimer(function()
            setElementPosition(localPlayer, 2003.0593261719,-2234.7744140625,13.546875)
        end, 500, 1)

        setElementData(localPlayer, "user:job", false)
        noti:addNotification('Zakończyłeś pracę.', 'info')
    end
end

-- useful

local anims, builtins = {}, {"Linear", "InQuad", "OutQuad", "InOutQuad", "OutInQuad", "InElastic", "OutElastic", "InOutElastic", "OutInElastic", "InBack", "OutBack", "InOutBack", "OutInBack", "InBounce", "OutBounce", "InOutBounce", "OutInBounce", "SineCurve", "CosineCurve"}

function table.find(t, v)
	for k, a in ipairs(t) do
		if a == v then
			return k
		end
	end
	return false
end

function animate(f, t, easing, duration, onChange, onEnd)
	assert(type(f) == "number", "Bad argument @ 'animate' [expected number at argument 1, got "..type(f).."]")
	assert(type(t) == "number", "Bad argument @ 'animate' [expected number at argument 2, got "..type(t).."]")
	assert(type(easing) == "string" or (type(easing) == "number" and (easing >= 1 or easing <= #builtins)), "Bad argument @ 'animate' [Invalid easing at argument 3]")
	assert(type(duration) == "number", "Bad argument @ 'animate' [expected function at argument 4, got "..type(duration).."]")
	assert(type(onChange) == "function", "Bad argument @ 'animate' [expected function at argument 5, got "..type(onChange).."]")
	table.insert(anims, {from = f, to = t, easing = table.find(builtins, easing) and easing or builtins[easing], duration = duration, start = getTickCount( ), onChange = onChange, onEnd = onEnd})
	return #anims
end

function destroyAnimation(a)
	if anims[a] then
		table.remove(anims, a)
	end
end

addEventHandler("onClientRender", root, function( )
	local now = getTickCount( )
	for k,v in ipairs(anims) do
		v.onChange(interpolateBetween(v.from, 0, 0, v.to, 0, 0, (now - v.start) / v.duration, v.easing))
		if now >= v.start+v.duration then
			if type(v.onEnd) == "function" then
				v.onEnd( )
			end
			table.remove(anims, k)
		end
	end
end)

--

if(getElementData(localPlayer, "user:job") == "Lotnik")then
    setElementData(localPlayer, "user:job", false)
end