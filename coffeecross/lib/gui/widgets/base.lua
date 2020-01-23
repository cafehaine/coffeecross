local class = require("class")

local base = class.create("Widget")

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

function base:click(x, y, width, height) end

function base:scroll(x, y) end

function base:zoom(val) end

function base:message(message) end

function base:drag(point, width, height) end

return base
