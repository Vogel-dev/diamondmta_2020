--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local anim = exports['dmta_base_anim']
local dxLibary = exports['dxLibary']

local sw,sh = guiGetScreenSize()
local baseX = 1920
local scale = 1
local minScale = 2
if sw < baseX then
    scale = math.min(minScale, baseX/sw)
end

function mth(minutes)
    local h = math.floor(minutes/60)
    local m = minutes - (h*60)
    return {h,m}
end

function formatMoney(money)
    while true do
        money, i = string.gsub(money, '^(-?%d+)(%d%d%d)', '%1,%2')
        if i == 0 then
            break
        end
    end
    return money
  end

local hud = {}

function hud:CreateTextures()
    self['txd_icon-money'] = dxLibary:createTexture(':dmta_base_hud/images/money.png', 'dxt5', false, 'clamp')
    self['txd_icon-clock'] = dxLibary:createTexture(':dmta_base_hud/images/clock.png', 'dxt5', false, 'clamp')
    self['txd_icon-heart'] = dxLibary:createTexture(':dmta_base_hud/images/hp.png', 'dxt5', false, 'clamp')
    self['txd_icon-oxygen'] = dxLibary:createTexture(':dmta_base_hud/images/oxygen.png', 'dxt5', false, 'clamp')
    self['txd_icon-armor'] = dxLibary:createTexture(':dmta_base_hud/images/armor.png', 'dxt5', false, 'clamp')
    self['txd_icon-food'] = dxLibary:createTexture(':dmta_base_hud/images/food.png', 'dxt5', false, 'clamp')
    self['txd_icon-drink'] = dxLibary:createTexture(':dmta_base_hud/images/drink.png', 'dxt5', false, 'clamp')
	self['txd_pasek'] = dxLibary:createTexture(':dmta_base_hud/images/pasek.png', 'dxt5', false, 'clamp')
	self['txd_background'] = dxLibary:createTexture(':dmta_base_hud/images/background.png', 'dxt5', false, 'clamp')
	self['txd_zapelnienie'] = dxLibary:createTexture(':dmta_base_hud/images/zapelnienie.png', 'dxt5', false, 'clamp')

    self['tick'] = getTickCount()
    self['tick_food'] = getTickCount()
    self['font'] = dxCreateFont('fonts/italic.ttf', 25/scale)
    self['font2'] = dxCreateFont('fonts/bold.ttf', 17/scale)

    self['render_fnc'] = function() self:Render() end
end

function hud:FormatHour()
    local t = getRealTime()
    return string.format('%02d', t['hour'])..':'..string.format('%02d', t['minute'])..':'..string.format('%02d', t['second'])
end

local FPS = {tick=getTickCount(),ms=60}
function getMS(ms)
    if getFPS() and (getTickCount() - FPS['tick']) > 500 then
        FPS['tick'] = getTickCount()
        FPS['ms'] = math.floor(1 / ms * 1000)
    end
end
addEventHandler('onClientPreRender', root, getMS)

local showed = false
local myMoney = 0

function getValue(last, now, money)
	return last > now and last - money or last < now and last + money
end

function getMoney()
	local money = getPlayerMoney()
	local value = math.abs(money - myMoney)
	if myMoney ~= money then
		myMoney = value < 100 and getValue(myMoney, money, 1) or value < 1000 and getValue(myMoney, money, 10) or value < 10000 and getValue(myMoney, money, 100) or value < 100000 and getValue(myMoney, money, 1000) or getValue(myMoney, money, 10000)
	end
end

function getFPS()
	local showed = false
	local settings = getElementData(localPlayer, 'settings') or {}
	for i,v in ipairs(settings) do
		if v['name'] == 'Licznik FPS' and v['state'] == 1 then
			showed = true
			break
		end
	end
	return showed
end

function get()
    local settings = getElementData(localPlayer, 'settings') or {}
    local showed = #settings < 1 and true or false
    for i,v in ipairs(settings) do
        if v['name'] == 'Pokaż HUD' and v['state'] == 1 then
            showed = true
            break
        end
    end
    return showed
end

function dxDrawRoundedRectangle(x, y, w, h, borderColor, bgColor, postGUI)
    if (x and y and w and h) then
        if (not borderColor) then
            borderColor = tocolor(0, 0, 0, 50);
        end
       
        if (not bgColor) then
            bgColor = borderColor;
        end
       
        dxDrawRectangle(x, y, w, h, bgColor, postGUI);
       
        dxDrawRectangle(x + 2, y - 1, w - 4, 1, borderColor, postGUI); -- top
        dxDrawRectangle(x + 2, y + h, w - 4, 1, borderColor, postGUI); -- bottom
        dxDrawRectangle(x - 1, y + 2, 1, h - 4, borderColor, postGUI); -- left
        dxDrawRectangle(x + w, y + 2, 1, h - 4, borderColor, postGUI); -- right
    end
