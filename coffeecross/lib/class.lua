local m = {}

local lua_type = type
local object_id = 1

function _G.type(obj)
	if lua_type(obj) == "table" then
		if obj.__is_object then
			return "object"
		elseif obj.__is_class then
			return "class"
		end
	end
	return lua_type(obj)
end

local function object_eq(o1, o2)
	if o1.__object_id == o2.__object_id then
		return true
	end
	if o1.equals then
		return o1:equals(o2)
	end
	return false
end

local function object_tostring(obj)
	if type(obj) == "object" then
		return obj.__class_name..": "..obj.__object_id
	else
		return "class: "..obj.__class_name
	end
end

function m.create(name, parent)
	local c = {__eq=object_eq, __tostring=object_tostring}
	if type(parent) == "class" then
		for k, v in pairs(parent) do
			c[k] = v
		end
	else
		parent = nil
	end

	c.__class_name = name
	c.__parent = parent
	c.__index = c
	c.__is_class = true

	c.new = function(...)
		local obj = setmetatable({}, c)
		obj.__object_id = object_id
		object_id = object_id + 1
		obj.__is_object = true
		if c.__new then
			c.__new(obj,...)
		end
		return obj
	end

	return c
end

return m
