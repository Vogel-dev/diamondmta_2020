--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local dxLibary = exports['dxLibary']

local sw,sh = guiGetScreenSize()
local baseX = 1920
local scale = 1
local minScale = 2
if sw < baseX then
    scale = math.min(minScale, baseX/sw)
end

function getTime()
    local real = getRealTime()

    local year = real['year'] + 1900
    local month = real['month'] + 1
    local day = real['monthday']
    local hour = real['hour']
    local minute = real['minute']

    return string.format('%04d', year)..'.'..string.format('%02d', month)..'.'..string.format('%02d', day)..' '..string.format('%02d', hour)..':'..string.format('%02d', minute)
end

local achievements = {}

function achievements:Load()
    self['txd_car'] = dxLibary:createTexture(':dmta_base_achievements/images/car.png')
    self['txd_house'] = dxLibary:createTexture(':dmta_base_achievements/images/house.png')
    self['txd_money'] = dxLibary:createTexture(':dmta_base_achievements/images/money.png')
    self['txd_puszka'] = dxLibary:createTexture(':dmta_base_achievements/images/puszka.png')
    self['txd_fist'] = dxLibary:createTexture(':dmta_base_achievements/images/fist.png')
    self['txd_ciuch'] = dxLibary:createTexture(':dmta_base_achievements/images/ciuch.png')
    self['txd_business'] = dxLibary:createTexture(':dmta_base_achievements/images/business.png')
    self['txd_drugs'] = dxLibary:createTexture(':dmta_base_achievements/images/drugs.png')

    self['list'] = {
        --{'Pierwszy pojazd', 'Zakup swój pierwszy pojazd', 15, self['txd_car']},

        {'Pierwszy wpierdol', 'Po raz pierwszy obskocz wpierdol.', 1, self['txd_fist']},
        {'Ubierz się człowieku', 'Zmień swój styl ubioru.', 1, self['txd_ciuch']},
        {'Pierwszy wóz', 'Zakup swój pierwszy pojazd.', 1, self['txd_car']},
        {'Własne lokum', 'Wynajmij swoją pierwszą posesje.', 1, self['txd_house']},
        {'Biznesmen', 'Kup swój pierwszy biznes.', 1, self['txd_business']},
        {'Pierwsze pieniądze', 'Zdobądź pierwsze 5,000$', 1, self['txd_money']},
        {'Powoli do przodu', 'Zdobądź pierwsze 10,000$', 2, self['txd_money']},
        {'Pomyśl o ochronie', 'Zdobądź pierwsze 100,000$', 3, self['txd_money']},
        {'Biznesmen', 'Zdobądź pierwsze 500,000$', 5, self['txd_money']},
        {'Milioner', 'Zdobądź pierwsze 1,000,000$', 10, self['txd_money']},
        {'Opierdolić sake', 'Sprzedaj gram dowolnego narkotyku', 1, self['txd_drugs']},
        {'Pierwsze kilo', 'Sprzedaj kilo dowolnego narkotyku', 2, self['txd_drugs']},
        {'Baron narkotykowy', 'Sprzedaj tonę dowolnego narkotyku', 5, self['txd_drugs']},
        {'Puszkarz', 'Znajdź ostatnią puszkę tajemniczego napoju.', 1, self['txd_puszka']},
        

        --{'Pierwsza nieruchomość', 'Zakup swoją pierwszą posiadłość', 15, self['txd_house']},
    }

    self['render_fnc'] = function() self:Render() end

    self['text'] = {}
end

function achievements:Render()
    local a,_a = 0,0
    if self['text'][6] == 'join' then
        a,_a = interpolateBetween(0, 0, 0, 235, 255, 0, (getTickCount()-self['text'][5])/1000, 'Linear')
    elseif self['text'][6] == 'quit' then
        a,_a = interpolateBetween(235, 255, 0, 0, 0, 0, (getTickCount()-self['text'][5])/1000, 'Linear')

        if a == 0 and _a == 0 then
            self['text'] = {}
            removeEventHandler('onClientRender', root, self['render_fnc'])
            return
        end
    end

    if (getTickCount()-self['text'][5]) > 10000 then
        self['text'][6] = 'quit'
        self['text'][5] = getTickCount()
    end

    dxLibary:dxLibary_createWindowAlpha(679/scale, 893/scale, 562/scale, 96/scale, a)

    dxDrawImage(720/scale, 903/scale, 80/scale, 80/scale, self['text'][4], 0, 0, 0, tocolor(255, 255, 255, _a), false)

    dxLibary:dxLibary_text('Otrzymujesz osiągnięcie: '..self['text'][1], 786/scale + 1, 910/scale + 1, 1231/scale + 1, 940/scale + 1, tocolor(0, 0, 0, _a), 3, 'default', 'center', 'bottom', false, false, false, true, false)
    dxLibary:dxLibary_text('Otrzymujesz osiągnięcie: #69bceb'..self['text'][1], 786/scale, 910/scale, 1231/scale, 940/scale, tocolor(255, 255, 255, _a), 3, 'default', 'center', 'bottom', false, false, false, true, false)

    dxLibary:dxLibary_text('Otrzymujesz '..self['text'][3]..' punktów doświadczenia', 796/scale + 1, 945/scale + 1, 1225/scale + 1, 989/scale + 1, tocolor(0, 0, 0, _a), 2, 'default', 'center', 'top', false, false, false, true, false)
    dxLibary:dxLibary_text('#939393Otrzymujesz #69bceb'..self['text'][3]..'#939393 poziom postaci w górę.', 796/scale, 945/scale, 1225/scale, 989/scale, tocolor(255, 255, 255, _a), 2, 'default', 'center', 'top', false, false, false, true, false)
