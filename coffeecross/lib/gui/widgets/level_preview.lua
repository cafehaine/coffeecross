local class = require("class")
local super = require("gui.widgets.base")
local utils = require("gui.utils")

local wdgt = class.create(super)

function wdgt.__new(self, attrs)
	super.__new(self, attrs)
	self.grid = attrs.grid
	self.palette = attrs.palette
end

function wdgt:auto_width()
	return utils.get_unit() * (15 + 2)
end

function wdgt:auto_height()
	return utils.get_unit() * (15 + 2)
end

function wdgt:render(width, height)
	local unit = utils.get_unit()
	local scale_x = (width-2*unit)/self.grid.width
	local scale_y = (height-2*unit)/self.grid.height
	local scale = math.min(scale_x, scale_y)

	local x = width/2-self.grid.width/2*scale
	local y = height/2-self.grid.height/2*scale

	love.graphics.setColor(0.8, 0.8, 0.8)
	love.graphics.rectangle("fill", x-unit, y-unit, self.grid.width*scale+2*unit, self.grid.height*scale+2*unit)

	self.grid:render(x, y, scale, self.palette)
end

return wdgt
