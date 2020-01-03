local viewstack = require("viewstack")
local world = require("world")

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

function init()
	local world_listing = love.filesystem.getDirectoryItems("levels/")
	local worlds = {}

	for _,v in ipairs(world_listing) do
		if love.filesystem.getInfo("levels/"..v.."/metadata", "file") then
			worlds[#worlds+1] = world.new(v)
		end
	end

	local grid = {group_type="grid_column"}

	local output = {
		gui={
			group_type = "stack",
			elements = {
				{type="background"},
				{
					group_type="grid_row",
					grid_layout={"auto", 1},
					elements = {
						{
							group_type="grid_column",
							grid_layout={"auto", 1},
							elements={
								{
									type="button",
									id="back",
									focus={right=1},
									text="Back",
									action=viewstack.pop
								},
								{type="none"}
							}
						},
						grid
					}
				}
			}
		},
		opaque=true,
		keybinds={escape=viewstack.pop},
		focus=1
	}

	grid.elements = {}
	grid.grid_layout = {}

	for i,v in ipairs(worlds) do
		grid.elements[i] = {
			focus={up=prev_index(i,worlds),down=next_index(i,worlds), left="back"},
			id=i,
			type="button",
			text=v.name,
			action=function()
				viewstack.pushnew("level_selector", v)
			end
		}
		grid.grid_layout[i] = "auto"
	end

	return output
end

return init
