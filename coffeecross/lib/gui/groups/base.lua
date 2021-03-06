local class = require("class")
local widgets = require("gui.widgets")
local groups = require("gui.groups")

local base = class.create("Base")

function base.__new(self, elm)
	self.elements = {}
	for i, elm in ipairs(elm.elements) do
		if elm.type then
			self.elements[i] = widgets.new(elm)
		elseif elm.group_type then
			self.elements[i] = groups.new(elm)
		else
			error("Element is neither an widget or a group.")
		end
	end
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

function base:keypressed(k, focus)
	for i=1, #self.elements do
		local new_focus = self.elements[i]:keypressed(k, focus)
		if new_focus then
			return new_focus
		end
	end

	return nil
end

function base:click(x, y, width, height)
	error("Not implemented.")
end

function base:update(dt)
	for i=1, #self.elements do
		self.elements[i]:update(dt)
	end
end

function base:scroll(x, y)
	for i=1, #self.elements do
		self.elements[i]:scroll(x, y)
	end
end

function base:zoom(val)
	for i=1, #self.elements do
		self.elements[i]:zoom(val)
	end
end

function base:message(message)
	for i=1, #self.elements do
		self.elements[i]:message(message)
	end
end

function base:drag(event, width, height)
	error("not implemented")
end

return base
