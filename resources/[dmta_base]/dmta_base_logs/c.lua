--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local dxLibary = exports.dxLibary
local editbox = exports.editbox
local noti = exports.dmta_base_notifications

local sw,sh = guiGetScreenSize()
local baseX = 1920
local scale = 1
local minScale = 2
if sw < baseX then
    scale = math.min(minScale, baseX/sw)
end

local logs = {}

function isMouseIn(x, y, w, h)
	if not isCursorShowing() then return end

	local pos = {getCursorPosition()}
	pos[1],pos[2] = (pos[1]*sw),(pos[2]*sh)

	if pos[1] >= x and pos[1] <= (x+w) and pos[2] >= y and pos[2] <= (y+h) then
		return true
	end
	return false
end

function logs:Load()
    self['variables'] = {}
    self['gui'] = false
    self['gui_settings'] = {}
    self['action'] = 'menu'
    self['settings_logs'] = {min_row=1,max_row=9}
    self['selected_search'] = false
    self['search_rows'] = {'nick', 'text', 'date'}
    self['search_clicked'] = false
    self['days_clicked'] = false
    self['days_rows'] = {1, 7, 30, 365}

    self['gui_fnc'] = function(logs) if self['gui'] ~= true then self['variables'] = logs self:ToggleGui(true) else self:ToggleGui(false) end end
    self['render_fnc'] = function() self:Render() end
    self['clicked_fnc'] = function(button, state) self:Clicked(button, state) end
    self['scrollUp_fnc'] = function() self:Scroll('up') end
    self['scrollDown_fnc'] = function() self:Scroll('down') end
    self['get_logs-fnc'] = function(name, logs) self:ChangeGui(name, logs) end

    self['icons'] = {
        back = dxLibary:createTexture(':dmta_base_logs/images/back.png', 'dxt5', false, 'clamp'),
        sort = dxLibary:createTexture(':dmta_base_logs/images/sort.png', 'dxt5', false, 'clamp')
    }

    addEvent('Logs:Gui', true)
    addEventHandler('Logs:Gui', resourceRoot, self['gui_fnc'])

    addEvent('GetLogs', true)
    addEventHandler('GetLogs', resourceRoot, self['get_logs-fnc'])
end

function logs:ToggleGui(boolean)
    if boolean == true then
        addEventHandler('onClientRender', root, self['render_fnc'])
        addEventHandler('onClientClick', root, self['clicked_fnc'])

        bindKey('mouse_wheel_up', 'both', self['scrollUp_fnc'])
        bindKey('mouse_wheel_down', 'both', self['scrollDown_fnc'])

        self['gui'] = true
        self['action'] = 'menu'
        showCursor(true)
    elseif boolean == false then
        removeEventHandler('onClientRender', root, self['render_fnc'])
        removeEventHandler('onClientClick', root, self['clicked_fnc'])

        unbindKey('mouse_wheel_up', 'both', self['scrollUp_fnc'])
        unbindKey('mouse_wheel_down', 'both', self['scrollDown_fnc'])

        self['gui'] = false
        showCursor(false)

        editbox:destroyCustomEditbox('LOGS-SEARCH')
    end
end

