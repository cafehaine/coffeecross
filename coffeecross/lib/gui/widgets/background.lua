local class = require("class")
local super = require("gui.widgets.base")

local wdgt = class.create(super)

function wdgt.__new(self, attrs)
	super.__new(self, attrs)
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
