local class = require("class")

local base = class.create()

function base.__new(self, attrs)
	self.attrs = attrs
	self.id = attrs.id
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

function base:update(dt) end

function base:mousepressed(x, y, button, width, height) end

return base
