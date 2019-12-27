local gui_group = require("gui.group")

local m = {}
m.__index = m

function m.new(group)
	local self = setmetatable({}, m)
	self.base_group = gui_group.new(group)
	return self
end

function m:render()
end

return m

