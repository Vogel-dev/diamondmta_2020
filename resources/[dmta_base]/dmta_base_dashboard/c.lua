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

local dxLibary = exports['dxLibary']
local editbox = exports['editbox']
local achv = exports['dmta_base_achievements']
local opv = exports['object_preview']
local noti = exports['dmta_base_notifications']
local gridlist = exports['gridlist']

local dashboard = {}

function isMouseIn(x, y, w, h)
    if not isCursorShowing() then return end

    local pos = {getCursorPosition()}
    pos[1],pos[2] = (pos[1]*sw),(pos[2]*sh)

    if pos[1] >= x and pos[1] <= (x+w) and pos[2] >= y and pos[2] <= (y+h) then
        return true
    end
    return false
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

-- dzialy w pomocy
local info = [[
    DOŁĄCZ DO NASZEJ SPOŁECZNOŚCI NA DISCORDZIE: https://discord.gg/ZJzbTaW

Rekrutacje do wszystkich frakcji są OTWARTE! Aby złożyć podanie dołącz na naszego discorda i wejdź w zakładkę podanie-na-SAPD/EMS

Rekrutacja na supportera jest OTWARTA! Aby złożyc podanie dołącza do naszego discorda i wejdź w zakładkę podanie-na-supporta

W razie potrzeby skontaktuj się z nami poprzez e-mail diamondmtacontactt@gmail.com lub pisząc do nas poprzez serwer discord.

Serwer funkcjonuje od dnia 17.12.2019 roku.
]]

local pomoc = [[
    Witaj na serwerze DiamondMTA!

Po dokładnym zapoznaniu się z regulaminem serwera umieszczonym na naszym serwerze Discord pierwsze co powinieneś zrobić to udać się na rynek
(zaznaczony na mapie, na przeciwko komendy) w celu zakupienia żywnośći oraz picia a następnie skierować się do ośrodka szkoleniowego który znajduje się
nieopodal warsztatu mechanicznego by wyrobić prawo jazdy. Teraz należało by zarobić jakieś pieniądze, na naszym serwerze mamy 4 prace dorywcze:
Magazyn, Rybak, Kurier, Dodo. Na samym początku spełniamy wymagania tylko do pracy magazyniera więc udajemy się właśnie tam. Gdy zarobimy już pierwsze pieniądze
wypadało by kupić swoje pierwsze auto, dokonać tego możemy w naszych 3 serwerowych salonach: Cygan, Salon Grotti oraz Salon Złota kierwonica (Salon z podmiankami).
Gdy mamy już własne auto przydało by się zadbać o własne bezpieczeństwo, jeżeli mamy spędzone 30h na serwerze i wolne 25k możemy udać się do urzędu wyrobić licencje na broń, 
a następnie zajechać do naszego sklepu z brońmi i dokonać zakupu.
Serwerowy Discord: https://discord.gg/HN8SSAR
Pojęcia RP:

IC (In Character) - wszystko co dzieje się w grze i dotyczy naszej postaci
OOC (Out of character) - wszystko poza światem gry (chat ooc, discord itp.)
MetaGaming (MG) - wykorzystywanie informacji OOC w grze IC
PowerGaming (PG) - wymuszenie danej akcji na graczu np. /me wali w morde gracz XYZ tak mocno, że aż upada
BunnyHopping (BH) - nierealistyczne skakanie jak królik w grze
DriveBy (DB) - strzelanie z okna kierowcy, jest to zakazane
DriveThru (DT) - strzelanie z okna pasażera
CharacterKill (CK) - uśmiercenie postaci
HelicopterKill (HK) - zabicie kogoś śmigłem helikoptera
RevengeKill (RK) - zabicie kogoś z zemsty najczęściej robione przez MG, pamiętajmy, że po BW nie pamiętamy ostatnich 15 minut
DeathMatch (DM) - atakowanie kogoś bez konkretnego powodu, zamiaru
BanEvading (BE) - uniknięcie bana, poprzez wyjście z serwera podczas interwencji administratora
BattleLog (BL) - wyjście z serwera podczas akcji RP, uniknięcie okradnięcie naszej postaci, wbicia jej BW,CK
VehicleDeathMatch (VDM) - zabicie gracza najczęściej poprzez najechanie go samochodem i czekanie aż wbije mu się BW
AwayFromKeyboard (AFK) - status gracza, który aktualnie nie przebywa przed komputerem, robi coś OOC
FailDriving (FD) - nierealistycznie poruszanie się pojazdem
CopBaiting (CB) - prowokowanie policji do pościgu, zakazane
BrutalWounded (BW) - stan nieprzytomności naszej postaci

/me - chat służący do wyrażania do aktualnie nasza postać robi
/do - chat służący do opisywania aktualnej sytuacji, co nasza postać widzi
]]

local autorzy = [[
    Przywileje dla Konta Diamond:


    - Zarobki w pracach dorywczych powiększone o 50%,
    - Zarobek ze sprzedaży narkotyków zwiększone o 50%,
    - Wypłata z frakcji powiększona o 50%,
    - Tankowanie na stacji paliw tańsze o 75%,
    - Naprawy w warsztacie mechanicznym tańsze o 20%,
    - Dostęp do uprzywilejowanego chatu dla kont diamond,
    - Stopień pragnienia i głodu zmniejsza się dwukrotnie wolniej,
    - Dostęp do wyjątkowych wyglądów postaci,
    - Drukrotnie zwiększona szansa na zdobycie respektu na pracach dorywczych,
    - Dwukrotnie zwiększona premia respektu zdobywanego na pracach dorywczych,
    - Wygrana w kasynie jest zwiększona o 50%,
    - Możliwość wyboru ostatnie pozycji gracza jako miejsca respawn'u podczas logowania na konto,
    - Specjalne wyróżnienie nicku w grze diamentowym kolorem.
    - Wpisy na tweeterze tańsze o 50%.
    - Doświadczenie zdobywane do następnego poziomu jest zwiększone o 50%.

    Aby zrealizować zakup konta diamond, udaj się do zakładki 'Konto Diamond'
]]
--

function dashboard:Load()
    self.premiumList = {
        ['buy'] = {
            {'Diamond 1 dzień', 'Cena: 10 punktów', {days=1,points=10}},
            {'Diamond 3 dni', 'Cena: 30 punktów', {days=3,points=30}},
            {'Diamond 7 dni', 'Cena: 70 punktów', {days=7,points=70}},
            {'Diamond 14 dni', 'Cena: 140 punktów', {days=14,points=140}},
            {'Diamond 30 dni', 'Cena: 300 punktów', {days=30,points=300}},
        },

        ['points'] = {
        {'10 punktów Diamond', 'Cena: 1.23zł', {'1.23zł','71480',10}},
            {'50 punktów Diamond', 'Cena: 4.92zł', {'4.92zł','74480',50}},
            {'100 punktów Diamond', 'Cena: 7.38zł', {'7.38zł','76480',100}},
            {'200 punktów Diamond', 'Cena: 11.07zł', {'11.07zł','79480',200}},
            {'300 punktów Diamond', 'Cena: 17.22zł', {'17.22zł','91400',300}},
        }
    }

    self['render_fnc'] = function() self:Render() end
    self['toggle_fnc'] = function() self:Toggle() end
    self['clicked_fnc'] = function(btn, state) self:Clicked(btn, state) end
    self['awards_list-fnc'] = function(...) self:GetAwards(...) end
    self['scroll_fnc'] = function(...) self:Scroll(...) end

    self['showed'] = false
    self['tick'] = getTickCount()
    self['alpha_tick'] = 500
    self['action'] = 'join'
    self['awards'] = false
    self['selected_spis'] = false
    self['actual_spis'] = false

    self.selected_page = 1
    self.selected_info = 1
    self.selected_help = 1
    self.selected_premium = 1
    self.selected_settings = 1
    self.selected_list = 1
    self.selected_points = false

    self['awards_tick'] = getTickCount()

    self['bank_money'] = 0
    self.mail = ''
    self['pj'] = {0,0,0,0,0,0}

    self['gielda_premium'] = {}

    self['rows'] = 1

    self['object'] = false

    self.row_help = 1

    self['achievementsList'] = achv:getAchievementsList()

    self['images'] = {
        off = dxCreateTexture('images/off.png', 'dxt5', false, 'clamp'),
        on = dxCreateTexture('images/on.png', 'dxt5', false, 'clamp'),

        car = dxCreateTexture('images/car.png', 'dxt5', false, 'clamp'),
        house = dxCreateTexture('images/house.png', 'dxt5', false, 'clamp'),
        mute = dxCreateTexture('images/mute.png', 'dxt5', false, 'clamp'),
        ban = dxCreateTexture('images/ban.png', 'dxt5', false, 'clamp'),
        prawko = dxCreateTexture('images/prawko.png', 'dxt5', false, 'clamp'),

        window = dxCreateTexture('images/window.png', 'dxt5', false, 'clamp'),
        rectangle_window = dxCreateTexture('images/rectangle_window.png', 'dxt5', false, 'clamp'),

        rectangle = dxCreateTexture('images/rectangle.png', 'dxt5', false, 'clamp'),
        arrow = dxCreateTexture('images/arrow.png', 'dxt5', false, 'clamp'),

        icon_stats = dxCreateTexture('images/icons/stats_normal.png', 'dxt5', false, 'clamp'),
        icon_stats_hover = dxCreateTexture('images/icons/stats_hover.png', 'dxt5', false, 'clamp'),
        icon_lists = dxCreateTexture('images/icons/lists_normal.png', 'dxt5', false, 'clamp'),
        icon_lists_hover = dxCreateTexture('images/icons/lists_hover.png', 'dxt5', false, 'clamp'),
        icon_premium = dxCreateTexture('images/icons/premium_normal.png', 'dxt5', false, 'clamp'),
        icon_premium_hover = dxCreateTexture('images/icons/premium_hover.png', 'dxt5', false, 'clamp'),
        icon_settings = dxCreateTexture('images/icons/settings_normal.png', 'dxt5', false, 'clamp'),
        icon_settings_hover = dxCreateTexture('images/icons/settings_hover.png', 'dxt5', false, 'clamp'),
        icon_help = dxCreateTexture('images/icons/help_normal.png', 'dxt5', false, 'clamp'),
        icon_help_hover = dxCreateTexture('images/icons/help_hover.png', 'dxt5', false, 'clamp'),
        icon_achievement = dxCreateTexture('images/icons/achievement_normal.png', 'dxt5', false, 'clamp'),
        icon_achievement_hover = dxCreateTexture('images/icons/achievement_hover.png', 'dxt5', false, 'clamp'),
        icon_info = dxCreateTexture('images/icons/info_normal.png', 'dxt5', false, 'clamp'),
        icon_info_hover = dxCreateTexture('images/icons/info_hover.png', 'dxt5', false, 'clamp'),
        icon_acsettings = dxCreateTexture('images/icons/acsettings_normal.png', 'dxt5', false, 'clamp'),
        icon_acsettings_hover = dxCreateTexture('images/icons/acsettings_hover.png', 'dxt5', false, 'clamp'),
        icon_user = dxCreateTexture('images/icons/user_normal.png', 'dxt5', false, 'clamp'),
        icon_user_hover = dxCreateTexture('images/icons/user_hover.png', 'dxt5', false, 'clamp'),
        icon_shader = dxCreateTexture('images/icons/shader_normal.png', 'dxt5', false, 'clamp'),
        icon_shader_hover = dxCreateTexture('images/icons/shader_hover.png', 'dxt5', false, 'clamp'),
        icon_psell = dxCreateTexture('images/icons/psell_normal.png', 'dxt5', false, 'clamp'),
        icon_psell_hover = dxCreateTexture('images/icons/psell_hover.png'), 'dxt5', false, 'clamp',
        icon_premiumb = dxCreateTexture('images/icons/premiumb_normal.png', 'dxt5', false, 'clamp'),
        icon_premiumb_hover = dxCreateTexture('images/icons/premiumb_hover.png', 'dxt5', false, 'clamp'),
        icon_points = dxCreateTexture('images/icons/points_normal.png', 'dxt5', false, 'clamp'),
        icon_points_hover = dxCreateTexture('images/icons/points_hover.png', 'dxt5', false, 'clamp'),
        icon_punish = dxCreateTexture('images/icons/punish_normal.png', 'dxt5', false, 'clamp'),
        icon_punish_hover = dxCreateTexture('images/icons/punish_hover.png', 'dxt5', false, 'clamp'),
        icon_vehicles = dxCreateTexture('images/icons/vehicles_normal.png', 'dxt5', false, 'clamp'),
        icon_vehicles_hover = dxCreateTexture('images/icons/vehicles_hover.png', 'dxt5', false, 'clamp'),
        icon_houses = dxCreateTexture('images/icons/houses_normal.png', 'dxt5', false, 'clamp'),
        icon_houses_hover = dxCreateTexture('images/icons/houses_hover.png', 'dxt5', false, 'clamp'),
        icon_mandates = dxCreateTexture('images/icons/mandates_normal.png', 'dxt5', false, 'clamp'),
        icon_mandates_hover = dxCreateTexture('images/icons/mandates_hover.png', 'dxt5', false, 'clamp'),
        icon_game = dxCreateTexture('images/icons/game_normal.png', 'dxt5', false, 'clamp'),
        icon_game_hover = dxCreateTexture('images/icons/game_hover.png', 'dxt5', false, 'clamp'),
    }

    bindKey('f1', 'down', self['toggle_fnc'])

    addEvent('playerAwards', true)
    addEventHandler('playerAwards', resourceRoot, self['awards_list-fnc'])
