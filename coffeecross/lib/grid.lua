local class = require("class")

local grid = class.create("Grid")

function grid.__new(self, width, height, initial_data)
	self.cells = {}
	self.width = width
	self.height = height

	if initial_data then
		self.cells = initial_data
	else
		for i=1, height do
			local line = {}
			for j=1, width do
				line[j] = 0
			end
			self.cells[i] = line
		end
	end
end

function grid:render(x, y, cell_size, palette)
	for i=1, self.height do
		for j=1, self.width do
			local cell = self.cells[i][j]
			local cell_x = x+(j-1)*cell_size
			local cell_y = y+(i-1)*cell_size
			if cell == -1 then -- blocked cell
				love.graphics.setLineWidth(cell_size/10)
				love.graphics.setColor(1,0,0)
				love.graphics.line(cell_x, cell_y, cell_x + cell_size, cell_y + cell_size)
				love.graphics.line(cell_x, cell_y + cell_size, cell_x+cell_size, cell_y)

			elseif cell ~= 0 then -- color cell
				love.graphics.setColor(palette[cell])
				love.graphics.rectangle("fill", cell_x, cell_y, cell_size, cell_size)
			end
		end
	end
end

function grid:check_row(reference, row)
	if self.width ~= reference.width or self.height ~= reference.height then
		return false
	end

	if row > self.height or row < 1 then
		error(("Invalid row index: %d is outside of range [1-%d]"):format(row, self.height))
	end

	for i=1, self.width do
		local self_cell = self.cells[row][i]
		local ref_cell = reference.cells[row][i]
		-- count "blocked" cells as empty
		self_cell = self_cell == -1 and 0 or self_cell
		ref_cell  = ref_cell  == -1 and 0 or ref_cell
		if self_cell ~= ref_cell then
			return false
		end
	end
	return true
end

function grid:check_col(reference, col)
	if self.width ~= reference.width or self.height ~= reference.height then
		return false
	end

	if col > self.width or col < 1 then
		error(("Invalid col index: %d is outside of range [1-%d]"):format(col, self.width))
	end

	for i=1, self.height do
		local self_cell = self.cells[i][col]
		local ref_cell = reference.cells[i][col]
		-- count "blocked" cells as empty
		self_cell = self_cell == -1 and 0 or self_cell
		ref_cell  = ref_cell  == -1 and 0 or ref_cell
		if self_cell ~= ref_cell then
			return false
		end
	end
	return true
end

function grid:equals(obj)
	for i=1, self.height do
		if not self:check_row(obj, i) then
			return false
		end
	end
	return true
end

function grid:wrong_cells(reference)
	if self.width ~= reference.width or self.height ~= reference.height then
		error("Comparing grids of different dimensions")
	end

	local errors = {}
	for i=1, self.height do
		for j=1, self.width do
			local self_cell = self.cells[i][j]
			local ref_cell = reference.cells[i][j]
			if self_cell ~= 0 then -- don't count empty cells as wrong
				self_cell = self_cell == -1 and 0 or self_cell
				if self_cell ~= ref_cell then
					errors[#errors+1] = {x=j, y=i}
				end
			end
		end
	end

	return errors
end

function grid:random_missing_cell(reference)
	if self.width ~= reference.width or self.height ~= reference.height then
		error("Comparing grids of different dimensions")
	end

	local missing = {}

	for i=1, self.height do
		for j=1, self.width do
			local self_cell = self.cells[i][j]
			local ref_cell = reference.cells[i][j]
			if self_cell == 0 and ref_cell ~= 0 then
				missing[#missing+1] = {x=j, y=i, val=ref_cell}
			end
		end
	end

	return missing[math.random(#missing)]
end

return grid
