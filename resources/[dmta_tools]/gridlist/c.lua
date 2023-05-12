--[[
Skrypt został wykonany przez:
   -Asper (nezymr69@gmail.com).

Na potrzeby serwera:
   -WestRPG (2018).

Jedyne i wyłączone prawo do używania kodu ma serwer WestRPG oraz autor skryptu. (Asper)
]]

local dxLibary = exports.dxLibary

local sw,sh = guiGetScreenSize()
local baseX = 1920
local scale = 1
local minScale = 2
if sw < baseX then
    scale = math.min(minScale, baseX/sw)
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

function isEventHandlerAdded(eventName, rootName, fnc)
  if type(eventName) == 'string' and isElement(rootName) and type(fnc) == 'function' then
    local eventHandlers = getEventHandlers(eventName, rootName)
    if type(eventHandlers) == 'table' and #eventHandlers > 0 then
      for i,v in pairs(eventHandlers) do
        if v == fnc then
          return true
        end
      end
    end
  end
  return false
end

local grids = {}

function dxLibary_createGridlist(name,labeles,max,x,y,w)
	openGui()

	table.insert(grids,
		{
			name=name,
			labeles=labeles,
			labels={},
			selected_min=1,
			selected_max=max,
			max=max,
			x=x,
			y=y,
			w=w,
			alpha=255
		}
	)
end

function openGui()
	if not isEventHandlerAdded('onClientRender', root, gui) then
		addEventHandler('onClientRender', root, gui)
		bindKey('mouse_wheel_down', 'down', scroll_down)
		bindKey('mouse_wheel_up', 'down', scroll_up)
		addEventHandler('onClientClick', root, clicked)
		addEventHandler('onClientC', root, clicked)
		addEventHandler('onClientClick', root, scroll_click)
	end
end

function closeGui()
	if isEventHandlerAdded('onClientRender', root, gui) then
		removeEventHandler('onClientRender', root, gui)
		unbindKey('mouse_wheel_down', 'down', scroll_down)
		unbindKey('mouse_wheel_up', 'down', scroll_up)
		removeEventHandler('onClientClick', root, clicked)
		removeEventHandler('onClientC', root, clicked)
		removeEventHandler('onClientClick', root, scroll_click)
	end
end

function dxLibary_addGridlistItem(name, items)
	for i,v in pairs(grids) do
		if v['name'] == name then
			table.insert(v['labels'], items)
		end
	end
end

function dxLibary_gridListSetAlpha(name, alpha)
	for i,v in pairs(grids) do
		if v['name'] == name then
			v['alpha'] = alpha
			break
		end
	end
end

function dxLibary_getGridListRows(name)
	local rows = 0
	for i,v in pairs(grids) do
		if v['name'] == name then
			rows = #v['labels']
			break
		end
	end
	return rows
end

function dxLibary_destroyGridlist(name)
	for i,v in pairs(grids) do
		if v['name'] == name then
			table.remove(grids, i)
		end
	end
end

function dxLibary_checkSelectedItem(name)
	local selected = false
	for i,v in pairs(grids) do
		if v['name'] == name then
			for i = 1,#v['labels'] do
				if v['labels'][i]['selected'] == true then
					selected = true
					break
				end
			end
			break
		end
	end
	return selected
end

function dxLibary_gridlistGetSelectedItemText(name, row)
	local text = ''
	for i,v in pairs(grids) do
		if v['name'] == name then
			for i = 1,#v['labels'] do
				if v['labels'][i]['selected'] == true then
					text = v['labels'][i][row]
					break
				end
			end
			break
		end
	end
	return text
end

function dxLibary_destroyGridlistItem(name,row)
	local x = 0
	for k,v in pairs(grids) do
		if v['name'] == name and #v['labels'] > 0 then
			x = x + 1

			if v['labels'][row] then
				table.remove(v['labels'], x)

				if x > v['max'] then
					v['selected_min'] = v['selected_min']-1
					v['selected_max'] = v['selected_max']-1
				end
				break
			end
		end
	end
end

function scroll_up()
	if not isEventHandlerAdded('onClientRender', root, gui) then return end

	for _,v in pairs(grids) do
		local r = 39/scale * v['max']
		if isMouseIn(v['x'] - 15/scale, v['y'], v['w'] + 45/scale, r) then
			v['selected_min'] = math.max(v['selected_min'] - 1, 1)
			v['selected_max'] = math.max(v['selected_max'] - 1, v.max)
			break
		end
	end
end

function scroll_down()
  	if not isEventHandlerAdded('onClientRender', root, gui) then return end

	for _,v in pairs(grids) do
		local r = 39/scale * v['max']
		if isMouseIn(v['x'] - 15/scale, v['y'], v['w'] + 45/scale, r) then
			local max = #v.labels < v.selected_max and #v.labels or v.selected_max
			local row = max ~= #v.labels and 1 or 0
			v['selected_min'] = v.selected_min + row
			v['selected_max'] = v.selected_max + row
			break
		end
	end
