--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local screenW, screenH = guiGetScreenSize()
local sx,sy = (screenW/1440), (screenH/900)

local czesci = {
--  [id]=montaż_cena,demontaż_cena,

--FELGI
	[1025]=5500,
	[1073]=2300,
	[1074]=3000,
	[1075]=4000,
	[1076]=2000,
	[1077]=1500,
	[1078]=2800,
	[1079]=2000,
	[1080]=2500,
	[1081]=1300,
	[1082]=1900,
	[1083]=2200,
	[1084]=3200,
	[1085]=2550,
	[1096]=2700,
	[1097]=4000,
	[1098]=1100,
--Stereo
	[1086]=1000,
--Spoilery
	[1000]=3000,
	[1001]=3500,
	[1002]=3250,
	[1003]=4000,
	[1014]=3300,
	[1015]=3800,
	[1016]=3500,
	[1023]=4500,
	[1049]=3000,
	[1050]=3400,
	[1058]=3600,
	[1060]=3500,
	[1138]=5000,
	[1139]=3700,
	[1146]=3000,
	[1147]=5000,
	[1158]=4300,
	[1162]=3000,
	[1163]=3300,
	[1164]=3500,
--Progi
	[1036]=3650,
	[1039]=2200,
	[1040]=2000,
	[1041]=2500,
	[1007]=2100,
	[1017]=2100,
	[1026]=2650,
	[1027]=3200,
	[1030]=2650,
	[1031]=3500,
	[1042]=2100,
	[1047]=3000,
	[1048]=2900,
	[1051]=3200,
	[1052]=3000,
	[1056]=2100,
	[1057]=2400,
	[1062]=2100,
	[1063]=2400,
	[1069]=3000,
	[1070]=2650,
	[1071]=2800,
	[1072]=2950,
	[1090]=2850,
	[1093]=2850,
	[1094]=2650,
	[1095]=2100,
	[1099]=2100,
	[1101]=2100,
	[1102]=2200,
	[1106]=2500,
	[1107]=2800,
	[1108]=2700,
	[1118]=2200,
	[1119]=2600,
	[1120]=2800,
	[1121]=2300,
	[1122]=2400,
	[1124]=2300,
	[1133]=2600,
	[1134]=2500,
	[1137]=2300,
--Bullbar . . ? [przod]
	[1100]=3220,
	[1115]=3500,
	[1116]=3460,
	[1123]=2840,
	[1125]=3000,
--Bullbar . . ? [tył]
	[1109]=3200,
	[1110]=3400,
--Front Sign [figurka itd z przodu]
	[1111]=3350,
	[1112]=3350,
--Hydraulika
	[1087]=16500,
--Wydechy
	[1034]=2400,
	[1037]=2200,
	[1044]=2000,
	[1046]=2200,
	[1018]=1900,
	[1019]=2100,
	[1020]=2200,
	[1021]=2000,
	[1022]=2000,
	[1028]=2100,
	[1029]=2200,
	[1043]=2650,
	[1044]=2100,
	[1045]=2650,
	[1059]=2650,
	[1064]=2300,
	[1065]=2400,
	[1066]=2650,
	[1089]=4200,
	[1092]=3900,
	[1104]=3800,
	[1105]=2600,
	[1113]=2300,
	[1114]=2900,
	[1126]=2100,
	[1127]=2250,
	[1129]=2100,
	[1132]=2650,
	[1135]=2100,
	[1136]=2650,
--Zderzaki [tylni]
	[1149]=4500,
	[1148]=5500,
	[1150]=3500,
	[1151]=4000,
	[1154]=3500,
	[1156]=3500,
	[1159]=4000,
	[1161]=4100,
	[1167]=3500,
	[1168]=3000,
	[1175]=3000,
	[1177]=3000,
	[1178]=3400,
	[1180]=4000,
	[1183]=3300,
	[1184]=3500,
	[1186]=3500,
	[1187]=3400,
	[1192]=2500,
	[1193]=3500,
--Zderzaki [przód]
	[1171]=4000,
	[1172]=5500,
	[1140]=4000,
	[1141]=5500,
	[1117]=3000,
	[1152]=3500,
	[1153]=4000,
	[1155]=4000,
	[1153]=4000,
	[1157]=4000,
	[1160]=4000,
	[1165]=4500,
	[1166]=3500,
	[1169]=4000,
	[1170]=4000,
	[1173]=4000,
	[1174]=3000,
	[1176]=3000,
	[1179]=4000,
	[1181]=3000,
	[1182]=2800,
	[1185]=3500,
	[1188]=3700,
	[1189]=3400,
	[1190]=3000,
	[1191]=2600,
--Wloty [góra]
	[1035]=3500,
	[1038]=4000,
	[1006]=3360,
	[1032]=3300,
	[1033]=3800,
	[1053]=3800,
	[1054]=3500,
	[1055]=3400,
	[1061]=3400,
	[1068]=3750,
	[1067]=3250,
	[1088]=3700,
	[1091]=3600,
	[1103]=3800,
	[1128]=5500,
	[1130]=5500,
	[1131]=5500,
--Wloty przód
	[1004]=3500,
	[1005]=3700,
	[1011]=3500,
	[1012]=3800,
	[1142]=3400,
	[1143]=3400,
	[1144]=3200,
	[1145]=3200,
--Dodatkowe lampy 
	[1013]=1100,
	[1024]=1300,
}

