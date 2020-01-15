local class = require("class")
local super = require("gui.widgets.base")
local utils = require("gui.utils")

local wdgt = class.create(super)

function wdgt.__new(self, attrs)
	super.__new(self, attrs)
	self.grid = attrs.grid
	self.palette = attrs.palette
	self.height = #self.grid
	self.width = #self.grid[1]
end

function wdgt:auto_width()
	return utils.get_unit() * (15 + 2)
end

function wdgt:auto_height()
	return utils.get_unit() * (15 + 2)
end

function wdgt:render(width, height)
	local unit = utils.get_unit()
	local scale_x = (width-2*unit)/self.width
	local scale_y = (height-2*unit)/self.height
	local scale = math.min(scale_x, scale_y)

	local x = width/2-self.width/2*scale
	local y = height/2-self.height/2*scale

	love.graphics.setColor(0.8, 0.8, 0.8)
	love.graphics.rectangle("fill", x-unit, y-unit, self.width*scale+2*unit, self.height*scale+2*unit)

	for i=1, #self.grid do
		for j=1, #self.grid[i] do
			local cell = self.grid[i][j]
			if cell ~= 0 then
				love.graphics.setColor(self.palette[self.grid[i][j]])
				love.graphics.rectangle("fill", x+(j-1)*scale, y+(i-1)*scale, scale, scale)
			end
		end
	end
end

return wdgt
