local class = require("class")
local widgets_base = require("gui.widgets.base")
local gui_utils = require("gui.utils")

local wdgt = class.create(widgets_base)

function wdgt.__new(obj, attrs)
	widgets_base.__new(obj, attrs)
	obj.text = attrs.text or error("HELLO")
	obj.drawable = love.graphics.newText(gui_utils.get_font(), obj.text)
	obj.color = obj.color or {1, 1, 1}
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