end

function hud:Render()
    if getFPS() then
        dxLibary:dxLibary_text(FPS['ms'], 5/scale + 1, 0 + 1, sw + 1, sh + 1, tocolor(0, 0, 0, a), 1, 'default-bold', 'left', 'top', false)
        dxLibary:dxLibary_text(FPS['ms'], 5/scale, 0, sw, sh, tocolor(255, 255, 255, a), 1, 'default-bold', 'left', 'top', false)
    end
    
    if not get() then return end
	--ustalamy kaske
	getMoney()
	--
	
    local a = 255

    local armor = getPedArmor(localPlayer) or 0
    local health = getElementHealth(localPlayer) or 0
    local oxygen = getPedOxygenLevel(localPlayer) or 0
    local food = getElementData(localPlayer, 'user:food') or 0
    local drink = getElementData(localPlayer, 'user:drink') or 0

    local plus = 45/scale
    local x = 10/scale
    local y = 50/scale

    dxDrawRoundedRectangle(10/scale, 1012/scale, 58/scale, 58/scale, tocolor(5, 5, 5, 150), false)
    dxDrawRoundedRectangle(10/scale, 1012/scale, 58/scale, 58/scale* (health/100), tocolor(105, 188, 235, 15), false)
    dxDrawImage(16/scale, 1016/scale, 48/scale, 48/scale, self['txd_icon-heart'], 0, 0, 0, tocolor(255, 255, 255, a), false)
    
    dxDrawRoundedRectangle(10+80/scale, 1012/scale, 58/scale, 58/scale, tocolor(5, 5, 5, 150), false)
    dxDrawRoundedRectangle(10+80/scale, 1012/scale, 58/scale, 58/scale* (food/100), tocolor(105, 188, 235, 15), false)
    dxDrawImage(15+80/scale, 1016/scale, 48/scale, 48/scale, self['txd_icon-food'], 0, 0, 0, tocolor(255, 255, 255, a), false)

    dxDrawRoundedRectangle(10+160/scale, 1012/scale, 58/scale, 58/scale, tocolor(5, 5, 5, 150), false)
    dxDrawRoundedRectangle(10+160/scale, 1012/scale, 58/scale, 58/scale* (drink/100), tocolor(105, 188, 235, 15), false)
    dxDrawImage(15+160/scale, 1016/scale, 48/scale, 48/scale, self['txd_icon-drink'], 0, 0, 0, tocolor(255, 255, 255, a), false)
    if armor > 0 then
        dxDrawRoundedRectangle(10+240/scale, 1012/scale, 58/scale, 58/scale, tocolor(5, 5, 5, 150), false)
        dxDrawRoundedRectangle(10+240/scale, 1012/scale, 58/scale, 58/scale* (armor/100), tocolor(105, 188, 235, 15), false)
        dxDrawImage(15+240/scale, 1016/scale, 48/scale, 48/scale, self['txd_icon-armor'], 0, 0, 0, tocolor(255, 255, 255, a), false)
    end

   -- if isPedInWater(localPlayer) then
       -- dxDrawRoundedRectangle(10+320/scale, 1012/scale, 58/scale, 58/scale, tocolor(5, 5, 5, 150), false)
       -- dxDrawRoundedRectangle(10+320/scale, 1012/scale, 58/scale, 58/scale* (oxygen/100), tocolor(105, 188, 235, 15), false)
       -- dxDrawImage(38+320/scale, 997/scale, 48/scale, 48/scale, self['txd_icon-oxygen'], 0, 0, 0, tocolor(255, 255, 255, a), false)
   -- end
