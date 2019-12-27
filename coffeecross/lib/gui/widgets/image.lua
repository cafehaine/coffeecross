local m = {}
m.__index = m

local set = require("set")
local gui_utils = require("gui.utils")
local VALID_MODES = set.new({"cover", "contain", "stretch"})

function m.new(attrs)
	local self = setmetatable({}, m)
	self.attrs = attrs
	self.image = love.graphics.newImage("assets/"..attrs.image) or error("HELLO")
	self.mode = attrs.mode or "contain"
	if not VALID_MODES:contains(self.mode) then
		error("Invalid mode: "..self.mode..".")
	end
	return self
end

function m:auto_width()
	return 0
end

function m:auto_height()
	return 0
end

function m:render(width, height)
	love.graphics.setColor(1, 1, 1)
	if self.mode == "contain" then
		--TODO maths.
		love.graphics.draw(self.image, 0, 0)
	else
		error("Mode not implemented: "..self.mode)
	end
end

return m
