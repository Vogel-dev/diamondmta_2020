--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

function pokazPrzedmioty()
	local q = exports['dmta_base_connect']:query("SELECT * FROM db_items WHERE dbid=?", getElementData(source, "user:dbid"))
	local przedmioty = {}

	for i = 1, #q do
		table.insert(przedmioty, {nazwa = q[i]["nazwa"], id = q[i]["id"]})
	end

	return przedmioty
end

addEvent("pokazPrzedmioty:eq", true)
addEventHandler("pokazPrzedmioty:eq", root, function()
	triggerClientEvent(source, "pokazPrzedmioty:eq:client", source, pokazPrzedmioty())
end)

addEvent("usunPrzedmiot:eq", true)
addEventHandler("usunPrzedmiot:eq", root, function(id)
	exports["dmta_base_connect"]:query("DELETE FROM db_items WHERE id=?", tonumber(id))
end)

addEvent("dajAnimacjeJedzenia:eq", true)
addEventHandler("dajAnimacjeJedzenia:eq", root, function(gracz, rodzaj)
	if rodzaj == "jedz" then
		setPedAnimation(gracz, "FOOD", "eat_burger", -1, false)
		setTimer(function()
			setPedAnimation(gracz, false)
		end, 5000, 1)
	elseif rodzaj == "pije" then
		setPedAnimation(gracz, "VENDING", "VEND_Drink_P", -1, false)
		setTimer(function()
			setPedAnimation(gracz, false)
		end, 1350, 1)
	end
end)

addEvent("odegrajRp:eq", true)
addEventHandler("odegrajRp:eq", root, function(gracz, tekst)
	local x, y, z = getElementPosition(gracz)
	local cuboid = createColSphere(x, y, z, 20)
	local wCuboid = getElementsWithinColShape(cuboid, "player")
	destroyElement(cuboid)
	for _, p in ipairs(wCuboid) do
		outputChatBox(tekst, p, 255, 255, 255, true)
	end
end)

local papierosy = {} 
--[[
dojedzenia = {}
player_burger = {}
wpierdala = {}

function wpiedala(gracz)
	if wpierdala[gracz] then return end
	wpierdala[gracz] = true
    setPedAnimation ( gracz, "FOOD", "eat_burger", 5000, false, false )
	setTimer(function () setPedAnimation(gracz,false);wpierdala[gracz] = nil; end,5000,1)
	--setPedWalkingStyle(gracz,126)
	dojedzenia[gracz] = dojedzenia[gracz] -1
	if dojedzenia[gracz] == 0 then
	destroyElement(player_burger[gracz])
	player_burger[gracz] = nil
    unbindKey(gracz, "fire", "down", wpiedala)
	end
end

addEvent("wpierdalaj:eq", true)
addEventHandler("wpierdalaj:eq", root, function(gracz)
	local burger = createObject(2880,0,0,0)
	player_burger[gracz] = burger
	dojedzenia[gracz] = 1
	exports.bone_attach:attachElementToBone(burger,gracz,12,0,0.00,0.00,-0.00,270,0)
    bindKey(gracz, "fire", "down", wpiedala)
end)--]]

--[[
dopicia = {}
player_pucha = {}
pije = {}

function pij(gracz)
	if pije[gracz] then return end
	pije[gracz] = true
    setPedAnimation ( gracz, "BAR", "dnk_stndM_loop", 2400, false, false )
	setTimer(function () setPedAnimation(gracz,false);pije[gracz] = nil; end,2400,1)
	--setPedWalkingStyle(gracz,126)
	dopicia[gracz] = dopicia[gracz] -1
	if dopicia[gracz] == 0 then
	destroyElement(player_pucha[gracz])
	player_pucha[gracz] = nil
    unbindKey(gracz, "fire", "down", pij)
	end
end

addEvent("pijPuszka:eq", true)
addEventHandler("pijPuszka:eq", root, function(gracz)
	local pucha = createObject(2601,0,0,0)
	player_pucha[gracz] = pucha
	dopicia[gracz] = 1
	exports.bone_attach:attachElementToBone(pucha,gracz,12,0,0.04,0.06,-0.03,270,0)
    bindKey(gracz, "fire", "down", pij)
end)
--]]

dopiciabutla = {}
player_butla = {}
pije2 = {}

function pij2(gracz)
	if pije2[gracz] then return end
	pije2[gracz] = true
    setPedAnimation ( gracz, "BAR", "dnk_stndM_loop", 2400, false, false )
	setTimer(function () setPedAnimation(gracz,false);pije2[gracz] = nil; end,2400,1)
	--setPedWalkingStyle(gracz,126)
	dopiciabutla[gracz] = dopiciabutla[gracz] -1
	if dopiciabutla[gracz] == 0 then
	destroyElement(player_butla[gracz])
	player_butla[gracz] = nil
    unbindKey(gracz, "fire", "down", pij2)
	end
end

addEvent("pijButla:eq", true)
addEventHandler("pijButla:eq", root, function(gracz)
	local butla = createObject(1486,0,0,0)
	player_butla[gracz] = butla
	dopiciabutla[gracz] = 2
	exports.bone_attach:attachElementToBone(butla,gracz,12,0,0.04,0.06,-0.03,270,0)
    bindKey(gracz, "fire", "down", pij2)
end)

dospalenia = {}
player_pet = {}
pali = {}

