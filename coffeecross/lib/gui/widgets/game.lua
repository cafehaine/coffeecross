local class = require("class")
local super = require("gui.widgets.base")
local palette = require("gui.widgets.palette")
local viewstack = require("viewstack")
local grid = require("grid")
local set = require("set")
local profile = require("profile")
local utils = require("gui.utils")
local base_utils = require("utils")
local input_utils = require("input.utils")

local wdgt = class.create("Game", super)

local cached_texts = {}

local MIN_ZOOM = 0.3
local MAX_ZOOM = 3

local function getText(text)
	if not cached_texts[text] then
		cached_texts[text] = love.graphics.newText(utils.get_font(), text)
	end
	return cached_texts[text]
end

function wdgt.__new(self, attrs)
	super.__new(self, attrs)
	self.level = attrs.level
	self.next_levels = attrs.next_levels
	self.focus = attrs.focus

	self.grid_x = 1
	self.grid_y = 1

	self.grid = grid.new(self.level.grid.width, self.level.grid.height)

	self.__zoom = 1
	self.grid_offset_x = 0
	self.grid_offset_y = 0

	self.draw_drag = nil

	self.indication_width = 0
	self.indication_height = 0

	local indications = self.level.indications
	for i=1, #indications.rows do
		self.indication_width = math.max(self.indication_width, #indications.rows[i])
	end

	for i=1, #indications.cols do
		self.indication_height = math.max(self.indication_height, #indications.cols[i])
	end

	self.completed_rows = set.new()
	self.completed_cols = set.new()
end

function wdgt:auto_width()
	return 0
end

function wdgt:auto_height()
	return 0
end

function wdgt:__drawIndication(left, top, indication, completed)
	local unit = utils.get_unit()
	local cell_size = unit * 8 * self.__zoom
	local font_scale = utils.get_unit_font_scale() * 6 * self.__zoom

	love.graphics.setColor(self.level.palette[indication.color])
	love.graphics.rectangle("fill", left, top, cell_size, cell_size)
	if completed then
		love.graphics.setColor(0.5,0.5,0.5)
	else
		love.graphics.setColor(1,1,1)
	end
	local text = getText(tostring(indication.count))
	local text_width, text_height = text:getDimensions()
	text_width, text_height = text_width * font_scale, text_height * font_scale
	love.graphics.draw(text, left + cell_size/2 - text_width/2, top + cell_size/2 - text_height/2, 0, font_scale)
end

function wdgt:__cell_by_coords(x, y, width, height)
	local unit = utils.get_unit()
	local cell_size = unit * 8 * self.__zoom
	local font_scale = utils.get_unit_font_scale() * 6

	local total_width = (self.grid.width + self.indication_width) * cell_size
	local total_height = (self.grid.height + self.indication_height) * cell_size

	local left = width/2-total_width/2 - self.grid_offset_x
	local top = height/2-total_height/2 - self.grid_offset_y

	local grid_left = left+cell_size*self.indication_width
	local grid_top = top+cell_size*self.indication_height

	local x, y = math.floor((x-grid_left)/cell_size+1), math.floor((y-grid_top)/cell_size) +1
	return x, y
end

function wdgt:__cell_in_grid(x, y)
	return not(x<1 or y<1 or x>self.grid.width or y>self.grid.height)
end

function wdgt:click(x, y, width, height)
	local cell_x, cell_y = self:__cell_by_coords(x, y, width, height)
	if self:__cell_in_grid(cell_x, cell_y) then
		self:__toggle_cell(cell_x, cell_y)
	end
end

function wdgt:render(width, height, focus)
	local unit = utils.get_unit()
	local cell_size = unit * 8 * self.__zoom
	local font_scale = utils.get_unit_font_scale() * 6

	local total_width = (self.grid.width + self.indication_width) * cell_size
	local total_height = (self.grid.height + self.indication_height) * cell_size

	local left = width/2-total_width/2 - self.grid_offset_x
	local top = height/2-total_height/2 - self.grid_offset_y

	local grid_left = left+cell_size*self.indication_width
	local grid_top = top+cell_size*self.indication_height

	-- Indications
	local indications = self.level.indications
	for i=1, #indications.rows do
		local row = indications.rows[i]
		local row_len = #row
		local row_left = grid_left - row_len * cell_size
		local completed = self.completed_rows:contains(i)
		for j=1, row_len do
			local cell_left = row_left + (j-1) * cell_size
			local cell_top = grid_top + (i-1) * cell_size
			local indication = row[j]
			self:__drawIndication(cell_left, cell_top, indication, completed)
		end
	end
	for i=1, #indications.cols do
		local col = indications.cols[i]
		local col_len = #col
		local col_top = grid_top - col_len * cell_size
		local completed = self.completed_cols:contains(i)
		for j=1, col_len do
			local indication = col[j]
			local cell_left = grid_left + (i-1) * cell_size
			local cell_top = col_top + (j-1) * cell_size
			self:__drawIndication(cell_left, cell_top, indication, completed)
		end
	end
	-- Grid background
	love.graphics.setColor(0.8, 0.8, 0.8)
	love.graphics.rectangle("fill", grid_left, grid_top, self.grid.width*cell_size, self.grid.height*cell_size)
	-- Grid
	self.grid:render(grid_left, grid_top, cell_size, self.level.palette)
	-- Grid foreground
	for i=0, self.grid.height do
		if i % 5 == 0 or i == self.grid.height then
			love.graphics.setLineWidth(unit/3)
			love.graphics.setColor(0, 0, 0, 0.4)
		else
			love.graphics.setLineWidth(unit/4)
			love.graphics.setColor(0, 0, 0, 0.2)
		end
		love.graphics.line(grid_left, grid_top + i*cell_size, grid_left + self.grid.width*cell_size, grid_top+i*cell_size)
	end

	for j=0, self.grid.width do
		if j % 5 == 0 or j == self.grid.width then
			love.graphics.setLineWidth(unit/3)
			love.graphics.setColor(0, 0, 0, 0.4)
		else
			love.graphics.setLineWidth(unit/4)
			love.graphics.setColor(0, 0, 0, 0.2)
		end
		love.graphics.line(grid_left + j*cell_size, grid_top, grid_left + j*cell_size, grid_top+self.grid.height*cell_size)
	end

	-- Drag line
	if self.draw_drag then
		local drag_start_x = grid_left + (self.draw_drag[1]+1/2-1)*cell_size
		local drag_start_y = grid_top + (self.draw_drag[2]+1/2-1)*cell_size
		local drag_end_x = grid_left + (self.draw_drag[3]+1/2-1)*cell_size
		local drag_end_y = grid_top + (self.draw_drag[4]+1/2-1)*cell_size

		local color = self.level.palette[palette.active_widget.index]
		if color == nil then
			color = {1, 0, 0}
		end
		love.graphics.setColor(color)

		love.graphics.setLineWidth(unit)
		love.graphics.line(drag_start_x, drag_start_y, drag_end_x, drag_end_y)
	end

	-- Focused cell
	if focus == self.id then
		local focus_x = grid_left + (self.grid_x+1/2-1)*cell_size
		local focus_y = grid_top + (self.grid_y+1/2-1)*cell_size
		love.graphics.setColor(0, 0, 0)
		love.graphics.circle("fill", focus_x, focus_y, 1.5*unit*self.__zoom)
		love.graphics.setColor(1, 1, 1)
		love.graphics.circle("fill", focus_x, focus_y, 0.5*unit*self.__zoom)
	end

end

function wdgt:__check_grid()
	if self.grid == self.level.grid then
		profile.set("world-"..self.level.world, self.level.level_name, "completed")
		profile.save()
		viewstack.pushnew("gamefinish", self.level.world, self.level, self.next_levels)
	end
	if profile.get("settings", "hints") then
		for i=1, self.grid.height do
			if self.grid:check_row(self.level.grid, i) then
				self.completed_rows:add(i)
			end
		end
		for i=1, self.grid.width do
			if self.grid:check_col(self.level.grid, i) then
				self.completed_cols:add(i)
			end
		end
	end
end

function wdgt:__toggle_cell(x, y)
	if self.completed_rows:contains(y) or self.completed_cols:contains(x) then
		-- Don't modify a cell if it's on a completed row/col
		return
	end
	local value = palette.active_widget.index
	if value == 0 then -- block
		value = -1
	end
	if self.grid.cells[y][x] == value then
		self.grid.cells[y][x] = 0
	else
		self.grid.cells[y][x] = value
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
		if self.grid_y == self.grid.height then
			return self.focus["down"]
		else
			self.grid_y = self.grid_y + 1
		end
	elseif k == "left" then
		self.grid_x = self.grid_x - 1
		if self.grid_x < 1 then
			self.grid_x = self.grid.width
		end
	elseif k == "right" then
		self.grid_x = self.grid_x + 1
		if self.grid_x > self.grid.width then
			self.grid_x = 1
		end
	elseif k == "space" or k == "return" then
		self:__toggle_cell(self.grid_x, self.grid_y)
	elseif k == "delete" or k == "backspace" then
		self.grid.cells[self.grid_y][self.grid_x] = 0
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
	local errors = self.grid:wrong_cells(self.level.grid)
	if #errors == 0 then
		local revealed = self.grid:random_missing_cell(self.level.grid)
		if revealed then
			self.grid.cells[revealed.y][revealed.x] = revealed.val
			self:__check_grid()
		end
	else
		for _, err in ipairs(errors) do
			self.grid.cells[err.y][err.x] = 0
		end
	end
end

function wdgt:message(message)
	if message == "reset" then
		self.grid = grid.new(self.level.grid.width, self.level.grid.height)
	elseif message == "hint" then
		self:hint()
	end
end

function wdgt:drag(event, width, height)
	local start_x, start_y = self:__cell_by_coords(event.startx, event.starty, width, height)
	if not self:__cell_in_grid(start_x, start_y) then
		return
	end
	local drag_x, drag_y = self:__cell_by_coords(event.x, event.y, width, height)

	local line_x, line_y = drag_x, start_y
	local col_x, col_y = start_x, drag_y

	local dist_line = input_utils.distance_coords(line_x, line_y, drag_x, drag_y)
	local dist_col = input_utils.distance_coords(col_x, col_y, drag_x, drag_y)

	local end_x, end_y
	local drag_dir

	if dist_line < dist_col then -- use "line drag"
		end_x = line_x
		end_y = line_y
		drag_dir = "line"
	else -- use "col drag"
		end_x = col_x
		end_y = col_y
		drag_dir = "col"
	end

	end_x = base_utils.clamp(end_x, 1, self.grid.width)
	end_y = base_utils.clamp(end_y, 1, self.grid.height)

	if event.final then
		local color = palette.active_widget.index
		if color == 0 then
			color = -1
		end

		if drag_dir == "line" then
			--TODO do not override cell if color == -1
			for x=start_x, end_x, start_x > end_x and -1 or 1 do
				self.grid.cells[start_y][x] = color
			end
		else
			for y=start_y, end_y, start_y > end_y and -1 or 1 do
				self.grid.cells[y][start_x] = color
			end
		end

		self:__check_grid()
		self.draw_drag = nil
	else
		self.draw_drag = {start_x, start_y, end_x, end_y}
	end
end

function wdgt:scroll(x, y)
	self.grid_offset_x = self.grid_offset_x - x-- / self.__zoom
	self.grid_offset_y = self.grid_offset_y - y-- / self.__zoom
end

return wdgt
