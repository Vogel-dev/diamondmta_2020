function getNames ( ) 
    local players = {} 
    for k, player in ipairs( getElementsByType ("player") ) do 
        local name = getPlayerName( player )
        table.insert( players, {name} ) 
    end 
    return players 
end 

function getMoney ( ) 
    local players = {} 
    for k, player in ipairs( getElementsByType ("player") ) do 
		local money = getPlayerMoney(player)	
        table.insert( players, {money} ) 
    end 
    return players 
end 

function getPings ( ) 
    local players = {} 
    for k, player in ipairs( getElementsByType ("player") ) do 
		local ping = getPlayerPing( player ) 		
        table.insert( players, {ping} ) 
    end 
    return players 
end 