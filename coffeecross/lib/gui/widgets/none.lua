local class = require("class")
local widgets_base = require("gui.widgets.base")

local wdgt = class.create(widgets_base)

function wdgt.__new() end

function wdgt:auto_width()
	return 0
end

function wdgt:auto_height()
	return 0
end

function wdgt:render() end

return wdgt
