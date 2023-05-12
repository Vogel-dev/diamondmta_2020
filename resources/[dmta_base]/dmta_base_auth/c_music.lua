--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

vlm = 0
sound = false

function volumeMusicP()
    vlm = vlm+0.0075
    setSoundVolume(sound, vlm)

    if vlm >= 1 then
        removeEventHandler('onClientRender', root, volumeMusicP)
    end
end

function volumeMusicM()
    vlm = vlm-0.0075
    setSoundVolume(sound, vlm)
    
    if vlm <= 0 then
        removeEventHandler('onClientRender', root, volumeMusicM)
        destroyElement(sound)
        sound = false
    end
end

function music(msc)
    if msc == true then
        if not sound then
            sound = playSound('sounds/music.mp3', true)
            setSoundVolume(sound, vlm)
        end

        removeEventHandler('onClientRender', root, volumeMusicM)
        addEventHandler('onClientRender', root, volumeMusicP)
    else
        if not sound then
            sound = playSound('sounds/music.mp3', true)
            setSoundVolume(sound, vlm)
        end

        removeEventHandler('onClientRender', root, volumeMusicP)
        addEventHandler('onClientRender', root, volumeMusicM)
    end
end

addEvent('stopMusic', true)
addEventHandler('stopMusic', resourceRoot, function()
  music(false)
end)