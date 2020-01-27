local class = require("class")
local viewstack = require("viewstack")
local super = require("gui.groups.base")
local utils = require("gui.utils")
local input_utils = require("input.utils")

local group = class.create("Popup", super)

function group.__new(self, attrs)
	super.__new(self, attrs)

	self.dismissable = attrs.dismissable
	if self.dismissable == nil then
		self.dismissable = true
	end

	if #self.elements ~= 1 then
		error("Popup groups must contain one and only one element.")
	end
end

function group:render(width, height, focus)
	local element = self.elements[1]

	local e_width = element:auto_width()
	local e_height = element:auto_height()

	local e_left = width/2-e_width/2
	local e_top = height/2-e_height/2

	local unit = utils.get_unit()

	-- background
	love.graphics.setColor(0,0,0,0.85)
	love.graphics.rectangle("fill", 0, 0, width, height)
	love.graphics.setColor(0.4, 0.4, 0.4)
	love.graphics.rectangle("fill", e_left-1*unit, e_top-1*unit, e_width+2*unit, e_height+2*unit, 2*unit)
	love.graphics.setColor(0.2, 0.2, 0.2)
	love.graphics.rectangle("fill", e_left, e_top, e_width, e_height, unit)

	local s_left, s_top, s_width, s_height = love.graphics.getScissor()

	love.graphics.push()
	love.graphics.setScissor(s_left+e_left, s_top+e_top, math.max(e_width,0), math.max(e_height,0))
	love.graphics.translate(e_left, e_top)
	element:render(e_width, e_height, focus)
	love.graphics.pop()

	love.graphics.setScissor(s_left, s_top, s_width, s_height)
end

function group:keypressed(k, focus)
	if k == "escape" and self.dismissable then
		viewstack.pop()
		return focus
	end

	local new_focus = focus

	new_focus = self.elements[1]:keypressed(k, focus) or new_focus

	return new_focus
end

function group:click(x, y, width, height)
	local element = self.elements[1]
	local e_width = element:auto_width()
	local e_height = element:auto_height()
	local e_left = width/2-e_width/2
	local e_top = height/2-e_height/2

	if utils.point_in_surface(x, y, e_left, e_top, e_width, e_height) then
		return element:click(x-e_left, y-e_top, e_width, e_height)
	elseif self.dismissable then
		viewstack.pop()
		return true
	end
end

function group:drag(event, width, height)
	local element = self.elements[1]
	local e_width = element:auto_width()
	local e_height = element:auto_height()
	local e_left = width/2-e_width/2
	local e_top = height/2-e_height/2

	if utils.point_in_surface(event.startx, event.starty, e_left, e_top, e_width, e_height) then
		return input_utils.drag_event.new({
			event.startx-e_left,
			event.starty-e_top,
			event.x-e_left,
			event.y-e_top,
			event.final
		})
	elseif self.dismissable then
		viewstack.pop()
		return true
	end
end

return group
