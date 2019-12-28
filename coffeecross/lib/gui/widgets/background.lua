local class = require("class")
local widgets_base = require("gui.widgets.base")

local wdgt = class.create(widgets_base)

function wdgt.__new(obj, attrs)
	widgets_base.__new(obj, attrs)
end

function wdgt:auto_width()
	return 0
end

function wdgt:auto_height()
	return 0
end

function wdgt:render(width, height)
	love.graphics.clear(0.7, 0.5, 0.3)
end

return wdgt
