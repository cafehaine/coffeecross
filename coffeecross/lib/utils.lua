local m = {}

local PROPERTY_PATTERN = "(%w+)=(.*)"

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
	local section = {}
	for line in file:lines() do
		if line == "---" then
			sections[#sections+1] = section
			section = {}
		else
			section[#section+1] = line
		end
	end
	sections[#sections+1] = section

	return sections
end

return m
