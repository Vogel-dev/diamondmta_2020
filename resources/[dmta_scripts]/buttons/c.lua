--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

sx, sy = guiGetScreenSize(  )

buttons = {}
buttonRender = {}
destroy = {}
id = {}
text = {}
limit = {}
fonts = {}

for i = 1,21 do 
	fonts[i] = dxCreateFont( "" .. i .. ".ttf", 20 )
end

function getFont( id )
	if id > #fonts then
		outputDebugString( "Nie wykryto takiej czcionki." )
	else
		return fonts[id]
	end
end

max = 50

addEventHandler( "onClientRender", root, function()
	for k,v in ipairs ( buttons ) do
		zmiana = 0
		if isMouseInPosition(v[1] - 1, v[2] - 1, v[3] + 2, v[4] + 2) then
			if v[5] < 80 then
				buttons[k] = {v[1], v[2], v[3], v[4], v[5] + 2}
				zmiana = 2
			end
		else
			if v[5] > 0 then
				buttons[k] = {v[1], v[2], v[3], v[4], v[5] - 2}
				zmiana = -2
			end
		end
		dxDrawRectangle( v[1] - 1, v[2] - 1, v[3] + 2, v[4] + 2, tocolor(70, 70, 70, 255), true )
		dxDrawRectangle( v[1], v[2], v[3], v[4], tocolor(25, 25, 25, 255), true )
		if buttonRender[k] then
			dxDrawImage( v[1], v[2], v[3], v[4], buttonRender[k], 0, 0, 0, tocolor(255, 255, 255, 255), true )
		end
		dxDrawText( text[k], v[1] + (v[3] / 2) + sx * 0.5, v[2] + (v[4] / 2) + sy * 0.5, v[3] / 2, v[4] / 2, tocolor(255, 255, 255, 255), 1, "default", "center", "center" )
		if v[6] == true then
			dxSetRenderTarget( buttonRender[k] )
				dxDrawImage(v[7] - v[9], v[8] - v[9], v[9] * 2, v[9] * 2, "circle.png", 0, 0, 0, tocolor(100, 100, 100, v[10]))
				buttons[k] = {v[1], v[2], v[3], v[4], v[5], true, v[7], v[8], v[9] + 5, v[10]}
				if v[9] + 5 > limit[k] then
					if v[10] > 0 then
						buttons[k] = {v[1], v[2], v[3], v[4], v[5], true, v[7], v[8], v[9] + 5, v[10] - 15, v[11]}
					else
						if buttonRender[k] then
							destroyElement( buttonRender[k] )
							buttonRender[k] = nil
						end
						if destroy[k] == true then
							buttons[k] = nil
						end
					end
				end
			dxSetRenderTarget(  )
		end
	end
end )

addEventHandler ( "onClientClick", getRootElement(), function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
	if button == "left" and state == "down" then
		for k,v in ipairs ( buttons ) do
			if isMouseInPosition(v[1] - 1, v[2] - 1, v[3] + 2, v[4] + 2) then
				cx, cy = getCursorPosition(  )
				cx = cx * sx
				cy = cy * sy
				cx = cx - (v[1] - 1)
				cy = cy - (v[2] - 1)
				buttons[k] = {v[1], v[2], v[3], v[4], v[5] + zmiana, true, math.floor(cx), math.floor(cy), 1, 255}
				if buttonRender[k] then
					destroyElement( buttonRender[k] )
				end
				buttonRender[k] = dxCreateRenderTarget( v[3], v[4], true )
			end
		end
	end
end )

function createButton(x, y, width, height, destroyB, idB, textB, limitek)
	freeButton = false
	for i = 1,max do
		if not buttons[i] then
			freeButton = i
			break
		end
	end
	if freeButton ~= false then
		buttons[freeButton] = {x, y, width, height, 0, false, 0, 0, 0, 0, 0, 1, 255}
		id[freeButton] = idB
		destroy[freeButton] = destroyB
		limit[freeButton] = limitek
		text[freeButton] = textB
	else
		outputDebugString( "Osiągnieto limit buttonów" )
	end
end

function destroyButton(idB)
	freeButton = false
	for i = 1,max do
		if id[i] == idB then
			freeButton = i
			break
		end
	end
	if freeButton ~= false then
		buttons[freeButton] = nil
	end
end

--setTimer(function() destroyButton("1button") end, 2000, 1)

function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
    local sx, sy = guiGetScreenSize ( )
    local cx, cy = getCursorPosition ( )
    local cx, cy = ( cx * sx ), ( cy * sy )
    if ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) then
        return true
    else
        return false
    end
end