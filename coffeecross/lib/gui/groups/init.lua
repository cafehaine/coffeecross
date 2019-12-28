local set = require("set")
local GROUPS = set.new({"grid_row", "grid_column", "stack", "popup"})

local m = {}

function m.is_valid(group_name)
	return GROUPS:contains(group_name)
end

function m.new(group)
	if m.is_valid(group.group_type) then
		return require("gui.groups."..group.group_type).new(group)
	else
		error("Unknown group type: "..group.group_type)
	end
end

return m
