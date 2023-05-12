--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local no_damage = {
	[23] = true,
	[41] = true,
	[42] = true,
}

local only_aim = {
	[32] = true,
}

local strzelanie = {
	[23] = true, -- Paralizator
[24] = true, -- Deagle
[38] = true, -- Minigun
[41] = true, -- Spray
[42] = true, -- Gaśnica
[46] = true, -- Aparat
[35] = true, -- Dildo
[9] = true, -- Dildo
[43] = true, -- Camera
[25] = true, -- ShotGun
[8] = true, -- siekiera
[16] = true, -- granat
[34] = true, -- Dildo
[30] = true, -- ak
[3] = true, -- ak
[5] = true, -- ak
[31] = true, -- ak
[36] = true, -- ak
[4] = true, -- noz
[28] = true, -- uzi
[32] = false, -- tec
[39] = true, -- bomba
[40] = true, -- detonator
[1] = true, -- kastet
[37] = true, -- ogien
[18] = true, -- molotiov
[26] = true, -- obrzyn
[27] = true, -- bojowa
[7] = true, -- kij bilardow
[22] = true, -- colt
[17] = true, -- gaz
}

function getDM()
	if no_damage[getPedWeapon(localPlayer)] then
		toggleControl('fire', true)
		toggleControl('aim_weapon', true)
		toggleControl('action', true)
	elseif only_aim[getPedWeapon(localPlayer)] then
		toggleControl('fire', false)
		toggleControl('aim_weapon', true)
		toggleControl('action', false)
	elseif strzelanie[getPedWeapon(localPlayer)] then
		toggleControl('fire', true)
		toggleControl('aim_weapon', true)
		toggleControl('action', true)
	else
		toggleControl('fire', false)
		toggleControl('aim_weapon', false)
		toggleControl('action', false)
	end
end

addEventHandler('onClientPlayerSpawn', root, function()
	setPlayerNametagShowing(root, false)
	toggleControl('fire', false)
	toggleControl('aim_weapon', false)
	toggleControl('action', false)
end)

addEventHandler('onClientPedDamage', root, function()
	cancelEvent()
end)