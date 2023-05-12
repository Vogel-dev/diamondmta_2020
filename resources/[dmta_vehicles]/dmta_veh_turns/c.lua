--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local texture = dxCreateTexture("kierunkowskaz.png")
dxSetTextureEdge(texture,"clamp")


function getPositionFromElementAtOffset(element,x,y,z)
	if not x or not y or not z then      
		return x, y, z   
	end        
	x,y,z = tonumber(x),tonumber(y),tonumber(z)
	local matrix = getElementMatrix ( element )
	local offX = x * matrix[1][1] + y * matrix[2][1] + z * matrix[3][1] + matrix[4][1]
	local offY = x * matrix[1][2] + y * matrix[2][2] + z * matrix[3][2] + matrix[4][2]
	local offZ = x * matrix[1][3] + y * matrix[2][3] + z * matrix[3][3] + matrix[4][3]
	return offX, offY, offZ
end




local sw, sh = guiGetScreenSize();
local zoom = 1;

if sw < 1920 then
    zoom = math.min(2, 1920/sw);
end

local wiel =   (sw+sh)/(1920+1080)



local vehiclespos={
	[541]={ --bullet
		{0.698,2.245,-0.214,10},
		{0.77,-2.2,0.12,13},
	},
	[597]={ -- radiowoz
		{1,-2.67,0.060,13},
		{1,2.3,-0.01,13},
	},
	[490]={ -- FBI Rancher
		{1.13,-3.1,0.12,13},
		{0.85,3.3,-0.45,13},
	},
	[578]={ -- Lawete
		{1.34,-6.7,-0.798,13},
		{1.17,4.39,-0.165,13},
	}, 
	[420]={ -- Taxi Premier
		{1,-2.67,0.0,13},
		{1,2.3,-0.01,13},
	},
	[426]={ -- Premier
		{1,-2.67,0.0,13},
		{0.756,2.3,-0.01,13},
	},
	[407]={ --Fire Truck
		{0.85,4.1,0.08,13},
		{1.03,-3.741,-0.161,13},
		{1.1,0.795,-0.33,13},
	},
	[544]={  -- FireTruck Leader
		{0.80,3.67,0.08,13},
		{0.88,-4.2,-0.83,13},
	}, 
	[560]={ -- sultan
		{0.95,2.3,0.07,13},
		{0.70,-2.35,0.1,13},
	},
	[416]={ -- karetka
		{0.98,2.95,0.07,13},
		{1.06,-3.75,-0.46,13},
	},
	[554]={ -- yosemite
		{1.16,2.54,0.1,13},
		{1.13,-2.8,0.1,13},
	},
	[411]={ -- infernus
		{1,2.6,-0.18,13},
		{0.9,-2.45,0.07,13},
	},
	[507]={ -- elegant
		{1.1,2.6,-0.05,13},
		{1,-3.03,-0.06,13}, 
	}, 
	[546]={ -- Intruder
		{1,2.6,0.03,13}, 
		{1.05,-2.7,0.1,13}, 
	},
	[585]={  -- Emperor
		{1,2.8,0.12,13}, 
		{0.93,-3,0.22,13}, 
	},
	[529]={ --Willard
		{1.02,2.519,0.085,13},
		{1.034,-2.6,0.195,13},
	},
	[421]={  -- Washington
		{0.9,2.55,-0.15,13},
		{0.85,-2.9,-0.2,13},
	},
	[400]={  -- Landstalker
		{0.93,2.03,-0.05,13},
		{0.98,-2.22,-0.08,13},
	},
	[489]={ -- Rancher
		{1.13,-3.1+0.45,0.12,13},
		{0.85,2.739,-0.45,13},
	},
	[579]={ -- Huntley
		{0.93,2.38,0.03,13},
		{1.04,-2.77,0.07,13},
	},
	[500]={ -- mesa
		{0.425,2.08,-0.205,13}, 
		{0.75,-1.97,-0.02,13}, 
		{0.93,1.914,-0.009,10}, 
	},
	[442]={ -- Romero
		{1.01,2.83,-0.18}, 
		{1.020,-3.09,-0.147}, 
	},
	[431]={  -- BUS
		{1.058,-5.703,-0.209,13},
		{1.01,-5.537,1.93,13},
		{0.972,5.89,0.437,13},
		{1.28,-0.013,1.924},
	},

	[599]={ --Police Ranger
		{1.13,-2.65,0.12,13},
		{0.85,2.709,-0.45,13},
	},
	[409]={ -- Limka
		{0.90,3.496,0.036,13},
		{0.901,-3.9,0.01,13}, 
	},
	[601]={ -- SWAT Czołg
		{1,-3.17,0.9,14},  
	},
	[573]={ -- Dune
		{0.82,3.1,-0.39,13},
		{0.866,-3.35,-0.35,13},
	},
	[428]={ -- Securicar
		{1.003,-4.0,-0.185,13},
		{0.855,1.3,1.357,11},
	},
	[427]={ -- EnForcer
		{0.971,-3.88,0.314,13},
		{0.94,2.692,0.2,13},
	},
	[482]={ -- Burrito
		{0.88,2.45,-0.33,12},
		{0.855,-2.58,-0.03,12},
	},
	[445]={ -- Admiral
		{0.96,2.34,-0.05,13},
		{0.93,-2.76,-0.088,13},
	},
	[551]={ -- Merit
		{0.97,2.6,-0.05,12},
		{1.02,-3.03,0.045,12},
	}, 
	[438]={ -- Cabby
		{1.124,2.39,-0.282,13},
		{1.124,-2.487,-0.282,13},
	},
	[492]={ -- Greenwood
		{0.79,2.55,-0.03,11},
		{0.57,2.55,-0.03,11},
		{0.833,-2.83,0,13},
	},
	[437]={ -- Coach
		{1.19,5.6,-0.159,13},
		{0.885,5.43,1.825,11},
		{1.2,-5.33,1.28,14},
	},
	[405]={ -- Sentinel
		{0.92,-2.67,-0.04,13},
		{0.92,2.26,-0.063,13},
	},
	[419]={ -- Esperanto
		{0.711,2.65,-0.409,13},
		{0.728,-2.87,-0.13,13},
	},
	[475]={ -- Sabre
		{0.881,2.452,-0.335},
		{0.863,-2.79,-0.219},
	},
	[410]={ -- manana
		{0.9,-2.2,0.1},
		{0.82,2.15,0.05},
	},
	[401]={ --bravura
		{0.989,-2.3,0.02},
		{0.97,2.55,0.035},
	},
	--generator
	[402]={ --Buffalo
		{0.855,2.564,-0.045,13},
		{0.856,-2.64,0,13},
	},
	[602]={ --Alpha
		{0.84,2.444,-0.406,11},
		{0.9,-2.655,-0.286,10},
	},
	[496]={ --Blista Compact
		{0.9,2.174,0.044,13},
		{0.915,-2.1,0.075,13},
	},
	[518]={ --Buccaneer
		{0.6,2.7,-0.03,13},
		{1.035,-2.836,-0.166,13},
	},
	[527]={ --Cadrona
		{0.93,2.459,0,13},
		{0.87,-2.325,0.12,13},
	},
	[589]={ --Club
		{0.795,2.399,0.18,13},
		{0.915,-2.265,0.39,10},
	},
	[587]={ --Euros
		{0.9,2.249,-0.271,13},
		{1.065,-2.535,0.135,13},
	},
	[533]={ --Feltzer
		{0.96,2.384,0.045,13},
		{0.945,-2.535,0.03,13},
	},
	[526]={ --Fortune
		{0.915,2.324,-0.12,13},
		{0.84,-2.325,-0.015,13},
	},
	[474]={ --Hermes
		{0.915,2.67,0.015,13},
		{0.99,-2.746,-0.045,13},
	},
	[517]={ --Majestic
		{0.945,2.745,-0.045,13},
		{1.005,-2.746,-0.105,13},
	},
	[403]={ --Linerunner
		{1.005,4.46,-0.811,13},
		{0.33,-4.126,-0.721,13},
	},
	[404]={ --Perennial
		{0.72,2.159,-0.03,13},
		{0.811,-2.731,-0.015,13},
	},
	[406]={ --Dumper
		{1.02,5.339,-0.346,20},
		{0.645,-2.746,-0.511,13},
	},
	[408]={ --Trashmaster
		{0.945,4.814,-0.166,13},
		{0.855,-4.066,-0.481,13},
	},
	[412]={ --Voodoo
		{0.901,2.655,-0.06,13},
		{0.96,-3.526,-0.151,13},
	},
	[413]={ --Pony
		{0.945,2.594,-0.09,13},
		{0.9,-2.625,0.315,13},
	},
	[414]={ --Mule
		{0.705,2.82,-0.045,13},
		{1.08,-3.391,2.069,13},
	},
	[415]={ --Cheetah
		{0.885,2.489,-0.226,13},
		{0.781,-2.385,0.03,13},
	},
	[418]={ --Moonbeam
		{0.961,2.399,-0.241,13},
		{0.795,-2.67,-0.601,13},
	},
	[422]={ --Bobcat
		{0.78,2.174,-0.256,13},
		{0.93,-2.43,-0.256,13},
		{1.02,1.499,-0.045,7},
	},
	[423]={ --Mr. Whoopee
		{0.75,2.294,0.06,13},
		{0.825,-2.25,0.03,13},
		{0.825,-2.22,1.409,6},
	},
	[424]={ --BF Injection
		{0.72,1.439,0.21,8},
		{0.6,-1.59,0.255,8},
	},
	[429]={ --Banshee
		{0.404,2.384,-0.271,13},
		{0.84,-2.415,0,10},
	},
	[433]={ --Barracks
		{1.244,3.705,-0.075,18},
		{1.364,-4.515,-0.736,13},
	},
	[434]={ --Hotknife
		{0.615,1.889,-0.135,13},
		{0.48,-1.995,-0.06,13},
	},
	[436]={ --Previon
		{0.84,2.234,-0.015,13},
		{0.915,-2.49,0.105,13},
	},
	[439]={ --Stallion
		{0.81,2.369,-0.466,13},
		{0.885,-2.685,-0.121,13},
	},
	[440]={ --Rumpo
		{0.96,2.564,-0.286,10},
		{1.02,1.784,-0.211,7},
		{0.915,-2.625,0.075,13},
	},
	[443]={ --Packer
		{1.05,5.864,-0.991,15},
		{1.454,-6.885,-0.736,13},
	},
	[451]={ --Turismo
		{1.02,1.964,-0.121,8},
		{0.87,-2.505,-0.211,13},
	},
	[455]={ --Flatbed
		{1.244,3.72,-0.075,15},
		{1.379,-4.53,-0.736,13},
	},
	[456]={ --Yankee
		{0.915,3.33,-0.075,13},
		{1.229,-4.62,-0.631,13},
	},
	[457]={ --Caddy
		{0.45,1.184,0.075,13},
		{0.525,-1.305,0.09,13},
	},
	[459]={ --Berkley's RC Van
		{0.945,2.594,-0.09,13},
		{0.9,-2.625,0.315,13},
	},
	[466]={ --Glendale
		{0.915,2.609,0.12,13},
		{1.02,-2.776,0.015,13},
	},

	[604]={ --Glendale deamged
		{0.915,2.609,0.12,13},
		{1.02,-2.776,0.015,13},
	},
	[467]={ --Oceanic
		{0.6,2.85,-0.105,13},
		{0.945,-3.031,0.015,13},
	},
	[470]={ --Patriot
		{1.035,2.174,0.195,8},
		{1.035,-2.64,-0.196,9},
	},
	[477]={ --ZR-350
		{0.825,2.715,-0.181,9},
		{1.095,-2.61,0.075,13},
	},
	[478]={ --Walton
		{1.08,2.009,0.105,13},
		{1.05,-2.55,-0.271,13},
	},
	[479]={ --Regina
		{0.975,2.504,0.03,13},
		{0.96,-2.761,0.06,13},
	},
	[480]={ --Comet
		{0.6,2.309,-0.421,13},
		{0.87,-2.385,-0.12,13},
	},
	[483]={ --Camper
		{0.795,2.624,-0.031,13},
		{0.66,-2.776,-0.256,13},
	},
	[485]={ --Baggage
		{0.615,1.739,0.225,8},
		{0.72,-1.38,0.045,6},
	},
	[486]={ --Dozer
		{0.9,1.514,1.05,13},
		{0.585,-3.226,1.14,13},
	},
	[491]={ --Virgo
		{0.855,2.519,-0.09,13},
		{0.855,-2.821,-0.12,13},
	},
	[495]={ --Sandking
		{1.095,2.414,0,13},
		{1.169,-2.16,-0.03,13},
	},
	[498]={ --Boxville
		{0.87,3.09,0.225,13},
		{0.96,-3.091,0.36,13},
	},
	[499]={ --Benson
		{0.78,2.519,-0.196,13},
		{1.14,-3.436,0.015,13},
	},
	[506]={ --Super GT
		{0.795,2.279,-0.316,13},
		{0.87,-2.34,-0.015,10},
	},
	[508]={ --Journey
		{0.69,3.045,-0.676,13},
		{1.065,-3.661,1.304,13},
	},
	[514]={ --Tanker
		{1.229,4.23,0.09,13},
		{1.065,-10.441,-0.391,13},
	},
	[515]={ --Roadtrain
		{1.319,4.425,-0.436,18},
		{1.349,-5.07,-1.125,13},
	},
	[516]={ --Nebula
		{0.945,2.655,-0.045,13},
		{0.975,-2.791,-0.015,13},
	},
	[524]={ --Cement Truck
		{0.945,3.66,-0.03,13},
		{1.244,-3.931,-1.066,13},
	},
	[525]={ --Towtruck
		{0.84,2.985,0.165,13},
		{0.945,-0.766,1.095,13},
	},
	[528]={ --FBI Truck
		{0.87,2.549,-0.151,8},
		{0.81,-2.64,-0.316,13},
	},
	[530]={ --Forklift
		{0.495,0.375,1.214,9},
		{0.495,-0.916,0.9,9},
	},
	[531]={ --Tractor
		{0.21,1.544,-0.12,10},
		{0.495,-1.575,0.24,8},
	},
	[534]={ --Remington
		{0.99,2.97,-0.181,13},
		{0.795,-2.761,-0.06,13},
	},
	[535]={ --Slamvan
		{0.825,2.504,-0.196,9},
		{0.945,-2.595,-0.151,13},
	},
	[536]={ --Blade
		{0.855,2.459,-0.121,13},
		{0.87,-3.091,-0.075,10},
	},
	[540]={ --Vincent
		{0.99,2.609,-0.105,13},
		{1.169,1.154,-0.075,8},
		{1.065,-2.731,-0.06,9},
	},
	[542]={ --Clover
		{0.975,2.655,-0.03,13},
		{0.765,-2.971,-0.06,13},
	},
	[543]={ --Sadler
		{0.765,2.294,0.09,13},
		{0.975,-2.64,0,9},
	},
	[545]={ --Hustler
		{0.48,1.709,0.06,13},
		{0.825,-2.115,-0.241,10},
	},
	[547]={ --Primo
		{0.945,2.534,0.045,13},
		{0.945,-2.625,0.06,13},
	},
	[549]={ --Tampa
		{0.9,2.519,0.015,10},
		{0.915,-2.61,0.075,13},
	},
	[550]={ --Sunrise
		{1.02,2.67,-0.181,13},
		{1.005,-2.7,-0.12,13},
	},
	[552]={ --Utility Van
		{1.08,3.075,0.39,11},
		{0.99,-3.031,0.63,8},
	},
	[555]={ --Windsor
		{0.735,2.249,0,13},
		{0.93,1.11,-0.015,10},
		{0.72,-2.43,-0.105,10},
	},
	[558]={ --Uranus
		{0.93,2.204,0.09,10},
		{0.915,-2.415,0.285,10},
	},
	[559]={ --Jester
		{0.78,2.339,0,11},
		{0.885,-2.265,0.195,8},
	},
	[561]={ --Stratum
		{0.9,2.624,-0.075,13},
		{0.915,-2.61,0,10},
	},
	[565]={ --Flash
		{0.84,2.069,0.044,9},
		{0.87,-1.95,0.09,10},
	},
	[566]={ --Tahoma
		{0.915,2.685,0.015,13},
		{0.945,-2.971,-0.06,13},
	},
	[567]={ --Savanna
		{0.99,2.94,-0.151,13},
		{0.99,-2.896,-0.135,13},
	},
	[568]={ --Bandito
		{0.135,2.264,0.045,13},
		{0.225,-1.59,0.15,8},
	},
	[574]={ --Sweeper
		{0.465,1.754,-0.211,13},
		{0.345,-1.245,-0.151,8},
	},
	[575]={ --Broadway
		{0.975,2.324,0.135,13},
		{0.915,-2.716,-0.015,13},
	},
	[576]={ --Tornado
		{0.96,2.459,0.21,13},
		{1.005,-3.166,0,10},
	},
	[580]={ --Stafford
		{0.795,2.624,-0.226,13},
		{1.08,-2.851,-0.045,9},
	},
	[582]={ --Newsvan
		{0.96,2.519,-0.06,13},
		{0.915,-3.421,0.105,13},
	},
	[583]={ --Tug
		{0.645,1.454,0.33,8},
		{0.51,-1.635,0.345,13},
	},
	[588]={ --Hotdog
		{0.975,3.42,0.435,20},
		{1.08,-4.081,-0.286,13},
	},
	[596]={ --Police LS
		{1,-2.67,0.015,13},
		{1,2.3,-0.01,13},
	},
	[600]={ --Picador
		{0.825,2.67,-0.03,13},
		{1.02,-2.716,0.075,13},
	},
	[603]={ --Phoenix
		{0.885,2.519,-0.121,13},
		{0.855,-2.625,-0.09,13},
	},
	[609]={ --Boxville Mission -- Yankee z pracy --
		{0.719,3.525,-0.436,13},
		{1.229,-4.62,-0.631,13},
	},
	[562]={ --Elegy
		{0.915,2.399,0.015,13},
		{0.495,-2.31,0.105,6},
	},
	[458]={ --Solair
		{0.945,2.459,-0.135,13},
		{0.975,-2.821,-0.166,10},
	},
	[605]={ --Deluxo
		{0.705,2.474,-0.135,9},
		{0.645,-2.64,0.165,10},
	},
}

	
	
	
function tn(n)
	if tonumber(n) then
		n=tonumber(n)
		n=n*1000
		n=math.floor(n)
		n=n/1000
		return n
	else
		return 0
	end
