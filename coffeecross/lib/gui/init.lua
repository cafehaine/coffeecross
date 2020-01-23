local gui_groups = require("gui.groups")
local class = require("class")

local gui = class.create("Gui")

function gui.__new(self, group, initial_focus)
	self.base_group = gui_groups.new(group)
	self.focus = initial_focus
	return self
end

function gui:render(showfocus)
	local width, height = love.graphics.getDimensions()
	love.graphics.setScissor(0, 0, width, height)
	self.base_group:render(width, height, showfocus and self.focus or nil)
end

function gui:keypressed(k)
	self.focus = self.base_group:keypressed(k, self.focus) or self.focus
end

function gui:click(x, y)
	local width, height = love.graphics.getDimensions()
	self.base_group:click(x, y, width, height)
end

function gui:update(dt)
	self.base_group:update(dt)
end

function gui:scroll(x, y)
	self.base_group:scroll(x, y)
end

function gui:zoom(val)
	self.base_group:zoom(val)
end

function gui:message_elements(message)
	self.base_group:message(message)
end

function gui:drag(point)
	local width, height = love.graphics.getDimensions()
	self.base_group:drag(point, width, height)
end

return gui

