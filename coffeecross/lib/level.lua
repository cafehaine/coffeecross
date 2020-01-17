local set = require("set")
local class = require("class")
local utils = require("utils")
local grid = require("grid")

local level = class.create()

local REQUIRED_PROPERTIES = {"name"}
local HEX_DIGITS = {
	["0"] = 0,
	["1"] = 1,
	["2"] = 2,
	["3"] = 3,
	["4"] = 4,
	["5"] = 5,
	["6"] = 6,
	["7"] = 7,
	["8"] = 8,
	["9"] = 9,
	["a"] = 10,
	["b"] = 11,
	["c"] = 12,
	["d"] = 13,
	["e"] = 14,
	["f"] = 15,
}

local function parse_hex_number(number)
	local output = 0
	for c in number:gmatch(".") do
		output = output * 16 + HEX_DIGITS[c:lower()]
	end
	return output
end

local function parse_color(color)
	local r_h, g_h, b_h = color:match("#(%x%x)(%x%x)(%x%x)")
	local r,g,b = parse_hex_number(r_h), parse_hex_number(g_h), parse_hex_number(b_h)
	return {r/255, g/255, b/255}
end

function level:__parse_line(line)
	local output = {}
	local index = 1
	for c in line:gmatch('.') do
		if c:match("%d") then
			local val = tonumber(c)
			if self.palette[val] == nil then
				error("Invalid level: Undefined color: "..c)
			end
			output[index] = val
		else
			output[index] = 0
		end
		index = index + 1
	end
	if index == 1 then
		error("Invalid level: Empty grid line")
	end
	return output
end

local _current, _count, _indications

local function _reset_generate()
	_current = 0
	_count = 0
	_indications = {}
end

local function _generate(cell)
	if _current ~= cell then
		if _current ~= 0 then
			_indications[#_indications+1] = {color=_current, count=_count}
		end
		_current = cell
		_count = 1
	else
		_count = _count + 1
	end
end

function level:__generate_indications()
	for i=1, self.grid.height do
		_reset_generate()
		for j=1, self.grid.width do
			_generate(self.grid.cells[i][j])
		end
		_generate(nil)
		self.indications.rows[#self.indications.rows+1] = _indications
	end
	for j=1, self.grid.width do
		_reset_generate()
		for i=1, self.grid.height do
			_generate(self.grid.cells[i][j])
		end
		_generate(nil)
		self.indications.cols[#self.indications.cols+1] = _indications
	end
end

function level:__parse(path)
	local missing_properties = set.new(REQUIRED_PROPERTIES)

	local sections = utils.read_file_sections(path)
	if not sections.properties or not sections.palette or not sections.level then
		error("level files must have 3 sections: 'properties', 'palette' and 'level'.")
	end

	for _, line in ipairs(sections.properties) do
		property, value = utils.parse_property(line)
		if property == "name" then
			self.properties.name = value
		end
		missing_properties:remove(property)
	end
	if not missing_properties:empty() then
		error("Invalid level file: Missing properties: "..tostring(missing_properties))
	end

	for _, line in ipairs(sections.palette) do
		self.palette[#self.palette+1] = parse_color(line)
	end
	if #self.palette == 0 then
		error("Invalid level file: No colors defined.")
	end

	local grid_lines = {}
	for _, line in ipairs(sections.level) do
		grid_lines[#grid_lines+1] = self:__parse_line(line)
	end
	if #grid_lines == 0 then
		error("Invalid level file: empty grid")
	end

	self.grid = grid.new(#grid_lines[1], #grid_lines, grid_lines)
	self:__generate_indications()
end

function level.__new(self, path)
	self.properties = {}
	self.palette = {}
	self.indications = {rows={}, cols={}}

	self:__parse(path)

	return self
end

return level
