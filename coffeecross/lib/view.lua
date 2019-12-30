local gui = require("gui")
local class = require("class")

local view = class.create()

function view.__new(self, path, ...)
	local realpath = "views/"..path..".lua"
	if not love.filesystem.getInfo(realpath, "file") then
		error("Cannot open file \""..realpath.."\"")
	end
	local chunk = love.filesystem.load("views/"..path..".lua")
	local temp = chunk()
	local props = type(temp) == "function" and temp(...) or temp
	self.gui = gui.new(props.gui, props.focus)
	self.opaque = props.opaque
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