local czescidemontaz = {
--  [id]=montaż_cena,demontaż_cena,

--FELGI
	[1025]=5500*0.5,
	[1073]=2300*0.5,
	[1074]=3000*0.5,
	[1075]=4000*0.5,
	[1076]=2000*0.5,
	[1077]=1500*0.5,
	[1078]=2800*0.5,
	[1079]=2000*0.5,
	[1080]=2500*0.5,
	[1081]=1300*0.5,
	[1082]=1900*0.5,
	[1083]=2200*0.5,
	[1084]=3200*0.5,
	[1085]=2550*0.5,
	[1096]=2700*0.5,
	[1097]=4000*0.5,
	[1098]=1100*0.5,
--Stereo
	[1086]=1000*0.5,
--Spoilery
	[1000]=3000*0.5,
	[1001]=3500*0.5,
	[1002]=3250*0.5,
	[1003]=4000*0.5,
	[1014]=3300*0.5,
	[1015]=3800*0.5,
	[1016]=3500*0.5,
	[1023]=4500*0.5,
	[1049]=3000*0.5,
	[1050]=3400*0.5,
	[1058]=3600*0.5,
	[1060]=3500*0.5,
	[1138]=5000*0.5,
	[1139]=3700*0.5,
	[1146]=3000*0.5,
	[1147]=5000*0.5,
	[1158]=4300*0.5,
	[1162]=3000*0.5,
	[1163]=3300*0.5,
	[1164]=3500*0.5,
--Progi
	[1036]=3650*0.5,
	[1039]=2200*0.5,
	[1040]=2000*0.5,
	[1041]=2500*0.5,
	[1007]=2100*0.5,
	[1017]=2100*0.5,
	[1026]=2650*0.5,
	[1027]=3200*0.5,
	[1030]=2650*0.5,
	[1031]=3500*0.5,
	[1042]=2100*0.5,
	[1047]=3000*0.5,
	[1048]=2900*0.5,
	[1051]=3200*0.5,
	[1052]=3000*0.5,
	[1056]=2100*0.5,
	[1057]=2400*0.5,
	[1062]=2100*0.5,
	[1063]=2400*0.5,
	[1069]=3000*0.5,
	[1070]=2650*0.5,
	[1071]=2800*0.5,
	[1072]=2950*0.5,
	[1090]=2850*0.5,
	[1093]=2850*0.5,
	[1094]=2650*0.5,
	[1095]=2100*0.5,
	[1099]=2100*0.5,
	[1101]=2100*0.5,
	[1102]=2200*0.5,
	[1106]=2500*0.5,
	[1107]=2800*0.5,
	[1108]=2700*0.5,
	[1118]=2200*0.5,
	[1119]=2600*0.5,
	[1120]=2800*0.5,
	[1121]=2300*0.5,
	[1122]=2400*0.5,
	[1124]=2300*0.5,
	[1133]=2600*0.5,
	[1134]=2500*0.5,
	[1137]=2300*0.5,
--Bullbar . . ? [przod]
	[1100]=3220*0.5,
	[1115]=3500*0.5,
	[1116]=3460*0.5,
	[1123]=2840*0.5,
	[1125]=3000*0.5,
--Bullbar . . ? [tył]
	[1109]=3200*0.5,
	[1110]=3400*0.5,
--Front Sign [figurka itd z przodu]
	[1111]=3350*0.5,
	[1112]=3350*0.5,
--Hydraulika
	[1087]=16500*0.5,
--Wydechy
	[1034]=2400*0.5,
	[1037]=2200*0.5,
	[1044]=2000*0.5,
	[1046]=2200*0.5,
	[1018]=1900*0.5,
	[1019]=2100*0.5,
	[1020]=2200*0.5,
	[1021]=2000*0.5,
	[1022]=2000*0.5,
	[1028]=2100*0.5,
	[1029]=2200*0.5,
	[1043]=2650*0.5,
	[1044]=2100*0.5,
	[1045]=2650*0.5,
	[1059]=2650*0.5,
	[1064]=2300*0.5,
	[1065]=2400*0.5,
	[1066]=2650*0.5,
	[1089]=4200*0.5,
	[1092]=3900*0.5,
	[1104]=3800*0.5,
	[1105]=2600*0.5,
	[1113]=2300*0.5,
	[1114]=2900*0.5,
	[1126]=2100*0.5,
	[1127]=2250*0.5,
	[1129]=2100*0.5,
	[1132]=2650*0.5,
	[1135]=2100*0.5,
	[1136]=2650*0.5,
--Zderzaki [tylni]
	[1149]=4500*0.5,
	[1148]=5500*0.5,
	[1150]=3500*0.5,
	[1151]=4000*0.5,
	[1154]=3500*0.5,
	[1156]=3500*0.5,
	[1159]=4000*0.5,
	[1161]=4100*0.5,
	[1167]=3500*0.5,
	[1168]=3000*0.5,
	[1175]=3000*0.5,
	[1177]=3000*0.5,
	[1178]=3400*0.5,
	[1180]=4000*0.5,
	[1183]=3300*0.5,
	[1184]=3500*0.5,
	[1186]=3500*0.5,
	[1187]=3400*0.5,
	[1192]=2500*0.5,
	[1193]=3500*0.5,
--Zderzaki [przód]
	[1171]=4000*0.5,
	[1172]=5500*0.5,
	[1140]=4000*0.5,
	[1141]=5500*0.5,
	[1117]=3000*0.5,
	[1152]=3500*0.5,
	[1153]=4000*0.5,
	[1155]=4000*0.5,
	[1153]=4000*0.5,
	[1157]=4000*0.5,
	[1160]=4000*0.5,
	[1165]=4500*0.5,
	[1166]=3500*0.5,
	[1169]=4000*0.5,
	[1170]=4000*0.5,
	[1173]=4000*0.5,
	[1174]=3000*0.5,
	[1176]=3000*0.5,
	[1179]=4000*0.5,
	[1181]=3000*0.5,
	[1182]=2800*0.5,
	[1185]=3500*0.5,
	[1188]=3700*0.5,
	[1189]=3400*0.5,
	[1190]=3000*0.5,
	[1191]=2600*0.5,
--Wloty [góra]
	[1035]=3500*0.5,
	[1038]=4000*0.5,
	[1006]=3360*0.5,
	[1032]=3300*0.5,
	[1033]=3800*0.5,
	[1053]=3800*0.5,
	[1054]=3500*0.5,
	[1055]=3400*0.5,
	[1061]=3400*0.5,
	[1068]=3750*0.5,
	[1067]=3250*0.5,
	[1088]=3700*0.5,
	[1091]=3600*0.5,
	[1103]=3800*0.5,
	[1128]=5500*0.5,
	[1130]=5500*0.5,
	[1131]=5500*0.5,
--Wloty przód
	[1004]=3500*0.5,
	[1005]=3700*0.5,
	[1011]=3500*0.5,
	[1012]=3800*0.5,
	[1142]=3400*0.5,
	[1143]=3400*0.5,
	[1144]=3200*0.5,
	[1145]=3200*0.5,
--Dodatkowe lampy 
	[1013]=1100*0.5,
	[1024]=1300*0.5,
}


