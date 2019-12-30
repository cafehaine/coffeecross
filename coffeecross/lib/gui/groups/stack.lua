local class = require("class")
local super = require("gui.groups.base")

local group = class.create(super)

function group.__new(self, elm)
	super.__new(self, elm)
end

function group:auto_width()
	local max = 0
	for i=1, #self.elements do
		max = math.max(total, self.elements[i]:auto_width())
	end
	return max
end

function group:auto_height()
	local max = 0
	for i=1, #self.elements do
		max = math.max(total, self.elements[i]:auto_width())
	end
	return max
end

function group:render(width, height, focus)
	for i=1, #self.elements do
		self.elements[i]:render(width, height, focus)
	end
end

return group
