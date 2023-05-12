--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local anims, builtins = {}, {"Linear", "InQuad", "OutQuad", "InOutQuad", "OutInQuad", "InElastic", "OutElastic", "InOutElastic", "OutInElastic", "InBack", "OutBack", "InOutBack", "OutInBack", "InBounce", "OutBounce", "InOutBounce", "OutInBounce", "SineCurve", "CosineCurve"}

function table.find(t, v)
	for k, a in ipairs(t) do
		if a == v then
			return k
		end
	end
	return false
end

local addScale = false

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

-- animation function :D

local alpha = 0;
local dx = exports.dmta_tool_dx;

local class = {};
local self = {};
setmetatable(self, {__index=class});

local sw,sh = guiGetScreenSize();
local zoom = 1;
if sw < 1920 then
    zoom = math.min(2, 1920/sw);
end;

function getVehicleSpeed(veh)
    local vx, vy, vz = getElementVelocity(veh);
    return math.sqrt(vx^2+vy^2+vz^2)*145;
end;

function getElementSpeed(theElement, unit)
    -- Check arguments for errors
    assert(isElement(theElement), "Bad argument 1 @ getElementSpeed (element expected, got " .. type(theElement) .. ")")
    local elementType = getElementType(theElement)
    assert(elementType == "player" or elementType == "ped" or elementType == "object" or elementType == "vehicle" or elementType == "projectile", "Invalid element type @ getElementSpeed (player/ped/object/vehicle/projectile expected, got " .. elementType .. ")")
    assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"), "Bad argument 2 @ getElementSpeed (invalid speed unit)")
    -- Default to m/s if no unit specified and "ignore" argument type if the string contains a number
    unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
    -- Setup our multiplier to convert the velocity to the specified unit
    local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
    -- Return the speed by calculating the length of the velocity vector, after converting the velocity to the specified unit
    return (Vector3(getElementVelocity(theElement)) * mult).length
end

function getVehicleRPM(vehicle)
    local vehicleRPM = 0
        if (vehicle) then  
            if (getVehicleEngineState(vehicle) == true) then
                if getVehicleCurrentGear(vehicle) > 0 then             
                    vehicleRPM = math.floor(((getElementSpeed(vehicle, "km/h") / getVehicleCurrentGear(vehicle)) * 160) + 0.5) 
                    if (vehicleRPM < 650) then
                        vehicleRPM = math.random(650, 750)
                    elseif (vehicleRPM >= 9000) then
                        vehicleRPM = math.random(9000, 9900)
                    end
                else
                    vehicleRPM = math.floor((getElementSpeed(vehicle, "km/h") * 160) + 0.5)
                    if (vehicleRPM < 650) then
                        vehicleRPM = math.random(650, 750)
                    elseif (vehicleRPM >= 9000) then
                        vehicleRPM = math.random(9000, 9900)
                    end
                end
            else
                vehicleRPM = 730;
            end
            return tonumber(vehicleRPM)
        else
            return 0
        end
    end

class.load = function()
    self.txd = {
        "img/icons/I_brake.png",
        "img/icons/I_door.png",
        "img/icons/I_engine.png",
        "img/icons/I_light.png",
        "img/icons/I_petrol.png",
    
        "img/icons/I_brake_lighted.png",
        "img/icons/I_door_lighted.png",
        "img/icons/I_engine_lighted.png",
        "img/icons/I_light_lighted.png",
        "img/icons/I_petrol_lighted.png",
    
        "img/C_menu.png",
        "img/C_menu_lighted.png",
        "img/C_petrol_menu.png",
        "img/C_petrol_menu_bar.png",
        "img/S_pointer.png",
        "img/S_pointer_2.png",
    };

    self.img = {};

    for i,v in pairs(self.txd) do
        self.img[i] = dxCreateTexture(v, "argb", false, "clamp");
    end;

    self.render_fnc = function() self.render() end;
    self.pre_render_fnc = function() self.preRender() end;
    
    self.font = dx:getFont("rbt-bi", 8);
    self.font2 = dx:getFont("rbt-bi", 16);

    self.pos = {};
    self.pos_tick = getTickCount();

    self.gui = false;
end;