--]]
    --y = y + 30/scale
   -- x = x-25/scale
   --if getElementData(localPlayer, 'user:faction') == 'SAPD' then

    --dxDrawText(formatMoney(myMoney)..' $', 344/scale +1, 1055/scale +1, 50/scale +1, 986/scale +1, tocolor(0, 0, 0, a), 1, self['font'], 'left', 'center', false, false, false, false, false)    
    --dxDrawText('#939393'..formatMoney(myMoney)..'#69bceb $', 344/scale, 1055/scale, 250/scale, 986/scale, tocolor(255, 255, 255, a), 1, self['font'], 'left', 'center', false, false, false, true, false) 
    
  -- else

    dxDrawText(formatMoney(myMoney)..' $', 10/scale +1, 995/scale +1, 250/scale +1, 986/scale +1, tocolor(0, 0, 0, a), 1, self['font'], 'left', 'center', false, false, false, false, false)    
    dxDrawText('#939393'..formatMoney(myMoney)..'#69bceb $', 10/scale, 995/scale, 250/scale, 986/scale, tocolor(255, 255, 255, a), 1, self['font'], 'left', 'center', false, false, false, true, false) 
   --end   

   if getElementData(localPlayer, 'user:job') then
    local job = getElementData(localPlayer, 'user:job') or 'Nie pracujesz'
    dxLibary:dxLibary_text('\nAktualnie pracujesz jako: '..job..'', 0 + 1, 0 + 1, 1920/scale - 5/scale + 1, 1080/scale + 1, tocolor(0, 0, 0, a), 2, 'default', 'right', 'top', false, false, false, true, false)
    dxLibary:dxLibary_text('\nAktualnie pracujesz jako: #666666'..job..'', 0, 0, 1920/scale - 5/scale, 1080/scale, tocolor(150, 150, 150, a), 2, 'default', 'right', 'top', false, false, false, true, false)
    end

    if getElementData(localPlayer, 'user:faction') == 'SAPD' then
        local minuty = getElementData(localPlayer, 'user:ftime') or 0
        dxLibary:dxLibary_text('\nSłużba: San Andreas Police Department\nRanga we frakcji: '..getElementData(localPlayer, 'frakcja:ranga')..'\nCzas na służbie: '..mth(minuty)[1]..'h '..mth(minuty)[2]..'m', 0 + 1, 0 + 1, 1920/scale - 5/scale + 1, 1080/scale + 1, tocolor(0, 0, 0, a), 2, 'default', 'right', 'top', false, false, false, true, false)
        dxLibary:dxLibary_text('\nSłużba: #0038a8San Andreas Police Department\n#969696Ranga we frakcji: #0038a8'..getElementData(localPlayer, 'frakcja:ranga')..'\n#969696Czas na służbie: #666666'..mth(minuty)[1]..'h '..mth(minuty)[2]..'m', 0, 0, 1920/scale - 5/scale, 1080/scale, tocolor(150, 150, 150, a), 2, 'default', 'right', 'top', false, false, false, true, false)
    end

    if getElementData(localPlayer, 'user:faction') == 'EMS' then
        local minuty = getElementData(localPlayer, 'user:ftime') or 0
        dxLibary:dxLibary_text('\nSłużba: Emergency Medical Services\nRanga we frakcji: '..getElementData(localPlayer, 'frakcja:ranga')..'\nCzas na służbie: '..mth(minuty)[1]..'h '..mth(minuty)[2]..'m', 0 + 1, 0 + 1, 1920/scale - 5/scale + 1, 1080/scale + 1, tocolor(0, 0, 0, a), 2, 'default', 'right', 'top', false, false, false, true, false)
        dxLibary:dxLibary_text('\nSłużba: #d40000Emergency Medical Services\n#969696Ranga we frakcji: #d40000'..getElementData(localPlayer, 'frakcja:ranga')..'\n#969696Czas na służbie: #666666'..mth(minuty)[1]..'h '..mth(minuty)[2]..'m', 0, 0, 1920/scale - 5/scale, 1080/scale, tocolor(150, 150, 150, a), 2, 'default', 'right', 'top', false, false, false, true, false)
    end

    local sesja = getElementData(localPlayer, 'user:sesion_online') or 0
    dxLibary:dxLibary_text('DiamondMTA - PID: '..getElementData(localPlayer, 'user:dbid')..' Aktualna sesja: '..mth(sesja)[1]..'h '..mth(sesja)[2]..'m', 0 + 1, 0 + 1, 1920/scale - 5/scale + 1, 1080/scale + 1, tocolor(0, 0, 0, a), 3, 'default', 'right', 'top', false, false, false, true, false)
    dxLibary:dxLibary_text('DiamondMTA - PID: '..getElementData(localPlayer, 'user:dbid')..' Aktualna sesja: #666666'..mth(sesja)[1]..'h '..mth(sesja)[2]..'m', 0, 0, 1920/scale - 5/scale, 1080/scale, tocolor(150, 150, 150, a), 3, 'default', 'right', 'top', false, false, false, true, false)
end

function hud:Show(bool)
    if bool == true and not showed then
        addEventHandler('onClientRender', root, self['render_fnc'])
        showed = true
    elseif bool == false then
        removeEventHandler('onClientRender', root, self['render_fnc'])
        showed = false
    end
end

addEventHandler('onClientResourceStart', resourceRoot, function()
    hud:CreateTextures()

    if getElementData(localPlayer, 'pokaz:hud') then
        hud:Show(true)
        --showPlayerHudComponent('radar', true)
    end
end)

addEventHandler('onClientElementDataChange', root, function(data)
    if data == 'pokaz:hud' then
        data = getElementData(localPlayer, data)
        --showPlayerHudComponent('radar', false)
        hud:Show(data)
    end
end)