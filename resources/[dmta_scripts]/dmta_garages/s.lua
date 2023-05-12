--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local db = exports.dmta_base_connect
local vehicles = exports.dmta_veh_base

local garages = {}

function garages:Load()
    local r = db:query('select * from db_garages')

    self['garages'] = {}
    self['vehicles'] = {}

    self['hit_fnc'] = function(...) self:OnHit(...) end
    self['create_fnc'] = function(player, id) self:CreateVehicle(player, id) end
    self['destroy_fnc'] = function(player) self:DestroyVehicle(player) end
    self['get_fnc'] = function(player, id) self:GetVehicle(player, id) end

    for i,v in ipairs(r) do
        self:CreateGarage(v)
    end
    
    addEvent('CreateVehicle', true)
    addEvent('DestroyVehicle', true)
    addEvent('GetVehicle', true)

    addEventHandler('CreateVehicle', resourceRoot, self['create_fnc'])
    addEventHandler('DestroyVehicle', resourceRoot, self['destroy_fnc'])
    addEventHandler('GetVehicle', resourceRoot, self['get_fnc'])
end

function garages:CreateVehicle(player, id)
    garages:DestroyVehicle(player)

	local r = db:query('select * from db_vehicles where id=? limit 1', id)
    for i,v in ipairs(r) do
		local position = fromJSON(v['position']) or {0,0,0}
		local color = fromJSON(v['color']) or {255,255,255,255,255,255}
		local tuning = fromJSON(v['tuning']) or {}

        self['vehicles'][player] = createVehicle(v['model'], unpack(position))
        if self['vehicles'][player] and isElement(self['vehicles'][player]) then
            setElementDimension(self['vehicles'][player], (getElementDimension(player)+100))
            setVehicleColor(self['vehicles'][player], unpack(color))
            setElementFrozen(self['vehicles'][player], true)

            for i,v in ipairs(tuning) do
                addVehicleUpgrade(self['vehicles'][player], tonumber(v))
            end

            triggerClientEvent(player, 'LoadVehicle', resourceRoot, self['vehicles'][player])
        end
	end
end

function garages:DestroyVehicle(player)
    local vehicle = self['vehicles'][player]
    if vehicle and isElement(vehicle) then
        destroyElement(vehicle)
        self['vehicles'][player] = false
    end
end

function garages:Refresh(id)
    self:DestroyGarage(id)

    local r = db:query('select * from db_garages where id=? limit 1', id)
    if r and #r > 0 then
        for i,v in ipairs(r) do
            self:CreateGarage(v)
        end
    end
end

function garages:CreateGarage(v)
    local query = db:query('select * from db_garages')
    for i,v in ipairs(query) do
		local pos_pos = split(v['pos'], ',')
		local pos = createMarker(pos_pos[1], pos_pos[2], pos_pos[3]-0.97, 'cylinder', 1.3, 105, 188, 235)
		setElementData(pos, 'marker:data', {query=v,type='pos'})
		setElementData(pos, 'marker:icon', 'car')
		local tw=createElement("text")
		setElementData(tw, "text", 'Garaż')
        setElementPosition(tw, pos_pos[1], pos_pos[2], pos_pos[3])
        setElementData(pos, 'data', v)
   -- local pos = fromJSON(v['pos'])
    --local marker = createMarker(pos[1], pos[2], pos[3]-0.98, 'cylinder', 2, 0, 100, 255)
    --setElementData(marker, 'data', v)

    addEventHandler('onMarkerHit', pos, self['hit_fnc'])
    end
end

function garages:DestroyGarage(id)
    for i,v in ipairs(getElementsByType('marker', resourceRoot)) do
        local data = getElementData(v, 'data')
        if data and data['id'] == id then
            removeEventHandler('onMarkerHit', v, self['hit_fnc'])
            destroyElement(v)
        end
    end
end

function garages:GetAccess(player, r)
    local access = false
    local owner, lokatorzy = r[1]['wlasciciel_nick'], (fromJSON(r[1]['lokatorzy']) or {})
    if getPlayerName(player) == owner then
        access = true
    else
        for i,v in ipairs(lokatorzy) do
            if v['name'] == getPlayerName(player) then
                access = true
                break
            end
        end
    end
    return access
