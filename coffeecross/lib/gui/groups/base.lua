local class = require("class")
local widgets = require("gui.widgets")
local groups = require("gui.groups")

local base = class.create()

function base.__new(obj, elm)
	obj.elements = {}
	for i, elm in ipairs(elm.elements) do
		if elm.type then
			obj.elements[i] = widgets.new(elm)
		elseif elm.group_type then
			obj.elements[i] = groups.new(elm)
		else
			error("Element is neither an widget or a group.")
		end
	end

	return obj
end

function base:auto_width()
	error("Not implemented.")
end

function base:auto_height()
	error("Not implemented.")
end

function base:render()
	error("Not implemented")
end

function base:keypressed(k, focus)
	local new_focus = focus

	for i=1, #self.elements do
		new_focus = self.elements[i]:keypressed(k, focus) or new_focus
	end

	return new_focus
end

return base
