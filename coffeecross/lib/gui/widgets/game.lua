local class = require("class")
local super = require("gui.widgets.base")
local utils = require("gui.utils")
local palette = require("gui.widgets.palette")
local viewstack = require("viewstack")

local wdgt = class.create(super)
wdgt.active_widget = nil

local cached_texts = {}

local MIN_ZOOM = 0.5
local MAX_ZOOM = 2

local function getText(text)
	if not cached_texts[text] then
		cached_texts[text] = love.graphics.newText(utils.get_font(), text)
	end
	return cached_texts[text]
end

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
	self.next_levels = attrs.next_levels
	self.focus = attrs.focus

	self.grid_x = 1
	self.grid_y = 1

	self.grid = generate_grid(self.level.grid)

	self.height = #self.level.grid
	self.width = #self.level.grid[1]

	self.__zoom = 1

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

function wdgt:__drawIndication(left, top, indication)
	local unit = utils.get_unit()
	local cell_size = unit * 8 * self.__zoom
	local font_scale = utils.get_unit_font_scale() * 6 * self.__zoom

	love.graphics.setColor(self.level.palette[indication.color])
	love.graphics.rectangle("fill", left, top, cell_size, cell_size)
	love.graphics.setColor(1,1,1)
	local text = getText(tostring(indication.count))
	local text_width, text_height = text:getDimensions()
	text_width, text_height = text_width * font_scale, text_height * font_scale
	love.graphics.draw(text, left + cell_size/2 - text_width/2, top + cell_size/2 - text_height/2, 0, font_scale)
end

function wdgt:mousepressed(x, y, button, width, height)
	local unit = utils.get_unit()
	local cell_size = unit * 8 * self.__zoom
	local font_scale = utils.get_unit_font_scale() * 6

	local total_width = (self.width + self.indication_width) * cell_size
	local total_height = (self.height + self.indication_height) * cell_size

	local left = width/2-total_width/2
	local top = height/2-total_height/2

	local grid_left = left+cell_size*self.indication_width
	local grid_top = top+cell_size*self.indication_height

	if not utils.point_in_surface(x, y, grid_left, grid_top, self.width * cell_size, self.height * cell_size) then
		return
	end
	self:__toggle_cell(math.floor((x-grid_left)/cell_size) + 1, math.floor((y-grid_top)/cell_size) + 1)
end

function wdgt:render(width, height, focus)
	wdgt.active_widget = self
	local unit = utils.get_unit()
	local cell_size = unit * 8 * self.__zoom
	local font_scale = utils.get_unit_font_scale() * 6

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
			local cell_left = row_left + (j-1) * cell_size
			local cell_top = grid_top + (i-1) * cell_size
			local indication = row[j]
			self:__drawIndication(cell_left, cell_top, indication)
		end
	end
	for i=1, #indications.cols do
		local col = indications.cols[i]
		local col_len = #col
		local col_top = grid_top - col_len * cell_size
		for j=1, col_len do
			local indication = col[j]
			local cell_left = grid_left + (i-1) * cell_size
			local cell_top = col_top + (j-1) * cell_size
			self:__drawIndication(cell_left, cell_top, indication)
		end
	end
	-- Grid background
	love.graphics.setColor(0.8, 0.8, 0.8)
	love.graphics.rectangle("fill", grid_left, grid_top, self.width*cell_size, self.height*cell_size)
	-- Grid
	for i=1, #self.grid do
		for j=1, #self.grid[i] do
			local cell = self.grid[i][j]
			local cell_x = grid_left+(j-1)*cell_size
			local cell_y = grid_top+(i-1)*cell_size
			if cell == -1 then -- blocked cell
				love.graphics.setLineWidth(unit)
				love.graphics.setColor(1,0,0)
				love.graphics.line(cell_x, cell_y, cell_x + cell_size, cell_y + cell_size)
				love.graphics.line(cell_x, cell_y + cell_size, cell_x+cell_size, cell_y)

			elseif cell ~= 0 then -- color cell
				love.graphics.setColor(self.level.palette[cell])
				love.graphics.rectangle("fill", cell_x, cell_y, cell_size, cell_size)
			end
		end
	end
	-- Grid foreground
	love.graphics.setLineWidth(unit/4)
	love.graphics.setColor(0, 0, 0, 0.2)
	for i=0, self.height do
		love.graphics.line(grid_left, grid_top + i*cell_size, grid_left + self.width*cell_size, grid_top+i*cell_size)
	end

	for j=0, self.width do
		love.graphics.line(grid_left + j*cell_size, grid_top, grid_left + j*cell_size, grid_top+self.height*cell_size)
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

function wdgt:__check_grid()
	for i=1, #self.grid do
		for j=1, #self.grid[i] do
			local cell = self.grid[i][j]
			if cell == -1 then -- consider "blocked" cells as empty
				cell = 0
			end
			local ref = self.level.grid[i][j]
			if cell ~= ref then
				return
			end
		end
	end
	viewstack.pushnew("gamefinish", self.level, self.next_levels)
end

function wdgt:__toggle_cell(x, y)
	local value = palette.active_widget.index
	if value == 0 then -- block
		value = -1
	end
	if self.grid[y][x] == value then
		self.grid[y][x] = 0
	else
		self.grid[y][x] = value
	end
	self:__check_grid()
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
	elseif k == "space" or k == "return" then
		self:__toggle_cell(self.grid_x, self.grid_y)
	elseif k == "delete" or k == "backspace" then
		self.grid[self.grid_y][self.grid_x] = 0
		self:__check_grid()
	elseif self.focus[k] then
		return self.focus[k]
	end

	return nil
end

function wdgt:zoom(val)
	self.__zoom = math.min(MAX_ZOOM, math.max(MIN_ZOOM, self.__zoom + val))
end

function wdgt:hint()
	--TODO
end

return wdgt