end

function isVehicleExists(id)
    local q = db:query('select * from db_vehicles where parking=0 and garage=0 and id=?', id)
    if q and #q > 0 then
        return true
    end
    return false
end

function garages:OnHit(hit, dim)
	if not hit or hit and not isElement(hit) or hit and isElement(hit) and getElementType(hit) ~= 'player' or not dim then return end

    local data = getElementData(source, 'data')
    if not data then return end

    local r = db:query('select * from db_houses where id=? limit 1', data['house_id'])
    if r and #r > 0 then
        local vehicle = getPedOccupiedVehicle(hit)
        if vehicle then
            local veh_ID = getElementData(vehicle, 'vehicle:id')
            if not veh_ID then return end

            if self:GetAccess(hit, r) then
                local owner = getElementData(vehicle, 'vehicle:ownerName')
                local org = getElementData(vehicle, 'vehicle:organization') == '' and false
                local myOrg = getElementData(hit, 'user:organization') == '' and false
                if (owner and owner == getPlayerName(hit)) or (myOrg and org and myOrg == org) then
                    local vig = db:query('select * from db_vehicles where garage=?', data['id'])
                    if vig and #vig >= data['places'] then
                        outputChatBox("#ff0000● #ffffffBrak wolnych miejsc w garażu.", hit, 255, 255, 255, true)
                        return
                    end

                    db:query('update db_vehicles set garage=? where id=?', data['id'], veh_ID)

                    vehicles:saveVehicle(vehicle)
                    destroyElement(vehicle)

                    outputChatBox("#00ff00● #ffffffPomyślnie odstawiłeś pojazd do garażu.", hit, 255, 255, 255, true)

                    self:Refresh(data['id'])
                end
            end
        else
            if self:GetAccess(hit, r) then
                local houseType = r[1]['organization'] == '' and 1 or 0
                local vehicles = db:query('select * from db_vehicles where garage=? and ownerName=?', data['id'], getPlayerName(hit))

                if houseType == 1 then
                    local org = getElementData(hit, 'user:organization') or ''
                    vehicles = db:query('select * from db_vehicles where garage=? and organization=?', data['id'], org)
                end

                if #vehicles > 0 then
                    self:CreateVehicle(hit, vehicles[1])
                    triggerClientEvent(hit, 'Garages:GetVehicles', resourceRoot, vehicles)
                else
                    --outputChatBox("#ff0000● #ffffffNie posiadasz pojazdów w garażu.", hit, 255, 255, 255, true) 
                end
            end
        end
    end
end

function garages:GetElementsWithinMarker(marker, player)
	local markerShape = getElementColShape(marker)
    local elements = getElementsWithinColShape(markerShape)
    
    for i,v in ipairs(elements) do
        if v == player then
            return true 
        end
    end
    return false
end

function garages:GetWithinMarker(player)
    for i,v in ipairs(getElementsByType('marker', resourceRoot, true)) do
        if self:GetElementsWithinMarker(v, player) then
            return v
        end
    end
end

function garages:GetVehicle(player, id)
    local marker = self:GetWithinMarker(player)
    if not marker then return end

    local data = getElementData(marker, 'data')
    if data then
        if isVehicleExists(id) then
            outputChatBox("#ff0000● #ffffffPodany pojazd już istnieje.", player, 255, 255, 255, true) 
            return
        end
        
        db:query('update db_vehicles set garage=0 where id=?', id)
    
        local vehicle = vehicles:loadVehicle(id, player)
        if vehicle and isElement(vehicle) then
            local x,y,z = getElementPosition(marker)
            z = z + 1
            
            setElementPosition(vehicle, x, y, z)
            setElementRotation(vehicle, 0, 0, tonumber(data['veh_rot']))
        end
	end
end

function refreshGarage(id)
    garages:Refresh(id)
end

addEventHandler('onResourceStart', resourceRoot, function()
    garages:Load()
end)