end


addEventHandler("onClientVehicleStartExit",root,function(el,seat)
	if wasEventCancelled() then return end
	if el==localPlayer then
	wychodzi = true
	end
end)

addEventHandler("onClientVehicleExit",root,function(el)
	if el==localPlayer then
	wychodzi = false
	end
end)


defaultSekf=2
maxa = 225
sekf = {
	[1]={a=maxa,plus=false},
	[2]={a=maxa,time=getTickCount()},
}

-- dev tools
wybrany = 1
edycja=1
plus=0.015
tick=getTickCount()
sw,sh = guiGetScreenSize()

bindKey("arrow_u","down",function()
	if not getElementData(localPlayer,"dev_dmta") then return end
	wybrany=wybrany+1
	
end)
bindKey("arrow_d","down",function()
	if not getElementData(localPlayer,"dev_dmta") then return end
	wybrany=wybrany-1
	if wybrany<1 then wybrany=1 return end
end)
bindKey("arrow_l","down",function()
	if not getElementData(localPlayer,"dev_dmta") then return end
	edycja=edycja-1
	if edycja < 0 then edycja=0 end
end)
bindKey("arrow_r","down",function()
	if not getElementData(localPlayer,"dev_dmta") then return end
	edycja=edycja+1
	if edycja > 5 then edycja=5 end
end)

