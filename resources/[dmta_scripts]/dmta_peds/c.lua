--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local noti = exports.dmta_base_notifications

local peds = {
	--randoms
	{114,2048.9104003906,-1774.4544677734,13.55327796936, 0,'**mówi** Chcesz zarobić w morde, geju?',180,{'DEALER', 'DEALER_IDLE'},'Ulicznik',0},
	{213,1010.3123779297,-1340.7705078125,13.366115570068,0,'\nŻul\n**mówi** Nie masz może troche fasoli?',90,{'GANGS', 'prtial_gngtlkH'},'Rafał Kosmeya',0},
	{212,1717.3072509766,-1742.8001708984,13.541376113892,0,'\nŻul\n**mówi** Ta dziwka Sara znowu się z kimś pierdoli?',180,{'GANGS', 'prtial_gngtlkH'},'Arek Kosmeya',0},
	{64,2417.5590820313,-1219.4907226563,25.5165138244631,0,'\nProstytutka\n**mówi** Promocja, 30 za godzinkę.',180,{'COP_AMBIENT', 'Coplook_loop'},'Sarah Kosmeya',0},
	{177,958.58630371094,-1310.7426757813,13.53196334,0,'Fryzjer',204,{'COP_AMBIENT', 'Coplook_loop'},'Jakub Kęcki',0},
	{258,993.13238525391,-1296.044921875,13.5468758,0,'Rzeźmieszek',180,{'COP_AMBIENT', 'Coplook_loop'},'Patryk Wolski',0},
	{79,1286.8054199219,-1364.41796875,13.55618476867,0,'\n\nBezdomny\n**mówi** Szefie masz obstawić piątke?',90,{'COP_AMBIENT', 'Coplook_loop'},'Mariusz Patyk\n(ojciec Dominika)',0},
	{72,1302.3024902344,-1367.9265136719,13.563080787659,0,'\n**mówi** Widziałeś mojego starego?',180,{'COP_AMBIENT', 'Coplook_loop'},'Dominik Patyk\n(syn Mariusza)',0},
	{67,1929.7260742188,-1769.2386474609,13.546875,0,'\nPracownik stacji\n**mówi** Słyszałeś, że jeździłem na crossie?!',250,{'GANGS', 'prtial_gngtlkG'},'Wiktor Nadolny',0},
	{22,985.21990966797,-1309.0495605469,13.382812,0,'**mówi** Dzień dobry, sprzeda mi pan papierosa?',0,{'GANGS', 'prtial_gngtlkG'},'Wiktor Stolarek',0},
	{230,877.62762451172,-1355.6799316406,13.585559844971,0,'**mówi** Wypierdalaj stąd!',85,{'GANGS', 'prtial_gngtlkG'},'Oskar Jeżakowski',0},
	{28,1813.3634033203,-2065.9033203125,13.54687,0,'**mówi** Yoo nigga, whats up czarnuchu!',270,{'GANGS', 'prtial_gngtlkG'},'Łukasz Osmański',0},
	{269,1704.6804199219,-1799.6169433594,13.532686233521,0,'**mówi** Jakaś szama mordo?',318,{'GANGS', 'prtial_gngtlkG'},'Kuba Rumiński',0},
	{111,2518.3393554688,-1480.8475341797,23.996364593506,0,'\nGangster\n**mówi** Zgubiłeś się kurwa, wafelku?',270,{'DEALER', 'DEALER_IDLE'},'Dariusz Pruszkowski',0},
	{28,2398.1545410156,-1208.3868408203,28.3270759,0,'\nTępak, gej\n**mówi** Yo mordo, kurwa ogarnij dla mnie JustCole, a zdradzę Ci tajemnicę.',3,{'GANGS', 'prtial_gngtlkH'},'Łukasz Osmański',0}, --podpowiedz
	{124,-1841.5725097656,1225.60546875,27.8437,0,'\nOchroniarz, gangster\n**mówi** Kurwa, gdzie te jebane strzykawki.',270,{'DEALER', 'DEALER_IDLE'},'Daniel Łagocki',0}, --kokaina_wejscie
	--urzad
	{150,359.71392822266,173.75202941895,1008.3893432617,0,'Urzędniczka',280,{'COP_AMBIENT', 'Coplook_loop'},'Kasia Urynowicz',3},
	{17,356.29782104492,178.52488708496,1008.376220703,0,'Urzędnik',272,{'COP_AMBIENT', 'Coplook_loop'},'Tomasz Dęciarz',3},
	{147,356.29751586914,168.9933013916,1008.376220703,0,'Urzędnik',270,{'COP_AMBIENT', 'Coplook_loop'},'Czarek Pazura',3},
	{59,356.29788208008,166.29095458984,1008.376220703,0,'Urzędnik',270,{'COP_AMBIENT', 'Coplook_loop'},'Marcin Nadolny',3},
	--bank
	{59,820.18695068359,2.2753252983093,1004.179687,0,'Bankier',270,{'COP_AMBIENT', 'Coplook_loop'},'Paweł Wkrętara',3},
	{55,820.18664550781,4.3058948516846,1004.1796875,0,'Bankier',270,{'COP_AMBIENT', 'Coplook_loop'},'Amanda Teflon',3},
	{46,820.18707275391,6.2855887413025,1004.1796875,0,'Stażysta',270,{'COP_AMBIENT', 'Coplook_loop'},'Hubert Tempak',3},
	--osk
	{67,2445.677734375,-1648.2000732422,1016.143310546,0,'Szkoleniowiec',90,{'COP_AMBIENT', 'Coplook_loop'},'Hubert Trępała',1},
	{56,2445.3464355469,-1663.8273925781,1016.143310546,0,'Szkoleniowiec',90,{'COP_AMBIENT', 'Coplook_loop'},'Anna Patyk',1},
	{72,2464.3615722656,-1655.9741210938,1016.1433105469,0,'Szkoleniowiec',90,{'COP_AMBIENT', 'Coplook_loop'},'Piotr Szamrowicz',1},
	--rybny
	{36,295.30462646484,-82.527359008789,1001.51562, 0,'\nPracownik\n**mówi** Zajebistego suma ostatnio złowiłem.',0,{'DEALER', 'DEALER_IDLE'},'Kacper Deling',4},
	--jubiler
	{57,2474.7333984375,-1620.7154541016,18089.20703125, 0,'\nPracownik\n**mówi** Kolejny którego stać tylko na Casio.',347,{'COP_AMBIENT', 'Coplook_loop'},'Bob Omega',1},
	--apteka
	{70,2590.5715332031,-1665.4708251953,20002.2578125, 0,'\nPracownik\n**mówi** Polecam "SrakoStop" - najlepszy na problemy z zołądkiem.',265,{'COP_AMBIENT', 'Coplook_loop'},'Richard Jones',1},
	{156,2590.3071289063,-1663.2218017578,20002.257812, 0,'Pracownik',246,{'COP_AMBIENT', 'Coplook_loop'},'Simon Williams',1},
	{169,2590.4975585938,-1662.0089111328,20002.2578, 0,'Pracownik',256,{'COP_AMBIENT', 'Coplook_loop'},'Nancy Casale',1},
	--diamond_gsm
	{20,2495.0466308594,-1684.6511230469,21912.04882, 0,'\nPracownik\n**mówi** Sprawdź moje rapsy ziomek, nowy klip na dniach.',170,{'COP_AMBIENT', 'Coplook_loop'},'Mariusz Berger',1},
	{101,2490.4228515625,-1684.9206542969,21912.0488, 0,'Pracownik',180,{'COP_AMBIENT', 'Coplook_loop'},'Mikołaj Więcaszek',1},
	{96,2485.7429199219,-1685.2121582031,21912.04882, 0,'Pracownik',182,{'COP_AMBIENT', 'Coplook_loop'},'Maciej Kuszmider',1},
	{22,2496.7788085938,-1700.2244873047,21912.048803,0,'\nKierownik\n**mówi** Banda kretynów, nie potrafi ustawić telefonów na półkach.',180,{'CASINO', 'dealone'},'Wiktor Stolarek',1},
	{28,2488.5541992188,-1700.3648681641,21912.0488220703,0,'\nPracownik\n**mówi** Yo men, nie mów nikomu, ale czasami podpierdalam towar.',218,{'CASINO', 'dealone'},'Łukasz Osmański',1},
	--sklep z bronia
	{73,296.71765136719,-40.215476989746,1001.515625, 0,'\nPracownik\n**mówi** Mam najdluższą lufę w mieście.',0,{'DEALER', 'DEALER_IDLE'},'Ralph Holtzmann',1},
	--stacje
	{2,1011.4279785156,-929.26287841797,42.328125,0,'Pracownik stacji',187,{"LOWRIDER", "M_smklean_loop"},'Bob Winstroll',0},
	--gringlanka
	{40,1968.9162597656,-1692.9572753906,990.02813720703,0,'Kelnerka',90,{'COP_AMBIENT', 'Coplook_loop'},'Eva Cremonesi',1},
	{169,1959.1597900391,-1685.9810791016,990.02813720703,0,'Kelnerka',15.7,{'COP_AMBIENT', 'Coplook_loop'},'Antonina Bruno',1},
	{194,1955.2218017578,-1697.7006835938,990.0281372070,0,'Kelnerka',200.5,{'COP_AMBIENT', 'Coplook_loop'},'Federica Ricci',1},
	{171,1950.8159179688,-1689.7250976563,990.02813720703,0,'Kelner',125.7,{'COP_AMBIENT', 'Coplook_loop'},'Gerolamo Conti',1},
	{240,1969.4294433594,-1697.3646240234,990.02813720703,0,'Kucharz',90,{"LOWRIDER", "M_smklean_loop"},'Leopoldo Pisano',1},
	{185,1956.4802978516,-1699.6182861328,990.0281372070,0,'Członek Mafii',90.0,{"INT_OFFICE", "OFF_Sit_Idle_Loop"},'Leopoldo Pisano',1},
	{303,1954.9948242188,-1699.4788818359,990.02813720703,0,'Członek Mafii',270.0,{"INT_OFFICE", "OFF_Sit_Idle_Loop"},'Salvatore Lertivo',1},
	{306,1959.7040283203,-1684.1022949219,990.0281372070,0,'Członek Mafii',90.0,{"INT_OFFICE", "OFF_Sit_Idle_Loop"},'Bertoldo Colombo',1},
	{307,1958.1249511719,-1684.2711181641,990.02813720703,0,'Członek Mafii',270.0,{"INT_OFFICE", "OFF_Sit_Idle_Loop"},'Carlo Gambino',1},
	{299,1948.7021484375,-1695.7159423828,990.02813720703,0,'Członek Mafii',270.0,{"LOWRIDER", "M_smklean_loop"},'Frank Maranzano',1},
	{310,1966.5600585938,-1686.7894287109,990.028137207033,0,'Członek Mafii',0.0,{'COP_AMBIENT', 'Coplook_loop'},'Vito Veloce',1},
	{309,1967.9758300781,-1685.2581787109,990.02813720703,0,'Członek Mafii',93.3,{'CASINO', 'dealone'},'Dario Veloce',1},
	{302,1964.8404541016,-1683.5947265625,990.02813720703,0,'Członek Mafii',220.2,{'DEALER', 'DEALER_IDLE'},'Vincenzo Gambino',1},
	{298,1964.2509521484,-1699.298828125,990.02813720703,0,'Członek Mafii',269.6,{"LOWRIDER", "M_smklean_loop"},'Dario Lertivo',1},
	{46,1967.5590820313,-1699.5856933594,990.02813720703,0,'Członek Mafii',28.8,{'DEALER', 'DEALER_IDLE'},'Salomone Pisano',1},
	{98,1965.9152832031,-1697.4716796875,990.0281372070,0,'Członek Mafii',206.8,{'CASINO', 'dealone'},'Savino Palermo',1},
	{302,2479.2126464844,-1531.6312255859,24.15442657470,0,'Członek Mafii',85.8,{'COP_AMBIENT', 'Coplook_loop'},'Eligio Genovese',0},
	{298,2477.3115234375,-1531.2912597656,24.14374732971,0,'Członek Mafii',256.8,{'DEALER', 'DEALER_IDLE'},'Thomson Lertivo',0},
	{299,2472.7080078125,-1527.4975585938,24.17791748046,0,'Członek Mafii',269.8,{"LOWRIDER", "M_smklean_loop"},'Aurelio Sal',0},
	-- rynek
	{58,1390.4289550781,-1608.4222412109,13.546875,0,'\nSprzedawca\n**mówi** Nie bądź parówa, kup burgera.',180,{'COP_AMBIENT', 'Coplook_loop'},'Wojtek Knozowski',0},
	{213,1388.4040527344,-1625.4371337891,13.546875,0,'\nSprzedawca\n**mówi** Kilo buraków, dwa dolarki.',270,{'COP_AMBIENT', 'Coplook_loop'},'Eryk Lewandowski',0},
	{73,1405.1461181641,-1625.3826904297,13.54687,0,'\nSprzedawca\n**mówi** Super pyszna wódeczka, tylko u mnie.',0,{'COP_AMBIENT', 'Coplook_loop'},'Sebastian Rogowski',0},
	{72,1401.9200439453,-1625.2796630859,13.54687,0,'\nSprzedawca\n**mówi** Zarąbiste kanapki, zapraszam.',0,{'COP_AMBIENT', 'Coplook_loop'},'Adrian Stopczyński',0},
	{60,1396.90234375,-1625.27734375,13.546875,0,'\nSprzedawca\n**mówi** Nie bądź faja, pizza domowej roboty.',0,{'COP_AMBIENT', 'Coplook_loop'},'Oskar Nadolny',0},
	{156,1379.0653076172,-1614.4954833984,13.546875,0,'\nSprzedawca\n**mówi** Dzień dobry, szybciej bo się spiesze na siłownie.',318,{'COP_AMBIENT', 'Coplook_loop'},'Wiktor Kluczenko',0},
	{182,1404.4503173828,-1606.1931152344,13.546875,0,'\nSprzedawca\n**mówi** Masz może papieroska, kucze?.',270,{'COP_AMBIENT', 'Coplook_loop'},'Oskar Lewandowski',0},
	{179,1417.912109375,-1608.8919677734,13.54687,0,'\nSprzedawca\n**mówi** Mam największą parówe w mieście.',90,{'COP_AMBIENT', 'Coplook_loop'},'Krzysztof Stolarek',0},
	{126,1417.4758300781,-1614.7081298828,13.539485931396,0,'\nSprzedawca\n**mówi** Widziałeś mojego syna tępaka?',90,{'COP_AMBIENT', 'Coplook_loop'},'Tomasz Osmański',0},
	{94,1417.4759521484,-1617.5744628906,13.539485931396,0,'\nSprzedawca\n**mówi** Dzień doberek.',86,{'COP_AMBIENT', 'Coplook_loop'},'Kacper Mathia',0},
	{121,1418.0433349609,-1631.5721435547,13.546875,0,'\nSprzedawca\n**mówi** Za godzinę odjeżda mi bus.',36,{'COP_AMBIENT', 'Coplook_loop'},'Marcin Bukolt',0},
	{191,1373.9084472656,-1598.7237548828,13.546875,0,'\nSprzedawczyni\n**mówi** Zarabiam na syna tępaka.',231,{'COP_AMBIENT', 'Coplook_loop'},'Ewa Osmańska',0},
	--weed
	{107,1411.6431884766,-1298.8760986328,13.54896068573,0,'\nDiler\n**mówi** Masz ten towar, kurwa?',180,{'DEALER', 'DEALER_IDLE'},'Marek Bocianowski',0},
	{30,-397.04513549805,-1433.7368164063,25.7265625,0,'\nPrzemytnik\n**mówi** Ty też uważasz, że jebią mi spodnie?',65.763282775879,{"FAT", "IDLE_tired"},'Adrian Dzięciołek',0},
	{124,-566.39898681641,-1505.5180664063,9.3186664581299,0,'\nDiler\n**mówi** Czujesz ten zapach, kurwa?',127.65948486328,{'DEALER', 'DEALER_IDLE'},'Adrian Polarewski',0},
	--coke
	{98,-1628.9933105469,-2238.7573242188,31.4765625,0,'Przemytnik',90,{"LOWRIDER", "M_smklean_loop"},'Vincenzo Veloce',0},
	{127,-1638.8530273438,-2237.57421875,31.4765625,0,'Gangster',90,{'DEALER', 'DEALER_IDLE'},'Luke Vasiliev',0},
	{46,2570.7158203125,-1640.5939941406,17158.85742187,0,'Przemytnik',91,{"LOWRIDER", "M_smklean_loop"},'Giancarlo Lorenzo',1},
	{300,2574.990234375,-1635.1866455078,17158.85742187,0,'Gangster',141,{'DEALER', 'DEALER_IDLE'},'Jaroslav Isayev',1},
	{302,2576.9580078125,-1645.8084716797,17158.85742187,0,'Przemytnik',38,{'DEALER', 'DEALER_IDLE'},'Fedro Castiglione',1},
	{126,2609.2987304688,2820.4391113281,10.8203125,0,'Członek Mafii',314.96487426758,{"LOWRIDER", "M_smklean_loop"},'Maxim Korovin',0},
	{125,2609.2517089844,2817.5183105469,10.8203125,0,'Członek Mafii',194.33042907715,{'DEALER', 'DEALER_IDLE'},'Igor Volkov',0},
	{112,2604.6003613281,2812.5895996094,10.8203125,0,'Członek Mafii',255.43104553223,{"LOWRIDER", "M_smklean_loop"},'Yuri Repin',0},
	{113,2611.3271484375,2805.1772460938,10.820312,0,'Szef Przemytników',53.665584564209,{'DEALER', 'DEALER_IDLE'},'Dario Veloce',0},
	{111,2611.5493164063,2811.2102050781,10.8203125,0,'Szef Mafii',95.9658203125,{'DEALER', 'DEALER_IDLE'},'Dariusz Pruszkowski',0},
	--meth
	{117,209.80696105957,-234.45878601074,1.77861881256,0,'Członek Yakuzy',0,{"LOWRIDER", "M_smklean_loop"},'Gakuto Ohira',0},
	{122,221.8254699707,-229.95860290527,1.77861881256,0,'Gangster',95,{'DEALER', 'DEALER_IDLE'},'Park Chen',0},
	{123,210.52392578125,-225.79397583008,1.778618812561,0,'Gangster',180,{'DEALER', 'DEALER_IDLE'},'Kuan-Yin Huang',0},
	{121,1281.833984375,304.36322021484,19.5546875,0,'Gangster',127.9495773315,{'DEALER', 'DEALER_IDLE'},'Chi Chao',0},
	{122,1270.2360839844,309.90397338867,19.561403274536,0,'Gangster',157.40325927734,{"LOWRIDER", "M_smklean_loop"},'Lian Peng',0},
	{117,1269.4617919922,288.01272583008,19.56140327453,0,'Członek Yakuzy',329.11154174805,{'DEALER', 'DEALER_IDLE'},'Yuuzou Sanya',0},
	{118,1277.7896728516,289.39260864258,19.5546875,0,'Członek Yakuzy',34.598812103271,{'DEALER', 'DEALER_IDLE'},'Michito Takase',0},
	{120,1280.8131103516,295.44839477539,19.5546875,0,'Członek Yakuzy',74.705741882324,{'DEALER', 'DEALER_IDLE'},'Takehiko Yokota',0},
	{117,2790.8225097656,-2488.72265625,13.64657306671,0,'Członek Yakuzy',88.516265869141,{'DEALER', 'DEALER_IDLE'},'Tsuguto Yamane',0},
	{118,2791.9050292969,-2498.3703613281,13.645251274109,0,'Członek Yakuzy',357.64883422852,{'DEALER', 'DEALER_IDLE'},'Yuuga Nakai',0},
	{120,2800.4926757813,-2495.263671875,13.634764671326,0,'Członek Yakuzy',89.143005371094,{'DEALER', 'DEALER_IDLE'},'Kouyuu Ogawa',0},
	{186,2800.0905761719,-2492.4174804688,13.635256767273,0,'Członek Yakuzy',89.143005371094,{'DEALER', 'DEALER_IDLE'},'Mineyuki Ohira',0},
	{227,2797.3410644531,-2490.2893066406,13.638612747192,0,'Członek Yakuzy',176.25048828125,{'DEALER', 'DEALER_IDLE'},'Noboru Kawakami',0},
	{228,2793.09375,-2487.4643554688,13.64379978179,0,'Szef Yakuzy',270.25134277344,{'DEALER', 'DEALER_IDLE'},'Sumiaki Yamamoto',0},
	{187,2796.3872070313,-2486.1506347656,13.639778137207,0,'Członek Yakuzy',90,{'DEALER', 'DEALER_IDLE'},'Sora Yoshimura',0},
	--blackshop
	{126,-1301.3233642578,502.97668457031,11.1953125,0,'Przemytnik',104.88059234619,{'DEALER', 'DEALER_IDLE'},'Ermanno Angelo',0},
	{125,-1299.3951416016,501.68377685547,11.1953125,0,'Handlarz broni',102.37384796143,{'DEALER', 'DEALER_IDLE'},'Delfio Trentino',0},
	{124,-1289.5373535156,501.90914916992,11.1953125,0,'Przemytnik',56.940116882324,{'DEALER', 'DEALER_IDLE'},'Protasio Zetticci',0},
	{46,-1289.0924072266,509.75680541992,11.195312,0,'Handlarz broni',121.80076599121,{'DEALER', 'DEALER_IDLE'},'Lazzaro Lucciano',0},
	{113,-1297.1751708984,511.57446289063,11.1953125,0,'Szef Przemytników',148.74771118164,{'DEALER', 'DEALER_IDLE'},'Dario Veloce',0},
	{303,-1304.2808837891,510.19696044922,11.195312,0,'Szef Handlarzy broni',199.50819396973,{'DEALER', 'DEALER_IDLE'},'Andrzej Kolikowski',0},

}

for i,v in ipairs(peds) do
	local ped = createPed(v[1], v[2], v[3], v[4], v[7])
	setElementDimension(ped, v[5])
	setElementInterior(ped, v[10])
	setElementData(ped, 'ped', true)

	if v[8] then
		setTimer(function()
			setPedAnimation(ped, v[8][1], v[8][2], -1, true, false, false, true, 1500)
		end, 50, 1)
	end

	setElementFrozen(ped, true)
	setElementData(ped, 'text', v[6])

	if v[9] ~= '' then
		setElementData(ped, 'user:type', v[9])
		setElementData(ped, 'user:hex', '#69bceb')
	end
end

function triggerOpenGui(target)
	if getElementData(target, 'ped') then
		noti:addNotification('Nie mam czasu na rozmowe.', 'info')
	end
end