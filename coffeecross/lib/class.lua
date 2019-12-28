local m = {}

local lua_type = type

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

function m.create(parent)
	local c = {}
	if type(parent) == "class" then
		for k, v in pairs(parent) do
			c[k] = v
		end
	else
		parent = nil
	end

	c.__parent = parent
	c.__index = c
	c.__is_class = true

	c.new = function(...)
		local obj = setmetatable({}, c)
		obj.__is_object = true
		c.__new(obj,...)
		return obj
	end

	return c
end

return m
