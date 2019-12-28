local gui = require("gui")
local class = require("class")

local view = class.create()

function view.__new(obj, path)
	local chunk = love.filesystem.load("views/"..path..".lua")

	local props = chunk()
	obj.gui = gui.new(props.gui, props.focus)
	obj.opaque = props.opaque
end

function view:render()
	self.gui:render()
end

function view:update(dt)

end

function view:keypressed(k)
	self.gui:keypressed(k)
end

return view