function pal(gracz)
	if pali[gracz] then return end
	pali[gracz] = true
    setPedAnimation ( gracz, "SMOKING", "M_smk_drag", 5000, false, false )
	setTimer(function () setPedAnimation(gracz,false);pali[gracz] = nil; end,5000,1)
	--setPedWalkingStyle(gracz,126)
	dospalenia[gracz] = dospalenia[gracz] -1
	if dospalenia[gracz] == 0 then
	setPedAnimation ( gracz, "SMOKING", "M_smk_out", 5000, false, false )
	setTimer(function () setPedAnimation(gracz,false) end,5000,1)
	destroyElement(player_pet[gracz])
	player_pet[gracz] = nil
    unbindKey(gracz, "fire", "down", pal)
	end
end

function trzepnij(gracz) 
	if isElement(player_pet[gracz]) then 
		setPedAnimation ( gracz, "SMOKING", "M_smk_tap", 3400, false, false )
		setTimer(function () setPedAnimation(gracz,false) end,3400,1)
		bindKey(gracz, "mouse2", "down", trzepnij)
    end 
end 
addCommandHandler("trzep", trzepnij)

addEvent("palPeta:eq", true)
addEventHandler("palPeta:eq", root, function(gracz)
	local pet = createObject ( 3027, 0, 0, 0 ) 
	player_pet[gracz] = pet
	dospalenia[gracz] = 7
	exports.bone_attach:attachElementToBone(pet,gracz,12,0,0.04,0.06,-0.03,0,0)
	bindKey(gracz, "fire", "down", pal)
	bindKey(gracz, "mouse2", "down", trzepnij)
end)

addEvent("zapalPapierosa:eq", true)
addEventHandler("zapalPapierosa:eq", root, function(gracz)
	local x, y, z = getElementPosition(gracz) 
    papierosy[gracz] = createObject ( 3027, 0, 0, 0 ) 
    exports["bone_attach"]:attachElementToBone(papierosy[gracz], gracz, 1, -0.01, 0.06, -0.01, 90, 90, 90 ) 
    toggleControl(gracz, "jump", false )
end)

addEvent("dajWedke:eq", true)
addEventHandler("dajWedke:eq", root, function(cos)
	if cos then
		takeWeapon(source, 7)
	else
		giveWeapon(source, 7)
	end
end)

addEvent("dajKij:eq", true)
addEventHandler("dajKij:eq", root, function(cos)
	if cos then
		takeWeapon(source, 5)
	else
		giveWeapon(source, 5)
	end
end)

addEvent("dajNoz:eq", true)
addEventHandler("dajNoz:eq", root, function(cos)
	if cos then
		takeWeapon(source, 4)
	else
		giveWeapon(source, 4)
	end
end)

addEvent("dajDeagle:eq", true)
addEventHandler("dajDeagle:eq", root, function(cos)
	if cos then
		takeWeapon(source, 24)
	else
		giveWeapon(source, 24, 99999)
	end
end)

addEvent("dajColt45:eq", true)
addEventHandler("dajColt45:eq", root, function(cos)
	if cos then
		takeWeapon(source, 22)
	else
		giveWeapon(source, 22, 99999)
	end
end)

addEvent("dajUzi:eq", true)
addEventHandler("dajUzi:eq", root, function(cos)
	if cos then
		takeWeapon(source, 28)
	else
		giveWeapon(source, 28, 99999)
	end
end)

addEvent("dajAK47:eq", true)
addEventHandler("dajAK47:eq", root, function(cos)
	if cos then
		takeWeapon(source, 30)
	else
		giveWeapon(source, 30, 99999)
	end
end)

addEvent("dajKastet:eq", true)
addEventHandler("dajKastet:eq", root, function(cos)
	if cos then
		takeWeapon(source, 1)
	else
		giveWeapon(source, 1, 99999)
	end
end)

addEvent("dajObrzyn:eq", true)
addEventHandler("dajObrzyn:eq", root, function(cos)
	if cos then
		takeWeapon(source, 26)
	else
		giveWeapon(source, 26, 99999)
	end
end)

addEvent("dajSniper:eq", true)
addEventHandler("dajSniper:eq", root, function(cos)
	if cos then
		takeWeapon(source, 34)
	else
		giveWeapon(source, 34, 99999)
	end
end)

addEvent("dajWyrzutnia:eq", true)
addEventHandler("dajWyrzutnia:eq", root, function(cos)
	if cos then
		takeWeapon(source, 36)
	else
		giveWeapon(source, 36, 99999)
	end
end)

addEvent("dajMolotov:eq", true)
addEventHandler("dajMolotov:eq", root, function(cos)
	if cos then
		takeWeapon(source, 18)
	else
		giveWeapon(source, 18, 99999)
	end
end)

addEvent("dajBomba:eq", true)
addEventHandler("dajBomba:eq", root, function(cos)
	if cos then
		takeWeapon(source, 39)
	else
		giveWeapon(source, 39, 99999)
	end
end)
  
function zgas(gracz) 
    if isElement(papierosy[gracz]) then 
        toggleControl(gracz, "jump", true) 
		destroyElement(papierosy[gracz]) 
		triggerEvent("odegrajRp:eq", gracz, gracz, "#969696* "..getPlayerName(gracz).." gasi papierosa.")
		--exports["smta_base_notifications"]:noti("Zgaszasz swojego papierosa.", gracz)
		bindKey(gracz, 'fire', 'down', zgas)
    end 
end 
addCommandHandler("zgaspapierosa", zgas)
--bindKey(gracz, 'enter', 'down', zgas)

addEventHandler("onPlayerQuit", root, function()
	if isElement(papierosy[source]) then 
		destroyElement(papierosy[source]) 
	end
end)