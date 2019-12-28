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
			error("Element is neither an widget or a group.")
		end
	end

	return self
end

function m:auto_width()
	local total = 0
	for i=1, #self.layout do
		if self.layout[i] == "auto" then
			total = total + self.elements[i]:auto_width()
		else
			error("Cannot compute auto_width for group if not all elements are of size auto.")
		end
	end
	return total
end

function m:auto_height()
	local max = 0
	for i=1, #self.layout do
		local height = self.elements[i]:auto_height()
		if height > max then max = height end
	end
	return max
end

function m:render(width, height, focus)
	local total_auto = 0
	local total_fracs = 0
	local widths = {}
	for i=1, #self.layout do
		if self.layout[i] == "auto" then
			local elm_width = self.elements[i]:auto_width()
			total_auto = total_auto + elm_width
			widths[i] = elm_width
		elseif type(self.layout[i]) == "number" then
			total_fracs = total_fracs + self.layout[i]
		else
			error("Unknown layout indication '"..self.layout[i].."'")
		end
	end

	local left, top, sc_width, sc_height = love.graphics.getScissor( )
	local left_pos = 0
	for i=1, #self.layout do
		local elm_width = widths[i] or (width - total_auto)/total_fracs*self.layout[i]

		love.graphics.push()
		love.graphics.setScissor(left_pos + left, top, elm_width, height)
		love.graphics.translate(left_pos, 0)

		self.elements[i]:render(elm_width, height, focus)

		left_pos = left_pos + elm_width
		love.graphics.pop()
	end
	love.graphics.setScissor(left, top, sc_width, sc_height)
end

function m:keypressed(k, focus)
	local new_focus = focus

	for i=1, #self.layout do
		new_focus = self.elements[i]:keypressed(k, focus) or new_focus
	end

	return new_focus
end

return m
