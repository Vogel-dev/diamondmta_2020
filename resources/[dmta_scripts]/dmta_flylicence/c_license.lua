--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local sw,sh = guiGetScreenSize()
local zoom = 1920/sw

local dx = exports.dxLibary

local LIC = {}

local tbl = {}
local timer = false
addCommandHandler("t", function()
    timer = setTimer(function()
        local x,y,z = getElementPosition(localPlayer)
        table.insert(tbl, {x, y, z})
        outputChatBox("Dodano!")
    end, 2500, 0)
end)

addCommandHandler("s", function()
    for i,v in pairs(tbl) do
        outputChatBox("{"..v[1]..", "..v[2]..", "..v[3].."},")
    end

    if(timer and isTimer(timer))then
        killTimer(timer)
        timer = false
    end
end)

-- usefull function created by Asper

function isMouseInPosition(x, y, w, h)
    if not isCursorShowing() then return end
        
    local mouse = {getCursorPosition()}
    local myX, myY = (mouse[1] * sw), (mouse[2] * sh)
    if (myX >= x and myX <= (x + w)) and (myY >= y and myY <= (y + h)) then
        return true
    end
        
    return false
end
    
local click = false
function onClick(x, y, w, h, called)
    if(isMouseInPosition(x, y, w, h) and not click and getKeyState("mouse1"))then
        click = true
        called()
    elseif(not getKeyState("mouse1") and click)then
        click = false
    end
end
    
--

LIC.marker = false
LIC.point = 1
LIC.type = false
LIC.blip = false

LIC.licenses = {
    L = {
        points = {
            {1946.0560302734, -2478.3662109375, 13.947242736816},
            {1883.4799804688, -2493.478515625, 14.014544487},
            {1715.4615478516, -2492.5290527344, 25.682970046997},
            -- {1637.0031738281, -2492.1015625, 43.626667022705},
            {1560.4422607422, -2482.2380371094, 56.894683837891},
            -- {1505.9130859375, -2430.70703125, 66.04621887207},
            {1462.8004150391, -2360.7368164063, 75.996994018555},
            -- {1418.5660400391, -2287.8217773438, 87.554611206055},
            {1381.0966796875, -2210.4145507813, 98.245346069336},
            -- {1360.5465087891, -2124.076171875, 106.3478012085},
            {1351.4298095703, -2033.9742431641, 114.28542327881},
            -- {1345.9261474609, -1935.1126708984, 108.9514541626},
            {1337.1175537109, -1832.7761230469, 109.61338806152},
            -- {1336.8249511719, -1735.0755615234, 116.75983428955},
            {1350.6514892578, -1636.740234375, 113.10313415527},
            -- {1369.7535400391, -1532.5119628906, 106.38986968994},
            {1400.7276611328, -1434.6834716797, 109.1371383667},
            -- {1436.6567382813, -1345.5584716797, 118.55358123779},
            {1460.7489013672, -1258.6177978516, 130.89213562012},
            -- {1471.7243652344, -1173.04296875, 142.54260253906},
            {1479.8184814453, -1079.6453857422, 143.1199798584},
            -- {1482.2437744141, -981.89202880859, 146.36871337891},
            {1430.3375244141, -903.8369140625, 146.52931213379},
            -- {1348.1387939453, -858.42858886719, 154.76663208008},
            {1262.62890625, -817.46990966797, 160.90502929688},
            -- {1174.9915771484, -779.75317382813, 165.60356140137},
            {1082.7847900391, -742.80395507813, 162.62411499023},
            -- {984.37475585938, -716.42700195313, 159.31604003906},
            {905.69378662109, -767.40673828125, 157.06823730469},
            -- {879.06280517578, -863.98071289063, 146.21368408203},
            {848.93292236328, -969.60296630859, 125.37685394287},
            -- {810.52435302734, -1077.7993164063, 88.003601074219},
            {770.96343994141, -1191.8421630859, 62.725765228271},
            -- {740.72515869141, -1298.5227050781, 60.081851959229},
            {747.95837402344, -1397.2884521484, 61.871212005615},
            -- {755.85186767578, -1498.7200927734, 61.529628753662},
            {763.05157470703, -1600.1538085938, 63.216781616211},
            -- {770.22912597656, -1703.66796875, 57.329986572266},
            {791.03790283203, -1801.1452636719, 60.178516387939},
            -- {875.49615478516, -1819.0740966797, 62.99543762207},
            {965.77386474609, -1775.2854003906, 52.564071655273},
            -- {1059.3317871094, -1745.7360839844, 58.308151245117},
            {1150.6773681641, -1753.8529052734, 64.809783935547},
            -- {1245.2388916016, -1754.4122314453, 70.040100097656},
            {1343.5513916016, -1754.2821044922, 71.13516998291},
            -- {1442.2446289063, -1754.6915283203, 74.913925170898},
            {1536.6617431641, -1770.7761230469, 80.427742004395},
            -- {1588.3859863281, -1841.7034912109, 89.631408691406},
            {1625.6520996094, -1925.5267333984, 96.331573486328},
            -- {1672.6461181641, -2002.8132324219, 102.17636108398},
            {1769.9077148438, -2023.6864013672, 86.648010253906},
            -- {1878.2913818359, -2024.0490722656, 79.607429504395},
            {1944.8360595703, -1962.8460693359, 92.284851074219},
            -- {1996.6673583984, -1884.8612060547, 94.828689575195},
            {2053.7153320313, -1810.3637695313, 100.45227050781},
            -- {2145.5310058594, -1802.0363769531, 91.467384338379},
            {2232.1027832031, -1860.0848388672, 74.509002685547},
            -- {2295.48046875, -1942.3660888672, 68.684005737305},
            {2298.5070800781, -2035.9332275391, 71.515296936035},
            -- {2267.2570800781, -2121.2797851563, 78.52311706543},
            {2239.6860351563, -2213.3366699219, 77.383888244629},
            -- {2200.1640625, -2306.7856445313, 65.810562133789},
            {2127.3483886719, -2388.8369140625, 47.192192077637},
            -- {2038.46875, -2449.0363769531, 39.746433258057},
            {1952.5363769531, -2477.9887695313, 28.090660095215},
            -- {1880.9288330078, -2493.22265625, 13.905621528625},
            {1831.3303222656, -2488.2060546875, 13.960194587708},
            -- {1815.3519287109, -2455.3649902344, 13.9652967453},
            {1817.5363769531, -2427.9428710938, 13.951711654663},
            -- {1839.6663818359, -2421.7646484375, 13.971568107605},
            {1879.2025146484, -2410.8215332031, 13.973836898804},
            -- {1915.6966552734, -2399.1435546875, 13.954458236694},
            {1950.1046142578, -2388.1787109375, 13.961183547974},
            {1979.7674560547, -2385.068359375, 13.951664924622},
        },

        cost = 3000,

        pos = {-2033.4343261719,-117.52773284912,1035.171875-1},

        marker = false,

        veh = {593, 1986.8427734375,-2382.8525390625,14.005171775818,0,0,90},
    },
}

