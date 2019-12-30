local gui_groups = require("gui.groups")
local class = require("class")

local gui = class.create()

function gui.__new(self, group, initial_focus)
	self.base_group = gui_groups.new(group)
	self.focus = initial_focus
	return self
end

function gui:render()
	local width, height = love.graphics.getDimensions()
	love.graphics.setScissor(0, 0, width, height)
	self.base_group:render(width, height, self.focus)
end

function gui:keypressed(k)
	self.focus = self.base_group:keypressed(k, self.focus)
end

function gui:update(dt)
	self.base_group:update(dt)
end

return gui

