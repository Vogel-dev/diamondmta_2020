--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

function alphaDown(element, time, startAlpha)
    triggerClientEvent(root, 'alpha:down', resourceRoot, element, time, startAlpha)
end


local alpha_cuboids = {
    {999.02319335938, -1348.7664794922, 13.351495742798-1,14.5,17,5,'vehicle'},
    {999.02319335938, -1348.7664794922, 13.351495742798-1,14.5,17,5,'player'},
    {1806.58313, -2066.87866, 12.55989, 5.5621337890625, 4.11474609375, 1.8932088851929,'vehicle'},
}

for i,v in ipairs(alpha_cuboids) do
    local cs = createColCuboid(v[1], v[2], v[3], v[4], v[5], v[6])
    setElementData(cs, 'ghost', v[7])
end

addEventHandler('onColShapeHit', resourceRoot, function(hit, dim)
	if not hit or hit and not isElement(hit) or hit and isElement(hit) and getElementType(hit) ~= 'player' or not dim then return end

    local type = getElementData(source, 'ghost')
    if type == 'vehicle' then
        local veh = getPedOccupiedVehicle(hit)
        if not veh then return end

        local ghost = getElementData(veh, 'vehicle:ghost')
        if not ghost then
            setElementData(veh, 'vehicle:ghost', true)
        else
            setElementData(veh, 'value:ghost', true)
        end
    elseif type == 'player' then
        local ghost = getElementData(hit, 'user:ghost')
        if not ghost then
            setElementData(hit, 'user:ghost', true)
        else
            setElementData(hit, 'value:ghost', true)
        end
    end
end)

addEventHandler('onColShapeLeave', resourceRoot, function(hit, dim)
	if not hit or hit and not isElement(hit) or hit and isElement(hit) and getElementType(hit) ~= 'player' or not dim then return end

    local type = getElementData(source, 'ghost')
    if type == 'vehicle' then
        local veh = getPedOccupiedVehicle(hit)
        if not veh then return end

        local value = getElementData(veh, 'value:ghost')
        if not value then
            setElementData(veh, 'vehicle:ghost', false)
        else
            setElementData(veh, 'value:ghost', false)
        end
    elseif type == 'player' then
        local value = getElementData(hit, 'value:ghost')
        if not value then
            setElementData(hit, 'user:ghost', false)
        else
            setElementData(hit, 'value:ghost', false)
        end
    end
end)