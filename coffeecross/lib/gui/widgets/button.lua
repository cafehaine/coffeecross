local class = require("class")
local super = require("gui.widgets.base")
local utils = require("gui.utils")

local wdgt = class.create(super)

function wdgt.__new(self, attrs)
	super.__new(self, attrs)
	self.action = attrs.action
	self.focus = attrs.focus
	self.text = attrs.text or error("HELLO")
	self.drawable = love.graphics.newText(utils.get_font(), self.text)
	self.color = attrs.color or {1, 1, 1}
end

function wdgt:auto_width()
	local unit = utils.get_unit()
	local font_scale = utils.get_font_scale()
	return self.drawable:getWidth()*font_scale + 6 * unit
end

function wdgt:auto_height()
	local unit = utils.get_unit()
	local font_scale = utils.get_font_scale()
	return self.drawable:getHeight()*font_scale + 6 * unit
end

function wdgt:render(width, height, focus)
	local unit = utils.get_unit()
	local font_scale = utils.get_font_scale()
	-- Border
	if focus == self.id then
		love.graphics.setColor(1.0, 0.7, 0.2)
	else
		love.graphics.setColor(0.3, 0.3, 0.3)
	end
	love.graphics.rectangle("fill", unit, unit, width-2*unit, height-2*unit, 2*unit)
	love.graphics.setColor(0.1, 0.1, 0.1)
	love.graphics.rectangle("fill", 2*unit, 2*unit, width-4*unit, height-4*unit, unit)
	-- Text
	love.graphics.setColor(self.color)
	local t_width, t_height = self.drawable:getDimensions()
	local t_width, t_height = t_width*font_scale, t_height*font_scale
	local x = width/2-t_width/2
	local y = height/2-t_height/2
	love.graphics.draw(self.drawable, x, y, 0, font_scale)
end

function wdgt:keypressed(k, focus)
	if focus == self.id then
		if self.focus[k] then
			return self.focus[k]
		elseif k == "return" or k == "space" then
			self.action()
		end
	end

	return nil
end

function wdgt:mousepressed(x, y, button, width, height)
	self.action()
end

return wdgt
