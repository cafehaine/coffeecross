local m = {}

local DATA = {}

function m.load()
	
end

function m.save()
	local lines = {}
	for k, v in pairs(DATA) do
		lines[#lines+1] = k.."="..v
	end
	love.filesystem.write("config.txt", table.concat(lines, "\n"))
end

function m.get(key)
	return DATA[key]
end

function m.set(key, value)
	DATA[key] = value
end

return m
