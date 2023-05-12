--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local dxLibary = exports['dxLibary']
local anim = exports['dmta_base_anim']

local sw, sh = guiGetScreenSize()
local scale = Vector2(sw < 1920 and math.min(2, 1920 / sw) or 1, sh < 1080 and math.min(2, 1080 / sh) or 1)

local tick = getTickCount()
local type = 'join'
local lived = false

function isMouseIn(x, y, w, h)
	if not isCursorShowing() then return end

	local pos = {getCursorPosition()}
	pos[1],pos[2] = (pos[1]*sw),(pos[2]*sh)

	if pos[1] >= x and pos[1] <= (x+w) and pos[2] >= y and pos[2] <= (y+h) then
		return true
	end
	return false
end

local bankomat = {
	saldo = 0,
	icon = dxLibary:createTexture(':dmta_base_atms/images/w-icon.png', 'dxt5', false, 'clamp'),
	code = '?',
	balance = 0,
}

function formatMoney(money)
	while true do
		money, i = string.gsub(money, '^(-?%d+)(%d%d%d)', '%1,%2')
		if i == 0 then
			break
		end
	end
	return money
end

function guiBankomat()
	if type == 'join' then
		a,lived = anim:animation(tick, 0, 255, 500, 'Linear')
		a2 = anim:animation(tick, 0, 230, 500, 'Linear')
	elseif type == 'quit' then
		a,lived = anim:animation(tick, 255, 0, 250, 'Linear')
		a2 = anim:animation(tick, 230, 0, 250, 'Linear')

		if not lived then
        	removeEventHandler('onClientRender', root, guiBankomat)
		end
	end
	dxDrawRectangle(0, 0, 1920, 1080, tocolor(15, 15, 15, 200), false)
	dxLibary:dxLibary_createWindowAlpha(606/scale.x, 244/scale.y, 709/scale.x, 593/scale.y, a)

	dxDrawImage(600/scale.x, 200/scale.y, 45/scale.x, 33/scale.y, bankomat['icon'], 0, 0, 0, tocolor(255, 255, 255, a), false)
	dxLibary:dxLibary_text('Diamond BANK', 650/scale.x, 184/scale.y, 819/scale.x, 234/scale.y, tocolor(237, 237, 237, a), 10, 'default', 'left', 'bottom', false, false, false, false, false)

	dxLibary:dxLibary_text(getPlayerName(localPlayer), 637/scale.x, 244/scale.y, 819/scale.x, 294/scale.y, tocolor(237, 237, 237, a), 6, 'default', 'left', 'bottom', false, false, false, false, false)
	dxLibary:dxLibary_text('WŁAŚCICIEL KARTY', 637/scale.x, 294/scale.y, 768/scale.x, 319/scale.y, tocolor(237, 237, 237, a), 1, 'default', 'left', 'top', false, false, false, false, false)

	dxLibary:dxLibary_text(bankomat['code'], 637/scale.x, 334/scale.y, 819/scale.x, 384/scale.y, tocolor(237, 237, 237, a), 6, 'default', 'left', 'bottom', false, false, false, false, false)
	dxLibary:dxLibary_text('NUMER KARTY', 637/scale.x, 384/scale.y, 768/scale.x, 409/scale.y, tocolor(237, 237, 237, a), 1, 'default', 'left', 'top', false, false, false, false, false)

	dxLibary:dxLibary_createButtonAlpha('Wpłać', 629/scale.x, 650/scale.y, 215/scale.x, 50/scale.y, 3, a2)
	dxLibary:dxLibary_createButtonAlpha('Wypłać', 629/scale.x, 707/scale.y, 215/scale.x, 50/scale.y, 3, a2)
	dxLibary:dxLibary_createButtonAlpha('Anuluj', 629/scale.x, 765/scale.y, 215/scale.x, 50/scale.y, 3, a2)

	dxLibary:dxLibary_text('$'..formatMoney(getPlayerMoney(localPlayer)), 1002/scale.x, 265/scale.y, 1128/scale.x, 305/scale.y, tocolor(0, 255, 0, a), 8, 'default', 'center', 'center', false, false, false, false, false)
	dxLibary:dxLibary_text('$'..formatMoney(bankomat['saldo']), 1157/scale.x, 265/scale.y, 1283/scale.x, 305/scale.y, tocolor(105, 188, 235, a), 8, 'default', 'center', 'center', false, false, false, false, false)
	dxLibary:dxLibary_text('GOTÓWKA', 1002/scale.x, 300/scale.y, 1128/scale.x, 328/scale.y, tocolor(237, 237, 237, a), 1, 'default', 'center', 'top', false, false, false, false, false)
	dxLibary:dxLibary_text('SALDO BANKOWE', 1157/scale.x, 300/scale.y, 1283/scale.x, 328/scale.y, tocolor(237, 237, 237, a), 1, 'default', 'center', 'top', false, false, false, false, false)

	dxDrawRectangle(1012/scale.x, 347/scale.y, 261/scale.x, 54/scale.y, tocolor(30, 30, 30, a), false)
	dxLibary:dxLibary_text('$', 1022/scale.x, 347/scale.y, 1114/scale.x, 401/scale.y, tocolor(105, 188, 235, a), 8, 'default', 'left', 'center', false, false, false, false, false)
	dxLibary:dxLibary_text(bankomat['balance'], 1171/scale.x, 347/scale.y, 1263/scale.x, 401/scale.y, tocolor(207, 206, 206, a), 8, 'default', 'right', 'center', false, false, false, false, false)

	for i = 1,9 do
		local sX = 0
		local sY = 75/scale.x * (i - 1)

		if i >= 4 and i <= 6 then
			sX = 75/scale.y
			sY = 75/scale.x * (i - 4)
		elseif i >= 7 and i <= 9 then
			sX = (75 * 2)/scale.y
			sY = 75/scale.x * (i - 7)
		end

		dxDrawRectangle(1033/scale.x + sY, 420/scale.y + sX, 64/scale.x, 64/scale.y, tocolor(30, 30, 30, a), false)
		dxLibary:dxLibary_text(i, 1033/scale.x + sY, 420/scale.y + sX, 64/scale.x + 1033/scale.x + sY, 64/scale.y + 420/scale.y + sX, tocolor(207, 206, 206, a), 5, 'default', 'center', 'center', false, false, false, false, false)
	end

	local sX = (75 * 3)/scale.y
	dxDrawRectangle(1033/scale.x, 420/scale.y + sX, 64/scale.x, 64/scale.y, tocolor(30, 30, 30, a), false)
	dxLibary:dxLibary_text('0', 1033/scale.x, 420/scale.y + sX, 64/scale.x + 1033/scale.x, 64/scale.y + 420/scale.y + sX, tocolor(207, 206, 206, a), 5, 'default', 'center', 'center', false, false, false, false, false)

	local sY = 75/scale.x
	dxDrawRectangle(1033/scale.x + sY, 420/scale.y + sX, 64/scale.x, 64/scale.y, tocolor(30, 30, 30, a), false)
	dxLibary:dxLibary_text('C', 1033/scale.x + sY, 420/scale.y + sX, 64/scale.x + 1033/scale.x + sY, 64/scale.y + 420/scale.y + sX, tocolor(207, 206, 206, a), 5, 'default', 'center', 'center', false, false, false, false, false)

	local sY = (75 * 2)/scale.x
	dxDrawRectangle(1033/scale.x + sY, 420/scale.y + sX, 64/scale.x, 64/scale.y, tocolor(30, 30, 30, a), false)
	dxLibary:dxLibary_text('←', 1033/scale.x + sY, 420/scale.y + sX, 64/scale.x + 1033/scale.x + sY, 64/scale.y + 420/scale.y + sX, tocolor(207, 206, 206, a), 5, 'default', 'center', 'center', false, false, false, false, false)
