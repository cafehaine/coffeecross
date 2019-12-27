local m = {}
m.__index = m

function m.new(path)
	local self = setmetatable({}, m)

	local chunk = love.filesystem.load("views/"..path..".lua")

	self.widgets = chunk()

	return self
end

function m:render()

end

function m:update(dt)

end

return m

