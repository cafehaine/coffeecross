local m = {}
local widgets = require("gui.widgets")
local groups = require("gui.groups")
m.__index = m

function m.new(elm)
	local self = setmetatable({}, m)
	self.layout = elm.grid_layout
	self.elements = {}
	for i, elm in ipairs(elm.elements) do
		if elm.type then
			self.elements[i] = widgets.new(elm)
		elseif elm.group_type then
			self.elements[i] = groups.new(elm)
		else
			error("Element is neither an element or a group.")
		end
	end

	return self
end

function m:auto_height()
	local total = 0
	for i=1, #self.layout do
		if self.layout[i] == "auto" then
			total = total + self.elements[i]:auto_height()
		else
			error("Cannot compute auto_height for group if not all elements are of size auto.")
		end
	end
	return total
end

function m:auto_width()
	local max = 0
	for i=1, #self.layout do
		local width = self.elements[i]:auto_width()
		if width > max then max = width end
	end
	return max
end

function m:render(width, height)
	local total_auto = 0
	local total_fracs = 0
	local heights = {}
	for i=1, #self.layout do
		if self.layout[i] == "auto" then
			local elm_height = self.elements[i]:auto_height()
			total_auto = total_auto + elm_height
			heights[i] = elm_height
		elseif type(self.layout[i]) == "number" then
			total_fracs = total_fracs + self.layout[i]
		else
			error("Unknown layout indication '"..self.layout[i].."'")
		end
	end

	local left, top = love.graphics.getScissor( )
	local top_pos = 0
	for i=1, #self.layout do
		local elm_height = heights[i] or (height - total_auto)/total_fracs*self.layout[i]

		love.graphics.push()
		love.graphics.setScissor(left, top + top_pos, width, elm_height)
		love.graphics.translate(0, top_pos)

		self.elements[i]:render(width, elm_height)

		top_pos = top_pos + elm_height
		love.graphics.pop()
	end
end

return m
