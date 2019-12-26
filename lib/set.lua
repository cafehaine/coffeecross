local m = {}
m.__index = m

function m.new(vals)
	local self = setmetatable({}, m)
	self.__type = "set"
	self.__values = {}
	self.__count = 0

	for _,v in ipairs(vals) do
		self:add(v)
	end

	return self
end

function m:contains(val)
	return self.__values[val] == true
end

function m:add(val)
	if not self.__values[val] then
		self.__values[val] = true
		self.__count = self.__count + 1
	end
end

function m:remove(val)
	if self.__values[val] then
		self.__values[val] = nil
		self.__count = self.__count - 1
	end
end

function m:empty()
	return self.__count == 0
end

-- __len doesn't work in lua 5.1
function m:len()
	return self.__count
end

function m:values()
	local output = {}
	local index = 1
	for val, b in pairs(self.__values) do
		output[index] = val
		index = index + 1
	end
	return output
end

function m.__concat(a,b)
	if type(a) == "table" and a.__type == "set" then
		a = tostring(a)
	end

	if type(b) == "table" and b.__type == "set" then
		b = tostring(b)
	end

	return a..b
end

function m:__tostring()
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

return m
