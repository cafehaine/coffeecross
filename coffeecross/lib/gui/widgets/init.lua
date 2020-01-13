local set = require("set")
local WIDGETS = set.new({"button", "none", "text", "image", "background",
                         "game", "palette", "fireworks", "level_preview"})

local m = {}

function m.is_valid(widget_name)
	return WIDGETS:contains(widget_name)
end

function m.new(widget)
	if m.is_valid(widget.type) then
		return require("gui.widgets."..widget.type).new(widget)
	else
		error("Unknown widget type: "..widget.type)
	end
end

return m