bindKey("num_enter","down",function()
	if not getElementData(localPlayer,"dev_dmta") then return end
	local veh = getPedOccupiedVehicle(localPlayer)
	if veh then
		local model = getElementModel(veh)
		--outputChatBox("["..tostring(model).."]={ --"..tostring(getVehicleName(veh)))
		local texts={"["..tostring(model).."]={ --"..tostring(getVehicleName(veh))}
		for i,v in ipairs(vehiclespos[model]) do
			table.insert(texts,"\t\t{"..tostring(tn(v[1]) or 0)..","..tostring(tn(v[2]) or 0)..","..tostring(tn(v[3]) or 0)..","..tostring(tn(v[4]) or 10).."},")
		--	outputChatBox("\t\t{"..tostring(tn(v[1]) or 0)..","..tostring(tn(v[2]) or 0)..","..tostring(tn(v[3]) or 0)..","..tostring(tn(v[4]) or 10).."},")
			
		end
		--outputChatBox("\t},")
		table.insert(texts,"\t},")
		
		outputChatBox(table.concat(texts,"\n"))
		setClipboard(table.concat(texts,"\n"))
	end
end)



function round(num)
    return math.floor(num + 0.3)
end

-- licznik pozycje
scalee=(sw/1000 + sh/850)/2
scalee2=(sw/1920 + sh/1080)/2
scalew=(sw/1920)/2
scaleh=(sh/1080)/2
c_XOffset = 10
c_YOffset = 10
c_ImageW = 214*1.30
c_ImageH = 151*1.30
g_XOffset = round(c_XOffset*scalee)
g_YOffset = round(c_YOffset*scalee)
g_ImageW = round(c_ImageW*scalee)
g_ImageH = round(c_ImageH*scalee)
licz = {sw - g_ImageW*1.1 - g_XOffset, sh - g_ImageH*1.1 - g_YOffset,g_ImageW, g_ImageH}