end

function clicked(btn, state)
	if not isEventHandlerAdded('onClientRender', root, gui) then return end
	if btn ~= 'left' or state ~= 'down' then return end
	local x = 0
	for _,v in pairs(grids) do
		for i = v['selected_min'],v['selected_max'] do
			x = x+1

			local sy = 39/scale * x
			if isMouseIn(v['x']-15/scale, (v['y']-35/scale) + sy, v['w']+30/scale, 37/scale) and v['labels'][i] then
				if v['labels'][i]['selected'] == true then
					v['labels'][i]['selected'] = false
				else
					for k = 1,#v['labels'] do
						v['labels'][k]['selected'] = false
					end
					v['labels'][i]['selected'] = true
				end
				break
			end
		end
	end
end

local click = false

function scroll_click(btn, state)
    if btn ~= 'left' then return end

    for i,v in pairs(grids) do
	    local r = (40/scale * v['max']) - 1/scale
	    if isMouseIn(0, (v['y'] + r / #v['labels'] * (v['selected_min']-1)), sw, (r / #v['labels'] * v['max'])) and state == 'down' then
	        click = true
	    elseif state == 'up' then
	        click = false
	    end
	end
end

function gui()
	if #grids < 1 then
		closeGui()
	end

	for _,v in pairs(grids) do
		local a_255 = v['alpha']
		local a_235 = v['alpha'] > 235 and 235 or v['alpha']
		local a_100 = v['alpha'] > 100 and 100 or v['alpha']
		local a_125 = v['alpha'] > 125 and 125 or v['alpha']

		local height = {}
		for index,k in pairs(v['labeles']) do
			local h = (k['height']/scale) * (index - 1)
			height[index] = k['height']
			dxLibary:dxLibary_text(k['name'], v['x'] + h, v['y']-55/scale, v['w']+v['x'], 37/scale+v['y'], tocolor(255, 255, 255, a_255), 1, 'default', 'left', 'center', false, false, true)
		end

		local r = (40/scale * v['max']) - 1/scale
		dxDrawRectangle(v['x'] - 15/scale, v['y'], v['w'] + 30/scale, r, tocolor(5, 5, 5, a_100), true)

		if #v['labels'] > v['max'] then
			for i = v.max, #v.labels do
				local sY = (r / #v['labels'] * v['max']) / 2
				if isMouseIn(0, (v['y'] + r / #v['labels'] * (i - 1)) - sY, sw, (r / #v['labels'] * v['max'])) and click then
					v.selected_min = i - (v.max - 1)
					v.selected_max = i
				end
			end

			dxDrawRectangle(v['x'] + v['w'] + 20/scale, v['y'], 5/scale, r, tocolor(30, 30, 30, a_235), true)	

			local color = click and {55, 98, 122} or {105, 188, 235}
			dxDrawRectangle(v['x'] + v['w'] + 20/scale, (v['y'] + r / #v['labels'] * (v['selected_min']-1)), 5/scale, (r / #v['labels'] * v['max']), tocolor(color[1], color[2], color[3], a_235), true)
		end 

		local x = 0
		for i = v['selected_min'],v['selected_max'] do
			x = x+1

			local sy = 39/scale * x

			if isMouseIn(v['x']-11/scale, (v['y']-35/scale) + sy, v['w']+21/scale, 37/scale) and v['labels'][i] and v['labels'][i]['selected'] ~= true then
				dxDrawRectangle(v['x']-11/scale, (v['y']-35/scale) + sy, v['w']+21/scale, 37/scale, tocolor(40, 40, 40, a_125), true)
			elseif v['labels'][i] and v['labels'][i]['selected'] == true then
				dxDrawRectangle(v['x']-11/scale, (v['y']-35/scale) + sy, v['w']+21/scale, 37/scale, tocolor(105, 188, 235, a_125), true)
			else
				if v['labels'][i] then
					dxDrawRectangle(v['x']-11/scale, (v['y']-35/scale) + sy, v['w']+21/scale, 37/scale, tocolor(30, 30, 30, a_125), true)
				end
			end

			if v['labels'][i] then
				for index = 1,#v['labeles'] do
					local h = (height[index]/scale) * (index - 1)
					dxLibary:dxLibary_text(v['labels'][i][index], v['x'] + h, v['y']-72/scale + sy, v['w']+v['x'], 37/scale+v['y'] + sy, tocolor(255, 255, 255, a_255), 1, 'default', 'left', 'center', false, false, true)
				end
			end
		end
	end
end