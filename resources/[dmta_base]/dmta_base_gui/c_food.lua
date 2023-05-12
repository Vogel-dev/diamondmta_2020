--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

setTimer(function()
    if getElementData(localPlayer, "user:premium") then
        setElementData(localPlayer, "user:drink", getElementData(localPlayer, "user:drink")-1.25)
		setElementData(localPlayer, "user:food", getElementData(localPlayer, "user:food")-1.25)
	else
		setElementData(localPlayer, "user:food", getElementData(localPlayer, "user:food")-2.25)
		setElementData(localPlayer, "user:drink", getElementData(localPlayer, "user:drink")-2.25)
	end
	if getElementData(localPlayer, 'user:food') < 2 then
		setElementData(localPlayer, 'user:food', 3)
	end
	if getElementData(localPlayer, 'user:drink') < 2 then
		setElementData(localPlayer, 'user:drink', 3)
	end
	if getElementData( localPlayer, "user:food" ) <= 20 then
        if not getElementData(localPlayer, "user:job") then
		  toggleControl( "sprint", false );
        end
		setElementHealth( localPlayer, getElementHealth( localPlayer ) - 1 );
	else
        if not getElementData(localPlayer, "user:job") then
		  toggleControl( "sprint", true );
        end
	end
end, 60000, 0)

addEventHandler( "onClientElementDataChange", root, function( data, oldVal )
	if not getElementData(localPlayer, "user:logged") then return end
	if data == "user:food" then
		if getElementData( localPlayer, "user:food" ) <= 0 then
            if not getElementData(localPlayer, "user:job") then
			     toggleControl( "sprint", false )
            end
			setElementHealth( localPlayer, getElementHealth( localPlayer ) - 5)
		elseif getElementData( localPlayer, "user:food" ) > 1 then
            if not getElementData(localPlayer, "user:job") then
			     toggleControl( "sprint", true )
            end
		end
	end
end)

function getFood()
end