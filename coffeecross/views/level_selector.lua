local viewstack = require("viewstack")
local level = require("level")

local function next_index(i, table)
	i=i+1

	if i>#table then
		i=1
	end

	return i
end

local function prev_index(i, table)
	i = i-1

	if i<1 then
		i=#table
	end

	return i
end

function init(world)
	local world_path = "levels/"..world.path
	local levels_listing = love.filesystem.getDirectoryItems(world_path)
	local levels = {}

	for _,v in ipairs(levels_listing) do
		if v:match("%d%d%.txt") and love.filesystem.getInfo(world_path.."/"..v, "file") then
			levels[#levels+1] = world_path.."/"..v
		end
	end

	local output = {
		gui={
			group_type = "stack",
			elements = {
				{type="background"},
				{group_type="grid_column"}
			}
		},
		opaque=true,
		keybinds={escape=viewstack.pop},
		focus=1
	}

	local grid = output.gui.elements[2]

	grid.elements = {}
	grid.grid_layout = {}

	for i,v in ipairs(levels) do
		grid.elements[i] = {
			focus={up=prev_index(i,levels),down=next_index(i,levels)},
			id=i,
			type="button",
			text=tostring(i),
			action=function()
				viewstack.pushnew("game", v)
			end
		}
		grid.grid_layout[i] = "auto"
	end

	return output
end

return init
