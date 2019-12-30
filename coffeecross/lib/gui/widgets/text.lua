local class = require("class")
local super = require("gui.widgets.base")
local gui_utils = require("gui.utils")

local wdgt = class.create(super)

function wdgt.__new(self, attrs)
	super.__new(self, attrs)
	self.text = attrs.text or error("HELLO")
	self.drawable = love.graphics.newText(gui_utils.get_font(), self.text)
	self.color = self.color or {1, 1, 1}
end

function wdgt:auto_width()
	return self.drawable:getWidth()
end

function wdgt:auto_height()
	return self.drawable:getHeight()
end

function wdgt:render(width, height)
	-- Text
	love.graphics.setColor(self.color)
	local t_width, t_height = self.drawable:getDimensions()
	local x = width/2-t_width/2
	local y = height/2-t_height/2
	love.graphics.draw(self.drawable, x, y)
end

return wdgt
