local class = require("class")
local super = require("gui.widgets.base")
local utils = require("gui.utils")

local wdgt = class.create(super)

function wdgt.__new(self, attrs)
	super.__new(self, attrs)
	self.text = attrs.text or error("HELLO")
	self.drawable = love.graphics.newText(utils.get_font(), self.text)
	self.color = self.color or {1, 1, 1}
end

function wdgt:auto_width()
	local font_scale = utils.get_font_scale()
	return self.drawable:getWidth()*font_scale
end

function wdgt:auto_height()
	local font_scale = utils.get_font_scale()
	return self.drawable:getHeight()*font_scale
end

function wdgt:render(width, height)
	local font_scale = utils.get_font_scale()
	-- Text
	love.graphics.setColor(self.color)
	local t_width, t_height = self.drawable:getDimensions()
	local t_width, t_height = t_width*font_scale, t_height*font_scale
	local x = width/2-t_width/2
	local y = height/2-t_height/2
	love.graphics.draw(self.drawable, x, y, 0, font_scale)
end

return wdgt
