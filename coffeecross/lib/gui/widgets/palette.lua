local class = require("class")
local utils = require("gui.utils")
local super = require("gui.widgets.base")

local wdgt = class.create(super)

local CELL_SIZE = 8

wdgt.active_widget = nil

function wdgt.__new(self, attrs)
	super.__new(self, attrs)
	self.action = attrs.action
	self.focus = attrs.focus
	self.palette = attrs.palette
	self.index = 1 -- 0 = clear
	self.focused = 1
end

function wdgt:auto_width()
	return utils.get_unit() * CELL_SIZE * (#self.palette+1)
end

function wdgt:auto_height()
	return utils.get_unit() * CELL_SIZE
end

function wdgt:render(width, height, focus)
	wdgt.active_widget = self
	local unit = utils.get_unit()
	love.graphics.clear(0,0,0)
	cell_width = width/(#self.palette+1)
	-- "clear" cell
	love.graphics.setLineWidth(unit)
	love.graphics.setColor(1,0,0)
	love.graphics.line(0,0,cell_width, height)
	love.graphics.line(0,height,cell_width, 0)
	-- Other cells
	for i=1, #self.palette do
		love.graphics.setColor(self.palette[i])
		love.graphics.rectangle("fill", 0+i*cell_width, 0, cell_width, height)
	end
	-- highlight the currently selected color
	love.graphics.setColor(0, 0, 0)
	local p1_x, p1_y = (self.index+1/4)*cell_width, height
	local p2_x, p2_y = (self.index+1/2)*cell_width, height*3/4
	local p3_x, p3_y = (self.index+3/4)*cell_width, height
	love.graphics.polygon("fill", p1_x, p1_y, p2_x, p2_y, p3_x, p3_y)
	love.graphics.setColor(1, 1, 1)
	p1_x = p1_x + unit
	p2_y = p2_y + unit
	p3_x = p3_x - unit
	love.graphics.polygon("fill", p1_x, p1_y, p2_x, p2_y, p3_x, p3_y)

	-- highlight the currently focused color
	if focus == self.id then
		love.graphics.setColor(0, 0, 0)
		love.graphics.circle("fill", (self.focused+1/2)*cell_width, height/2, 2*unit)
		love.graphics.setColor(1, 1, 1)
		love.graphics.circle("fill", (self.focused+1/2)*cell_width, height/2, unit)
	end
end

function wdgt:keypressed(k, focus)
	if focus ~= self.id then
		return nil
	end

	if self.focus[k] then
		return self.focus[k]
	end

	if k == "left" then
		self.focused = self.focused - 1
		if self.focused < 0 then
			self.focused = #self.palette
		end
	elseif k == "right" then
		self.focused = self.focused + 1
		if self.focused > #self.palette then
			self.focused = 0
		end
	elseif k == "return" or k == "space" then
		self.index = self.focused
	end

	return nil
end

return wdgt