function logs:Draw()
  local x = 0
  local visible = 0
  local search_text = editbox:getCustomEditboxText('LOGS-SEARCH') or ''
  for i,v in pairs(self['gui_settings']['logs']) do
      if self['selected_search'] ~= false and string.len(search_text) > 0 then
          if string.find(string.gsub(v[self['selected_search']]:lower(),'#%x%x%x%x%x%x', ''), search_text:lower(), 1, true) then
              visible = visible + 1
              if self['settings_logs']['max_row'] >= i and self['settings_logs']['min_row'] <= i then
                  x = x + 1

                  local sY = 63/scale * x
                  local _sY = 63/scale * (x - 1)

                  dxDrawImage(623/scale - 15/scale, 305/scale + _sY, 675/scale + 20/scale, 58/scale, 'images/rectangle.png', 0, 0, 0, tocolor(27, 27, 27, 235), false)
                  dxLibary:dxLibary_text(v['nick'], 623/scale, 240/scale + sY, 682/scale, 305/scale + sY, tocolor(255, 255, 255, 255), 1.00, 'default', 'left', 'center', false, false, false, false, false)
                  dxLibary:dxLibary_text(v['text'], 800/scale, 240/scale + sY, 1190/scale, 305/scale + sY, tocolor(255, 255, 255, 255), 1.00, 'default', 'left', 'center', false, true, false, false, false)
                  dxLibary:dxLibary_text(string.sub(v['date'], 1, 16), 1221/scale, 240/scale + sY, 1298/scale, 305/scale + sY, tocolor(255, 255, 255, 255), 1.00, 'default', 'right', 'center', false, false, false, false, false)
              end
          end
      else
          visible = visible + 1
          if self['settings_logs']['max_row'] >= i and self['settings_logs']['min_row'] <= i then
              x = x + 1

              local sY = 63/scale * x
              local _sY = 63/scale * (x - 1)

              dxDrawImage(623/scale - 15/scale, 305/scale + _sY, 675/scale + 20/scale, 58/scale, 'images/rectangle.png', 0, 0, 0, tocolor(27, 27, 27, 235), false)
              dxLibary:dxLibary_text(v['nick'], 623/scale, 240/scale + sY, 682/scale, 305/scale + sY, tocolor(255, 255, 255, 255), 1.00, 'default', 'left', 'center', false, false, false, false, false)
              dxLibary:dxLibary_text(v['text'], 800/scale, 240/scale + sY, 1190/scale, 305/scale + sY, tocolor(255, 255, 255, 255), 1.00, 'default', 'left', 'center', false, true, false, false, false)
              dxLibary:dxLibary_text(string.sub(v['date'], 1, 16), 1221/scale, 240/scale + sY, 1298/scale, 305/scale + sY, tocolor(255, 255, 255, 255), 1.00, 'default', 'right', 'center', false, false, false, false, false)
          end
      end
  end
  return visible
end

