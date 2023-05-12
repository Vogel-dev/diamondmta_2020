--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local db = exports.dmta_base_connect

local logs = {}

function _getElementData(player, data)
    if getElementData(player, data) then
        return getElementData(player, data)
    end
    return 0
end

function logs:Load()
    self['command_fnc'] = function(player) self:Command(player) end
    self['get_logs-fnc'] = function(name,daysback) self:Get(client,name,daysback) end

    addCommandHandler('logs', self['command_fnc'])
    addEvent('GetLogs', true)
    addEventHandler('GetLogs', resourceRoot, self['get_logs-fnc'])
end

function logs:Get(player,name,daysback)
    local logs = {
        transfer = db:query('select * from logs_transfers where date > now() - interval ? day', daysback),
        chat = db:query('select * from logs_chat where date > now() - interval ? day', daysback),
    }

    triggerClientEvent(player, 'GetLogs', resourceRoot, name, (logs[name] or {}))
end

function logs:Command(player)
    if _getElementData(player, 'rank:duty') > 2 then
        triggerClientEvent(player, 'Logs:Gui', resourceRoot, {{name='Logi przelewów',logs='transfer'}, {name='Logi czatu',logs='chat'}})
    end
end

addEventHandler('onResourceStart', resourceRoot, function()
    logs:Load()
end)
