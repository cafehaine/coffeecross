local m = {}
m.__index = m

local gui_utils = require("gui.utils")

local PADDING_SIZE = 6

function m.new(attrs)
	local self = setmetatable({}, m)
	self.attrs = attrs
	self.text = attrs.text or error("HELLO")
	self.drawable = love.graphics.newText(gui_utils.get_font(), self.text)
	self.color = attrs.color or {1, 1, 1}
	return self
end

function m:auto_width()
	return self.drawable:getWidth() + PADDING_SIZE*2
end

function m:auto_height()
	return self.drawable:getHeight() + PADDING_SIZE*2
end


function m:render(width, height)
	-- Border
	love.graphics.clear(1, 0, 1)
	-- Text
	love.graphics.setColor(self.color)
	local t_width, t_height = self.drawable:getDimensions()
	local x = width/2-t_width/2
	local y = height/2-t_height/2
	love.graphics.draw(self.drawable, x, y)
end

return m