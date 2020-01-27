local gui = require("gui")
local class = require("class")

local view = class.create("View")

function view.__new(self, path, ...)
	local realpath = "views/"..path..".lua"
	if not love.filesystem.getInfo(realpath, "file") then
		error("Cannot open file \""..realpath.."\"")
	end
	local chunk = love.filesystem.load("views/"..path..".lua")
	local temp = chunk()
	local props = type(temp) == "function" and temp(...) or temp
	self.gui = gui.new(props.gui, props.focus)
	self.keybinds = props.keybinds or {}
	self.opaque = props.opaque
	self.name = path
end

function view:render(showfocus)
	self.gui:render(showfocus)
end

function view:update(dt)
	self.gui:update(dt)
end

function view:keypressed(k)
	if self.keybinds[k] then
		self.keybinds[k]()
	else
		self.gui:keypressed(k)
	end
end

function view:click(x, y)
	self.gui:click(x, y)
end

function view:scroll(x, y)
	self.gui:scroll(x, y)
end

function view:zoom(val)
	self.gui:zoom(val)
end

function view:message_elements(message)
	self.gui:message_elements(message)
end

function view:drag(event)
	self.gui:drag(event)
end

return view
