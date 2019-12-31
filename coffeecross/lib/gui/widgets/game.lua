local class = require("class")
local super = require("gui.widgets.base")
local utils = require("gui.utils")

local wdgt = class.create(super)

local function generate_grid(level_grid)
	local output = {}
	for i=1, #level_grid do
		local row = {}
		for j=1, #level_grid[i] do
			row[#row+1] = 0
		end
		output[#output+1] = row
	end
	return output
end

function wdgt.__new(self, attrs)
	super.__new(self, attrs)
	self.level = attrs.level
	self.focus = attrs.focus

	self.grid_x = 1
	self.grid_y = 1

	self.grid = generate_grid(self.level.grid)

	self.height = #self.level.grid
	self.width = #self.level.grid[1]

	self.indication_width = 0
	self.indication_height = 0

	local indications = self.level.indications
	for i=1, #indications.rows do
		self.indication_width = math.max(self.indication_width, #indications.rows[i])
	end

	for i=1, #indications.cols do
		self.indication_height = math.max(self.indication_height, #indications.cols[i])
	end
end

function wdgt:auto_width()
	return 0
end

function wdgt:auto_height()
	return 0
end

function wdgt:render(width, height, focus)
	local unit = utils.get_unit()
	local cell_size = unit * 8

	local total_width = (self.width + self.indication_width) * cell_size
	local total_height = (self.height + self.indication_height) * cell_size

	local left = width/2-total_width/2
	local top = height/2-total_height/2

	local grid_left = left+cell_size*self.indication_width
	local grid_top = top+cell_size*self.indication_height

	-- Indications
	local indications = self.level.indications
	for i=1, #indications.rows do
		local row = indications.rows[i]
		local row_len = #row
		local row_left = grid_left - row_len * cell_size
		for j=1, row_len do
			local indication = row[j]
			love.graphics.setColor(self.level.palette[indication.color])
			love.graphics.rectangle("fill", row_left + (j-1) * cell_size, grid_top + (i-1)*cell_size, cell_size, cell_size)
		end
	end
	for i=1, #indications.cols do
		local col = indications.cols[i]
		local col_len = #col
		local col_top = grid_top - col_len * cell_size
		for j=1, col_len do
			local indication = col[j]
			love.graphics.setColor(self.level.palette[indication.color])
			love.graphics.rectangle("fill", grid_left + (i-1) * cell_size, col_top + (j-1) * cell_size, cell_size, cell_size)
		end
	end
	-- Grid
	for i=1, #self.grid do
		for j=1, #self.grid[i] do
			local cell = self.grid[i][j]
			if cell ~= 0 then
				love.graphics.setColor(self.level.palette[cell])
				love.graphics.rectangle("fill", grid_left+(j-1)*cell_size, grid_top+(i-1), cell_size, cell_size)
			end
		end
	end
	-- Focused cell
	if focus == self.id then
		local focus_x = grid_left + (self.grid_x+1/2-1)*cell_size
		local focus_y = grid_top + (self.grid_y+1/2-1)*cell_size
		love.graphics.setColor(0, 0, 0)
		love.graphics.circle("fill", focus_x, focus_y, 2*unit)
		love.graphics.setColor(1, 1, 1)
		love.graphics.circle("fill", focus_x, focus_y, unit)
	end

end

function wdgt:keypressed(k, focus)
	if focus ~= self.id then
		return nil
	end

	if k == "up" then
		if self.grid_y == 1 then
			return self.focus["up"]
		else
			self.grid_y = self.grid_y - 1
		end
	elseif k == "down" then
		if self.grid_y == self.height then
			return self.focus["down"]
		else
			self.grid_y = self.grid_y + 1
		end
	elseif k == "left" then
		self.grid_x = self.grid_x - 1
		if self.grid_x < 1 then
			self.grid_x = self.width
		end
	elseif k == "right" then
		self.grid_x = self.grid_x + 1
		if self.grid_x > self.width then
			self.grid_x = 1
		end
	end

	return nil
end

return wdgt
