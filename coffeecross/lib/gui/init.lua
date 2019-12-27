local gui_groups = require("gui.groups")

local m = {}
m.__index = m

function m.new(group)
	local self = setmetatable({}, m)
	self.base_group = gui_groups.new(group)
	return self
end

function m:render()
	local width, height = love.graphics.getDimensions()
	love.graphics.setScissor(0, 0, width, height)
	self.base_group:render(width, height)
end

return m

