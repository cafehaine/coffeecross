local m = {}

local serdes = require("serdes")
local utils = require("utils")

local data = {}
local PROFILE_PATH = "profile.txt"

function m.load()
	if not love.filesystem.getInfo(PROFILE_PATH) then
		return
	end
	local sections = utils.read_file_sections(PROFILE_PATH)
	for section_name, lines in pairs(sections) do
		local section = {}
		for _, line in ipairs(lines) do
			local key, value = utils.parse_property(line)
			section[key] = serdes.deserialize(value)
		end
		data[section_name] = section
	end
end

function m.save()
	local lines = {}
	for label, section in pairs(data) do
		lines[#lines+1] = "--- "..label
		for k, v in pairs(section) do
			lines[#lines+1] = k.."="..serdes.serialize(v)
		end
	end
	love.filesystem.write(PROFILE_PATH, table.concat(lines, "\n"))
end

function m.get(section, key)
	if not data[section] then
		return nil
	end
	return data[section][key]
end

function m.set(section, key, value)
	local sec = data[section]
	if sec == nil then
		data[section] = {}
		sec = data[section]
	end
	sec[key] = value
end

return m
