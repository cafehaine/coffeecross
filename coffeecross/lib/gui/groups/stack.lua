local class = require("class")
local groups_base = require("gui.groups.base")

local group = class.create(groups_base)

function group.__new(obj, elm)
	groups_base.__new(obj, elm)
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
