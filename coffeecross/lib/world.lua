local class = require("class")

local world = class.create()

function world.__new(obj, path)
	--TODO parse metadata
	obj.path = path
end

function world:get_name()
	--TODO used parsed metadata
	return "Hello"
end

return world
