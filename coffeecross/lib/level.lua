local m = {}
m.__index = m
local set = require("lib.set")

local REQUIRED_PROPERTIES = {"name"}
local PROPERTY_PATTERN = "(%w+)=(.*)"
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

function m:__parse_line(line)
	local output = {}
	local index = 1
	for c in line:gmatch('.') do
		if c:match("%d") then
			local val = tonumber(c)
			if self.__palette[val] == nil then
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

function m:__parse(path)
	local missing_properties = set.new(REQUIRED_PROPERTIES)

	local file = io.open(path)
	local line = file:read("*l")

	while line ~= nil and line ~= "---" do
		property, value = line:match(PROPERTY_PATTERN)
		if property == "name" then
			self.__properties.name = value
		end
		missing_properties:remove(property)
		line = file:read("*l")
	end
	if not missing_properties:empty() then
		error("Invalid level file: Missing properties: "..missing_properties)
	end

	line = file:read("*l")
	while line ~= nil and line ~= "---" do
		self.__palette[#self.__palette+1] = parse_color(line)
		line = file:read("*l")
	end
	if #self.__palette == 0 then
		error("Invalid level file: No colors defined.")
	end

	line = file:read("*l")
	while line ~= nil and line ~= "---" do
		self.__grid[#self.__grid+1] = self:__parse_line(line)
		line = file:read("*l")
	end
	if #self.__grid == 0 then
		error("Invalid level file: empty grid")
	end
	--TODO Check that the dimensions are valid
end

function m.new(path)
	local self = setmetatable({}, m)

	self.__properties = {}
	self.__palette = {}
	self.__grid = {}

	self:__parse(path)

	return self
end

function m:draw(x, y, width)
	for i=1, #self.__grid do
		local row = self.__grid[i]
		for j=1, #row do
			local cell = row[j]
			if cell ~= 0 then
				love.graphics.setColor(self.__palette[cell])
				love.graphics.rectangle("fill", x+(j-1)*width, y+(i-1)*width, width, width)
			end
		end
	end
end

return m
