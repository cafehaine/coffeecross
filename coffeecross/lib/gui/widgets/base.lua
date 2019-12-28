local class = require("class")

local base = class.create()

function base.__new(obj, attrs)
	obj.attrs = attrs
	obj.id = attrs.id
end

function base:auto_width()
	error("Not implemented.")
end

function base:auto_height()
	error("Not implemented.")
end

function base:render()
	error("Not implemented")
end

function base:keypressed(k, focus) end

return base
