local m = {}

local serdes = require("serdes")

local DATA = {}

function m.load()
	--TODO
end

function m.save()
	local lines = {}
	for label, section in pairs(DATA) do
		lines[#lines+1] = "--- "..label
		for k, v in pairs(section) do
			lines[#lines+1] = k.."="..serdes.serialize(v)
		end
	end
	love.filesystem.write("profile.txt", table.concat(lines, "\n"))
end

function m.get(section, key)
	if not DATA[section] then
		return nil
	end
	return DATA[section][key]
end

function m.set(section, key, value)
	local sec = DATA[section]
	if sec == nil then
		DATA[section] = {}
		sec = DATA[section]
	end
	sec[key] = value
end

return m
