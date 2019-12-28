local class = require("class")
local widgets_base = require("gui.widgets.base")
local gui_utils = require("gui.utils")

local PADDING_SIZE = 6

local wdgt = class.create(widgets_base)

function wdgt.__new(obj, attrs)
	widgets_base.__new(obj, attrs)
	obj.action = attrs.action
	obj.focus = attrs.focus
	obj.text = attrs.text or error("HELLO")
	obj.drawable = love.graphics.newText(gui_utils.get_font(), obj.text)
	obj.color = attrs.color or {1, 1, 1}
end

function wdgt:auto_width()
	return self.drawable:getWidth() + PADDING_SIZE*2
end

function wdgt:auto_height()
	return self.drawable:getHeight() + PADDING_SIZE*2
end

function wdgt:render(width, height, focus)
	-- Border
	if focus == self.id then
		love.graphics.clear(1, 0, 1)
	else
		love.graphics.clear(0.1, 0.1, 0.1)
	end
	-- Text
	love.graphics.setColor(self.color)
	local t_width, t_height = self.drawable:getDimensions()
	local x = width/2-t_width/2
	local y = height/2-t_height/2
	love.graphics.draw(self.drawable, x, y)
end

function wdgt:keypressed(k, focus)
	if focus == self.id then
		if self.focus[k] then
			return self.focus[k]
		elseif k == "return" then
			self.action()
		end
	end

	return nil
end

return wdgt