function logs:Render()
    if self['action'] == 'menu' then
        dxLibary:dxLibary_createWindow(792/scale, 314/scale, 336/scale, 452/scale, false)
        dxLibary:dxLibary_text('#69bcebWybierz logi które chcesz przeglądać:', 802/scale, 324/scale, 1118/scale, 374/scale, tocolor(255, 255, 255, 255), 3, 'default', 'center', 'center', false, false, false, true, false)
        dxLibary:dxLibary_createButton('Zamknij panel', 825/scale, 707/scale, 274/scale, 38/scale, tocolor(255, 255, 255, 255), false)

        for i,v in pairs(self['variables']) do
            local sY = 40/scale * (i - 1)
            dxDrawImage(825/scale, 384/scale + sY, 274/scale, 38/scale, 'images/rectangle.png', 0, 0, 0, tocolor(27, 27, 27, 235), false)
            dxLibary:dxLibary_shadowText(v['name'], 825/scale, 384/scale + sY, 274/scale + 825/scale, 38/scale + 384/scale + sY, tocolor(255, 255, 255, 255), 1.00, 'default', 'center', 'center', false, false, false, false, false)
        end

        dxDrawImage(825/scale, 500/scale, 274/scale, 38/scale, 'images/rectangle.png', 0, 0, 0, tocolor(27, 27, 27, 235), false)
        dxLibary:dxLibary_text((self['days_search'] or 'Wybierz czas do tyłu'), 825/scale, 500/scale, 274/scale + 825/scale, 38/scale + 500/scale, tocolor(255, 255, 255, 255), 1.00, 'default', 'center', 'center', false, false, false, false, false)
        if self['days_clicked'] == true then
            for i,v in pairs(self['days_rows']) do
                local sY = 40/scale * i
                dxDrawImage(830/scale, 500/scale + sY, 264/scale, 38/scale, 'images/rectangle.png', 0, 0, 0, tocolor(27, 27, 27, 235), false)
                dxLibary:dxLibary_text(v, 830/scale, 500/scale + sY, 264/scale + 830/scale, 38/scale + 500/scale + sY, tocolor(255, 255, 255, 255), 1.00, 'default', 'center', 'center', false, false, false, false, false)
            end
        end
    elseif self['action'] == 'logs' then
        dxLibary:dxLibary_createWindow(603/scale, 206/scale, 715/scale, 668/scale, false)
        dxLibary:dxLibary_shadowText('Aktualne przeglądane logi: '..self['gui_settings']['name']..'\nWszystkich zapisanych logów: '..#self['gui_settings']['logs'], 622/scale, 218/scale, 801/scale, 269/scale, tocolor(255, 255, 255, 255), 3, 'default', 'left', 'center', false, false, false, false, false)

        if isMouseIn(1250/scale, 220/scale, 50/scale, 50/scale) then
            dxDrawImage(1250/scale, 220/scale, 50/scale, 50/scale, self['icons']['back'], 0, 0, 0, tocolor(105, 188, 235, 255), false)
        else
            dxDrawImage(1250/scale, 220/scale, 50/scale, 50/scale, self['icons']['back'], 0, 0, 0, tocolor(222, 222, 222, 255), false)
        end

        if isMouseIn(1177/scale, 220/scale, 50/scale, 50/scale) then
            dxDrawImage(1177/scale, 220/scale, 50/scale, 50/scale, self['icons']['sort'], 0, 0, 0, tocolor(105, 188, 235, 255), false)
        else
            dxDrawImage(1177/scale, 220/scale, 50/scale, 50/scale, self['icons']['sort'], 0, 0, 0, tocolor(222, 222, 222, 255), false)
        end

        dxLibary:dxLibary_text('Nick', 623/scale, 275/scale, 682/scale, 305/scale, tocolor(255, 255, 255, 255), 1.00, 'default', 'left', 'center', false, false, false, false, false)
        dxLibary:dxLibary_text('Text', 800/scale, 275/scale, 1216/scale, 305/scale, tocolor(255, 255, 255, 255), 1.00, 'default', 'left', 'center', false, false, false, false, false)
        dxLibary:dxLibary_text('Data', 1221/scale, 275/scale, 1298/scale, 305/scale, tocolor(255, 255, 255, 255), 1.00, 'default', 'right', 'center', false, false, false, false, false)

        local x = self:Draw()
        if x > 10 then
    		local r = 70/scale * 8
            dxDrawRectangle(1309/scale, 305/scale, 3/scale, r, tocolor(30, 30, 30, 235), false)
            dxDrawRectangle(1309/scale, (305/scale + r / x * (self['settings_logs']['min_row']-1)), 3/scale, (r / x * 9), tocolor(105, 188, 235, 235), false)
        end

        dxDrawImage(900/scale, 250/scale, 218/scale, 28/scale, 'images/rectangle.png', 0, 0, 0, tocolor(27, 27, 27, 235), false)
        dxLibary:dxLibary_text((self['selected_search'] or 'Wybierz wyszukiwanie'), 900/scale, 250/scale, 218/scale + 900/scale, 28/scale + 250/scale, tocolor(255, 255, 255, 255), 1.00, 'default', 'center', 'center', false, false, false, false, false)
        if self['search_clicked'] == true then
            for i,v in pairs(self['search_rows']) do
                local sY = 30/scale * i
                dxDrawImage(905/scale, 250/scale + sY, 208/scale, 28/scale, 'images/rectangle.png', 0, 0, 0, tocolor(27, 27, 27, 235), false)
                dxLibary:dxLibary_text(v, 905/scale, 250/scale + sY, 208/scale + 905/scale, 28/scale + 250/scale + sY, tocolor(255, 255, 255, 255), 1.00, 'default', 'center', 'center', false, false, false, false, false)
            end
        end
    end
end

function logs:ChangeGui(name,logs)
    if self.action == 'logs' then return end

    self['gui_settings'] = {name=name,logs=logs}
    self['action'] = 'logs'
    self['selected_search'] = false
    self['search_clicked'] = false

    editbox:createCustomEditbox('LOGS-SEARCH', 'Wyszukaj...', 900/scale, 210/scale, 218/scale, 28/scale, false, '', true)
end

function logs:Scroll(keyState)
    if keyState == 'up' and self['action'] == 'logs' then
        if self['settings_logs']['min_row'] ~= 1 then
            self['settings_logs']['min_row'] = self['settings_logs']['min_row'] - 1
            self['settings_logs']['max_row'] = self['settings_logs']['max_row'] - 1
        end
    elseif keyState == 'down' and self['action'] == 'logs' then
        if ((#self['gui_settings']['logs'] >= self['settings_logs']['max_row'] and self['settings_logs']['max_row']) or #self['gui_settings']['logs']) ~= #self['gui_settings']['logs'] then
            self['settings_logs']['min_row'] = self['settings_logs']['min_row'] + 1
            self['settings_logs']['max_row'] = self['settings_logs']['max_row'] + 1
        end
    end
end

function randomSort(a, b)
    local rnd = math.random(0,1)
    return rnd == 0 and true or rnd == 1 and false
end

function logs:Clicked(button, state)
    if button ~= 'left' or state ~= 'down' then return end

    if self['action'] == 'menu' then
        if isMouseIn(825/scale, 707/scale, 274/scale, 38/scale) then
            removeEventHandler('onClientRender', root, self['render_fnc'])
            removeEventHandler('onClientClick', root, self['clicked_fnc'])

            unbindKey('mouse_wheel_up', 'both', self['scrollUp_fnc'])
            unbindKey('mouse_wheel_down', 'both', self['scrollDown_fnc'])

            self['gui'] = false
            self['settings_logs'] = {min_row=1,max_row=9}
            showCursor(false)
        elseif isMouseIn(825/scale, 500/scale, 274/scale, 38/scale) then
            self['days_clicked'] = not self['days_clicked']
        end

        if self['days_clicked'] == true then
            for i,v in pairs(self['days_rows']) do
                local sY = 40/scale * i
                if isMouseIn(830/scale, 500/scale + sY, 264/scale, 38/scale) then
                    self['days_search'] = v
                    self['days_clicked'] = false
                end
            end
        end

        for i,v in pairs(self['variables']) do
            local sY = 40/scale * (i - 1)
            if isMouseIn(825/scale, 384/scale + sY, 274/scale, 38/scale) then
                if self['days_search'] then
                    triggerServerEvent('GetLogs', resourceRoot, v['logs'], tonumber(self['days_search']))
                else
                    noti:addNotification('Najpierw wybierz ilość dni.', 'error')
                end
            end
        end
    elseif self['action'] == 'logs' then
        if isMouseIn(1250/scale, 220/scale, 50/scale, 50/scale) then
            self['gui_settings'] = {}
            self['action'] = 'menu'
            editbox:destroyCustomEditbox('LOGS-SEARCH')
        elseif isMouseIn(1177/scale, 220/scale, 50/scale, 50/scale) then
            table.sort(self['gui_settings']['logs'], randomSort)
        elseif isMouseIn(900/scale, 250/scale, 218/scale, 28/scale) then
            self['search_clicked'] = not self['search_clicked']
        end

        for i,v in pairs(self['search_rows']) do
            local sY = 30/scale * i
            if isMouseIn(905/scale, 250/scale + sY, 208/scale, 28/scale) and self['search_clicked'] == true then
                self['selected_search'] = v
                self['search_clicked'] = false
            end
        end
    end
end

addEventHandler('onClientResourceStart', resourceRoot, function()
    logs:Load()
end)

addEventHandler('onClientResourceStop', resourceRoot, function()
    editbox:destroyCustomEditbox('LOGS-SEARCH')
end)
