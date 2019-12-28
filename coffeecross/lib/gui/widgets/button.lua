local m = {}
m.__index = m

local gui_utils = require("gui.utils")

local PADDING_SIZE = 6

function m.new(attrs)
	local self = setmetatable({}, m)
	self.attrs = attrs
	self.id = attrs.id
	self.action = attrs.action
	self.focus = attrs.focus
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

function m:render(width, height, focus)
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

function m:keypressed(k, focus)
	if focus == self.id then
		if self.focus[k] then
			return self.focus[k]
		elseif k == "return" then
			self.action()
		end
	end

	return nil
end

return m
