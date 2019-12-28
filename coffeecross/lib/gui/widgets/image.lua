local class = require("class")
local widgets_base = require("gui.widgets.base")
local set = require("set")
local gui_utils = require("gui.utils")

local VALID_MODES = set.new({"cover", "contain", "stretch"})

local wdgt = class.create(widgets_base)

function wdgt.__new(obj, attrs)
	widgets_base.__new(obj, attrs)
	obj.image = love.graphics.newImage("assets/"..attrs.image) or error("HELLO")
	obj.mode = attrs.mode or "stretch"
	if not VALID_MODES:contains(obj.mode) then
		error("Invalid mode: "..obj.mode..".")
	end
end

function wdgt:auto_width()
	return 0
end

function wdgt:auto_height()
	return 0
end

function wdgt:render(width, height)
	love.graphics.setColor(1, 1, 1)

	local width_i, height_i = self.image:getDimensions()
	local factor_x = width / width_i
	local factor_y = height / height_i

	if self.mode == "contain" then
		local factor = math.min(factor_x, factor_y)
		local x = width/2-width_i*factor/2
		local y = height/2-height_i*factor/2
		love.graphics.draw(self.image, x, y, 0, factor, factor)
	elseif self.mode == "cover" then
		local factor = math.max(factor_x, factor_y)
		local x = width/2-width_i*factor/2
		local y = height/2-height_i*factor/2
		love.graphics.draw(self.image, x, y, 0, factor, factor)
	elseif self.mode == "stretch" then
		love.graphics.draw(self.image, 0, 0, 0, factor_x, factor_y)
	else
		error("Mode not implemented: "..self.mode)
	end
end

return wdgt
