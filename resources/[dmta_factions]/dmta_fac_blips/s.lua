--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

playerBlips = { }

for index,value in ipairs(getElementsByType("player")) do
    if( playerBlips [ value ] ) then
    destroyElement( playerBlips[ value ] )
            playerBlips [ value ] = nil
    end
        playerBlips[ value ] = createBlipAttachedTo ( value, 0 )	
    setElementVisibleTo(playerBlips[value],getRootElement( ),false)
     
    --if getElementData(value, 'user:sapd_gps') then
    if getElementData(value, 'user:faction') == 'SAPD' then
    for index1,value1 in ipairs(getElementsByType("player")) do
    --if getElementData(value, 'user:sapd_gps') then
    if getElementData(value1, 'user:faction') == 'SAPD' then
	setElementVisibleTo(playerBlips[value],value1,true)
	setBlipColor(playerBlips[value], 0, 56, 168, 255)
    --end
    --end
    end	
    end
    end	
    end
    
    for index,value in ipairs(getElementsByType("player")) do
        if( playerBlips [ value ] ) then
        destroyElement( playerBlips[ value ] )
                playerBlips [ value ] = nil
        end
            playerBlips[ value ] = createBlipAttachedTo ( value, 0 )	
        setElementVisibleTo(playerBlips[value],getRootElement( ),false)
        
        if getElementData(value, 'user:faction') == 'EMS' then
        for index1,value1 in ipairs(getElementsByType("player")) do
        if getElementData(value1, 'user:faction') == 'EMS' then
        setElementVisibleTo(playerBlips[value],value1,true)
        setBlipColor(playerBlips[value], 212, 0, 0, 255)
        --end
        --end
        end	
        end
        end	
        end
	
setTimer(
    function()  
        restartResource(getThisResource())
    end,
60000, 0)
