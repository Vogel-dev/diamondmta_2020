--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local scroll = {}

local sw,sh = guiGetScreenSize()
local zoom = 1
if sw < 1920 then
    zoom = math.min(2, 1920 / sw)
end

local img = {};

function getCenter(x, y)
    x,y = x / zoom, y / zoom
    return (sw / 2) - (x / 2), (sh / 2) - (y / 2)
end

function isMouseInPosition(x, y, w, h)
	if not isCursorShowing() then return end

	local pos = {getCursorPosition()}
	pos[1], pos[2] = (pos[1] * sw), (pos[2] * sh)

	if pos[1] >= x and pos[1] <= (x + w) and pos[2] >= y and pos[2] <= (y + h) then
		return true
	end
	return nil
end

function scroll:load()
    self.render_fnc = function() self:render() end
    self.click_fnc = function(...) self:click(...) end
    self.key_fnc = function(...) self:key(...) end

    self.scrolls = {}
    self.showed = false

    --[[local x,y = getCenter(-700,310)
    self:create("SCROLL1", x, y, 6 / zoom, 50 / zoom, 0, 0, {}, 235 / zoom)
    showCursor(true)]]
end

function scroll:create(name, x, y, w, h, row, showed, tbl, height, a)
    self.scrolls[#self.scrolls] = {name, x, y, w, h, row, showed, tbl, 0, false, height, {}, a or 255}

    if not self.showed then 
        addEventHandler("onClientRender", root, self.render_fnc)
        addEventHandler("onClientClick", root, self.click_fnc)
        addEventHandler("onClientKey", root, self.key_fnc)

        img[1] = dxCreateTexture("img/scroll.png", "argb", false, "clamp");
        img[2] = dxCreateTexture("img/circle.png", "argb", false, "clamp");
    end

    for i,v in pairs(self.scrolls) do
        local max = (v[3] + (v[11] - v[5])) - v[3]
        local row = 0
        for i = v[3], (v[3] + max) do
            local rel = (i - v[3]) /  max
            row = rel * (#v[8] - (v[7]))
            v[12][math.floor(row + 1)] = i
        end
    end

    self.showed = true
end

function scroll:destroy(name)
    for i,v in pairs(self.scrolls) do
        if v[1] == name then
            self.scrolls[i] = nil
            break
        end
    end

    if #self.scrolls < 1 and self.showed then
        removeEventHandler("onClientRender", root, self.render_fnc)
        removeEventHandler("onClientClick", root, self.click_fnc)
        removeEventHandler("onClientKey", root, self.key_fnc)

        for i,v in pairs(img) do
            if(v and isElement(v))then
                destroyElement(v);
            end;
        end;

        self.showed = false
    end
end

function scroll:getPosition(name)
    local row = 0
    for i,v in pairs(self.scrolls) do
        if v[1] == name then
            row = math.abs(v[6])
            break
        end
    end
    return row
end

function scroll:updateTable(name, tbl)
    for i,v in pairs(self.scrolls) do
        if v[1] == name then
            v[8] = tbl

            local max = (v[3] + (v[11] - v[5])) - v[3]
            local row = 0
            for i = v[3], (v[3] + max) do
                local rel = (i - v[3]) /  max
                row = rel * (#v[8] - (v[7]))
                v[12][math.floor(row)] = i
            end
            break
        end
    end
end

function scroll:key(key, press)
    if press then
        if key == "mouse_wheel_up" then
            for i,v in pairs(self.scrolls) do
                if v[6] > 0 then
                    v[6] = v[6] - 1
                    v[9] = v[12][math.floor(v[6])] or 0
                end
            end
        elseif key == "mouse_wheel_down" then
            for i,v in pairs(self.scrolls) do
                if (v[6] + v[7]) < #v[8] then
                    v[6] = v[6] + 1
                    v[9] = v[12][math.floor(v[6])] or 0
                end
            end
        end
    end
end

function scroll:render()
    for i,v in pairs(self.scrolls) do
        if v[9] > v[3] + (v[11] - v[5]) then
            v[9] = v[3] + v[11] - v[5]
        elseif v[9] < v[3] then
            v[9] = v[3]
        end

        dxDrawImage(v[2], v[3], v[4], v[11], img[1], 0, 0, 0, tocolor(255, 255, 255, v[13]), false);
        dxDrawImage(v[2], v[9], v[4], v[5], img[2], 0, 0, 0, tocolor(255, 255, 255, v[13]), false);
    end
end

function dxCreateScroll(...)
    scroll:create(...)
end

function dxDestroyScroll(name)
    scroll:destroy(name)
end

function dxScrollGetPosition(name)
    return scroll:getPosition(name)
end

function dxScrollUpdateTable(...)
    scroll:updateTable(...)
end

function dxScrollSetAlpha(name, alpha)
    for i,v in pairs(scroll.scrolls) do
        if v[1] == name then
            v[13] = alpha;
            break;
        end;
    end;
end;

addEventHandler("onClientResourceStart", resourceRoot, function()
    scroll:load()
end)