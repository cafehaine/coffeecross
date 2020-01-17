local class = require("class")
local super = require("gui.widgets.base")

local wdgt = class.create("Background", super)
local GRADIENT = love.graphics.newImage("assets/background_gradient.png")

function wdgt.__new(self, attrs)
	super.__new(self, attrs)
end

function wdgt:auto_width()
	return 0
end

function wdgt:auto_height()
	return 0
end

function wdgt:render(width, height)
	local img_width, img_height = GRADIENT:getPixelDimensions()
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(GRADIENT, 0, 0, 0, width/img_width, height/img_height)
end

return wdgt
