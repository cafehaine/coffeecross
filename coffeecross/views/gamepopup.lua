local viewstack = require("viewstack")

local gui = {
	group_type = "popup",
	elements = {
		{
			group_type = "grid_column",
			grid_layout = {"auto", "auto", "auto"},
			elements = {
				{
					id=1,
					focus={up=3,down=2},
					type="button",
					text="Reset level",
					action=function()end
				},
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
}

return {gui=gui, opaque=false, focus=1}
