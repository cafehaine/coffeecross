local class = require("class")
local utils = require("utils")

local world = class.create()

function world.__new(self, path)
	self.path = path

	local sections = utils.read_file_sections("levels/"..path.."/metadata")
	if not sections.properties then
		error("World files must have 1 sections, file has "..#sections)
	end

	for _, line in ipairs(sections.properties) do
		property, value = utils.parse_property(line)
		if property == "name" then
			self.name = value
		end
	end

	if not self.name then
		error("World has no name.")
	end
end

return world
