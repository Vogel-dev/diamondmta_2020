--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

level = {}
level.alpha = 0
--setElementData( localPlayer, "user:level", 0 )
--setElementData( localPlayer, "user:exp", 0 )
level.hide = 1

font = exports["buttons"]:getFont( 1 )
local dx = exports.dxLibary

sx, sy = guiGetScreenSize(  )

addEventHandler( "onClientRender", root, function()
	if not level.newLevel then
		level.newLevel = getElementData( localPlayer, "user:level" )
	end
	if not level.newExp then
		level.newExp = getElementData( localPlayer, "user:exp" )
	end
	if not level.newExp then level.newExp = 0 end
	if getElementData( localPlayer, "user:exp" ) ~= level.newExp then
		if getElementData( localPlayer, "user:exp" ) < level.newExp then
			if level.alpha < 255 then
				level.alpha = level.alpha + 5
			else
				setElementData( localPlayer, "user:exp", getElementData( localPlayer, "user:exp" ) + 0.5 )
				if getElementData( localPlayer, "user:exp" ) == 100 then
					setElementData( localPlayer, "user:exp", 0 )
					setElementData( localPlayer, "user:level", getElementData( localPlayer, "user:level" ) + 1 )
					level.newExp = level.newExp - 100
				end
			end
		else
			if level.alpha < 255 then
				level.alpha = level.alpha + 5
			else
				setElementData( localPlayer, "user:exp", getElementData( localPlayer, "user:exp" ) - 0.5 )
				if getElementData( localPlayer, "user:exp" ) < 0 then
					setElementData( localPlayer, "user:exp", 100 )
					setElementData( localPlayer, "user:level", getElementData( localPlayer, "user:level" ) - 1 )
					level.newExp = level.newExp + 100
				end
			end
		end
	else
		if level.hide == 1 then
			setTimer( function()
				level.hide = 2
			end, 15000, 1 )
		end
		if level.hide == 2 then
			if level.alpha > 0 then
				level.alpha = level.alpha - 5
			end
		end
	end
	dxDrawImage( sx * 0.5 - 200, sy - 100, 400, 100, "pasek.png", 0, 0, 0, tocolor(255, 255, 255, level.alpha) )
	dxDrawImageSection( sx * 0.5 - 200, sy - 100, getElementData( localPlayer, "user:exp" ) * 4, 100, 0, 0, getElementData( localPlayer, "user:exp" ) * 4, 100, "paseczek.png", 0, 0, 0, tocolor(255, 255, 255, level.alpha) )
	dxDrawImage( sx * 0.5 - 200, sy - 100, 400, 100, "poziom.png", 0, 0, 0, tocolor(255, 255, 255, level.alpha) )
	dx:dxLibary_text(getElementData( localPlayer, "user:level" ), -1, sy - 62, sx, sy, tocolor(255, 255, 255, level.alpha), 1, "default", "center", "center", false, false, false, true, false)
	--dxDrawText( getElementData( localPlayer, "user:level" ), -1, sy - 38, sx, sy, tocolor(255, 255, 255, level.alpha), 0.5, font, "center", "top" )
end )

function setLevel( level )
	setElementData( localPlayer, "user:level", level )
end

function setExp( level )
	setElementData( localPlayer, "user:exp", level )
	level.newExp = 0
end

function getLevel(  )
	return getElementData( localPlayer, "user:level" )
end

function addExp( exp )
	level.newExp = level.newExp + exp
end

function getExp(  )
	return getElementData( localPlayer, "user:exp" )
end

addEvent( "addExpC", true )
addEventHandler( "addExpC", localPlayer, function( exp )
	level.newExp = level.newExp + exp
end )