addEventHandler("onClientRender",root,function()
	
	
	
	if wychodzi==true then return end
	if getElementData(localPlayer,"dev_dmta") == true then
		
		local veh = getPedOccupiedVehicle(localPlayer)
		if veh then
			local model = getElementModel(veh)
			if not vehiclespos[model] then vehiclespos[model]={} end
			if not vehiclespos[model][wybrany] then vehiclespos[model][wybrany]={0,0,0,13} end
			if getTickCount()-tick > 100 then
				local toed = vehiclespos[model][wybrany][edycja] or 0
				if getKeyState("num_add") then
					if edycja < 4 then 
						vehiclespos[model][wybrany][edycja]=toed+plus
						toed=toed+plus
						tick=getTickCount()
					elseif edycja==4 then
						vehiclespos[model][wybrany][edycja]=toed+1
						toed=toed+1
						tick=getTickCount()
					elseif edycja==5 then
						if getTickCount()-tick > 300 then
							tick=getTickCount()
							plus=plus+0.001
						end
					end
				end
				if getKeyState("num_sub") then
					if edycja < 4 then 
						vehiclespos[model][wybrany][edycja]=toed-plus
						toed=toed-plus
						tick=getTickCount()
					elseif edycja==4 then
						vehiclespos[model][wybrany][edycja]=toed-1
						toed=toed-1
						tick=getTickCount()
					elseif edycja==5 then
						if getTickCount()-tick > 300 then
							tick=getTickCount()
							plus=plus-0.001
						end
					end
				end
				
			end
			
			
			
			local pos=vehiclespos[model][wybrany]
			
			for i=1,4 do
				if not pos[i] then
					if i==4 then
						vehiclespos[model][wybrany][i]=10
					else
						vehiclespos[model][wybrany][i]=0
					end
				end
			end
			
			local pos2={}
			for i,v in ipairs(pos) do
				if i==edycja then
					pos2[i]="#00FF00"..tostring(tn(v)).."#FFFFFF"
				else
					pos2[i]="#FFFFFF"..tostring(tn(v)).."#FFFFFF"
				end
			end
			
			local ma=tn(plus)
			if edycja==5 then 
				ma="#00FF00"..tostring(ma).."#FFFFFF"
			end
			
			dxDrawText("Wybrany: #FF0000"..tostring(wybrany).." #FFFFFF|| X: "..tostring(pos2[1] or 0).." | Y: "..tostring(pos2[2] or 0).." | Z: "..tostring(pos2[3] or 0).." |S: "..tostring(pos2[4] or 0).." |PLUS: "..tostring(ma),sw/2,40,sw/2,40,tocolor(255,255,255,255),1.5,"default-bold","center","top",false,false,false,true)
		end
		
		
		
	end


	--if getElementData(localPlayer,"ACL") then 
	dxSetBlendMode("blend")
	-- sekfencja nr 1
	if sekf[1].plus == true then
		sekf[1].a=sekf[1].a+25
		if sekf[1].a>maxa then 
			sekf[1].a = maxa
			sekf[1].plus=false 
		end
	elseif sekf[1].plus == false then
		sekf[1].a=sekf[1].a-25
		if sekf[1].a<50 then 
			sekf[1].a=50; 
			sekf[1].plus=true 
		end
	end
	-- sekfencja nr 2
	if getTickCount() - sekf[2].time > 400 then	
		sekf[2].time = getTickCount()
		if sekf[2].a == maxa then
			sekf[2].a = 0
		else
			sekf[2].a = maxa
		end
	end
	
	if isPedInVehicle(localPlayer) and not getElementData(localPlayer,"hud") then
		local veh = getPedOccupiedVehicle(localPlayer) 
		if veh then
			local model = getElementModel(veh)
			local kier = getElementData(veh, "kierunkowskazy")
			if vehiclespos[model] then
				local alphaison=vehiclespos[model].styl
				local alphaison=sekf[alphaison or defaultSekf].a
				--if kier=="r" or kier=="a" then
					--dxDrawImage(1430/zoom, 606/zoom, 550/zoom, 550/zoom, ":smta_veh_speedometer/licznik/pkierunek.png", 0, 0, 0, tocolor(255, 255, 255, alphaison), false)
				--end
				--if kier=="l" or kier=="a" then
					--dxDrawImage(1430/zoom, 606/zoom, 550/zoom, 550/zoom, ":smta_veh_speedometer/licznik/lkierunek.png", 0, 0, 0, tocolor(255, 255, 255, alphaison), false)
				--end
			end
		end
	end
	
	
	local matrix = {getCameraMatrix()}
	for i,veh in ipairs(getElementsByType("vehicle",root,true)) do
		if getElementData(veh,"kierunkowskazy") then
			local model = getElementModel(veh)
			local kier = getElementData(veh,"kierunkowskazy")
			if vehiclespos[model] then
				local xmnoz = 1
				for i,v in ipairs(vehiclespos[model]) do
					if kier == "r" then
						dxDrawTurn(veh,matrix,v[1],v[2],v[3],v[4],v.sizeh,vehiclespos[model].styl)
					elseif kier == "l" then
						dxDrawTurn(veh,matrix,v[1]*-1,v[2],v[3],v[4],v.sizeh,vehiclespos[model].styl)
					elseif kier == "a" then
						dxDrawTurn(veh,matrix,v[1],v[2],v[3],v[4],v.sizeh,vehiclespos[model].styl)
						dxDrawTurn(veh,matrix,v[1]*-1,v[2],v[3],v[4],v.sizeh,vehiclespos[model].styl)
					end
				end
			end
		end
		
	end
	
	
	
	
	dxSetBlendMode("blend")
	-- for i,v in ipairs(getElementsByType("marker",resourceRoot,true)) do
		-- local r,g,b = getMarkerColor(v)
		-- setMarkerColor(v,r,g,b,sekf[2].a)
	-- end
	
	--end
end)
 

 
 
 
 function getLine(x,y,z,x2,y2,z2,s)
	if isLineOfSightClear(x,y,z,x2,y2,z2, true,true, true, true,false,false,false) then
		return true
	end
	return false
 end
  
 
 function dxDrawTurn(veh,matrix,x,y,z,size,sizeh,styl)
	local x,y,z = getPositionFromElementAtOffset(veh,x,y,z)
	local dist = getDistanceBetweenPoints3D(x, y, z, matrix[1],matrix[2],matrix[3])
	local s = size or 10
	local s = s*50 / dist
	local s = s * wiel
	--if isLineOfSightClear(x, y, z, matrix[1],matrix[2],matrix[3], true,true, true, true,false,false,false,localPlayer)  then
	if getLine(x, y, z, matrix[4],matrix[5],matrix[6],s) then
		local x,y = getScreenFromWorldPosition(x,y,z)
		if x and y then
			
			local h = (sizeh or 1)
			dxDrawImage(x-(s/2),y-((s/4)*h),s,(s/2)*h,texture,0,0,0,tocolor(235-10,183-10,13,sekf[styl or defaultSekf].a))
		end
	end

 end
 
 
 
 
 
 
 