end

function key(key, press)
	if press then
		if tonumber(key) and tonumber(key) >= 0 and tonumber(key) <= 9 then
			if tonumber(bankomat['balance']) == 0 then
				bankomat['balance'] = ''
			end

			if bankomat['balance']:len() < 8 then
				bankomat['balance'] = bankomat['balance'] .. tonumber(key)
			end
		elseif key == 'backspace' then
			bankomat['balance'] = string.sub(bankomat['balance'], 1, string.len(bankomat['balance']) - 1)

			if bankomat['balance'] == '' then
				bankomat['balance'] = 0
			end
		elseif key == 'c' then
			bankomat['balance'] = 0
		end
	end
end

function clicked(btn, state)
	if btn ~= 'state' and state ~= 'down' then return end

	for i = 1,9 do
		local sX = 0
		local sY = 75/scale.x * (i - 1)

		if i >= 4 and i <= 6 then
			sX = 75/scale.y
			sY = 75/scale.x * (i - 4)
		elseif i >= 7 and i <= 9 then
			sX = (75 * 2)/scale.y
			sY = 75/scale.x * (i - 7)
		end

		if isMouseIn(1033/scale.x + sY, 420/scale.y + sX, 64/scale.x, 64/scale.y) then
			if tonumber(bankomat['balance']) == 0 then
				bankomat['balance'] = ''
			end

			if bankomat['balance']:len() < 8 then
				bankomat['balance'] = bankomat['balance'] .. i
			end
		end
	end

	local sX = (75 * 3)/scale.y
	local sY = 75/scale.x
	local _sY = (75 * 2)/scale.x
	if isMouseIn(1033/scale.x, 420/scale.y + sX, 64/scale.x, 64/scale.y) then
		if tonumber(bankomat['balance']) == 0 then
			bankomat['balance'] = ''
		end

		if bankomat['balance']:len() < 8 and tonumber(bankomat['balance']) ~= 0 then
			bankomat['balance'] = bankomat['balance'] .. '0'
		end
	elseif isMouseIn(1033/scale.x + sY, 420/scale.y + sX, 64/scale.x, 64/scale.y) then
		bankomat['balance'] = 0
	elseif isMouseIn(1033/scale.x + _sY, 420/scale.y + sX, 64/scale.x, 64/scale.y) then
		bankomat['balance'] = string.sub(bankomat['balance'], 1, string.len(bankomat['balance']) - 1)

		if bankomat['balance'] == '' then
			bankomat['balance'] = 0
		end
	elseif isMouseIn(629/scale.x, 765/scale.y, 215/scale.x, 50/scale.y) then
		type = 'quit'
		tick = getTickCount()
		setElementFrozen(localPlayer, false)
		showChat(true)
		showCursor(false)
		removeEventHandler('onClientClick', root, clicked)
		removeEventHandler('onClientKey', root, key)
		setElementData(localPlayer, 'grey_shader', 0)
		setElementData(localPlayer, 'pokaz:hud', true)
		guiSetInputEnabled(false)
	elseif isMouseIn(1183/scale.x - 35/scale.x, 646/scale.y, 64/scale.y + 20/scale.x, 35/scale.y) then
		bankomat['balance'] = string.sub(bankomat['balance'], 1, string.len(bankomat['balance'])-1)

		if bankomat['balance'] == '' then
			bankomat['balance'] = 0
		end
	elseif isMouseIn(1033/scale.x + 15/scale.x, 646/scale.y, 64/scale.x + 20/scale.x, 35/scale.y) then
		bankomat['balance'] = 0
	elseif isMouseIn(629/scale.x, 650/scale.y, 215/scale.x, 50/scale.y) then
		triggerServerEvent('bankomat:akcja', resourceRoot, 'WPLAC', tonumber(bankomat['balance']), false)
	elseif isMouseIn(629/scale.x, 707/scale.y, 215/scale.x, 50/scale.y) then
		triggerServerEvent('bankomat:akcja', resourceRoot, 'WYPLAC', tonumber(bankomat['balance']), false)
	end
end

addEvent('goBankomat', true)
addEventHandler('goBankomat', resourceRoot, function(money)
	if lived then return end

	if money then
		bankomat['saldo'] = money
	end

	addEventHandler('onClientRender', root, guiBankomat)
	setElementData(localPlayer, 'grey_shader', 1)
	setElementData(localPlayer, 'pokaz:hud', false)
	setElementFrozen(localPlayer, true)
	addEventHandler('onClientClick', root, clicked)
	addEventHandler('onClientKey', root, key)
	showChat(false)
	showCursor(true)
	tick = getTickCount()
	type = 'join'

	guiSetInputEnabled(true)

	if bankomat['code'] == '?' then
		bankomat['code'] = string.sub(getPlayerSerial(localPlayer), 1, 4)..' '..string.sub(getElementData(localPlayer, 'user:register'), 1, 4)..' '..string.format('%04d', string.sub(getElementData(localPlayer, 'user:dbid'), 1, 4))..' 2021'
	end

	bankomat['balance'] = 0
end)

addEvent('update:saldo', true)
addEventHandler('update:saldo', resourceRoot, function(saldo)
	bankomat['saldo'] = saldo
end)
