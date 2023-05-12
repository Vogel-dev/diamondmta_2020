--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local window = dxLibary:createTexture(':dmta_base_radar/images/window.png')
local pasek = dxLibary:createTexture(':dmta_base_radar/images/pasek.png')

blipsTexture = {}

for i = 0,55 do
	if fileExists('blips/'..i..'.png') then
		blipsTexture[i] = dxLibary:createTexture(':dmta_base_radar/blips/'..i..'.png', 'dxt5', false, 'clamp')
	end
end

replaceBlips = {
    
    {'Praca', 52, {}},
    {'Marihuana', 16, {}},
    {'Urząd miasta', 19, {{1481.9185791016,-1766.3193359375,18.795755386353}}},
    {'Sklep z bronią', 15, {{1359.9744873047,-1274.7375488281,13.3828125}}},
    {'Rynek', 28, {{1400.6298828125,-1616.7005615234,13.539485931396}}},
    {'Zarząd Wędkarstwa', 17, {{2820.3215332031,-1617.0899658203,11.088542938232}}},
    {'Szpital Główny', 22, {{1175.2008056641,-1323.4342041016,14.390625}}},
    {'Salon samochodowy', 55, {}},
    {'Komis samochodowy', 14, {}},
    {'Warsztat mechaniczny', 27, {{1733.04296875,-1746.0086669922,13.535557746887}}},
    {'Komenda Policji', 30, {{1554.7969970703,-1675.6149902344,16.1953125}}},
    {'Parking strzeżony', 35, {{1009.1525268555,-1368.1472167969,13.342638015747}}},
    {'Ośrodek szkoleniowy', 38, {{1774.3751220703,-1723.6434326172,13.546875}}},
    {'Bank', 39, {{1310.1888427734,-1366.7958984375,13.506487846375}}},
    {'Stacja paliw', 40, {}},
    {'Giełda pojazdów', 51, {{1785.1203613281,-2052.1770019531,13.576071739197}}},
    {'Sklep z ubraniami', 45, {{1073.1667480469,-1384.8074951172,13.868677139282}}},
    
}

function findBlipTexture(id)
    return blipsTexture[id] or blipsTexture[0]
end

for i,v in ipairs(replaceBlips) do
    v[5] = blipsTexture[v[2]] or blipsTexture[0]

    for index,k in ipairs(v[3]) do
        v[4] = {}
        v[4][index] = createBlip(k[1], k[2], k[3], v[2])
        setBlipVisibleDistance(v[4][index], 300)
    end
end

function blipsRender(a)
    dxDrawImage(Bigmap['PosX'] - 3/scale, center(-540/scale), Bigmap['Width'] + 6/scale, 144/scale, window, 0, 0, 0, tocolor(255, 255, 255, a), false)
    dxDrawImage(Bigmap['PosX'] - 3/scale, (center(-540/scale) + 144/scale), Bigmap['Width'] + 6/scale, 2/scale, pasek, 0, 0, 0, tocolor(255, 255, 255, a), false)

    local k = 0
    for i,v in ipairs(replaceBlips) do
        if (blip_legend_page + 3) >= i and blip_legend_page <= i then
            k = k + 1

            local x = 262/scale * (k - 1)

            dxDrawImage(528/scale + x, center(-594/scale), 64/scale, 64/scale, v[5], 0, 0, 0, tocolor(255, 255, 255, a), false)
            dxLibary:dxLibary_text(v[1], 528/scale + x, center(-570/scale), 598/scale + x, 170/scale + center(-570/scale), tocolor(255, 255, 255, a), 3, 'default', 'center', 'center', false, false, false, false, false)

            if isMouseIn(400/scale, center(-615/scale), 64/scale, 64/scale) then
                dxDrawImage(400/scale, center(-615/scale), 64/scale, 64/scale, radarSettings['arrow1'], 180, 0, 0, tocolor(55, 98, 125, a), false)
            else
                dxDrawImage(400/scale, center(-615/scale), 64/scale, 64/scale, radarSettings['arrow1'], 180, 0, 0, tocolor(105, 188, 235, a), false)
            end

            if isMouseIn(1461/scale, center(-615/scale), 64/scale, 64/scale) then
                dxDrawImage(1461/scale, center(-615/scale), 64/scale, 64/scale, radarSettings['arrow1'], 0, 0, 0, tocolor(55, 98, 125, a), false)
            else
                dxDrawImage(1461/scale, center(-615/scale), 64/scale, 64/scale, radarSettings['arrow1'], 0, 0, 0, tocolor(105, 188, 235, a), false)
            end

            if isMouseIn(528/scale + x, center(-594/scale), 64/scale, 64/scale) then
                local _x,_y = getCursorPosition()
                _x,_y = _x * sw, _y * sh
                _x,_y = _x + 10/scale, _y

                local text = 'Kliknij aby zlokalizować'
                local textWidth = dxGetTextWidth(text, 1, 'default') * 1.2/scale
                --dxLibary:dxLibary_createWindow(_x, _y, textWidth, 17, true)
                dxLibary:dxLibary_text(text, _x, _y, textWidth + _x, 17 + _y, tocolor(255, 255, 255, a), 1, 'default', 'center', 'center', false, false, false, false, false)
            end
        end
    end
end