function turn(typ)
	if isPedInVehicle(localPlayer) then
		local veh = getPedOccupiedVehicle(localPlayer)
		if getPedOccupiedVehicleSeat(localPlayer) == 0 then
		
			--if getElementData(localPlayer,"ACL")=="Admin" then
			--if getPlayerTeam(localPlayer) or getElementData(localPlayer,"ACL")=="Admin" then
			
			if tostring(getElementData(veh,"kierunkowskazy")) == tostring(typ) then 
				setElementData(veh,"kierunkowskazy",nil)
			else
				setElementData(veh,"kierunkowskazy",typ)
			end
			
			
				-- if getElementData(localPlayer,"ACL")=="Admin" then
					-- setElementData(veh,"kierunkowskazy",nil)
					-- local x,y,z = getElementPosition(veh)
					
					
					-- for i,v in ipairs(vehiclespos[getElementModel(veh)]) do
						-- local s = v[4] / 60
						-- if typ == "r" then
							-- local kier = createMarker(0,0,0,"corona",s,235-10,183-10,13,255,root)
							-- attachElements(kier,veh,v[1],v[2],v[3])
						-- elseif typ == "l" then
							-- local kier = createMarker(v[1]*-1,v[2],v[3],"corona",s,235-10,183-10,13,255,root)
							-- attachElements(kier,veh,v[1]*-1,v[2],v[3])
						-- elseif typ == "a" then
							-- local kier = createMarker(v[1],v[2],v[3],"corona",s,235-10,183-10,13,255,root)
							-- attachElements(kier,veh,v[1],v[2],v[3])
							-- local kier = createMarker(v[1]*-1,v[2],v[3],"corona",s,235-10,183-10,13,255,root)
							-- attachElements(kier,veh,v[1]*-1,v[2],v[3])
						-- end
					-- end
					
				--end
			
			
			
			--end
		end
	end
