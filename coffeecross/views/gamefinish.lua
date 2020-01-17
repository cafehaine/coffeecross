local viewstack = require("viewstack")

local function skip_first(table)
	local output = {}
	for i=2, #table do
		output[#output+1] = table[i]
	end
	return output
end

function init(world, level, next_levels)
	local next_level_button = {
		id=1,
		focus={up=3, down=2},
		type="button",
	}

	if #next_levels > 0 then
		next_level_button.text = "Next level"
		next_level_button.action = function()
			viewstack.pop_to_view("level_selector")
			viewstack.pushnew("game", world, next_levels[1], skip_first(next_levels))
		end
	else
		next_level_button.text = "Go back to world selection"
		next_level_button.action = function()
			viewstack.pop_to_view("world_selector")
		end
	end

	local gui = {
		group_type = "stack",
		elements = {
			{
				group_type = "popup",
				elements = {
					{
						group_type = "grid_column",
						grid_layout = {"auto", "auto", "auto", "auto", "auto", "auto"},
						elements = {
							{type="text", text="Level completed!"},
							{type="text", text=level.properties.name},
							{type="level_preview", grid=level.grid, palette=level.palette},
							next_level_button,
							{
								id=2,
								focus={up=1,down=3},
								type="button",
								text="Go back to level selection",
								action=function()viewstack.pop_to_view("level_selector")end
							},
							{
								id=3,
								focus={up=2,down=1},
								type="button",
								text="Exit to main menu",
								action=function()viewstack.pop_to_view("main")end
							}
						}
					}
				}
			},
			{
				type="fireworks"
			}
		}
	}
	return {gui=gui, opaque=false, focus=1}
end

return init
