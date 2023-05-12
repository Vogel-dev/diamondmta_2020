--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local dxLibary = exports['dxLibary']
local gridlist = exports['gridlist']

local sw,sh = guiGetScreenSize()
local baseX = 1920
local scale = 1
local minScale = 2
if sw < baseX then
    scale = math.min(minScale, baseX/sw)
end

local notis = {
	text = '',
	tick = getTickCount(),
	accept = false,
}

local ucho = {
	logs = {},
	reports = {},
}

local warn = {
	text = '',
	admin = '',
	tick = getTickCount()
}

function myReports()
  local t = {}
  for i,v in ipairs(ucho.reports) do
    table.insert(t, v)
  end
  return t
end

local font = dxLibary:dxLibary_getFont(1)

function roundedRectangle(x, y, w, h, borderColor, bgColor, postGUI)
	if (x and y and w and h) then
		if (not borderColor) then
			borderColor = tocolor(0, 0, 0, 200);
		end
		
		if (not bgColor) then
			bgColor = borderColor;
		end
		
		--> Background
		dxDrawRectangle(x, y, w, h, bgColor, postGUI);
		
		--> Border
		dxDrawRectangle(x + 2, y - 1, w - 4, 1, borderColor, postGUI); -- top
		dxDrawRectangle(x + 2, y + h, w - 4, 1, borderColor, postGUI); -- bottom
		dxDrawRectangle(x - 1, y + 2, 1, h - 4, borderColor, postGUI); -- left
		dxDrawRectangle(x + w, y + 2, 1, h - 4, borderColor, postGUI); -- right
	end
end

addEventHandler('onClientRender', root, function()
  	--ucho
	if getElementData(localPlayer, 'logs:showed') and getElementData(localPlayer, 'pokaz:hud') then
		local logi = table.concat(ucho['logs'], '\n')
		dxLibary:dxLibary_shadowText2('Logi:\n'..logi, 21/scale, 372/scale, 274/scale, 749/scale, tocolor(255, 255, 255, 255), 2, 'default', 'left', 'top', false, false, false, false, false)

    local text = ''
    local newReports = (#ucho.reports - 10)

    for i,v in ipairs(ucho.reports) do
      if i <= 10 then
        text = (text:len()>0)and(text..'\n'..v[1])or(v[1])
      end
    end

    local textNewReports = newReports > 0 and newReports..'+' or ''
    dxLibary:dxLibary_shadowText2('Raporty:\n'..text..'\n\n'..textNewReports, 21/scale, 372/scale, sw - 21/scale, 749/scale, tocolor(255, 255, 255, 255), 2, 'default', 'right', 'top', false, false, false, false, false)
  end

	--notifikacje kar
	if notis['text'] ~= '' then
		if notis['accept'] ~= true and getTickCount()-notis['tick'] > 15000 then
			notis['tick'] = getTickCount()
			notis['accept'] = true
		end

		local w = dxGetTextWidth(notis.text, 1, font) + 20/scale
		if notis['accept'] == true then
			local y = interpolateBetween(-5/scale, 0, 0, -35/scale, 0, 0, (getTickCount()-notis['tick'])/500, 'Linear')
			roundedRectangle((sw / 2) - (w / 2), y, w, 35/scale, tocolor(15, 15, 15, 200), tocolor(15, 15, 15, 200), false)
			dxLibary:dxLibary_shadowText2(notis['text'], (sw / 2) - (w / 2), y, (sw / 2) - (w / 2) + w, 35/scale + y, tocolor(255, 0, 0, 255), 1, 'default', 'center', 'center', false, true, false, false, false)

			if getTickCount()-notis['tick'] > 500 then
				notis['text'] = ''
				notis['accept'] = false
				notis['tick'] = false
			end
		else
			local y = interpolateBetween(-35/scale, 0, 0, -5/scale, 0, 0, (getTickCount()-notis['tick'])/500, 'Linear')
			roundedRectangle((sw / 2) - (w / 2), y, w, 35/scale, tocolor(15, 15, 15, 200), tocolor(15, 15, 15, 200), false)
			dxLibary:dxLibary_shadowText2(notis['text'], (sw / 2) - (w / 2), y, (sw / 2) - (w / 2) + w, 35/scale + y, tocolor(255, 0, 0, 255), 1, 'default', 'center', 'center', false, true, false, false, false)
		end
	end

	--warn
	if warn['text'] ~= '' then
		local r,g,b = interpolateBetween(255, 0, 0, 200, 0, 0, (getTickCount()-warn['tick'])/1500, 'SineCurve')
		dxDrawRectangle(0, 0, sw, sh, tocolor(r, g, b, 150), true)
		dxLibary:dxLibary_shadowText2('Otrzymałeś ostrzeżenie od '..warn['admin'], 610/scale, 132/scale, 1311/scale, 240/scale, tocolor(255, 255, 255, 255), 6, 'default', 'center', 'center', false, false, true, false, false)
		dxLibary:dxLibary_shadowText2('Nie stosowanie się do ostrzeżeń może skutkować kickiem lub banem!', 610/scale, 793/scale, 1311/scale, 901/scale, tocolor(255, 255, 255, 255), 6, 'default', 'center', 'center', false, false, true, false, false)
		dxLibary:dxLibary_shadowText2('Powód:\n'..warn['text'], 610/scale, 486/scale, 1311/scale, 594/scale, tocolor(255, 255, 255, 255), 4, 'default', 'center', 'center', false, false, true, false, false)
	end
end)

addEvent('addAdminNotification', true)
addEventHandler('addAdminNotification', resourceRoot, function(text)
	notis['text'] = text
	notis['tick'] = getTickCount()
	notis['accept'] = false
	outputConsole(text)
end)

addEvent('updateLogs', true)
addEventHandler('updateLogs', root, function(logs)
	if getElementData(localPlayer, 'logs:showed') and getElementData(localPlayer, 'rank:duty') then
    ucho.logs = logs
  end
end)

addEvent('addReport', true)
addEventHandler('addReport', resourceRoot, function(text, player)
  table.insert(ucho.reports, {text, player})
end)

addEvent('removeReport', true)
addEventHandler('removeReport', resourceRoot, function(player)
	for i = 1,#ucho['reports'] do
		if ucho['reports'][i][2] == player then
			table.remove(ucho['reports'], i)
		end
	end
end)

addEvent('addWarn', true)
addEventHandler('addWarn', resourceRoot, function(text,admin)
	local time_warn = 5000

	warn['text'] = text
	warn['admin'] = admin
	setTimer(function()
		playSoundFrontEnd(5)
	end, 300, (time_warn/(300*2)))

	setTimer(function()
		warn['text'] = ''
		warn['admin'] = ''
	end, time_warn, 1)
end)
