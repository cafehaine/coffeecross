local m = {}

local PROPERTY_PATTERN = "([%w%-%.]+)=(.*)"
local SECTION_PATTERN = "%-%-%- ?([%w%-%.]+)"

function m.parse_property(line)
	property, value = line:match(PROPERTY_PATTERN)
	if property == nil then
		error("line isn't a valid property declaration.")
	end
	return property, value
end

function m.read_file_sections(path)
	local file = love.filesystem.newFile(path)
	local sections = {}
	local name = nil
	local section = nil
	for line in file:lines() do
		section_name = line:match(SECTION_PATTERN)
		if section_name then
			if name then -- Don't try to save first "nil" section
				sections[name] = section
			end
			section = {}
			name = section_name
		else
			if not section then
				error("Line outside of section.")
			end
			section[#section+1] = line
		end
	end
	if name then
		sections[name] = section
	end

	return sections
end

return m
