local class = require("class")
local viewstack = require("viewstack")
local super = require("gui.groups.base")

local group = class.create(super)

function group.__new(self, elm)
	super.__new(self, elm)
	if #self.elements ~= 1 then
		error("Popup groups must contain one and only one element.")
	end
end

function group:render(width, height, focus)
	love.graphics.setColor(0,0,0,0.85)
	love.graphics.rectangle("fill", 0, 0, width, height)

	local element = self.elements[1]

	local e_width = element:auto_width()
	local e_height = element:auto_height()

	local e_left = width/2-e_width/2
	local e_top = height/2-e_height/2

	local s_left, s_top, s_width, s_height = love.graphics.getScissor()

	love.graphics.push()
	love.graphics.setScissor(s_left+e_left, s_top+e_top, e_width, e_height)
	love.graphics.translate(e_left, e_top)
	element:render(e_width, e_height, focus)
	love.graphics.pop()

	love.graphics.setScissor(s_left, s_top, s_width, s_height)
end

function group:keypressed(k, focus)
	if k == "escape" then
		viewstack.pop()
		return focus
	end

	local new_focus = focus

	new_focus = self.elements[1]:keypressed(k, focus) or new_focus

	return new_focus
end


return group