class.render = function()
    local veh = getPedOccupiedVehicle(localPlayer);
    if(veh and getElementData(localPlayer, "pokaz:hud")) then
        local mX = 10/zoom;
        local speed = getVehicleSpeed(veh);
        local rpm = getVehicleRPM(veh)/37;
        local fuel = getElementData(veh, "vehicle:fuel") or 25;
        local gas = getElementData(veh, 'vehicle:gas') or 25
        local distance = getElementData(veh, "vehicle:distance") or 0;
        local bak = getElementData(veh, 'vehicle:bak') or 25

        if(getElementModel(veh) == 453)then return end
        if(getElementModel(veh) == 509)then return end
        if(getElementModel(veh) == 481)then return end
        if(getElementModel(veh) == 510)then return end

    if getVehicleType(veh) == 'Bike' then

	    dxDrawText(string.format('%01d', speed)..' km/h', 1656/zoom + 1, 1025/zoom + 1, 1910/zoom + 1, 1045/zoom + 1, tocolor(0, 0, 0, 255), 1, self.font, 'right', 'bottom', false, false, false, false, false)
        dxDrawText('#69bceb'..string.format('%01d', speed)..'#939393 km/h', 1656/zoom, 1025/zoom, 1910/zoom, 1045/zoom, tocolor(255, 255, 255, 255), 1, self.font, 'right', 'bottom', false, false, false, true, false)

	    dxDrawText(string.format('%.1f', distance)..' km', 1685/zoom + 1, 1041/zoom + 1, 1910/zoom + 1, 1035/zoom + 1, tocolor(0, 0, 0, 255), 1, self.font, 'right', 'top', false, false, false, true, false)
        dxDrawText('#69bceb'..string.format('%.1f', distance)..'#939393 km', 1685/zoom, 1041/zoom, 1910/zoom, 1035/zoom, tocolor(255, 255, 255, 255), 1, self.font, 'right', 'top', false, false, false, true, false)

		dxDrawText(string.format('%.1f', fuel)..' / '..bak..'L', 1685/zoom + 1, 975/zoom + 1, 1910/zoom + 1, 1072/zoom + 1, tocolor(0, 0, 0, 255), 1, self.font, 'right', 'top', false, false, false, true, false)
		dxDrawText('#69bceb'..string.format('%.1f', fuel)..'#939393 / #69bceb'..bak..'#939393L', 1685/zoom, 975/zoom, 1910/zoom, 1072/zoom, tocolor(255, 255, 255, 255), 1, self.font, 'right', 'top', false, false, false, true, false)
    else

        if fuel > bak then
            fuel = bak
        elseif gas > bak then
            gas = bak
        end

        if speed > 25 and getVehicleType(veh) == 'Bike' then
            local lvl = (speed-25) > 255 and 255 or (speed-25)
            setBlurLevel(lvl)
        else
            setBlurLevel(0)
        end

       -- fuel = fuel < 0 and 0 or fuel

        distance = string.format("%08.1f", distance);

        if(getVehicleOverrideLights(veh) == 2)then
            dxDrawImage(sw-516/zoom-mX, sh-398/zoom, 486/zoom, 368/zoom, self.img[12], 0, 0, 0, tocolor(255, 255, 255, alpha), false); -- glowna tarcza
            dxDrawImage(sw-209/zoom-mX, sh-95/zoom, 42/zoom, 34/zoom, self.img[9], 0, 0, 0, tocolor(255, 255, 255, alpha), false); -- swiatla
            dxDrawImage(sw-66/zoom-mX, sh-114/zoom, 34/zoom, 36/zoom, self.img[10], 0, 0, 0, tocolor(255, 255, 255, alpha), false); -- paliwo ikonka
        else
            dxDrawImage(sw-516/zoom-mX, sh-398/zoom, 486/zoom, 368/zoom, self.img[11], 0, 0, 0, tocolor(255, 255, 255, alpha), false); -- glowna tarcza
            dxDrawImage(sw-209/zoom-mX, sh-95/zoom, 42/zoom, 34/zoom, self.img[4], 0, 0, 0, tocolor(255, 255, 255, alpha), false); -- swiatla
            dxDrawImage(sw-62/zoom-mX, sh-110/zoom, 25/zoom, 27/zoom, self.img[5], 0, 0, 0, tocolor(255, 255, 255, alpha), false); -- paliwo ikonka
        end;

        dxDrawImage(sw-390/zoom-mX, sh-395/zoom, 356/zoom, 358/zoom, self.img[16], speed-30.5, 0, 0, tocolor(255, 255, 255, alpha), false); -- predkosc
        --dxDrawImage(sw-508/zoom-mX, sh-225/zoom, 181/zoom, 194/zoom, self.img[15], rpm-50, 0, 0, tocolor(255, 255, 255, alpha), false); -- obroty

        if(getElementData(veh, "vehicle:handbrake"))then
            dxDrawImage(sw-292/zoom-mX, sh-100/zoom, 44/zoom, 36/zoom, self.img[6], 0, 0, 0, tocolor(255, 255, 255, alpha), false); -- reczny
        else
            dxDrawImage(sw-292/zoom-mX, sh-100/zoom, 44/zoom, 36/zoom, self.img[1], 0, 0, 0, tocolor(255, 255, 255, alpha), false); -- reczny
        end;

        if(isVehicleLocked(veh))then
            dxDrawImage(sw-167/zoom-mX, sh-103/zoom, 36/zoom, 40/zoom, self.img[7], 0, 0, 0, tocolor(255, 255, 255, alpha), false); -- zamek
        else
            dxDrawImage(sw-167/zoom-mX, sh-103/zoom, 36/zoom, 40/zoom, self.img[2], 0, 0, 0, tocolor(255, 255, 255, alpha), false); -- zamek
        end;

        if(getVehicleEngineState(veh))then
            dxDrawImage(sw-252/zoom-mX, sh-95/zoom, 44/zoom, 36/zoom, self.img[8], 0, 0, 0, tocolor(255, 255, 255, alpha), false); -- silnik
        else
            dxDrawImage(sw-252/zoom-mX, sh-95/zoom, 44/zoom, 36/zoom, self.img[3], 0, 0, 0, tocolor(255, 255, 255, alpha), false); -- silnik
        end;

        --dxDrawText(string.format('%01d', speed)..'km/h', sw-516/zoom-mX+ 1, sh-458/zoom+ 1, 486/zoom+sw-395/zoom-mX+ 1, 368/zoom+sh-210/zoom+ 1, tocolor(0, 0, 0, 255), 1, self.font2, "center", "center", false)
        --dxDrawText(''..string.format('%01d', speed)..'km/h', sw-516/zoom-mX, sh-458/zoom, 486/zoom+sw-395/zoom-mX, 368/zoom+sh-210/zoom, tocolor(200, 200, 200, 255), 1, self.font2, "center", "center", false)


        dxDrawText(distance.."km", sw-516/zoom-mX+ 1, sh-398/zoom+ 1, 486/zoom+sw-395/zoom-mX+ 1, 368/zoom+sh-210/zoom+ 1, tocolor(0, 0, 0, 255), 1, self.font, "center", "center", false); -- przebieg
        dxDrawText(distance.."km", sw-516/zoom-mX, sh-398/zoom, 486/zoom+sw-395/zoom-mX, 368/zoom+sh-210/zoom, tocolor(150, 150, 150, alpha), 1, self.font, "center", "center", false); -- przebieg
        --dxDrawText(string.format('%01d', speed.."km/h", sw-316/zoom-mX, sh-398/zoom, 486/zoom+sw-395/zoom-mX, 368/zoom+sh-210/zoom, tocolor(215, 212, 212, alpha), 1, self.font, "center", "center", false); -- przebieg

        dxDrawImage(sw-135/zoom-mX, sh-405/zoom, 132/zoom, 295/zoom, self.img[13], 0, 0, 0, tocolor(255, 255, 255, alpha)); -- paliwo
       -- dxDrawImage(sw-135/zoom-mX, sh-405/zoom, 132/zoom, 295/zoom * (fuel/bak), "img/C_petrol_menu_bar.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
        dxDrawImageSection(sw-135/zoom-mX, sh-405/zoom+295/zoom, 132/zoom, -(fuel/bak/1.36)*401/zoom, 0, 0, 132, -(fuel/bak/1.36)*401, "img/C_petrol_menu_bar.png", 0, 0, 0, tocolor(255, 255, 255, alpha), false); -- paliwo
    end; 
end;
end;

class.preRender = function()
    local vehicle = getPedOccupiedVehicle(localPlayer);
    if(not vehicle)then return end

    local distance = getElementData(vehicle, "vehicle:distance") or 0;
    local fuel = getElementData(vehicle, "vehicle:fuel") or 25;
    local gas = getElementData(vehicle, "vehicle:gas") or 25;
    local actualType = getElementData(vehicle, "vehicle:actualType") or "sBenzyna";

    if(((actualType == "Benzyna" or actualType == "Diesel") and fuel <= 0) or (actualType == "LPG" and gas <= 0) and getVehicleEngineState(vehicle) == true)then
        setVehicleEngineState(vehicle, false);
    end;

    if(#self.pos < 3)then
        self.pos = {getElementPosition(vehicle)};
        self.pos_tick = getTickCount();
    else
        local x,y,z = getElementPosition(vehicle);
        local dist = getDistanceBetweenPoints3D(self.pos[1], self.pos[2], self.pos[3], x, y, z);
        if(dist > 10)then
            setElementData(vehicle, "vehicle:distance", distance+0.01)

            if(actualType == "Benzyna" or actualType == "Diesel")then
                setElementData(vehicle, "vehicle:fuel", fuel-0.01);
            elseif(actualType == "LPG")then
                setElementData(vehicle, "vehicle:gas", gas-0.01);
            end;

            self.pos = {getElementPosition(vehicle)};
            self.pos_tick = getTickCount();
        end
    end
end;

addEventHandler("onClientVehicleEnter", root, function(player)
    if(player ~= localPlayer or self.gui)then return end;

    addEventHandler("onClientRender", root, self.render_fnc);
    addEventHandler("onClientPreRender", root, self.pre_render_fnc);

    animate(alpha, 255, 1, 500, function(a)
        alpha = a;
    end);

    self.gui = true;
end);

addEventHandler("onClientVehicleStartExit", root, function(player)
    if(player ~= localPlayer)then return end;

    if(not wasEventCancelled())then
        animate(alpha, 0, 1, 500, function(a)
            alpha = a;

            if(a == 0)then
                removeEventHandler("onClientRender", root, self.render_fnc);
                removeEventHandler("onClientPreRender", root, self.pre_render_fnc);
                self.gui = false;
            end;
        end);
    end;
end);

addEventHandler("onClientResourceStart", resourceRoot, function()
    if(getPedOccupiedVehicle(localPlayer))then
        addEventHandler("onClientRender", root, self.render_fnc);
        addEventHandler("onClientPreRender", root, self.pre_render_fnc);

        self.gui = true;

        animate(alpha, 255, 1, 500, function(a)
            alpha = a;
        end);
    end;
end);

class.load();