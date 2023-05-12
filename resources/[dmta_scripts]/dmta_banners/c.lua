--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local banner = {}
  
function banner:Load()
    self['banners'] = {
        --['Idlewood stacja wjazd - tablica'] = {pos={1948.48828125,-1778.9702148438,13.546875},rot={0,0,0},dim=0,int=0,txd='images/stacja_wjazd.png',world_texture='streetsign2_256',object_id=3468},
        ['Przed Bankiem'] = {pos={1310.125,-1369.575,16.1},rot={0,0,0},dim=0,int=0,txd='images/banner_diamondbank.png',world_texture='vgsn_scrollsgn',object_id=7313},
        ['przecho-marker/discord'] = {pos={983.12506, -1336.7316, 14.95063},rot={0,0,180},dim=0,int=0,txd='images/discord.png',world_texture='vgsn_scrollsgn',object_id=7313},
        ['przecho-marker/discord2'] = {pos={989.0007900000001, -1353.8459, 14.279231},rot={0,0,90},dim=0,int=0,txd='images/discord.png',world_texture='vgsn_scrollsgn',object_id=7313},
        ['Salon pojazdów - dach'] = {txd='images/salon_sciana.png',world_texture='concpanel_la'},
        ['Salon pojazdów - sciana'] = {txd='images/salon_sciana.png',world_texture='CJ_SPORTS_WALL',object_id=2395},
        ['Okno'] = {txd='images/okno.png',world_texture='carshowwin2'},
       -- ['Tablica prawko B'] = {pos={2561.8574,-1683.6113,1665.5},rot={0,0,21.5},dim=62,int=1,txd='images/tablica_prawko_b.png',world_texture='nf_blackbrd',object_id=3077},
       -- ['Tablica prawko D'] = {pos={2552.2041,-1708.6235,1665.5},rot={0,0,21.5},dim=62,int=1,txd='images/tablica_prawko_d.png',world_texture='nf_blackbrd',object_id=3077},
       -- ['Tablica prawko C'] = {pos={2561.8574,-1698.3132,1665.5},rot={0,0,21.5},dim=62,int=1,txd='images/tablica_prawko_c.png',world_texture='nf_blackbrd',object_id=3077},
        --['Tablica prawko A'] = {pos={2552.2041,-1665.77,1665.5},rot={0,0,338.5},dim=62,int=1,txd='images/tablica_prawko_a.png',world_texture='nf_blackbrd',object_id=3077},
    }

    for i,v in pairs(self['banners']) do
        local object = false
        
        if v['pos'] then
            object = createObject(v['object_id'], v['pos'][1], v['pos'][2], v['pos'][3], v['rot'][1], v['rot'][2], v['rot'][3])
            setElementDimension(object, v['dim'])
            setElementInterior(object, v['int'])
        end

        local shader = dxCreateShader('shaders/shader.fx')
        local txd = exports['dxLibary']:createTexture(':dmta_banners/'..v['txd'], 'dxt5', false, 'clamp')
        dxSetShaderValue(shader, 'shader', txd)

        if object then
            engineApplyShaderToWorldTexture(shader, v['world_texture'], object)
        else
            engineApplyShaderToWorldTexture(shader, v['world_texture'])
        end
    end
end

addEventHandler('onClientResourceStart', resourceRoot, function()
    banner:Load()
end)