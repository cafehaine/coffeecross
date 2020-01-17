local class = require("class")
local super = require("gui.widgets.base")

local wdgt = class.create("Fireworks", super)

function wdgt.__new() end

function wdgt:auto_width()
	return 0
end

function wdgt:auto_height()
	return 0
end

function wdgt:render() end

return wdgt