end

local shaders = {
    --[[
    {name='Efekt bloom',state=0,opis='Efekt bloom'},
    {name='Karoseria pojazdów',state=0,opis='Karoseria pojazdów'},
    {name='Lepszy kontrast',state=0,opis='Lepszy kontrast'},
    {name='Większe detale',state=0,opis='Większe detale'},
    {name='Efekt blur',state=0,opis='Efekt blur'},
    {name='Dynamiczna woda',state=0,opis='Dynamiczna woda'},
    --]]
}

local settings = {
    {name='Licznik FPS',state=0,opis='Pokaż liczbę klatek na sekunde'},
    {name='Pokaż HUD',state=1,opis='Pokaż radar, licznik, hud'},
}

function dashboard:MathTime(time)
    return math.floor(time/60)..'h '..time - (math.floor(time/60)*60)..'m'
end

function _getElementData(player, data)
    if getElementData(player, data) then
        return tostring(getElementData(player, data))
    end
    return tostring(0)
end

function getTableRowFromName(table, name)
    for i,v in pairs(table) do
        if v[1] == name then
            return i
        end
    end
    return 1
end

function _getTableRowFromName(table, name)
    for i,v in pairs(table) do
        if v['name'] == name then
            return i
        end
    end
    return 1
end

function dashboard:GetAwards(awards, pj, bank_money, gielda_premium, mail)
    self['awards'] = awards
    self['pj'] = pj
    self['bank_money'] = bank_money
    self.mail = mail
    self['gielda_premium'] = gielda_premium

    if self.selected_page == 4 and self.selected_premium == 3 then
        gridlist:dxLibary_destroyGridlist('DASHBOARD-GIELDA')
        self:CreateGridPremium()
    end
end

function dashboard:CreateGridPremium()
    gridlist:dxLibary_createGridlist('DASHBOARD-GIELDA', {{name='Nick',height=0}, {name='Cena',height=125}, {name='Punkty',height=125}}, 9, 684/scale, 360/scale, 320/scale)
    for i,v in pairs(self['gielda_premium']) do
        gridlist:dxLibary_addGridlistItem('DASHBOARD-GIELDA', {v['nick'], v['cost']..'$', v['points']})
    end
end

local x = 0 -- main
local x2 = -100 -- main
local x_info = -140 -- info

local clicked = false

function scroll_click(btn, state)
    if btn ~= 'left' then return end

    local r = 80/scale * 6
    if isMouseIn(1250/scale, 300/scale, 5/scale, r) and state == 'down' then
        clicked = true
    elseif state == 'up' then
        clicked = false
    end
end

