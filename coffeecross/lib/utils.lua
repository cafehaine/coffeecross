local m = {}

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
