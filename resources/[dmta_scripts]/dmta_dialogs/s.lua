--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

addEventHandler("onResourceStart", resourceRoot, function ()
	local osmanski_podpowiedz = createColSphere(2398.1103515625,-1207.6484375,28.383653640747, 1);
	addEventHandler("onColShapeHit", osmanski_podpowiedz, enter_osmanski);
	addEventHandler("onColShapeLeave", osmanski_podpowiedz, exit_osmanski);
end);

function enter_osmanski(hit, dim)
	addCommandHandler("daj", osmanski_dialog);
	outputChatBox("#fada5e● #ffffffŁukasz Osmański mówi: #969696Yo men, masz tą JustCole, kurwa?", hit, 255, 255, 255, true)
	outputChatBox("#fada5e● #ffffffJeżeli posiadasz puszkę JustColi wpisz #969696/daj", hit, 255, 255, 255, true)
end

function exit_osmanski(hit, dim)
	removeCommandHandler("daj", osmanski_dialog);
end

function osmanski_dialog(plr, cmd)
	local uzyl_podpowiedz = getElementData(plr, "user:osmanski_podpowiedz") or 0;

	if getElementData(plr, 'user:justcola') == 1 then
	if uzyl_podpowiedz == 0 then
		setElementData(plr, "user:osmanski_podpowiedz", 1);
		outputChatBox("#fada5e● #ffffffŁukasz Osmański mówi: #969696Yo men, kurwa ratujesz mi życie, słyszałeś o tej przeróbce kokainy w El Quebrados, hasło to: Łysy kuje dupsko.", plr, 255, 255, 255, true)
	end
else
	outputChatBox("#fada5e● #ffffffŁukasz Osmański mówi: #969696Yo men, nie masz puszki to wypierdalaj kurwa.", plr, 255, 255, 255, true)
end
if uzyl_podpowiedz == 1 then
	outputChatBox("#fada5e● #ffffffŁukasz Osmański mówi: #969696Yo men, kurwa wypierdalaj stąd nie będę się dwa razy powtarzał.", plr, 255, 255, 255, true)
end
end
--kokaina_wejscie_przerobka
addEventHandler("onResourceStart", resourceRoot, function ()
	local kokaina_2_wejscie = createColSphere(-1841.5725097656,1225.60546875,27.8437, 1);
	addEventHandler("onColShapeHit", kokaina_2_wejscie, enter_kokaina);
	addEventHandler("onColShapeLeave", kokaina_2_wejscie, exit_kokaina);
end);

function enter_kokaina(hit, dim)
	addCommandHandler("haslo", kokaina_dialog);
	outputChatBox("#fada5e● #ffffffDaniel Łagocki mówi: #969696Czego tu kurwa, zaraz Ci zajebie!", hit, 255, 255, 255, true)
	outputChatBox("#fada5e● #ffffffJeżeli znasz hasło od Osmańskiego wpisz #969696/haslo", hit, 255, 255, 255, true)
end

function exit_kokaina(hit, dim)
	removeCommandHandler("haslo", kokaina_dialog);
end

function kokaina_dialog(plr, cmd)
	if getElementData(plr, 'user:justcola') == 1 then
		outputChatBox("#fada5e● #ffffffDaniel Łagocki mówi: #969696Dobra kurwa, wchodzisz tylko morda w kubeł i nikomu nie mówisz o tym miejscu!", plr, 255, 255, 255, true)
		setElementPosition(plr, 2564.916015625,-1640.724609375,17158.857421875)
		setElementInterior(plr, 1)
else
	outputChatBox("#fada5e● #ffffffDaniel Łagocki mówi: #969696Wypierdalaj stąd kurwa, dęty konfidencie!", plr, 255, 255, 255, true)
end
end

local marker = createMarker(2562.4953613281,-1640.56640625,17158.857421875-0.95, 'cylinder', 1.2, 255, 50, 15)
setElementInterior(marker, 1)
setElementData(marker, 'marker:icon', 'brak')
function tp(plr)
setElementPosition(plr, -1839.1575927734,1224.8701171875,27.84375)
setElementInterior(plr, 0)
end
addEventHandler("onMarkerHit", marker, tp)