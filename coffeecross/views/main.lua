local viewstack = require("viewstack")

local gui = {
	group_type = "grid_row",
	grid_layout = {"auto", 1},
	elements = {
		{
			group_type = "grid_column",
			grid_layout = {1,"auto","auto", "auto"},
			elements = {
				{type="image", image="logo.png", mode="contain"},
				{
					id=1,
					focus={up=2,down=2},
					type="button",
					text="LevelsAé",
					action=function()end
				},
				{
					id=2,
					focus={up=1,down=1},
					type="button",
					text="ExitAé",
					action=viewstack.pop
				},
				{
					type="text",
					text="CoffeeCross, alpha 0.1Aé"
				}
			}
		},
		{type="none"}
	}
}

return {gui=gui, opaque=true, focus=1}
