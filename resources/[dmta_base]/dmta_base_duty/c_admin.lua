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

local dxLibary = exports.dxLibary
local editbox = exports.editbox

function formatMoney(money)
    while true do
        money, i = string.gsub(money, '^(-?%d+)(%d%d%d)', '%1,%2')
        if i == 0 then
            break
        end
    end
    return money
  end

function isMouseIn(x, y, w, h)
	if not isCursorShowing() then return end

	local pos = {getCursorPosition()}
	pos[1],pos[2] = (pos[1]*sw),(pos[2]*sh)

	if pos[1] >= x and pos[1] <= (x+w) and pos[2] >= y and pos[2] <= (y+h) then
		return true
	end
	return false
end

class 'admin' 
{
	players = {},
	vehicles = {},
	pages = {'Gracze', 'Pojazdy'},
	showed = nil,
	text = '',
	page = 0,
	value = nil,

	render_fnc = function() admin:render() end,
	clicked_fnc = function(...) admin:click(...) end,

	render_look_fnc = function() admin:renderLook() end,
	clicked_look_fnc = function(...) admin:clickLook(...) end,

	start = function(self, players, vehicles)
		if self.showed then
			self.players = {}
			self.vehicles = {}
			self.showed = nil

			removeEventHandler('onClientRender', root, self.render_fnc)
			removeEventHandler('onClientClick', root, self.clicked_fnc)

			showCursor(false)

			editbox:destroyCustomEditbox('ADMIN-ID')
		else
			self.players = players
			self.vehicles = vehicles
			self.showed = true

			addEventHandler('onClientRender', root, self.render_fnc)
			addEventHandler('onClientClick', root, self.clicked_fnc)

			showCursor(true, false)

			editbox:createCustomEditbox('ADMIN-ID', 'Wprowadź nick/id...', 843/scale, 575/scale, 235/scale, 35/scale, false, '', true)
		end
	end,

	render = function(self)
        dxLibary:dxLibary_createWindow(792/scale, 378/scale, 336/scale, 325/scale, false)
        
        dxLibary:dxLibary_text('#69bcebWybierz typ oraz wprowadź id/nick:', 802/scale, 430/scale, 1118/scale, 374/scale, tocolor(255, 255, 255, 255), 3, 'default', 'center', 'center', false, false, false, true, false)

        for i,v in pairs(self.pages) do
            local sY = 50/scale * (i - 1)
            dxLibary:dxLibary_createButton(v, 825/scale, 430/scale + sY, 274/scale, 45/scale)
        end

        dxLibary:dxLibary_createButton('Zamknij panel', 825/scale, 650/scale, 274/scale, 38/scale, tocolor(255, 255, 255, 255), false)
	end,

	renderLook = function(self)
        dxLibary:dxLibary_createWindow(696/scale, 317/scale, 528/scale, 447/scale, tocolor(0, 0, 0, 222), false)

        dxLibary:dxLibary_text('#69bceb'..self.text, 706/scale, 327/scale, 1214/scale, 378/scale, tocolor(255, 255, 255, 255), 4, 'default', 'center', 'center', false, false, false, true, false)
        
        local text = '?'
		if self.page == 1 then
			local zalogowany = self.value.logged or 0
    	if zalogowany == 1 then
    		zalogowany = "Tak"
    		zalogowany2 = "Tak"
    	else
    		zalogowany = "Nie"
    		zalogowany2 = "Nie"
    	end
			dxLibary:dxLibary_createWindow(792/scale, 378/scale, 336/scale, 325/scale, false)
        	text = 'Zalogowany: '..zalogowany..'\nData rejestracji: '..self.value.registered..'\nOstanie logowanie: '..self.value.lastlogin..'\nEmail: '..self.value.email..'\nIlość gotówki: '..formatMoney(self.value.money)..'\nIlość gotówki w banku: '..formatMoney(self.value.bank_money)..'\nZarobione pieniądze: '..self.value.zarobione..'\nA: '..self.value.prawkoA..', B: '..self.value.prawkoB..', C: '..self.value.prawkoC..', L: '..self.value.prawkoL..', R: '..self.value.licencjaR..', B: '..self.value.licencjaB..'\nRespekt: '..self.value.reputation..'\nDiamond: '..self.value.premium_date..', punkty premium: '..self.value.premium_points..'\nSerial: '..self.value.serial..'\nCzas online: '..self.value.online..'\nFrakcja: '..self.value.faction..', Ranga: '..self.value.frank..', Czas na służbie: '..self.value.ftime..'\nOrganizacja: '..self.value.org..', Ranga: '..self.value.orank..'\nZioło (1): '..self.value.weed1..', Zioło (2): '..self.value.weed2..', Meta (1): '..self.value.meth1..'\nMeta (2): '..self.value.meth2..', Koka (1): '..self.value.coke1..', Koka (2): '..self.value.coke2..''
		elseif self.page == 2 then
			dxLibary:dxLibary_createWindow(792/scale, 378/scale, 336/scale, 325/scale, false)
			text = 'Pojemność silnika: '..self.value.engine..'\nParking strzeżony: '..self.value.parking..'\nGaraż: '..self.value.garage..'\nTuning: '..self.value.tuning..'\nWłaściciel: '..self.value.ownerName..' PID:'..self.value.owner..'\nOrganizacja: '..self.value.organization..'\nPrzebieg: '..self.value.distance..'\nPaliwo: '..self.value.fuel..'/'..self.value.bak..'\nRodzaj silnika: '..self.value.type..'\nNapęd: '..self.value.driveType..'\nOstatnio na parkingu: '..self.value.parking_date..'\nOstatni kierowca: '..self.value.lastDriver..''
        end

