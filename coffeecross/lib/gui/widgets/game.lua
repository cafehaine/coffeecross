local class = require("class")
local super = require("gui.widgets.base")

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
	self.grid = generate_grid(self.level.grid)

	self.height = #self.level.grid
	self.width = #self.level.grid[1]

	self.max_indication_cols = 0
	self.max_indication_rows = 0

	local indications = self.level.indications
	for i=1, #indications.rows do
		self.max_indication_rows = math.max(self.max_indication_rows, #indications.rows[i])
	end

	for i=1, #indications.cols do
		self.max_indication_cols = math.max(self.max_indication_cols, #indications.cols[i])
	end
end

function wdgt:auto_width()
	return 0
end

function wdgt:auto_height()
	return 0
end

function wdgt:render(width, height, focus)
	if focus == self.id then
		love.graphics.clear(0.5,0,0.5)
	else
		love.graphics.clear(0,0,0)
	end
end

function wdgt:keypressed(k, focus)
	if focus == self.id and self.focus[k] then
		return self.focus[k]
	end
	return nil
end

return wdgt
