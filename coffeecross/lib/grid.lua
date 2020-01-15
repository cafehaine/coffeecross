local class = require("class")

local grid = class.create()

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

function grid:equals(obj)
	if self.width ~= obj.width or self.height ~= obj.height then
		return false
	end

	for i=1, self.height do
		for j=1, self.width do
			local self_cell = self.cells[i][j]
			local obj_cell  = obj.cells[i][j]
			-- count "blocked" cells as empty
			self_cell = self_cell == -1 and 0 or self_cell
			obj_cell  = obj_cell  == -1 and 0 or obj_cell
			if self_cell ~= obj_cell then
				return false
			end
		end
	end
	return true
end

return grid