for i,v in pairs(LIC.licenses) do
    v.marker = createMarker(v.pos[1], v.pos[2], v.pos[3]+0.01, "cylinder", 1.2, 124, 185, 232)
    setElementDimension(v.marker, 0)
    setElementInterior(v.marker, 3)
    setElementData(v.marker, 'marker:icon', 'fly')
end

LIC.onRender = function()
    local cost = ""
    if(LIC.licenses[LIC.type].cost > 0)then
        cost = "\n\nCena: "..LIC.licenses[LIC.type].cost.." $"
    end
    dxDrawRectangle(0, 0, 1920, 1080, tocolor(15, 15, 15, 200), false)
    dx:dxLibary_createWindow(714/zoom, 307/zoom, 493/zoom, 467/zoom)
    dx:dxLibary_text("Licencja lotnicza", 724/zoom, 317/zoom, 1197/zoom, 373/zoom, tocolor(105, 188, 235, 255), 10, "default", "center", "center", false, false, false, false, false)
    dx:dxLibary_text("Posiadając licencje lotniczą, możesz kierować maszynami powietrznymi oraz podjąc się prac w których jest ona wymagana."..cost, 738/zoom, 485/zoom, 1187/zoom, 569/zoom, tocolor(255, 255, 255, 255), 5, "default", "center", "center", false, true, false, false, false)
    dx:dxLibary_createButton("Rozpocznij", 748/zoom, 678/zoom, 202/zoom, 51/zoom, 3)
    dx:dxLibary_createButton("Anuluj", 985/zoom, 678/zoom, 202/zoom, 51/zoom, 3)

    onClick(748/zoom, 678/zoom, 202/zoom, 51/zoom, function()
        removeEventHandler("onClientRender", root, LIC.onRender)
        showCursor(false)

        for i,v in pairs(LIC.licenses) do
            if(isElementWithinMarker(localPlayer, v.marker))then
                triggerServerEvent("start.lic", resourceRoot, v, i)
            end
        end
    end)

    onClick(985/zoom, 678/zoom, 202/zoom, 51/zoom, function()
        removeEventHandler("onClientRender", root, LIC.onRender)
        showCursor(false)
    end)
end

addEventHandler("onClientMarkerHit", resourceRoot, function(hit, dim)
    if(hit ~= localPlayer or not dim)then return end

    for i,v in pairs(LIC.licenses) do
        if(source == v.marker)then
            addEventHandler("onClientRender", root, LIC.onRender)
            showCursor(true)
            LIC.type = i
            return
        end
    end

    if(source == LIC.marker)then
        destroyElement(LIC.marker)
        destroyElement(LIC.blip)
        
        LIC.point = LIC.point+1

        for i,v in pairs(LIC.licenses) do
            if(i == LIC.type)then
                if(LIC.point == #v.points)then
                    triggerServerEvent("stop.lic", resourceRoot, i)
                    outputChatBox("#00ff00● #ffffffZdałeś egzamin, gratulacje.", 255, 255, 255, true)
                
                    setTimer(function()
                        setElementPosition(localPlayer, 1978.4455566406,-2189.4633789063,13.546875)
                        setElementInterior(localPlayer, 0)
                    end, 500, 1)
                else
                    LIC.marker = createMarker(v.points[LIC.point][1], v.points[LIC.point][2], v.points[LIC.point][3], "ring", 4, 105, 188, 235, 255)
                    LIC.blip = createBlipAttachedTo(LIC.marker, 41)
                end
            end
        end
    end
end)

addEvent("start.lic", true)
addEventHandler("start.lic", resourceRoot, function(v, type)
    LIC.point = 1
    LIC.type = type
    for i,v in pairs(LIC.licenses) do
        if(i == type)then
            LIC.marker = createMarker(v.points[1][1], v.points[1][2], v.points[1][3], "ring", 4, 105, 188, 235, 255)
            LIC.blip = createBlipAttachedTo(LIC.marker, 41)
        end
    end
end)

addEvent("stop.lic", true)
addEventHandler("stop.lic", resourceRoot, function(v, type)
    if(LIC.marker and isElement(LIC.marker))then
        destroyElement(LIC.marker)
        destroyElement(LIC.blip)
    end
end)