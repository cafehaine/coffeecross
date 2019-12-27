local gui = require("gui")

local m = {}
m.__index = m

function m.new(path)
	local self = setmetatable({}, m)

	local chunk = love.filesystem.load("views/"..path..".lua")

	local view = chunk()
	self.gui = gui.new(view.gui)
	self.opaque = view.opaque

	return self
end

function m:render()
	self.gui:render()
end

function m:update(dt)

end

function m:keypressed(k)
	self.gui:keypressed(k)
end

return m

