local viewstack = require("viewstack")

function init(level)
	local gui = {
		group_type = "stack",
		elements = {
			{
				group_type = "popup",
				elements = {
					{
						group_type = "grid_column",
						grid_layout = {"auto", "auto", "auto", "auto", "auto"},
						elements = {
							{type="text", text="Level completed!"},
							{type="text", text=level.properties.name},
							{type="level_preview", grid=level.grid, palette=level.palette},
							{
								id=1,
								focus={up=2,down=2},
								type="button",
								text="Go back to level selection",
								action=function()viewstack.pop()viewstack.pop()end
							},
							{
								id=2,
								focus={up=1,down=1},
								type="button",
								text="Exit to main menu",
								action=viewstack.clear
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
