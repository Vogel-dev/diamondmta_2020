--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local sw,sh = guiGetScreenSize()
local baseX = 1920
local scale = 1
local minScale = 2
if sw < baseX then
    scale = math.min(minScale, baseX/sw)
end

local ban_info = {
    {
      nick = 'my nickname',
      reason = 'test',
      admin = 'admin',
      date = '02-12-2019',
      first_date = '02-12-2019',
      serial = '458A967818FD718957ADJKDH17598ADS',
      ip = '15.15.15.15',
    }
}

local s_music = false
  
local function gui()
    if s_music then
        dxDrawRectangle(0, 0, 1920, 1080, tocolor(15, 15, 15, 200), false)
        local a = (math.sqrt(getSoundFFTData(s_music, 2048, 2)[1])*256) + 150 or 150
        dxDrawImage((sw/2) - ((400/scale)/2), 200/scale, 400/scale, 400/scale, images['puls'], 0, 0, 0, tocolor(105, 188, 235, a), false)

        local x = math.sin(getTickCount()/500)*1
        dxDrawImage((sw/2) - ((450/scale)/2) + x, 185/scale, 450/scale, 450/scale, images['logo2'], 0, 0, 0, tocolor(255, 255, 255, 255), false)
    end
    
    local text = 'Kara została nałożona na konto: '..ban_info[1]['nick']..'\nKara została nałożona na serial: '..ban_info[1]['serial']..'\nPowód otrzymania kary: '..ban_info[1]['reason']..'\nOsoba nakładająca kare: '..ban_info[1]['admin']..'\nData otrzymania kary: '..ban_info[1]['first_date']..'\nKara będzie trwała do: '..ban_info[1]['date']
    local text2 = 'Kara została nałożona na konto: #929292'..ban_info[1]['nick']..'\n#ffffffKara została nałożona na serial: #929292'..ban_info[1]['serial']..'#ffffff\nPowód otrzymania kary: #929292'..ban_info[1]['reason']..'#ffffff\nOsoba nakładająca kare: #929292'..ban_info[1]['admin']..'#ffffff\nData otrzymania kary: #929292'..ban_info[1]['first_date']..'#ffffff\nKara będzie trwała do: #929292'..ban_info[1]['date']
  
    exports['dxLibary']:dxLibary_text('Zostałeś zbanowany na tym serwerze.\n\n'..text..'\n\nAby ubiegać się o wcześniejsze zdjęcie kary napisz na naszym discordzie:\ndiscord.gg/Kh5gdkm', 0 + 1, 700/scale + 1, sw + 1, 791/scale + 1, tocolor(0, 0, 0, 255), 5, 'default', 'center', 'center', false, false, false, true, false)
    exports['dxLibary']:dxLibary_text('#69bcebZostałeś zbanowany na tym serwerze.#ffffff\n\n'..text2..'\n\nAby ubiegać się o wcześniejsze zdjęcie kary napisz na naszym discordzie:\n#69bcebdiscord.gg/Kh5gdkm', 0, 700/scale, sw, 791/scale, tocolor(255, 255, 255, 255), 5, 'default', 'center', 'center', false, false, false, true, false)
end
  
addEvent('pokaz:bana', true)
addEventHandler('pokaz:bana', resourceRoot, function(q)
    if sound then
        destroyElement(sound)
        sound = false
    end

    s_music = playSound('sounds/music_ban.mp3', true)
    setSoundVolume(s_music, 1)

    addEventHandler('onClientRender', root, gui)
  
    if q then
        ban_info = q
    end
end)