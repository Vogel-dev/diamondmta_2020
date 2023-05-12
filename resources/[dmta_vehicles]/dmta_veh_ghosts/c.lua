--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

function render(element, time, startAlpha, tick, rnd)
    local a = interpolateBetween(startAlpha, 0, 0, 100, 0, 0, (getTickCount()-tick)/time, 'Linear')
    if element and isElement(element) then
        setElementAlpha(element, math.floor(a))
    end
end

function alphaDown(element, time, startAlpha)
    local tick = getTickCount()
    local rnd = function() render(element, time, startAlpha, tick) end

    addEventHandler('onClientRender', root, rnd)
    setTimer(function()
        removeEventHandler('onClientRender', root, rnd)
    end, time, 1)
end
addEvent('alpha:down', true)
addEventHandler('alpha:down', resourceRoot, alphaDown)


addEventHandler('onClientRender', root, function()
    --ghost vehicle
    local vehicles = 0
    for i,v in pairs(getElementsByType('vehicle', root, true)) do
        if vehicles == 0 then
            setElementAlpha(v, 255)
        end
        
        local x, y, z = getElementPosition(v)
        for _,k in pairs(getElementsByType('vehicle', root, true)) do
            if k ~= v and v and isElement(v) and k and isElement(k) then
                if not getElementData(k, 'vehicle:ghost') and not getElementData(v, 'vehicle:ghost') then
                    setElementCollidableWith(k, v, true)
                else
                    setElementCollidableWith(k, v, false)

                    local xx, yy, zz = getElementPosition(k)
                    local distance = getDistanceBetweenPoints3D(xx, yy, zz, x, y, z)
                    if distance < 6 then
                        vehicles = vehicles + 1

                        local alpha_ = ((distance + 5) / 11) * 255
                        setElementAlpha(v, tonumber(alpha_))
                        setElementAlpha(k, tonumber(alpha_))
                    end
                end
            end
        end
    end
    --ghost player
    local players = 0
    for i,v in pairs(getElementsByType('player', root, true)) do
        if players == 0 and not getElementData(v, 'inv') then
            setElementAlpha(v, 255)
        end
        
        local x, y, z = getElementPosition(v)
        for _,k in pairs(getElementsByType('player', root, true)) do
            if k ~= v and v and isElement(v) and k and isElement(k) then
                if not getElementData(k, 'user:ghost') and not getElementData(v, 'user:ghost') then
                    setElementCollidableWith(k, v, true)
                else
                    setElementCollidableWith(k, v, false)

                    local xx, yy, zz = getElementPosition(k)
                    local distance = getDistanceBetweenPoints3D(xx, yy, zz, x, y, z)
                    if distance < 6 then
                        players = players + 1

                        local alpha_ = ((distance + 5) / 11) * 255
							
						local a1 = getElementData(v, 'inv') and 0 or tonumber(alpha_)
                        setElementAlpha(v, a1)
							
						local a2 = getElementData(k, 'inv') and 0 or tonumber(alpha_)
                        setElementAlpha(k, a2)
                    end
                end
            end
        end
    end
end)