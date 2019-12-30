local class = require("class")

local world = class.create()

function world.__new(self, path)
	--TODO parse metadata
	self.path = path
end

function world:get_name()
	--TODO used parsed metadata
	return "Hello"
end

return world
