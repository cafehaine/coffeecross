local class = require("class")

local set = class.create()

function set.__new(obj, vals)
	obj.__values = {}
	obj.__count = 0

	if vals == nil then
		vals = {}
	end

	for _,v in ipairs(vals) do
		obj:add(v)
	end
end

function set:contains(val)
	return self.__values[val] == true
end

function set:add(val)
	if not self.__values[val] then
		self.__values[val] = true
		self.__count = self.__count + 1
	end
end

function set:remove(val)
	if self.__values[val] then
		self.__values[val] = nil
		self.__count = self.__count - 1
	end
end

function set:empty()
	return self.__count == 0
end

-- __len doesn't work in lua 5.1
function set:len()
	return self.__count
end

function set:values()
	local output = {}
	local index = 1
	for val, b in pairs(self.__values) do
		output[index] = val
		index = index + 1
	end
	return output
end

function set:__tostring()
	local strings = {}
	for i, val in ipairs(self:values()) do
		if type(val) == "string" then
			strings[i] = ("%q"):format(val)
		else
			strings[i] = tostring(val)
		end
	end
	return ("{%s}"):format(table.concat(strings, ', '))
end

return set