end

function achievements:IsAchievementThere(name)
    local x = false
    for i,v in ipairs(self['list']) do
        if v[1] == name then
            x = v
            break
        end
    end
    return x
end

function achievements:IsPlayerHaveAchievement(name)
    local list = getElementData(localPlayer, 'user:achievements') or {}
    local have = false
    for i,v in ipairs(list) do
        if v['name'] == name then
            have = true
            break
        end
    end
    return have
end

function achievements:AddPlayerAchievement(name, bonus)
    local list = getElementData(localPlayer, 'user:achievements') or {}
    local points = getElementData(localPlayer, 'user:level') or 1

    table.insert(list, {name=name,date=getTime()})

    setElementData(localPlayer, 'user:achievements', list)
    setElementData(localPlayer, 'user:level', (points + bonus))
end

function achievements:GetAchievement(name)
    local get = self:IsAchievementThere(name)
    if get then
        self['text'] = {name, get[2], get[3], get[4], getTickCount(), 'join'}
        addEventHandler('onClientRender', root, self['render_fnc'])
        achievements:AddPlayerAchievement(name, get[3])
    end
end

function getAchievementsList()
    return achievements['list']
end

addEventHandler('onClientResourceStart', resourceRoot, function()
    achievements:Load()
end)

-- milionerzy

addEventHandler('onClientElementDataChange', root, function(data, oldValue)
    if source ~= localPlayer then return end

    if getElementData(source, 'user:salonachv') and not achievements:IsPlayerHaveAchievement('Pierwszy wóz') then
        achievements:GetAchievement('Pierwszy wóz')
    end

    if getElementData(source, 'user:houseachv') and not achievements:IsPlayerHaveAchievement('Własne lokum') then
        achievements:GetAchievement('Własne lokum')
    end

    if getElementData(source, 'user:sold_drugs') > 0 and not achievements:IsPlayerHaveAchievement('Opierdolić sake') then
        achievements:GetAchievement('Opierdolić sake')
    end

    if getElementData(source, 'user:sold_drugs') > 99 and not achievements:IsPlayerHaveAchievement('Pierwsze kilo') then
        achievements:GetAchievement('Pierwsze kilo')
    end

    if getElementData(source, 'user:sold_drugs') > 999 and not achievements:IsPlayerHaveAchievement('Baron narkotykowy') then
        achievements:GetAchievement('Baron narkotykowy')
    end

    if getElementData(source, 'user:biznesachv') and not achievements:IsPlayerHaveAchievement('Biznesmen') then
        achievements:GetAchievement('Biznesmen')
    end

    if getElementModel(source) ~= 26 and getElementModel(source) ~= 0 and not achievements:IsPlayerHaveAchievement('Ubierz się człowieku') then
        achievements:GetAchievement('Ubierz się człowieku')
    end

    if getElementHealth(source) == 0 and not achievements:IsPlayerHaveAchievement('Pierwszy wpierdol') then
        achievements:GetAchievement('Pierwszy wpierdol')
    end

    if getElementData(source, 'user:justcola') == 1 and not achievements:IsPlayerHaveAchievement('Puszkarz') then
        achievements:GetAchievement('Puszkarz')
    end

    if data == 'user:money' then
        local money = getPlayerMoney(source)
        if money >= 5000 and not achievements:IsPlayerHaveAchievement('Pierwsze pieniądze') then
            achievements:GetAchievement('Pierwsze pieniądze')
	      elseif money >= 10000 and not achievements:IsPlayerHaveAchievement('Powoli do przodu') then
            achievements:GetAchievement('Powoli do przodu')
		    elseif money >= 100000 and not achievements:IsPlayerHaveAchievement('Większe pieniądze') then
            achievements:GetAchievement('Większe pieniądze')
		    elseif money >= 500000 and not achievements:IsPlayerHaveAchievement('Biznesman') then
            achievements:GetAchievement('Biznesman')
		    elseif money >= 1000000 and not achievements:IsPlayerHaveAchievement('Milioner') then
            achievements:GetAchievement('Milioner')
        end
    end
end)