function dashboard:List(table, text0Table, textInfo)
    local a_235 = self.alpha_255 > 235 and 235 or self.alpha_255

    local x_list = 330
    local x_list2 = 300
    local x_list3 = 275

    if #table == 0 then
        dxLibary:dxLibary_text(text0Table, 638/scale + 1, x_list/scale + 1, 1282/scale + 1, 425/scale + x_list/scale + 1, tocolor(0, 0, 0, self['alpha_255']), 6, 'default', 'center', 'center', false, false, false, false, false)
        dxLibary:dxLibary_text(text0Table, 638/scale, x_list/scale, 1282/scale, 425/scale + x_list/scale, tocolor(105, 188, 235, self['alpha_255']), 6, 'default', 'center', 'center', false, false, false, false, false)
    else
        if #table > 6 then
            local r = 80/scale * 6

            dxDrawRectangle(1250/scale, x_list2/scale, 5/scale, r, tocolor(30, 30, 30, a_235), false)

            for i = 6, #table do
                local sY = (r / #table * 6) / 2
                if isMouseIn(0, (x_list2/scale + r / #table * (i - 1)) - sY, sw, (r / #table * 6)) and clicked then
                    self.rows = i - (6 - 1)
                end
            end

            local color = clicked and {0, 125, 255} or {105, 188, 235}
            dxDrawRectangle(1250/scale, (x_list2/scale + r / #table * (self['rows']-1)), 5/scale, (r / #table * 6), tocolor(color[1], color[2], color[3], a_235), false)
        end

        local x = 6 - (#table > 6 and 6 or #table + 2)
        local sY = 80/scale * (x - 2)
        dxLibary:dxLibary_text(textInfo, 689/scale + 1, x_list3/scale + sY + 1, 1234/scale + 1, 298/scale + x_list3/scale + sY + 1, tocolor(0, 0, 0, self['alpha_255']), 8, 'default', 'center', 'center', false, true, false, false, false)     
        dxLibary:dxLibary_text(textInfo, 689/scale, x_list3/scale + sY, 1234/scale, 298/scale + x_list3/scale + sY, tocolor(105, 188, 235, self['alpha_255']), 8, 'default', 'center', 'center', false, true, false, false, false)     

        for i,v in pairs(table) do
            if (self['rows'] + 5) >= i and self['rows'] <= i then
                x = x + 1

                local sY = 80/scale * (x - 1)

                local img = v[1]
                if not isElement(img) then
                    img = self['images'][img]
                end

                if v[4] and not v[4][1] then
                    dxDrawImage(689/scale, x_list2/scale + sY, 542/scale, 75/scale, self['images']['rectangle_window'], 0, 0, 0, tocolor(255, 255, 255, a_235), false)
                    dxDrawImage(705/scale, x_list2/scale + sY + 5/scale, 64/scale, 64/scale, img, 0, 0, 0, tocolor(150, 150, 150, self['alpha_255']), false)

                    dxLibary:dxLibary_text(v[2], 785/scale, x_list2/scale - 365/scale  + sY, 981/scale, 417/scale + sY + x_list2/scale, tocolor(150, 150, 150, self['alpha_255']), 6, 'default', 'left', 'center', false, false, false, false, false)
                    dxLibary:dxLibary_text(v[3], 785/scale, x_list2/scale - 350/scale + sY, 430/scale + 785/scale, 456/scale + sY + x_list2/scale, tocolor(50, 98, 125, self['alpha_255']), 1, 'default', 'left', 'center', false, true, false, false, false)
                else
                    dxDrawImage(689/scale, x_list2/scale + sY, 542/scale, 75/scale, self['images']['window'], 0, 0, 0, tocolor(255, 255, 255, a_235), false)
                    dxDrawImage(705/scale, x_list2/scale + sY + 5/scale, 64/scale, 64/scale, img, 0, 0, 0, tocolor(255, 255, 255, self['alpha_255']), false)

                    dxLibary:dxLibary_text(v[2], 785/scale, x_list2/scale - 365/scale  + sY, 981/scale, 417/scale + sY + x_list2/scale, tocolor(255, 255, 255, self['alpha_255']), 6, 'default', 'left', 'center', false, false, false, false, false)
                    dxLibary:dxLibary_text(v[3], 785/scale, x_list2/scale - 350/scale + sY, 430/scale + 785/scale, 456/scale + sY + x_list2/scale, tocolor(105, 188, 235, self['alpha_255']), 1, 'default', 'left', 'center', false, true, false, false, false)
                end

                if v[4] and v[4][1] then
                    dxLibary:dxLibary_text(v[4][1], 1075/scale, x_list2/scale + 21/scale + sY, 133/scale + 1075/scale, 33/scale + x_list2/scale + 21/scale + sY, tocolor(255, 255, 255, self['alpha_255']), 2, 'default', 'center', 'center', false, false, false, true, false)
                else
                    if v[4] then
                        dxLibary:dxLibary_text(v[4][2], 1075/scale, x_list2/scale + 21/scale + sY, 133/scale + 1075/scale, 33/scale + x_list2/scale + 21/scale + sY, tocolor(150, 150, 150, self['alpha_255']), 2, 'default', 'center', 'center', false, false, false, true, false)
                    end
                end
            end
        end
    end
end

function dashboard:HaveAchievement(name)
    local x = false
    for i,v in pairs(self['actual_spis']) do
        if v[1] == name then
            x = v
            break
        end
    end
    return x
end

function dashboard:GetAchievements()
    local tb = {}
    for i,v in pairs(self['achievementsList']) do
        local have = self:HaveAchievement(v[1])
        if have then
            table.insert(tb, {v[4], v[1], v[2], {'Osiągnięte:\n#69bceb'..have[2]}})
        else
            table.insert(tb, {v[4], v[1], v[2], {false, 'Nie osiągnięte'}})
        end
    end
    return tb
end

local change_login = true
local change_password = false
local change_mail = false
local peda = 0

function dashboard:CreateEdits()
    local xyz = change_mail and {3,2,1} or change_password and {2,1,3} or change_login and {1,3,2}

    local names = {
        {'Wprowadź swój login...', 'Wprowadź nowy login...', 'Potwierdź nowy login...'},
        {'Wprowadź swoje hasło...', 'Wprowadź nowe hasło...', 'Potwierdź nowe hasło...'},
        {'Wprowadź swój e-mail...', 'Wprowadź nowy e-mail...', 'Potwierdź nowy e-mail...'},
    }

    editbox:createCustomEditbox('CHANGE-EDIT1', names[xyz[1]][1], 825/scale, 431/scale, 273/scale, 38/scale, false, '', false, false, true)
    editbox:createCustomEditbox('CHANGE-EDIT2', names[xyz[1]][2], 825/scale, 507/scale, 273/scale, 38/scale, false, '', false, false, true)
    editbox:createCustomEditbox('CHANGE-EDIT3', names[xyz[1]][3], 825/scale, 580/scale, 273/scale, 38/scale, false, '', false, false, true)

    editbox:createCustomEditbox('CHANGE-EDIT7', names[xyz[2]][1], 686/scale, 455/scale, 160/scale, 32/scale, false, '', false, true, true, 1)
    editbox:createCustomEditbox('CHANGE-EDIT8', names[xyz[2]][2], 686/scale, 511/scale, 160/scale, 32/scale, false, '', false, true, true, 1)
    editbox:createCustomEditbox('CHANGE-EDIT9', names[xyz[2]][3], 686/scale, 572/scale, 160/scale, 32/scale, false, '', false, true, true, 1)

    local plus = 393/scale
    editbox:createCustomEditbox('CHANGE-EDIT4', names[xyz[3]][1], 686/scale + plus, 455/scale, 160/scale, 32/scale, false, '', false, true, true, 1)
    editbox:createCustomEditbox('CHANGE-EDIT5', names[xyz[3]][2], 686/scale + plus, 511/scale, 160/scale, 32/scale, false, '', false, true, true, 1)
    editbox:createCustomEditbox('CHANGE-EDIT6', names[xyz[3]][3], 686/scale + plus, 572/scale, 160/scale, 32/scale, false, '', false, true, true, 1)
end

function dashboard:Render()
    if self['action'] == 'join' then
        self['alpha_255'] = interpolateBetween(0, 0, 0, 255, 0, 0, (getTickCount()-self['tick'])/self['alpha_tick'], 'Linear')

        x = math.min(x + 50, 1080)
        x2 = math.min(x2 + 10, 100)

        x_info = math.min(x_info + 10, 50)
    elseif self['action'] == 'quit' then
        self['alpha_255'] = interpolateBetween(255, 0, 0, 0, 0, 0, (getTickCount()-self['tick'])/(self['alpha_tick']/2), 'Linear')

        x = math.max(x - 100, 0)
        x2 = math.max(x2 - 20, -100)

        x_info = math.max(x_info - 20, -140)

        if self['alpha_255'] == 0 then
            removeEventHandler('onClientRender', root, self['render_fnc'])
            removeEventHandler('onClientClick', root, self['clicked_fnc'])

            self['showed'] = false
            self.selected_points = false

            x = 0
            x2 = -100
            x_info = -140

            editbox:destroyCustomEditbox('DASHBOARD-PREMIUMCODE')
            gridlist:dxLibary_destroyGridlist('DASHBOARD-GIELDA')
            editbox:destroyCustomEditbox('DASHBOARD-GIELDA-PUNKTY')
            editbox:destroyCustomEditbox('DASHBOARD-GIELDA-CENA')

            for i = 1,9 do
                editbox:destroyCustomEditbox('CHANGE-EDIT'..i)
            end

            unbindKey('mouse_wheel_up', 'down', self['scroll_fnc'])
            unbindKey('mouse_wheel_down', 'down', self['scroll_fnc'])

            if ped and isElement(ped) then
                destroyElement(ped)
                ped = false
            end

            self.object = false
        end
    end

    local a_255 = self.alpha_255
    local a_200 = self.alpha_255 > 200 and 200 or self.alpha_255

    local img = self.selected_page == 1 and self.images.icon_stats_hover or self.images.icon_stats
    local rgb = self.selected_page == 1 and {105, 188, 235} or {222,222,222}
    local y = -360/scale
    --opv:setProjection(self.object, (sw/2) - 50/scale, 280/scale, 500/scale, 500/scale)
    --opv:setAlpha(ped, self.alpha_255)
    dxDrawRectangle(0, 0, 1920, 1080, tocolor(15, 15, 15, 200), false)
    dxDrawRectangle(0, 0, 300, 1077, tocolor(15, 15, 15, 200), false)

    local a = isMouseIn(x2/scale, (sh / 2) - ((100/scale)/2) + y, 100/scale, 140/scale) and a_200 or a_255
    dxDrawImage(x2/scale, (sh / 2) - ((100/scale)/2) + y, 100/scale, 100/scale, img, 0, 0, 0, tocolor(222, 222, 222, a), false)
    dxLibary:dxLibary_text('Statystyki', x2/scale, (sh / 2) - ((100/scale)/2) + y, 100/scale + x2/scale, 245/scale + (sh / 2) - ((100/scale)/2) + y, tocolor(rgb[1], rgb[2], rgb[3], a), 6, 'default', 'center', 'center', false)

    y = y + 170/scale
    img = self.selected_page == 2 and self.images.icon_settings_hover or self.images.icon_settings
    rgb = self.selected_page == 2 and {105, 188, 235} or {222, 222, 222}

    local a = isMouseIn(x2/scale, (sh / 2) - ((100/scale)/2) + y, 100/scale, 140/scale) and a_200 or a_255
    dxDrawImage(x2/scale, (sh / 2) - ((100/scale)/2) + y, 100/scale, 100/scale, img, 0, 0, 0, tocolor(222, 222, 222, a), false)
    dxLibary:dxLibary_text('Ustawienia', x2/scale, (sh / 2) - ((100/scale)/2) + y, 100/scale + x2/scale, 245/scale + (sh / 2) - ((100/scale)/2) + y, tocolor(rgb[1], rgb[2], rgb[3], a), 6, 'default', 'center', 'center', false)

    y = y + 170/scale
    img = self.selected_page == 3 and self.images.icon_help_hover or self.images.icon_help
    rgb = self.selected_page == 3 and {105, 188, 235} or {222, 222, 222}

    local a = isMouseIn(x2/scale, (sh / 2) - ((100/scale)/2) + y, 100/scale, 140/scale) and a_200 or a_255
    dxDrawImage(x2/scale, (sh / 2) - ((100/scale)/2) + y, 100/scale, 100/scale, img, 0, 0, 0, tocolor(222, 222, 222, a), false)
    dxLibary:dxLibary_text('Pomoc', x2/scale, (sh / 2) - ((100/scale)/2) + y, 100/scale + x2/scale, 245/scale + (sh / 2) - ((100/scale)/2) + y, tocolor(rgb[1], rgb[2], rgb[3], a), 6, 'default', 'center', 'center', false)

    y = y + 170/scale
    img = self.selected_page == 4 and self.images.icon_premiumb_hover or self.images.icon_premiumb
    rgb = self.selected_page == 4 and {105, 188, 235} or {222, 222, 222}

    local a = isMouseIn(x2/scale, (sh / 2) - ((100/scale)/2) + y, 100/scale, 140/scale) and a_200 or a_255
    dxDrawImage(x2/scale, (sh / 2) - ((100/scale)/2) + y, 100/scale, 100/scale, img, 0, 0, 0, tocolor(222, 222, 222, a), false)
    dxLibary:dxLibary_text('Konto Diamond', x2/scale, (sh / 2) - ((100/scale)/2) + y, 100/scale + x2/scale, 245/scale + (sh / 2) - ((100/scale)/2) + y, tocolor(rgb[1], rgb[2], rgb[3], a), 6, 'default', 'center', 'center', false)

    y = y + 170/scale
    img = self.selected_page == 5 and self.images.icon_lists_hover or self.images.icon_lists
    rgb = self.selected_page == 5 and {105, 188, 235} or {222, 222, 222}

    local a = isMouseIn(x2/scale, (sh / 2) - ((100/scale)/2) + y, 100/scale, 140/scale) and a_200 or a_255
    dxDrawImage(x2/scale, (sh / 2) - ((100/scale)/2) + y, 100/scale, 100/scale, img, 0, 0, 0, tocolor(222, 222, 222, a), false)
    dxLibary:dxLibary_text('Spisy', x2/scale, (sh / 2) - ((100/scale)/2) + y, 100/scale + x2/scale, 245/scale + (sh / 2) - ((100/scale)/2) + y, tocolor(rgb[1], rgb[2], rgb[3], a), 6, 'default', 'center', 'center', false)
    
    dxDrawRectangle(300/scale, (sh / 2) - ((x/scale)/2), 2/scale, x/scale, tocolor(105, 188, 235, a_255), false)

    if self.selected_page == 1 then
        local img = self.selected_info == 1 and self.images.icon_user_hover or self.images.icon_user
        local rgb = self.selected_info == 1 and {105, 188, 235} or {222,222,222}
        local y = 125

        local a = isMouseIn((sw / 2) - (((140 + y)/scale)/2), x_info/scale, 100/scale, 140/scale) and a_200 or a_255
        dxDrawImage((sw / 2) - (((140 + y)/scale)/2), x_info/scale, 100/scale, 100/scale, img, 0, 0, 0, tocolor(222, 222, 222, a), false)
        dxLibary:dxLibary_text('Postać', (sw / 2) - (((140 + y)/scale)/2), x_info/scale, 100/scale + (sw / 2) - (((140 + y)/scale)/2), x_info + 250/scale, tocolor(rgb[1], rgb[2], rgb[3], a), 6, 'default', 'center', 'center', false)

        y = y - 340
        img = self.selected_info == 2 and self.images.icon_achievement_hover or self.images.icon_achievement
        rgb = self.selected_info == 2 and {105, 188, 235} or {222, 222, 222}

        local a = isMouseIn((sw / 2) - (((140 + y)/scale)/2), x_info/scale, 100/scale, 140/scale) and a_200 or a_255
        dxDrawImage((sw / 2) - (((140 + y)/scale)/2), x_info/scale, 100/scale, 100/scale, img, 0, 0, 0, tocolor(222, 222, 222, a), false)
        dxLibary:dxLibary_text('Osiągnięcia', (sw / 2) - (((140 + y)/scale)/2), x_info/scale, 100/scale + (sw / 2) - (((140 + y)/scale)/2), x_info + 250/scale, tocolor(rgb[1], rgb[2], rgb[3], a), 6, 'default', 'center', 'center', false)
        
        if self.selected_info == 1 then
            local prawkoA = self['pj'][1]
            local prawkoB = self['pj'][2]
            local prawkoC = self['pj'][3]
            local prawkoL = self['pj'][4]
            local licencjaR = self['pj'][5]
            local licencjaB = self['pj'][6]

            local prawka = {}
            if prawkoA == 1 then table.insert(prawka, '\n- Prawo jazdy kat. A') end
            if prawkoB == 1 then table.insert(prawka, '\n- Prawo jazdy kat. B') end
            if prawkoC == 1 then table.insert(prawka, '\n- Prawo jazdy kat. C') end
            if prawkoL == 1 then table.insert(prawka, '\n- Licencja lotnicza') end
            if licencjaR == 1 then table.insert(prawka, '\n- Karta wędkarska') end
            if licencjaB == 1 then table.insert(prawka, '\n- Licencja na broń') end

            if #prawka > 0 then
                prawka = table.concat(prawka, ', ')
            else
                prawka = 'Brak'
            end

            local organizacja = getElementData(localPlayer, "user:oranga") or 0
    	if organizacja == true then
    		organizacja = "Tak"
    	else
    		organizacja = "Brak"
    	end

            local premium = getElementData(localPlayer, 'user:premiumDate') or 'Nie aktywne'
            local organizacja = getElementData(localPlayer, 'user:idorg') or 'Brak'
            local zarobione = formatMoney(getElementData(localPlayer, 'user:zarobione')) or 'Brak'
            local frakcja = getElementData(localPlayer, 'user:fname') or 'Brak'
            local exp = getElementData(localPlayer, 'user:exp')
            exp = 100-exp
            local text = '- Login konta: #69bceb'..getPlayerName(localPlayer)..'#ffffff\n- Adres mail: #69bceb'..self.mail..'#ffffff\n- Data rejestracji: #69bceb'.._getElementData(localPlayer, 'user:register')..'#ffffff\n- Konto diamond: #69bceb'..premium..'#ffffff\n- Przegrany czas: #69bceb'..self:MathTime(_getElementData(localPlayer, 'user:online'))..'#ffffff\n- Aktualna sesja: #69bceb'..self:MathTime(_getElementData(localPlayer, 'user:sesion_online'))..'#ffffff\n- Aktualny poziom: #69bceb'..getElementData(localPlayer, 'user:level')..'\n#ffffff- Brakujące doświadczenie do następnego poziomu: #69bceb'..exp..'\n#ffffff- Punkty premium: #69bceb'.._getElementData(localPlayer, 'user:premiumPoints')..'#ffffff\n- Respekt: #69bceb'..getElementData(localPlayer, 'user:reputation')..'#ffffff\n- Posiadane uprawnienia: #69bceb'..prawka..'#ffffff\n- Gotówka przy sobie: #69bceb'..formatMoney(getPlayerMoney(localPlayer))..'$#ffffff\n- Gotówka w banku: #69bceb'..formatMoney(self['bank_money'])..'$#ffffff\n- Model postaci: #69bceb'..getElementModel(localPlayer)..'#ffffff\n- Zarobiona gotówka: #69bceb'..zarobione..'#ffffff\n- Przynależność do organizacji (ID): #69bceb'..organizacja..'#ffffff\n- Przynależność do frakcji: #69bceb'..frakcja..'#ffffff\n- Czas na służbie: #69bceb'..self:MathTime(_getElementData(localPlayer, 'user:ftime'))..'#ffffff\n- Sprzedane narkotyki: #69bceb'..getElementData(localPlayer, 'user:sold_drugs')..'\n\n- Posiadane narkotyki: \n#69bceb'..getElementData(localPlayer, 'user:weed1')..' #ffffffsuszu konopnego, #69bceb'..getElementData(localPlayer, 'user:weed2')..' #ffffffpaczek marihuany\n#69bceb'..getElementData(localPlayer, 'user:meth1')..' #ffffffmetyloaminy #69bceb'..getElementData(localPlayer, 'user:meth2')..' #ffffffpaczek metamfetmiany\n#69bceb'..getElementData(localPlayer, 'user:coke1')..' #ffffffliści kokainy #69bceb'..getElementData(localPlayer, 'user:coke2')..' #ffffffpaczek kokainy.'


            dxLibary:dxLibary_text(text, 675/scale, 266/scale, 623/scale + 675/scale, 548/scale + 266/scale, tocolor(255, 255, 255, self['alpha_255']), 4, 'default', 'left', 'center', false, false, false, true, false)
            
            --opv:setProjection(self.object, (sw/2) - 50/scale, 280/scale, 500/scale, 500/scale)
            --opv:setAlpha(ped, self.alpha_255)
        elseif self.selected_info == 2 then
            self['actual_spis'] = self['awards'][4]['table']

            local tb = self:GetAchievements()
            self['actual_spis'] = tb
            self:List(tb, '?', 'Lista osiągnięć:')
        end
    elseif self.selected_page == 2 then
        local img = self.selected_settings == 1 and self.images.icon_game_hover or self.images.icon_game
        local rgb = self.selected_settings == 1 and {105, 188, 235} or {222,222,222}
        local y = 125


        local a = isMouseIn((sw / 2) - (((140 + y)/scale)/2), x_info/scale, 100/scale, 140/scale) and a_200 or a_255
        dxDrawImage((sw / 2) - (((140 + y)/scale)/2), x_info/scale, 100/scale, 100/scale, img, 0, 0, 0, tocolor(222, 222, 222, a), false)
        dxLibary:dxLibary_text('Gra', (sw / 2) - (((140 + y)/scale)/2), x_info/scale, 100/scale + (sw / 2) - (((140 + y)/scale)/2), x_info + 250/scale, tocolor(rgb[1], rgb[2], rgb[3], a), 6, 'default', 'center', 'center', false)

        --y = y - 300     
       -- img = self.selected_settings == 2 and self.images.icon_shader_hover or self.images.icon_shader
       -- rgb = self.selected_settings == 2 and {105, 188, 235} or {222, 222, 222}

       -- local a = isMouseIn((sw / 2) - (((140 + y)/scale)/2), x_info/scale, 100/scale, 140/scale) and a_200 or a_255
       -- dxDrawImage((sw / 2) - (((140 + y)/scale)/2), x_info/scale, 100/scale, 100/scale, img, 0, 0, 0, tocolor(222, 222, 222, a), false)
       -- dxLibary:dxLibary_text('Grafika', (sw / 2) - (((140 + y)/scale)/2), x_info/scale, 100/scale + (sw / 2) - (((140 + y)/scale)/2), x_info + 250/scale, tocolor(rgb[1], rgb[2], rgb[3], a), 6, 'default', 'center', 'center', false)
        
       y = y - 340
        img = self.selected_settings == 3 and self.images.icon_acsettings_hover or self.images.icon_acsettings
        rgb = self.selected_settings == 3 and {105, 188, 235} or {222, 222, 222}

        local a = isMouseIn((sw / 2) - (((140 + y)/scale)/2), x_info/scale, 100/scale, 140/scale) and a_200 or a_255
        dxDrawImage((sw / 2) - (((140 + y)/scale)/2), x_info/scale, 100/scale, 100/scale, img, 0, 0, 0, tocolor(222, 222, 222, a), false)
        dxLibary:dxLibary_text('Konto', (sw / 2) - (((140 + y)/scale)/2), x_info/scale, 100/scale + (sw / 2) - (((140 + y)/scale)/2), x_info + 250/scale, tocolor(rgb[1], rgb[2], rgb[3], a), 6, 'default', 'center', 'center', false)
       
        local a_75 = self.alpha_255 > 75 and 75 or self.alpha_255
        if self.selected_settings == 1 then
            for i,v in pairs(self.settings_acc) do
                local y = 20/scale
                local sY = 90/scale * (i - 4)

                if i < #self.settings_acc then
                    dxDrawImage((sw / 2) - ((500/scale)/2), 618/scale + sY, 500/scale, 3/scale, self.images.rectangle, 0, 0, 0, tocolor(5, 5, 5, a_75), false)
                end

                dxDrawImage(1100/scale, 538/scale + sY + y, 103/scale, 32/scale, v.state == 1 and self.images.on or self.images.off, 0, 0, 0, tocolor(255, 255, 255, self.alpha_255), false)
                
                dxLibary:dxLibary_text(v.name, 710/scale, 524/scale + sY + y, 1145/scale, 556/scale + sY + y, tocolor(105, 188, 235, self.alpha_255), 5, 'default', 'left', 'center', false, false, false, false, false)
                dxLibary:dxLibary_text(v.opis, 710/scale, 575/scale + sY + y, 1145/scale, 556/scale + sY + y, tocolor(255, 255, 255, self.alpha_255), 3, 'default', 'left', 'center', false, false, false, false, false)
            end       
        elseif self.selected_settings == 2 then
            for i,v in pairs(self.date) do
                local y = 20/scale
                local sY = 90/scale * (i - 4)

                if i < #self.date then
                    dxDrawImage((sw / 2) - ((500/scale)/2), 618/scale + sY, 500/scale, 3/scale, self.images.rectangle, 0, 0, 0, tocolor(5, 5, 5, a_75), false)
                end

                dxDrawImage(1100/scale, 538/scale + sY + y, 103/scale, 32/scale, v.state == 1 and self.images.on or self.images.off, 0, 0, 0, tocolor(255, 255, 255, self.alpha_255), false)
                
                dxLibary:dxLibary_text(v.name, 710/scale, 524/scale + sY + y, 1145/scale, 556/scale + sY + y, tocolor(105, 188, 235, self.alpha_255), 5, 'default', 'left', 'center', false, false, false, false, false)
                dxLibary:dxLibary_text(v.opis, 710/scale, 575/scale + sY + y, 1145/scale, 556/scale + sY + y, tocolor(255, 255, 255, self.alpha_255), 3, 'default', 'left', 'center', false, false, false, false, false)
            end
        elseif self.selected_settings == 3 then
            local w, h = 400/scale, 485/scale

            for i = 1,9 do
                editbox:customEditboxSetAlpha('CHANGE-EDIT'..i, self.alpha_255)
            end

            -- last
            dxLibary:dxLibary_createWindowAlpha((sw / 2) - (700/scale / 2), (sh / 2) - (375/scale / 2), w / 1.3, h / 1.3, a_200) -- last
            dxLibary:dxLibary_text(change_mail and 'Zmiana hasła konta' or change_password and 'Zmiana loginu konta' or change_login and 'Zmiana adresu e-mail', 609/scale, 335/scale, 919/scale, 422/scale, tocolor(105, 188, 235, self.alpha_255), 4, 'default', 'center', 'center', false, false, false, false, false)
            dxLibary:dxLibary_createButtonAlpha('Zapisz dane', 686/scale, 660/scale, 160/scale, 32/scale, 1, self.alpha_255)

            local plus = 393/scale
            dxLibary:dxLibary_createWindowAlpha((sw / 2) - (700/scale / 2) + plus, (sh / 2) - (375/scale / 2), w / 1.3, h / 1.3, a_200) -- last
            dxLibary:dxLibary_text(change_login and 'Zmiana hasła konta' or change_password and 'Zmiana adresu e-mail' or change_mail and 'Zmiana loginu konta', 609/scale + plus, 335/scale, 919/scale, 422/scale + plus, tocolor(105, 188, 235, self.alpha_255), 4, 'default', 'center', 'center', false, false, false, false, false)
            dxLibary:dxLibary_createButtonAlpha('Zapisz dane', 686/scale + plus, 660/scale, 160/scale, 32/scale, 1, self.alpha_255)
            --new

            editbox:new_gui({'CHANGE-EDIT4','CHANGE-EDIT5','CHANGE-EDIT6','CHANGE-EDIT7','CHANGE-EDIT8','CHANGE-EDIT9'})

            dxLibary:dxLibary_createWindowAlpha((sw / 2) - (w / 2), (sh / 2) - (h / 2), w, h, self.alpha_255) -- menu
            dxLibary:dxLibary_createWindowAlpha((sw / 2) - (w / 2), (sh / 2) - (h / 2), w, h, self.alpha_255) -- menu

            local text = change_mail and 'Zmiana adresu e-mail' or change_login and 'Zmiana loginu konta' or change_password and 'Zmiana hasła konta'
            dxLibary:dxLibary_text(text, 760/scale, 285/scale, 1160/scale, 362/scale, tocolor(105, 188, 235, self.alpha_255), 6, 'default', 'center', 'center', false, false, false, false, false)
            
            dxLibary:dxLibary_createButtonAlpha('Zapisz dane', 835/scale, 701/scale, 250/scale, 44/scale, 3, self.alpha_255)

            editbox:new_gui({'CHANGE-EDIT1','CHANGE-EDIT2','CHANGE-EDIT3'})

            local color1 = isMouseIn((sw / 2) - 430/scale, (sh / 2) - ((64/scale) / 2), 64/scale, 64/scale) and {105, 188, 235} or {105, 188, 235}
            local color2 = isMouseIn((sw / 2) + 367/scale, (sh / 2) - ((64/scale) / 2), 64/scale, 64/scale) and {105, 188, 235} or {105, 188, 235}
            dxDrawImage((sw / 2) - 430/scale, (sh / 2) - ((64/scale) / 2), 64/scale, 64/scale, self.images.arrow, 180, 0, 0, tocolor(color1[1], color1[2], color1[3], self.alpha_255), false)
            dxDrawImage((sw / 2) + 367/scale, (sh / 2) - ((64/scale) / 2), 64/scale, 64/scale, self.images.arrow, 0, 0, 0, tocolor(color2[1], color2[2], color2[3], self.alpha_255), false)
        end
    elseif self.selected_page == 3 then
        local img = self.selected_help == 1 and self.images.icon_info_hover or self.images.icon_info
        local rgb = self.selected_help == 1 and {105, 188, 235} or {222,222,222}
        local y = 260

        local a = isMouseIn((sw / 2) - (((140 + y)/scale)/2), x_info/scale, 100/scale, 140/scale) and a_200 or a_255
        dxDrawImage((sw / 2) - (((140 + y)/scale)/2), x_info/scale, 100/scale, 100/scale, img, 0, 0, 0, tocolor(222, 222, 222, a), false)
        dxLibary:dxLibary_text('Informacje', (sw / 2) - (((140 + y)/scale)/2), x_info/scale, 100/scale + (sw / 2) - (((140 + y)/scale)/2), x_info + 250/scale, tocolor(rgb[1], rgb[2], rgb[3], a), 6, 'default', 'center', 'center', false)

        y = y - 300     
        img = self.selected_help == 2 and self.images.icon_settings_hover or self.images.icon_settings
        rgb = self.selected_help == 2 and {105, 188, 235} or {222, 222, 222}

        local a = isMouseIn((sw / 2) - (((140 + y)/scale)/2), x_info/scale, 100/scale, 140/scale) and a_200 or a_255
        dxDrawImage((sw / 2) - (((140 + y)/scale)/2), x_info/scale, 100/scale, 100/scale, img, 0, 0, 0, tocolor(222, 222, 222, a), false)
        dxLibary:dxLibary_text('Pomoc', (sw / 2) - (((140 + y)/scale)/2), x_info/scale, 100/scale + (sw / 2) - (((140 + y)/scale)/2), x_info + 250/scale, tocolor(rgb[1], rgb[2], rgb[3], a), 6, 'default', 'center', 'center', false)
        
        y = y - 300
        img = self.selected_help == 3 and self.images.icon_premiumb_hover or self.images.icon_premiumb
        rgb = self.selected_help == 3 and {105, 188, 235} or {222, 222, 222}

        local a = isMouseIn((sw / 2) - (((140 + y)/scale)/2), x_info/scale, 100/scale, 140/scale) and a_200 or a_255
        dxDrawImage((sw / 2) - (((140 + y)/scale)/2), x_info/scale, 100/scale, 100/scale, img, 0, 0, 0, tocolor(222, 222, 222, a), false)
        dxLibary:dxLibary_text('Konto Diamond', (sw / 2) - (((140 + y)/scale)/2), x_info/scale, 100/scale + (sw / 2) - (((140 + y)/scale)/2), x_info + 250/scale, tocolor(rgb[1], rgb[2], rgb[3], a), 6, 'default', 'center', 'center', false)

        local text = self.selected_help == 1 and info or self.selected_help == 2 and pomoc or self.selected_help == 3 and autorzy
        dxLibary:dxLibary_text(text, 0, 329/scale, sw, 752/scale, tocolor(255, 255, 255, self['alpha_255']), 2, 'default', 'center', 'center', false, false, false, true, false)
    elseif self.selected_page == 4 then
        local img = self.selected_premium == 1 and self.images.icon_premiumb_hover or self.images.icon_premiumb
        local rgb = self.selected_premium == 1 and {105, 188, 235} or {222,222,222}
        local y = 260

        local a = isMouseIn((sw / 2) - (((140 + y)/scale)/2), x_info/scale, 100/scale, 140/scale) and a_200 or a_255
        dxDrawImage((sw / 2) - (((140 + y)/scale)/2), x_info/scale, 100/scale, 100/scale, img, 0, 0, 0, tocolor(222, 222, 222, a), false)
        dxLibary:dxLibary_text('Konto Diamond', (sw / 2) - (((140 + y)/scale)/2), x_info/scale, 100/scale + (sw / 2) - (((140 + y)/scale)/2), x_info + 250/scale, tocolor(rgb[1], rgb[2], rgb[3], a), 6, 'default', 'center', 'center', false)

        y = y - 300     
        img = self.selected_premium == 2 and self.images.icon_points_hover or self.images.icon_points
        rgb = self.selected_premium == 2 and {105, 188, 235} or {222, 222, 222}

        local a = isMouseIn((sw / 2) - (((140 + y)/scale)/2), x_info/scale, 100/scale, 140/scale) and a_200 or a_255
        dxDrawImage((sw / 2) - (((140 + y)/scale)/2), x_info/scale, 100/scale, 100/scale, img, 0, 0, 0, tocolor(222, 222, 222, a), false)
        dxLibary:dxLibary_text('Punkty Diamond', (sw / 2) - (((140 + y)/scale)/2), x_info/scale, 100/scale + (sw / 2) - (((140 + y)/scale)/2), x_info + 250/scale, tocolor(rgb[1], rgb[2], rgb[3], a), 6, 'default', 'center', 'center', false)
        
        y = y - 300
        img = self.selected_premium == 3 and self.images.icon_psell_hover or self.images.icon_psell
        rgb = self.selected_premium == 3 and {105, 188, 235} or {222, 222, 222}

        local a = isMouseIn((sw / 2) - (((140 + y)/scale)/2), x_info/scale, 100/scale, 140/scale) and a_200 or a_255
        dxDrawImage((sw / 2) - (((140 + y)/scale)/2), x_info/scale, 100/scale, 100/scale, img, 0, 0, 0, tocolor(222, 222, 222, a), false)
        dxLibary:dxLibary_text('Giełda', (sw / 2) - (((140 + y)/scale)/2), x_info/scale, 100/scale + (sw / 2) - (((140 + y)/scale)/2), x_info + 250/scale, tocolor(rgb[1], rgb[2], rgb[3], a), 6, 'default', 'center', 'center', false)
    
        if self.selected_premium == 1 then
            local y = 340/scale

            for i,v in pairs(self.premiumList['buy']) do
                local sY = 80/scale * (i - 1)

                dxDrawImage(689/scale, 340/scale + sY, 542/scale, 75/scale, self['images']['window'], 0, 0, 0, tocolor(255, 255, 255, self['alpha_255'] > 255 and 235 or self['alpha_255']), false)
                dxDrawImage(705/scale, y + sY + 5/scale, 64/scale, 64/scale, self.images.icon_premiumb, 0, 0, 0, tocolor(255, 255, 255, self['alpha_255']), false)

                dxLibary:dxLibary_text(v[1], 785/scale, y - 365/scale  + sY, 981/scale, 417/scale + sY + y, tocolor(255, 255, 255, self['alpha_255']), 6, 'default', 'left', 'center', false, false, false, false, false)
                dxLibary:dxLibary_text(v[2], 785/scale, y - 350/scale + sY, 981/scale, 456/scale + sY + y, tocolor(105, 188, 235, self['alpha_255']), 1, 'default', 'left', 'center', false, false, false, false, false)

                dxLibary:dxLibary_createButtonAlpha('Zakup usługę', 1075/scale, y + 21/scale + sY, 133/scale, 33/scale, 1, self.alpha_255)
            end
        elseif self.selected_premium == 2 then
            if not self.selected_points then
                local y = 340/scale

                for i,v in pairs(self.premiumList['points']) do
                    local sY = 80/scale * (i - 1)

                    dxDrawImage(689/scale, 340/scale + sY, 542/scale, 75/scale, self['images']['window'], 0, 0, 0, tocolor(255, 255, 255, self['alpha_255'] > 255 and 235 or self['alpha_255']), false)
                    dxDrawImage(705/scale, y + sY + 5/scale, 64/scale, 64/scale, self.images.icon_premiumb, 0, 0, 0, tocolor(255, 255, 255, self['alpha_255']), false)

                    dxLibary:dxLibary_text(v[1], 785/scale, y - 365/scale  + sY, 981/scale, 417/scale + sY + y, tocolor(255, 255, 255, self['alpha_255']), 6, 'default', 'left', 'center', false, false, false, false, false)
                    dxLibary:dxLibary_text(v[2], 785/scale, y - 350/scale + sY, 981/scale, 456/scale + sY + y, tocolor(105, 188, 235, self['alpha_255']), 1, 'default', 'left', 'center', false, false, false, false, false)

                    dxLibary:dxLibary_createButton('Zakup usługę', 1075/scale, y + 21/scale + sY, 133/scale, 33/scale, 1, self.alpha_255)
                end
            else
                local cost = self.selected_points[1]
                local number = self.selected_points[2]
                local points = self.selected_points[3]

                dxLibary:dxLibary_text('Aby zakupić #69bceb'..points..'#ffffff punktów premium - wykonaj poniższą instrukcję.\nWyślij SMS o treści #69bcebMSMS.SMTA#ffffff na numer #69bceb'..number..'#ffffff.\nKoszt SMS wynosi: #69bceb'..cost..'#ffffff wraz z VAT.', 689/scale, 340/scale, 1231/scale, 494/scale, tocolor(255, 255, 255, self.alpha_255), 3, 'default', 'center', 'center', false, false, false, true, false)

                dxLibary:dxLibary_createButtonAlpha('Zakup usługę', 798/scale, 570/scale, 156/scale, 39/scale, 1, self.alpha_255)
                dxLibary:dxLibary_createButtonAlpha('Cofnij', 970/scale, 570/scale, 156/scale, 39/scale, 1, self.alpha_255)

                editbox:customEditboxSetAlpha('DASHBOARD-PREMIUMCODE', self.alpha_255)
            end
        elseif self.selected_premium == 3 then
            local points = getElementData(localPlayer, 'user:premiumPoints') or 0
            local money = formatMoney(getPlayerMoney(localPlayer))
            dxLibary:dxLibary_text('Dostępne punkty: #69bceb'..points..'#ffffff\nDostępna gotówka: #69bceb'..money..'$#ffffff', 1029/scale, 360/scale, 1244/scale, 430/scale, tocolor(255, 255, 255, self['alpha_255']), 2, 'default', 'center', 'center', false, false, false, true, false)
    
            editbox:customEditboxSetAlpha('DASHBOARD-GIELDA-PUNKTY', self['alpha_255'])
            editbox:customEditboxSetAlpha('DASHBOARD-GIELDA-CENA', self['alpha_255'])
    
            gridlist:dxLibary_gridListSetAlpha('DASHBOARD-GIELDA', self['alpha_255'])
    
            local selected = gridlist:dxLibary_gridlistGetSelectedItemText('DASHBOARD-GIELDA', 1) or ''
            local text = selected == getPlayerName(localPlayer) and 'Usuń' or 'Kup'
            dxLibary:dxLibary_createButtonAlpha(text, 1039/scale, 430/scale, 195/scale, 40/scale, 1, self['alpha_255'])
            dxLibary:dxLibary_createButtonAlpha('Wystaw', 1039/scale, 680/scale, 195/scale, 40/scale, 1, self['alpha_255'])
        end
    elseif self.selected_page == 5 then
        local img = self.selected_list == 1 and self.images.icon_punish_hover or self.images.icon_punish
        local rgb = self.selected_list == 1 and {105, 188, 235} or {222,222,222}
        local y = 410

        local a = isMouseIn((sw / 2) - (((140 + y)/scale)/2), x_info/scale, 100/scale, 140/scale) and a_200 or a_255
        dxDrawImage((sw / 2) - (((140 + y)/scale)/2), x_info/scale, 100/scale, 100/scale, img, 0, 0, 0, tocolor(222, 222, 222, a), false)
        dxLibary:dxLibary_text('Kary', (sw / 2) - (((140 + y)/scale)/2), x_info/scale, 100/scale + (sw / 2) - (((140 + y)/scale)/2), x_info + 250/scale, tocolor(rgb[1], rgb[2], rgb[3], a), 6, 'default', 'center', 'center', false)

        y = y - 300     
        img = self.selected_list == 2 and self.images.icon_houses_hover or self.images.icon_houses
        rgb = self.selected_list == 2 and {105, 188, 235} or {222, 222, 222}

        local a = isMouseIn((sw / 2) - (((140 + y)/scale)/2), x_info/scale, 100/scale, 140/scale) and a_200 or a_255
        dxDrawImage((sw / 2) - (((140 + y)/scale)/2), x_info/scale, 100/scale, 100/scale, img, 0, 0, 0, tocolor(222, 222, 222, a), false)
        dxLibary:dxLibary_text('Domki', (sw / 2) - (((140 + y)/scale)/2), x_info/scale, 100/scale + (sw / 2) - (((140 + y)/scale)/2), x_info + 250/scale, tocolor(rgb[1], rgb[2], rgb[3], a), 6, 'default', 'center', 'center', false)
        
        y = y - 300
        img = self.selected_list == 3 and self.images.icon_vehicles_hover or self.images.icon_vehicles
        rgb = self.selected_list == 3 and {105, 188, 235} or {222, 222, 222}

        local a = isMouseIn((sw / 2) - (((140 + y)/scale)/2), x_info/scale, 100/scale, 140/scale) and a_200 or a_255
        dxDrawImage((sw / 2) - (((140 + y)/scale)/2), x_info/scale, 100/scale, 100/scale, img, 0, 0, 0, tocolor(222, 222, 222, a), false)
        dxLibary:dxLibary_text('Pojazdy', (sw / 2) - (((140 + y)/scale)/2), x_info/scale, 100/scale + (sw / 2) - (((140 + y)/scale)/2), x_info + 250/scale, tocolor(rgb[1], rgb[2], rgb[3], a), 6, 'default', 'center', 'center', false)
    
        y = y - 300
        img = self.selected_list == 4 and self.images.icon_mandates_hover or self.images.icon_mandates
        rgb = self.selected_list == 4 and {105, 188, 235} or {222, 222, 222}

        local a = isMouseIn((sw / 2) - (((140 + y)/scale)/2), x_info/scale, 100/scale, 140/scale) and a_200 or a_255
        dxDrawImage((sw / 2) - (((140 + y)/scale)/2), x_info/scale, 100/scale, 100/scale, img, 0, 0, 0, tocolor(222, 222, 222, a), false)
        dxLibary:dxLibary_text('Mandaty', (sw / 2) - (((140 + y)/scale)/2), x_info/scale, 100/scale + (sw / 2) - (((140 + y)/scale)/2), x_info + 250/scale, tocolor(rgb[1], rgb[2], rgb[3], a), 6, 'default', 'center', 'center', false)
    
        if self.selected_list == 3 then
            self:List(self['awards'][3]['table'], 'Nie posiadasz żadnych pojazdów.', 'Lista twoich pojazdów:')
        elseif self.selected_list == 2 then
            self:List(self['awards'][2]['table'], 'Nie posiadasz żadnych nieruchomości.', 'Lista twoich nieruchomości:')
        elseif self.selected_list == 1 then
            self:List(self['awards'][1]['table'], 'Nie posiadasz żadnych kar.', 'Lista twoich kar:')
        elseif self.selected_list == 4 then
            self:List(self['awards'][5]['table'], 'Nie posiadasz żadnych mandatów.', 'Lista twoich mandatów:')
        else
            self['actual_spis'] = false
        end
    end
end

function dashboard:Toggle()
    if self['showed'] == true then
        if (getTickCount()-self['tick']) >= self['alpha_tick'] then
            self['tick'] = getTickCount()
            self['action'] = 'quit'
            
            showCursor(false)
            --setElementData(localPlayer, 'player:blackwhite', false)
            setElementData(localPlayer, 'pokaz:hud', true)
            showPlayerHudComponent('radar', true)
            showChat(true)
            removeEventHandler('onClientClick', root, scroll_click)
        end
    else
        if not getElementData(localPlayer, 'user:logged') or not getElementData(localPlayer, 'pokaz:hud') then return end

        addEventHandler('onClientRender', root, self['render_fnc'])
        addEventHandler('onClientClick', root, self['clicked_fnc'])
        addEventHandler('onClientClick', root, scroll_click)

        self['showed'] = true
        showChat(false)
        showCursor(true)
        setElementData(localPlayer, 'pokaz:hud', false)
        showPlayerHudComponent('radar', false)
        --setElementData(localPlayer, 'player:blackwhite', true)
        self['tick'] = getTickCount()
        self['action'] = 'join'

        self.selected_points = false

        local search = {
            function(name, data)
                local is = false
                for i,v in pairs(data) do
                    if v['name'] == name then
                        is = v['state']
                        break
                    end
                end
                return is
            end
        }

        local date = getElementData(localPlayer, 'shaders') or {}
        for i,v in pairs(shaders) do
            local ss = search[1](v['name'], date)
            if ss then
                v['state'] = ss
            end
        end

        local dates = getElementData(localPlayer, 'settings') or {}
        for i,v in pairs(settings) do
            local ss = search[1](v['name'], dates)
            if ss then
                v['state'] = ss
            end
        end

        self['date'] = shaders
        self['settings_acc'] = settings

        if self['selected_page'] == 1 and self.selected_info == 1 then
            self:CreatePed()
        end

        if not self['awards'] or (getTickCount()-self['awards_tick']) > 15000 then
            triggerServerEvent('getPlayerAwards', resourceRoot)
            self['awards_tick'] = getTickCount()
        end

        if self.selected_page == 4 and self.selected_premium == 3 then
            self:CreateGridPremium()
            editbox:createCustomEditbox('DASHBOARD-GIELDA-PUNKTY', 'Wprowadź punkty...', 1039/scale, 625/scale, 195/scale, 30/scale, false, '')
            editbox:createCustomEditbox('DASHBOARD-GIELDA-CENA', 'Wprowadź cene...', 1039/scale, 570/scale, 195/scale, 30/scale, false, '')
        elseif self.selected_page == 2 and self.selected_settings == 3 then
            for i = 1,9 do
                editbox:destroyCustomEditbox('CHANGE-EDIT'..i)
            end

            self:CreateEdits()
        end

        bindKey('mouse_wheel_up', 'down', self['scroll_fnc'])
        bindKey('mouse_wheel_down', 'down', self['scroll_fnc'])
    end
end

function dashboard:Scroll(key, keyState)
    if self.selected_page == 5 or (self.selected_page == 1 and self.selected_info == 2) then
        if key == 'mouse_wheel_up' then
            self.rows = math.max(self.rows - 1, 1)
        elseif key == 'mouse_wheel_down' then
            self.rows = math.min(self.rows + 1, (#self.actual_spis - 5))
        end
    elseif self.selected_page == 3 then
        if key == 'mouse_wheel_up' then
            self.row_help = math.max(self.row_help - 1, 1)
        elseif key == 'mouse_wheel_down' then
            local max = split(self.selected_help[2], '\n') or {}
            self.row_help = math.min(self.row_help + 1, (#max - 15))
        end
    end
end

function dashboard:CreatePed()
    ped = createPed(0, 0, 0, 0)
    setElementDimension(ped, 9696)

    self['object'] = opv:createObjectPreview(ped, 0, 0, 180, (sw/2) - 50/scale, (sh/2) - ((500/scale)/2), 500/scale, 500/scale, false, true, true)
    setElementModel(ped, getElementModel(localPlayer))
end

function dashboard:Complete()
    if self.selected_page == 1 and self.selected_info == 1 then
        if ped and isElement(ped) then
            destroyElement(ped)
            ped = false
        end

        self.object = false
    elseif self.selected_page == 2 and self.selected_settings == 3 then
        for i = 1,9 do
            editbox:destroyCustomEditbox('CHANGE-EDIT'..i)
        end
    elseif self.selected_page == 4 and self.selected_premium == 3 then
        gridlist:dxLibary_destroyGridlist('DASHBOARD-GIELDA')
        editbox:destroyCustomEditbox('DASHBOARD-GIELDA-PUNKTY')
        editbox:destroyCustomEditbox('DASHBOARD-GIELDA-CENA')
    end
end

function dashboard:Clicked(btn, state)
    if btn ~= 'left' or state ~= 'down' then return end

    if(self.selected_page == 3)then
        local y = 260
        if isMouseIn((sw / 2) - (((140 + y)/scale)/2), x_info/scale, 100/scale, 140/scale) then
            self.selected_help = 1
        elseif isMouseIn((sw / 2) - (((140 + y - 300)/scale)/2), x_info/scale, 100/scale, 140/scale) then
            self.selected_help = 2
        elseif isMouseIn((sw / 2) - (((140 + y - 600)/scale)/2), x_info/scale, 100/scale, 140/scale) then
            self.selected_help = 3
        end
    end

    if isMouseIn(100/scale, (sh / 2) - ((100/scale)/2) + (-360/scale), 100/scale, 140/scale) and self.selected_page ~= 1 then
        self:Complete()

        self.selected_page = 1

        if self.selected_info == 1 then
            self:CreatePed()
        end
    elseif isMouseIn(100/scale, (sh / 2) - ((100/scale)/2) + ((-360/scale) + (170/scale)), 100/scale, 140/scale) and self.selected_page ~= 2 then
        self:Complete()
        self.selected_page = 2

        if self.selected_settings == 3 then
            self:CreateEdits()
        end
    elseif isMouseIn(100/scale, (sh / 2) - ((100/scale)/2) + ((-360/scale) + ((170/scale) * 2)), 100/scale, 140/scale) and self.selected_page ~= 3 then
        self:Complete()
        self.selected_page = 3
    elseif isMouseIn(100/scale, (sh / 2) - ((100/scale)/2) + ((-360/scale) + ((170/scale) * 3)), 100/scale, 140/scale) and self.selected_page ~= 4 then
        self:Complete()
        self.selected_page = 4

        if self.selected_premium == 3 then
            self:CreateGridPremium()
            editbox:createCustomEditbox('DASHBOARD-GIELDA-PUNKTY', 'Wprowadź punkty...', 1039/scale, 625/scale, 195/scale, 30/scale, false, '')
            editbox:createCustomEditbox('DASHBOARD-GIELDA-CENA', 'Wprowadź cene...', 1039/scale, 570/scale, 195/scale, 30/scale, false, '')
        end
    elseif isMouseIn(100/scale, (sh / 2) - ((100/scale)/2) + ((-360/scale) + ((170/scale) * 4)), 100/scale, 140/scale) and self.selected_page ~= 5 then
        self:Complete()
        self.selected_page = 5
    elseif isMouseIn((sw / 2) - (((140 + 125)/scale)/2), 50/scale, 100/scale, 140/scale) and self.selected_page == 1 and self.selected_info ~= 1 then
        self.selected_info = 1
        self:CreatePed()
    elseif isMouseIn((sw / 2) - (((140 + 125 - 340)/scale)/2), 50/scale, 100/scale, 140/scale) and self.selected_page == 1 and self.selected_info ~= 2 then
        self:Complete()
        self.selected_info = 2
        self.rows = 1 
    elseif isMouseIn((sw / 2) - (((140 + 125)/scale)/2), 50/scale, 100/scale, 140/scale) and self.selected_page == 2 and self.selected_settings ~= 1 then
        self:Complete()
        self.selected_settings = 1
    --elseif isMouseIn((sw / 2) - (((140 + 260 - 300)/scale)/2), 50/scale, 100/scale, 140/scale) and self.selected_page == 2 and self.selected_settings ~= 2 then
        --self:Complete()
        --self.selected_settings = 2
    elseif isMouseIn((sw / 2) - (((140 + 125 - 340)/scale)/2), 50/scale, 100/scale, 140/scale) and self.selected_page == 2 and self.selected_settings ~= 3 then
        self.selected_settings = 3
        self:CreateEdits()
    elseif isMouseIn((sw / 2) - (((140 + 260)/scale)/2), 50/scale, 100/scale, 140/scale) and self.selected_page == 4 then
        self:Complete()
        self.selected_premium = 1
    elseif isMouseIn((sw / 2) - (((140 + 260 - 300)/scale)/2), 50/scale, 100/scale, 140/scale) and self.selected_page == 4 then
        self:Complete()
        self.selected_premium = 2
    elseif isMouseIn((sw / 2) - (((140 + 260 - 600)/scale)/2), 50/scale, 100/scale, 140/scale) and self.selected_page == 4 and self.selected_premium ~= 3 then
        self.selected_premium = 3

        dashboard:CreateGridPremium()
        editbox:createCustomEditbox('DASHBOARD-GIELDA-PUNKTY', 'Wprowadź punkty...', 1039/scale, 625/scale, 195/scale, 30/scale, false, '')
        editbox:createCustomEditbox('DASHBOARD-GIELDA-CENA', 'Wprowadź cene...', 1039/scale, 570/scale, 195/scale, 30/scale, false, '')
    elseif isMouseIn((sw / 2) - (((140 + 410)/scale)/2), 50/scale, 100/scale, 140/scale) and self.selected_page == 5 then
        self.selected_list = 1
        self.rows = 1
    elseif isMouseIn((sw / 2) - (((140 + 410 - 300)/scale)/2), 50/scale, 100/scale, 140/scale) and self.selected_page == 5 then
        self.selected_list = 2
        self.rows = 1
    elseif isMouseIn((sw / 2) - (((140 + 410 - 600)/scale)/2), 50/scale, 100/scale, 140/scale) and self.selected_page == 5 then
        self.selected_list = 3
        self.rows = 1
    elseif isMouseIn((sw / 2) - (((140 + 410 - 900)/scale)/2), 50/scale, 100/scale, 140/scale) and self.selected_page == 5 then
        self.selected_list = 4      
        self.rows = 1
    end

    if self.selected_page == 2 and self.selected_settings == 1 then
        for i,v in pairs(self.settings_acc) do
            local y = 20/scale
            local sY = 90/scale * (i - 4)
            if isMouseIn(1100/scale, 538/scale + sY + y, 103/scale, 32/scale) then
                v.state = v.state == 1 and 0 or 1
                setElementData(localPlayer, 'settings', self.settings_acc)
            end
        end
    --elseif self.selected_page == 2 and self.selected_settings == 2 then
        --for i,v in pairs(self.date) do
            --local y = 20/scale
            --local sY = 90/scale * (i - 4)
            --if isMouseIn(1100/scale, 538/scale + sY + y, 103/scale, 32/scale) then
               ---- v.state = v.state == 1 and 0 or 1
                --setElementData(localPlayer, 'shaders', self.date)
           --end
        --end
    elseif self.selected_page == 2 and self.selected_settings == 3 then
        if isMouseIn((sw / 2) - 430/scale, (sh / 2) - ((64/scale) / 2), 64/scale, 64/scale) then
            if change_mail then
                change_password = true
                change_mail = false
            elseif change_password then
                change_password = false
                change_login = true
            elseif change_login then
                change_login = false
                change_mail = true
            end

            for i = 1,9 do
                editbox:destroyCustomEditbox('CHANGE-EDIT'..i)
            end

            self:CreateEdits()
        elseif isMouseIn((sw / 2) + 367/scale, (sh / 2) - ((64/scale) / 2), 64/scale, 64/scale) then
            if change_login then
                change_login = false
                change_password = true
            elseif change_password then
                change_password = false
                change_mail = true
            elseif change_mail then
                change_mail = false
                change_login = true
            end

            for i = 1,9 do
                editbox:destroyCustomEditbox('CHANGE-EDIT'..i)
            end

            self:CreateEdits()
        elseif isMouseIn(835/scale, 701/scale, 250/scale, 44/scale) then
            local edit1 = editbox:getCustomEditboxText('CHANGE-EDIT1') or ''
            local edit2 = editbox:getCustomEditboxText('CHANGE-EDIT2') or ''
            local edit3 = editbox:getCustomEditboxText('CHANGE-EDIT3') or ''
            if (edit1:len() < 4 or edit2:len() < 4 or edit3:len() < 4) and change_login then
                noti:addNotification('Login powinien zawierać minimum 4 znaki.', 'error')
            elseif (edit1:len() < 7 or edit2:len() < 7 or edit3:len() < 7) and change_password then
                noti:addNotification('Hasło powinno zawierać minimum 7 znaków.', 'error')
            elseif (edit1:len() < 5 or edit2:len() < 5 or edit3:len() < 5) and change_mail then
                noti:addNotification('Adres e-mail powinien zawierać minimum 5 znaków.', 'error')
            elseif (not string.match(edit1, '[A-Za-z0-9%.%%%+%-]+@[A-Za-z0-9%.%%%+%-]+%.%w%w%w?%w?') or not string.match(edit2, '[A-Za-z0-9%.%%%+%-]+@[A-Za-z0-9%.%%%+%-]+%.%w%w%w?%w?') or not string.match(edit3, '[A-Za-z0-9%.%%%+%-]+@[A-Za-z0-9%.%%%+%-]+%.%w%w%w?%w?')) and change_mail then
                noti:addNotification('Adres e-mail jest nieprawidłowy.', 'error')
            elseif edit2 ~= edit3 then
                local text = change_password and 'Podane hasła nie są takie same.' or change_login and 'Podane loginy nie są takie same.' or change_mail and 'Podane e-maile nie są takie same.'
                noti:addNotification(text, 'error')
            else
                triggerServerEvent('change:date', resourceRoot, {change_login, change_password, change_mail, edit1, edit2})
            end
        end
    elseif self.selected_page == 4 and self.selected_premium == 1 then
        local y = 340/scale

        for i,v in pairs(self.premiumList['buy']) do
            local sY = 80/scale * (i - 1)

            if isMouseIn(1075/scale, y + 21/scale + sY, 133/scale, 33/scale) then
                triggerServerEvent('buy:premium', resourceRoot, v[3])
            end
        end
    elseif self.selected_page == 4 and self.selected_premium == 2 then
        if self.selected_points then
            if isMouseIn(995/scale, 570/scale, 156/scale, 39/scale) then
                self.selected_points = false
                editbox:destroyCustomEditbox('DASHBOARD-PREMIUMCODE')
            elseif isMouseIn(791/scale, 570/scale, 156/scale, 39/scale) then
                local code = editbox:getCustomEditboxText('DASHBOARD-PREMIUMCODE') or ''
                triggerServerEvent('buy:points', resourceRoot, code)
            end
        else
            local y = 340/scale
            for i,v in pairs(self.premiumList['points']) do
                local sY = 80/scale * (i - 1)

                if isMouseIn(1075/scale, y + 21/scale + sY, 133/scale, 33/scale) then
                    self.selected_points = v[3]
                    editbox:createCustomEditbox('DASHBOARD-PREMIUMCODE', 'Wprowadź kod...', 821/scale, 495/scale, 279/scale, 30/scale, false, '')
                end
            end
        end
    elseif self.selected_page == 4 and self.selected_premium == 3 then
        local selected_1 = gridlist:dxLibary_gridlistGetSelectedItemText('DASHBOARD-GIELDA', 1) or ''
        local selected_2 = gridlist:dxLibary_gridlistGetSelectedItemText('DASHBOARD-GIELDA', 2) or ''
        local selected_3 = gridlist:dxLibary_gridlistGetSelectedItemText('DASHBOARD-GIELDA', 3) or ''

        local text_1 = editbox:getCustomEditboxText('DASHBOARD-GIELDA-PUNKTY') or ''
        local text_2 = editbox:getCustomEditboxText('DASHBOARD-GIELDA-CENA') or ''

        local text = selected_1 == getPlayerName(localPlayer) and 'usun' or 'kup'
        if isMouseIn(1039/scale, 430/scale, 195/scale, 40/scale) and selected_1 ~= '' and selected_2 ~= '' and selected_3 ~= '' then
            triggerServerEvent('premium:action', resourceRoot, text, selected_1, selected_2, selected_3)
        elseif isMouseIn(1039/scale, 680/scale, 195/scale, 40/scale) and text_1 ~= '' and text_2 ~= '' then
            triggerServerEvent('premium:action', resourceRoot, 'wystaw', text_1, text_2, true)
        end
    end
end

addEventHandler('onClientResourceStart', resourceRoot, function()
    dashboard:Load()
end)

addEventHandler('onClientResourceStop', resourceRoot, function()
    for i = 1,9 do
        editbox:destroyCustomEditbox('CHANGE-EDIT'..i)
    end

    gridlist:dxLibary_destroyGridlist('DASHBOARD-GIELDA')
    editbox:destroyCustomEditbox('DASHBOARD-GIELDA-PUNKTY')
    editbox:destroyCustomEditbox('DASHBOARD-GIELDA-CENA')

    editbox:destroyCustomEditbox('DASHBOARD-PREMIUMCODE')
end)
