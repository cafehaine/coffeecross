local class = require("class")
local utils = require("gui.utils")
local super = require("gui.widgets.base")

local wdgt = class.create(super)

local CELL_SIZE = 8

function wdgt.__new(self, attrs)
	super.__new(self, attrs)
	self.action = attrs.action
	self.focus = attrs.focus
	self.palette = attrs.palette
end

function wdgt:auto_width()
	return utils.get_unit() * CELL_SIZE * (#self.palette+1)
end

function wdgt:auto_height()
	return utils.get_unit() * CELL_SIZE
end

function wdgt:render(width, height, focus)
	love.graphics.clear(0,0,0)
	cell_width = width/(#self.palette+1)
	--render "clear" cell
	for i=1, #self.palette do
		love.graphics.setColor(self.palette[i])
		love.graphics.rectangle("fill", 0+i*cell_width, 0, cell_width, height)
	end
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