end

addCommandHandler("migacz prawy",function() turn("r") end)
addCommandHandler("migacz lewy",function() turn("l") end)
addCommandHandler("migacze awaryjne",function() turn("a") end)

addCommandHandler("vehicles_migacze",function()
	local aa=0
	for i,v in pairs(vehiclespos) do
		aa=aa+1
	end
	outputChatBox("Pojazdów wykonanych: " ..tostring(aa))
end)


bindKey("]","down","migacz prawy")
bindKey("[","down","migacz lewy")
bindKey("\\","down","migacze awaryjne")

addEventHandler("onClientPlayerWeaponFire",localPlayer,function(wp,_,_,x,y,z,el)
	if getElementData(localPlayer,"dev_dmta") then
		outputChatBox("Pozycja strzału: "..tostring(x)..","..tostring(y)..","..tostring(z).."")
		if el and isElement(el) then
			local px, py, pz = x,y,z
			local vx, vy, vz = getElementPosition(el)
			local sx = px - vx
			local sy = py - vy
			local sz = pz - vz
			local rotvX,rotvY,rotvZ = getVehicleRotation(el)
			
			local t = math.rad(rotvX)
			local p = math.rad(rotvY)
			local f = math.rad(rotvZ)
			local ct = math.cos(t)
			local st = math.sin(t)
			local cp = math.cos(p)
			local sp = math.sin(p)
			local cf = math.cos(f)
			local sf = math.sin(f) 
			local z = ct*cp*sz + (sf*st*cp + cf*sp)*sx + (-cf*st*cp + sf*sp)*sy
			local x = -ct*sp*sz + (-sf*st*sp + cf*cp)*sx + (cf*st*sp + sf*cp)*sy
			local y = st*sz - sf*ct*sx + cf*ct*sy
			local x=math.floor(x*1000)/1000
			local y=math.floor(y*1000)/1000
			local z=math.floor(z*1000)/1000
			
			outputChatBox("Pozycja strzału względem elementu: "..tostring(x)..","..tostring(y)..","..tostring(z).."")
			outputChatBox("ID objektu: "..getElementID(el))
		end
	end
end)