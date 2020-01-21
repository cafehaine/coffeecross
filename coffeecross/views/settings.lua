local viewstack = require("viewstack")

local gui = {
	group_type = "popup",
	elements = {
		{
			group_type = "grid_column",
			grid_layout = {"auto", "auto", "auto", "auto"},
			elements = {
				{type="text", text="Settings"},
				{
					group_type = "grid_row",
					grid_layout = {"auto", "auto"},
					elements = {
						{type="text", text="Animations"},
						{
							type="toggle",
							id=1,
							focus={up=3, down=2},
							profile_section="settings",
							profile_key="animations",
						}
					},
				},
				{
					group_type = "grid_row",
					grid_layout = {"auto", "auto"},
					elements = {
						{type="text", text="Hints"},
						{
							type="toggle",
							id=2,
							focus={up=1, down=3},
							profile_section="settings",
							profile_key="hints",
						}
					},
				},
				{
					id=3,
					focus={up=2,down=1},
					type="button",
					text="Audio",
					action=function()end
				}
			}
		}
	}
}

return {gui=gui, opaque=false, focus=1}