local id = {
	[0]="MASKA",
	[1]="WLOTY",
	[2]="SPOJLER",
	[3]="PROGI",
	[4]="PRZEDNIE BULLBARS",
	[5]="TYLNIE BULLBARS",
	[6]="HEADLIGHTS",
	[7]="WLOTY NA DACH",
	[8]="NITRO",
	[9]="HYDRAULIKA",
	[10]="STEREO",
	[11]="NIEZNANE",
	[12]="FELGI",
	[13]="WYDECH",
	[14]="PRZEDNI ZDERZAK",
	[15]="TYLNI ZDERZAK",
	[16]="MISC",
}

function isEventHandlerAdded(sEventName,pElementAttachedTo,func)
	if type(sEventName)=='string' and isElement(pElementAttachedTo) and type(func)=='function' then local aAttachedFunctions = getEventHandlers(sEventName,pElementAttachedTo)
	if type(aAttachedFunctions)=='table' and #aAttachedFunctions > 0 then for i,v in ipairs(aAttachedFunctions) do if v==func then return true end end end
	end return false
end

local sw,sh = guiGetScreenSize()
local font = dxCreateFont("cz.ttf", 15)
local font2 = dxCreateFont("cz2.ttf", 15)
wybor = nil
typtuningu = nil
informacjetuning1 = nil
informacjetuning2 = nil

aktualnytuning = {}
vehicle_player = {}

wybortuning = nil
wybortuningu2 = nil

