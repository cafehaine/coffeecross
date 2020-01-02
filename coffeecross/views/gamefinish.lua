local viewstack = require("viewstack")

local gui = {
	group_type = "popup",
	elements = {
		{
			group_type = "grid_column",
			grid_layout = {"auto", "auto", "auto"},
			elements = {
				{type="text", text="Level completed!"},
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
}

return {gui=gui, opaque=false, focus=1}
