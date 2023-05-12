--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local db = exports.dmta_base_connect
local objects = {}

addEvent('save:object', true)
addEventHandler('save:object', resourceRoot, function(id, x, y, z, rx, ry, rz, exists)
	if not id or not x or not z or not rx or not ry or not rz then return end

	if exists and objects[exists] then
		db:query('update db_objects set pos=?, rotation=? where id=?', toJSON({x, y, z}), toJSON({rx, ry, rz}), exists)
		setElementPosition(objects[exists], x, y, z)
		setElementRotation(objects[exists], rx, ry, rz)
	else
		local int,dim = getElementInterior(client),getElementDimension(client)
		local q, _, i = db:query('insert into db_objects (model, pos, rotation, interior, dim) values (?, ?, ?, ?, ?)', id, toJSON({x, y, z}), toJSON({rx, ry, rz}), int, dim)
		getObjectFromTable(i)
	end
end)

function createCustomObject(id, i, pos, rotation, int, dim)
	local x, y, z = unpack(pos)
	local rx, ry, rz = unpack(rotation)

	objects[i] = createObject(id, x, y, z, rx, ry, rz)
	if not objects[i] then
		outputDebugString('DMTA/TOOL/OBJECTS Nie udało się stworzyć obiektu (ID: '..id..').')
		objects[i] = nil
		return
	end

	setElementData(objects[i], 'object:editor', i)
	setElementDimension(objects[i], dim)
	setElementInterior(objects[i], int)
end

function destroyCustomObject(id)
	if objects[id] and isElement(objects[id]) then
		db:query('delete from db_objects where id=?', id)
		destroyElement(objects[id])
		objects[id] = nil
	end
end
addEvent('destroy:object', true)
addEventHandler('destroy:object', resourceRoot, destroyCustomObject)

function getObjectFromTable(id)
	local q = db:query('select * from db_objects where id=? limit 1', id)
	if q and #q > 0 then
		createCustomObject(q[1].model, q[1].id, fromJSON(q[1].pos), fromJSON(q[1].rotation), q[1].interior, q[1].dim)
	else
		outputDebugString('DMTA/TOOL/OBJECTS Nie znaleziono obiektu. (ID: '..id..').')
	end
end

addEventHandler('onResourceStart', resourceRoot, function()
	local q = db:query('select * from db_objects')
	for i,v in ipairs(q) do
		createCustomObject(v.model, v.id, fromJSON(v.pos), fromJSON(v.rotation), v.interior, v.dim)
	end
end)