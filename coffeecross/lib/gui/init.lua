local gui_groups = require("gui.groups")

local m = {}
m.__index = m

function m.new(group, initial_focus)
	local self = setmetatable({}, m)
	self.base_group = gui_groups.new(group)
	self.focus = initial_focus
	return self
end

function m:render()
	local width, height = love.graphics.getDimensions()
	love.graphics.setScissor(0, 0, width, height)
	self.base_group:render(width, height, self.focus)
end

function m:keypressed(k)
	self.focus = self.base_group:keypressed(k, self.focus)
end

return m