function onRender()
	local x,y = getCursorPosition()
	if (wybor==2) then
		local r, g, b, r2, g2, b2 = getVehicleColor(getPedOccupiedVehicle(localPlayer))
		setVehicleColor(vehicle_player[localPlayer], r, g, b, r2, g2, b2)
        dxDrawImage(screenW * 0.3765, screenH * 0.1042, screenW * 0.0169, screenH * 0.0299, ":dmta_veh_tuning/gfx/arrow.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
        dxDrawImage(screenW * 0.6051, screenH * 0.1042, screenW * 0.0169, screenH * 0.0299, ":dmta_veh_tuning/gfx/arrow.png", 180, 0, 0, tocolor(255, 255, 255, 255), false)
        dxDrawImage(screenW * 0.4051, screenH * 0.0586, screenW * 0.1926, screenH * 0.1198, ":dmta_veh_tuning/gfx/oknoczesc.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
        dxDrawImage(screenW * 0.0338, screenH * 0.0898, screenW * 0.1926, screenH * 0.0573, ":dmta_veh_tuning/gfx/oknokategoria.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
        dxDrawImage(screenW * 0.1213, screenH * 0.1602, screenW * 0.0169, screenH * 0.0299, ":dmta_veh_tuning/gfx/arrow.png", 270, 0, 0, tocolor(255, 255, 255, 255), false)
        dxDrawImage(screenW * 0.1213, screenH * 0.0469, screenW * 0.0169, screenH * 0.0299, ":dmta_veh_tuning/gfx/arrow.png", 90, 0, 0, tocolor(255, 255, 255, 255), false)
		if wybortuning and wybortuningu2 then
			informacjetuning1 = aktualnytuning[wybortuningu2 or 1]
			if wybortuning and wybortuningu2 then
				if getVehicleUpgradeOnSlot(getPedOccupiedVehicle(localPlayer),wybortuning) ~= 0 then
					informacjetuning1 = "Zamontowane\nID: "..(aktualnytuning[(wybortuningu2 or 1)] or "ODŚWIEŻ")  ------------- coś tu?
					informacjetuning2 = "Cena: "..czescidemontaz[aktualnytuning[(wybortuningu2 or 1)]].." $"
					dxDrawImage(screenW * 0.7243, screenH * 0.0130, screenW * 0.2684, screenH * 0.1328, ":dmta_veh_tuning/gfx/bgzdem.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
				else
					if #aktualnytuning > 0 then
						informacjetuning1 = "ID: "..(aktualnytuning[(wybortuningu2 or 1)] or "ODŚWIEŻ") ------------- coś tu?
						informacjetuning2 = "Cena: "..(czesci[aktualnytuning[(wybortuningu2 or 1)]].." $" or 999999)
					else
						informacjetuning1 = "Brak możliwych"
						informacjetuning2 = ""
					end
					dxDrawImage(screenW * 0.7243, screenH * 0.0130, screenW * 0.2684, screenH * 0.1328, ":dmta_veh_tuning/gfx/bgzam.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
				end
			end
			if informacjetuning1 and informacjetuning2 then
				shadowText(informacjetuning1.."\n"..informacjetuning2, 582*sx, 56*sy, 857*sx, 164*sy, tocolor(150, 150, 150, 255), 1.00, font, "center", "center", false, false, false, false, false)
			end
			if wybortuning then
				typtuningu = id[wybortuning]
				if typtuningu then
					shadowText(typtuningu, 51*sx, 56*sy, 326*sx, 164*sy, tocolor(150, 150, 150, 255), 1.00, font2, "center", "center", false, false, false, false, false)
				end
			end
		end
	end
end

function dodajElementy(plr)
	if plr == localPlayer then
		if getPedOccupiedVehicle(plr) then
			max_kat2 = 0
			aktualnytuning = {}
			if wybortuning == 1 then
				for i,v in ipairs(getVehicleCompatibleUpgrades(getPedOccupiedVehicle(localPlayer),wybortuning)) do
					if getVehicleUpgradeOnSlot(getPedOccupiedVehicle(localPlayer),wybortuning) == 0 then
						table.insert(aktualnytuning,v)
						max_kat2 = max_kat2 + 1
					else
						table.insert(aktualnytuning,getVehicleUpgradeOnSlot(getPedOccupiedVehicle(localPlayer),wybortuning))
						max_kat2 = 1
					end
				end
			elseif wybortuning == 2 then
				for i,v in ipairs(getVehicleCompatibleUpgrades(getPedOccupiedVehicle(localPlayer),wybortuning)) do
					if getVehicleUpgradeOnSlot(getPedOccupiedVehicle(localPlayer),wybortuning) == 0 then
						table.insert(aktualnytuning,v)
						max_kat2 = max_kat2 + 1
					else
						table.insert(aktualnytuning,getVehicleUpgradeOnSlot(getPedOccupiedVehicle(localPlayer),wybortuning))
						max_kat2 = 1
					end
				end
			elseif wybortuning == 3 then
				for i,v in ipairs(getVehicleCompatibleUpgrades(getPedOccupiedVehicle(localPlayer),wybortuning)) do
					if getVehicleUpgradeOnSlot(getPedOccupiedVehicle(localPlayer),wybortuning) == 0 then
						table.insert(aktualnytuning,v)
						max_kat2 = max_kat2 + 1
					else
						table.insert(aktualnytuning,getVehicleUpgradeOnSlot(getPedOccupiedVehicle(localPlayer),wybortuning))
						max_kat2 = 1
					end
				end
			elseif wybortuning == 4 then
				for i,v in ipairs(getVehicleCompatibleUpgrades(getPedOccupiedVehicle(localPlayer),wybortuning)) do
					if getVehicleUpgradeOnSlot(getPedOccupiedVehicle(localPlayer),wybortuning) == 0 then
						table.insert(aktualnytuning,v)
						max_kat2 = max_kat2 + 1
					else
						table.insert(aktualnytuning,getVehicleUpgradeOnSlot(getPedOccupiedVehicle(localPlayer),wybortuning))
						max_kat2 = 1
					end
				end
			elseif wybortuning == 5 then
				for i,v in ipairs(getVehicleCompatibleUpgrades(getPedOccupiedVehicle(localPlayer),wybortuning)) do
					if getVehicleUpgradeOnSlot(getPedOccupiedVehicle(localPlayer),wybortuning) == 0 then
						table.insert(aktualnytuning,v)
						max_kat2 = max_kat2 + 1
					else
						table.insert(aktualnytuning,getVehicleUpgradeOnSlot(getPedOccupiedVehicle(localPlayer),wybortuning))
						max_kat2 = 1
					end
				end
			elseif wybortuning == 6 then
				for i,v in ipairs(getVehicleCompatibleUpgrades(getPedOccupiedVehicle(localPlayer),wybortuning)) do
					if getVehicleUpgradeOnSlot(getPedOccupiedVehicle(localPlayer),wybortuning) == 0 then
						table.insert(aktualnytuning,v)
						max_kat2 = max_kat2 + 1
					else
						table.insert(aktualnytuning,getVehicleUpgradeOnSlot(getPedOccupiedVehicle(localPlayer),wybortuning))
						max_kat2 = 1
					end
				end
			elseif wybortuning == 7 then
				for i,v in ipairs(getVehicleCompatibleUpgrades(getPedOccupiedVehicle(localPlayer),wybortuning)) do
					if getVehicleUpgradeOnSlot(getPedOccupiedVehicle(localPlayer),wybortuning) == 0 then
						table.insert(aktualnytuning,v)
						max_kat2 = max_kat2 + 1
					else
						table.insert(aktualnytuning,getVehicleUpgradeOnSlot(getPedOccupiedVehicle(localPlayer),wybortuning))
						max_kat2 = 1
					end
				end
			elseif wybortuning == 8 then
				for i,v in ipairs(getVehicleCompatibleUpgrades(getPedOccupiedVehicle(localPlayer),wybortuning)) do
					if getVehicleUpgradeOnSlot(getPedOccupiedVehicle(localPlayer),wybortuning) == 0 then
						table.insert(aktualnytuning,v)
						max_kat2 = max_kat2 + 1
					else
						table.insert(aktualnytuning,getVehicleUpgradeOnSlot(getPedOccupiedVehicle(localPlayer),wybortuning))
						max_kat2 = 1
					end
				end
			elseif wybortuning == 9 then
				for i,v in ipairs(getVehicleCompatibleUpgrades(getPedOccupiedVehicle(localPlayer),wybortuning)) do
					if getVehicleUpgradeOnSlot(getPedOccupiedVehicle(localPlayer),wybortuning) == 0 then
						table.insert(aktualnytuning,v)
						max_kat2 = max_kat2 + 1
					else
						table.insert(aktualnytuning,getVehicleUpgradeOnSlot(getPedOccupiedVehicle(localPlayer),wybortuning))
						max_kat2 = 1
					end
				end
			elseif wybortuning == 10 then
				for i,v in ipairs(getVehicleCompatibleUpgrades(getPedOccupiedVehicle(localPlayer),wybortuning)) do
					if getVehicleUpgradeOnSlot(getPedOccupiedVehicle(localPlayer),wybortuning) == 0 then
						table.insert(aktualnytuning,v)
						max_kat2 = max_kat2 + 1
					else
						table.insert(aktualnytuning,getVehicleUpgradeOnSlot(getPedOccupiedVehicle(localPlayer),wybortuning))
						max_kat2 = 1
					end
				end
			elseif wybortuning == 11 then
				for i,v in ipairs(getVehicleCompatibleUpgrades(getPedOccupiedVehicle(localPlayer),wybortuning)) do
					if getVehicleUpgradeOnSlot(getPedOccupiedVehicle(localPlayer),wybortuning) == 0 then
						table.insert(aktualnytuning,v)
						max_kat2 = max_kat2 + 1
					else
						table.insert(aktualnytuning,getVehicleUpgradeOnSlot(getPedOccupiedVehicle(localPlayer),wybortuning))
						max_kat2 = 1
					end
				end
			elseif wybortuning == 12 then
				for i,v in ipairs(getVehicleCompatibleUpgrades(getPedOccupiedVehicle(localPlayer),wybortuning)) do
					if getVehicleUpgradeOnSlot(getPedOccupiedVehicle(localPlayer),wybortuning) == 0 then
						table.insert(aktualnytuning,v)
						max_kat2 = max_kat2 + 1
					else
						table.insert(aktualnytuning,getVehicleUpgradeOnSlot(getPedOccupiedVehicle(localPlayer),wybortuning))
						max_kat2 = 1
					end
				end
			elseif wybortuning == 13 then
				for i,v in ipairs(getVehicleCompatibleUpgrades(getPedOccupiedVehicle(localPlayer),wybortuning)) do
					if getVehicleUpgradeOnSlot(getPedOccupiedVehicle(localPlayer),wybortuning) == 0 then
						table.insert(aktualnytuning,v)
						max_kat2 = max_kat2 + 1
					else
						table.insert(aktualnytuning,getVehicleUpgradeOnSlot(getPedOccupiedVehicle(localPlayer),wybortuning))
						max_kat2 = 1
					end
				end
			elseif wybortuning == 14 then
				for i,v in ipairs(getVehicleCompatibleUpgrades(getPedOccupiedVehicle(localPlayer),wybortuning)) do
					if getVehicleUpgradeOnSlot(getPedOccupiedVehicle(localPlayer),wybortuning) == 0 then
						table.insert(aktualnytuning,v)
						max_kat2 = max_kat2 + 1
					else
						table.insert(aktualnytuning,getVehicleUpgradeOnSlot(getPedOccupiedVehicle(localPlayer),wybortuning))
						max_kat2 = 1
					end
				end
			elseif wybortuning == 15 then
				for i,v in ipairs(getVehicleCompatibleUpgrades(getPedOccupiedVehicle(localPlayer),wybortuning)) do
					if getVehicleUpgradeOnSlot(getPedOccupiedVehicle(localPlayer),wybortuning) == 0 then
						table.insert(aktualnytuning,v)
						max_kat2 = max_kat2 + 1
					else
						table.insert(aktualnytuning,getVehicleUpgradeOnSlot(getPedOccupiedVehicle(localPlayer),wybortuning))
						max_kat2 = 1
					end
				end
			elseif wybortuning == 16 then
				for i,v in ipairs(getVehicleCompatibleUpgrades(getPedOccupiedVehicle(localPlayer),wybortuning)) do
					if getVehicleUpgradeOnSlot(getPedOccupiedVehicle(localPlayer),wybortuning) == 0 then
						table.insert(aktualnytuning,v)
						max_kat2 = max_kat2 + 1
					else
						table.insert(aktualnytuning,getVehicleUpgradeOnSlot(getPedOccupiedVehicle(localPlayer),wybortuning))
						max_kat2 = 1
					end
				end
			end
		end
	end
end

function getPositionFromElementOffset(element,offX,offY,offZ)
	local m = getElementMatrix(element)
	local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]
	local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
	local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
	return x,y,z
end

function ustawKamere(plr)
	if plr == localPlayer then
		if getPedOccupiedVehicle(plr) then
			if getVehicleController(getPedOccupiedVehicle(plr)) == plr then
				if vehicle_player[plr] then
					local x,y,z = getElementPosition(vehicle_player[plr])
					if wybortuning == 0 then -- Wloty na masce
						local newX, newY, newZ = getPositionFromElementOffset(vehicle_player[plr], 0, 6, 0.5)
						setCameraMatrix(newX, newY, newZ, x,y,z)
					elseif wybortuning == 1 then -- Wlot na masce
						local newX, newY, newZ = getPositionFromElementOffset(vehicle_player[plr], 0, 6, 0.5)
						setCameraMatrix(newX, newY, newZ, x,y,z)
					elseif wybortuning == 2 then -- Spoiler
						local newX, newY, newZ = getPositionFromElementOffset(vehicle_player[plr], 0, -6, 0.5)
						setCameraMatrix(newX, newY, newZ, x,y,z)
					elseif wybortuning == 3 then -- Progi
						local newX, newY, newZ = getPositionFromElementOffset(vehicle_player[plr], -4, 0, 0)
						setCameraMatrix(newX, newY, newZ, x,y,z)
					elseif wybortuning == 4 then -- Przednie orurowanie
						local newX, newY, newZ = getPositionFromElementOffset(vehicle_player[plr], 0, 6, 0)
						setCameraMatrix(newX, newY, newZ, x,y,z)
					elseif wybortuning == 5 then -- Tylnie orurowanie
						local newX, newY, newZ = getPositionFromElementOffset(vehicle_player[plr], 0, -6, 0)
						setCameraMatrix(newX, newY, newZ, x,y,z)
					elseif wybortuning == 6 then -- halogeny
						local newX, newY, newZ = getPositionFromElementOffset(vehicle_player[plr], 0, 6, 0)
						setCameraMatrix(newX, newY, newZ, x,y,z)
					elseif wybortuning == 7 then -- Wlot na dachu
						local newX, newY, newZ = getPositionFromElementOffset(vehicle_player[plr], 0, 6, 1.5)
						setCameraMatrix(newX, newY, newZ, x,y,z)
					elseif wybortuning == 9 then -- Hydraulika
						local newX, newY, newZ = getPositionFromElementOffset(vehicle_player[plr], 0, 6, 2)
						setCameraMatrix(newX, newY, newZ, x,y,z)
					elseif wybortuning == 10 then -- System audio
						local newX, newY, newZ = getPositionFromElementOffset(vehicle_player[plr], 0, 6, 2)
						setCameraMatrix(newX, newY, newZ, x,y,z)
					elseif wybortuning == 12 then -- Felgi
						local newX, newY, newZ = getPositionFromElementOffset(vehicle_player[plr], -4, 0.5, -0.25)
						setCameraMatrix(newX, newY, newZ, x,y,z)
					elseif wybortuning == 13 then -- Wydech
						local newX, newY, newZ = getPositionFromElementOffset(vehicle_player[plr], 0, -6, -0.4)
						setCameraMatrix(newX, newY, newZ, x,y,z)
					elseif wybortuning == 14 then -- Przedni zderzak
						local newX, newY, newZ = getPositionFromElementOffset(vehicle_player[plr], 0, 6, 0)
						setCameraMatrix(newX, newY, newZ, x,y,z)
					elseif wybortuning == 15 then -- Tylni zderzak
						local newX, newY, newZ = getPositionFromElementOffset(vehicle_player[plr], 0, -6, 0)
						setCameraMatrix(newX, newY, newZ, x,y,z)
					elseif wybortuning == 16 then -- Dodatki na masce
						local newX, newY, newZ = getPositionFromElementOffset(vehicle_player[plr], 0, 6, 0.5)
						setCameraMatrix(newX, newY, newZ, x,y,z)
					end
				end
			end
		end
	end
end

bindKey("arrow_u", "down", function()
	if isEventHandlerAdded("onClientRender",root,onRender) then
		if wybortuning >= 16 then wybortuning = 1 return end
		if wybortuning == 10 then wybortuning = 11 end
		if wybortuning == 7 then wybortuning = 8 end
		local upg = getVehicleUpgrades(getPedOccupiedVehicle(localPlayer))
		for _,v in ipairs(upg) do
			removeVehicleUpgrade(vehicle_player[localPlayer],v)
			addVehicleUpgrade(vehicle_player[localPlayer],v)
		end
		wybortuning = wybortuning + 1
		wybortuningu2 = 1
		if wybortuning == 4 then wybortuning = 6 end
		dodajElementy(localPlayer)
		ustawKamere(localPlayer)
	end
end)


bindKey("arrow_d", "down", function()
	if isEventHandlerAdded("onClientRender",root,onRender) then
		if wybortuning <= 1 then wybortuning = 16 return end
		if wybortuning == 12 then wybortuning = 11 end
		if wybortuning == 9 then wybortuning = 8 end
		local upg = getVehicleUpgrades(getPedOccupiedVehicle(localPlayer))
		for _,v in ipairs(upg) do
			addVehicleUpgrade(vehicle_player[localPlayer],v)
		end
		wybortuning = wybortuning - 1
		wybortuningu2 = 1
		if wybortuning == 5 then wybortuning = 3 end
		dodajElementy(localPlayer)
		ustawKamere(localPlayer)	
	end
end)

bindKey("arrow_l", "down", function()
	if isEventHandlerAdded("onClientRender",root,onRender) then
		local upg = getVehicleUpgrades(getPedOccupiedVehicle(localPlayer))
		for _,v in ipairs(upg) do
			addVehicleUpgrade(vehicle_player[localPlayer],v)
		end
		if wybortuningu2 <= 1 then return end
		wybortuningu2 = wybortuningu2 - 1
		informacjetuning1 = wybortuningu2
		informacjetuning2 = "."
		dodajElementy(localPlayer)
		addVehicleUpgrade(vehicle_player[localPlayer],aktualnytuning[(wybortuningu2 or 1)])
	end
end)

bindKey("arrow_r", "down", function()
	if isEventHandlerAdded("onClientRender",root,onRender) then
		local upg = getVehicleUpgrades(getPedOccupiedVehicle(localPlayer))
		for _,v in ipairs(upg) do
			addVehicleUpgrade(vehicle_player[localPlayer],v)
		end
		if wybortuningu2 >= max_kat2 then return end
		wybortuningu2 = wybortuningu2 + 1
		informacjetuning1 = wybortuningu2
		informacjetuning2 = "."
		dodajElementy(localPlayer)
		addVehicleUpgrade(vehicle_player[localPlayer],aktualnytuning[(wybortuningu2 or 1)])
	end
end)

bindKey("backspace", "down", function()
	if isEventHandlerAdded("onClientRender",root,onRender) then
		removeEventHandler("onClientRender",root,onRender)
		showCursor(false)
		wybor = nil
		informacjetuning1 = nil
		informacjetuning2 = nil
		typtuningu = nil
		wybortuning = nil
		wybortuningu2 = nil
		max_kat2 = nil
		setCameraTarget(localPlayer)
		setElementFrozen(getPedOccupiedVehicle(localPlayer),false)
		setElementData(localPlayer, "pokaz:hud", true)
		showChat(true)
		if vehicle_player[localPlayer] and isElement(vehicle_player[localPlayer]) then
			destroyElement(vehicle_player[localPlayer])
		end
	end
end)

bindKey("enter", "down", function()
	if wybortuning and wybortuningu2 and #aktualnytuning > 0 then
		local kategoria = id[wybortuning]
		local kategoria_id = wybortuning
		local id = aktualnytuning[(wybortuningu2 or 1)]
		local cena = 999999
		if getVehicleUpgradeOnSlot(getPedOccupiedVehicle(localPlayer),wybortuning) ~= 0 then -- demontaż
			cena = czescidemontaz[aktualnytuning[(wybortuningu2 or 1)]]
		else
			if #aktualnytuning > 0 then
				cena = (czesci[aktualnytuning[(wybortuningu2 or 1)]] or 999999)-- montaż
			else
				cena = 999999
			end
		end
		triggerServerEvent("tuning:tuningujPojazd",localPlayer,localPlayer, kategoria_id, id, cena)
		dodajElementy(localPlayer)
	end
end)


addEvent("tuning:otworzGUI",true)
addEventHandler("tuning:otworzGUI",root,function(plr)
	if plr and isElement(plr) then
		wybor = 2
		wybortuning = 0
		wybortuningu2 = 1
		max_kat2 = 0	
		if not isEventHandlerAdded("onClientRender",root,onRender) then
			addEventHandler("onClientRender",root,onRender)
		end
		vehicle_player[localPlayer] = createVehicle(getElementModel(getPedOccupiedVehicle(localPlayer)), 1708.4838867188,-1789.0555419922,13.268005371094,0, 0, 310.88861083984, "TUNING")
		local upg = getVehicleUpgrades(getPedOccupiedVehicle(localPlayer))
		for _,v in ipairs(upg) do
			addVehicleUpgrade(vehicle_player[localPlayer],v)
		end
		plr = localPlayer
		ustawKamere(localPlayer)
		dodajElementy(localPlayer)
		setElementData(localPlayer, "pokaz:hud", false)
		showChat(false)
	end
end)

addEvent("tuning:zamknijGUI",true)
addEventHandler("tuning:zamknijGUI",root,function(plr)
	if isEventHandlerAdded("onClientRender",root,onRender) then
		removeEventHandler("onClientRender",root,onRender)
		showCursor(false)
		wybor = nil
		informacjetuning1 = nil
		informacjetuning2 = nil
		typtuningu = nil
		wybortuning = nil
		wybortuningu2 = nil
		max_kat2 = nil
		setCameraTarget(localPlayer)
		setElementFrozen(getPedOccupiedVehicle(localPlayer),false)
		setElementData(localPlayer, "pokaz:hud", true)
		showChat(true)
		executeCommandHandler("radar")
		if vehicle_player[localPlayer] and isElement(vehicle_player[localPlayer]) then
			destroyElement(vehicle_player[localPlayer])
		end
	end
end)

function shadowText(text,x,y,w,h,color,size,font,xx,yy,x1,x2,x3,x4,x5)
  dxDrawText(text,x+1,y+1,w+1,h+1,tocolor(0,0,0),size,font,xx,yy,x1,x2,x3,x4,x5)
  dxDrawText(text,x,y,w,h,color,size,font,xx,yy,x1,x2,x3,x4,x5)
end