        dxLibary:dxLibary_text(text, 716/scale, 388/scale, 1204/scale, 687/scale, tocolor(255, 255, 255, 255), 2, 'default', 'center', 'center', false, true, false, false, false)
        
        dxLibary:dxLibary_createButton('Cofnij', 841/scale, 720/scale, 238/scale, 44/scale, tocolor(255, 255, 255, 255), false)	
    end,

	clickLook = function(self, button, state)
		if button ~= 'left' or state ~= 'down' then return end

		if isMouseIn(841/scale, 720/scale, 238/scale, 44/scale) then
			addEventHandler('onClientRender', root, self.render_fnc)
			addEventHandler('onClientClick', root, self.clicked_fnc)

			removeEventHandler('onClientRender', root, self.render_look_fnc)
			removeEventHandler('onClientClick', root, self.clicked_look_fnc)

			editbox:createCustomEditbox('ADMIN-ID', 'Wprowadź nick/id...', 843/scale, 575/scale, 235/scale, 35/scale, false, '', true)
		end
	end,

	click = function(self, button, state)
		if button ~= 'left' or state ~= 'down' then return end

        for i,v in pairs(self.pages) do
            local sY = 50/scale * (i - 1)
            if isMouseIn(825/scale, 430/scale + sY, 274/scale, 45/scale) then
            	local text = editbox:getCustomEditboxText('ADMIN-ID') or ''
            	if i == 1 then
            		for i,v in pairs(self.players) do
            			if v.login == text then
							removeEventHandler('onClientRender', root, self.render_fnc)
							removeEventHandler('onClientClick', root, self.clicked_fnc)

							addEventHandler('onClientRender', root, self.render_look_fnc)
							addEventHandler('onClientClick', root, self.clicked_look_fnc)

							editbox:destroyCustomEditbox('ADMIN-ID')	

							self.text = 'Informacje o graczu: '..v.login..' / '..v.id	
							self.page = 1
							self.value = v
            			end
            		end
            	elseif i == 2 then
            		for i,v in pairs(self.vehicles) do
            			if v.id == tonumber(text) then
							removeEventHandler('onClientRender', root, self.render_fnc)
							removeEventHandler('onClientClick', root, self.clicked_fnc)

							addEventHandler('onClientRender', root, self.render_look_fnc)
							addEventHandler('onClientClick', root, self.clicked_look_fnc)

							editbox:destroyCustomEditbox('ADMIN-ID')	

							self.text = 'Informacje o pojeździe: '..getVehicleNameFromModel(v.model)..' / '..v.id..''	
							self.page = 2	
							self.value = v	
            			end
            		end
            	end
            end
        end
		
		if isMouseIn(825/scale, 650/scale, 274/scale, 38/scale) then
			self.players = {}
			self.vehicles = {}
			self.showed = nil

			removeEventHandler('onClientRender', root, self.render_fnc)
			removeEventHandler('onClientClick', root, self.clicked_fnc)

			showCursor(false)

			editbox:destroyCustomEditbox('ADMIN-ID')
		end
	end,
}

addEvent('admin:gui', true)
addEventHandler('admin:gui', resourceRoot, function(players, vehicles)
	admin:start(players, vehicles)
end)

addEventHandler('onClientResourceStop', resourceRoot, function()
	editbox:destroyCustomEditbox('ADMIN-ID')
end)