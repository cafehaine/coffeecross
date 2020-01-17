local class = require("class")
local super = require("gui.widgets.button")
local utils = require("gui.utils")
local viewstack = require("viewstack")
local profile = require("profile")

local wdgt = class.create("LevelStart", super)

function wdgt.__new(self, attrs)
	super.__new(self, attrs)
	self.world_name = attrs.world_name
	self.level_name = attrs.level_name
	self.next_levels = attrs.next_levels
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
	if profile.get("world-"..self.world_name, self.level_name) == "completed" then
		love.graphics.setColor(1.0, 0.7, 0.2)
	end
	love.graphics.draw(self.drawable, x, y, 0, font_scale)
end

function wdgt:action()
	viewstack.pushnew("game", self.world_name, self.level_name, self.next_levels)
end

return wdgt
