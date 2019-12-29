local viewstack = require("viewstack")

local gui = {
	group_type = "popup",
	elements = {
		{
			group_type = "grid_column",
			grid_layout = {"auto", "auto", "auto"},
			elements = {
				{type="text", text="Settings"},
				{
					id=1,
					focus={up=2,down=2},
					type="button",
					text="Display",
					action=function()end
				},
				{
					id=2,
					focus={up=1,down=1},
					type="button",
					text="Audio",
					action=function()end
				}
			}
		}
	}
}

return {gui=gui, opaque=false, focus=1}
