--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

engineImportTXD (engineLoadTXD("taser.txd"), 347)
engineReplaceModel(engineLoadDFF("taser.dff", 347), 347)

function strzal(wp, _, _, hitX, hitY, hitZ, element, startX, startY, startZ)
	if(wp == 23) then
		strzal(hitX, hitY, hitZ, startX, startY, startZ)
		if(source == localPlayer) then
			strzal()
		end
	end
end
addEventHandler("onClientPlayerWeaponFire", getRootElement(), strzal)