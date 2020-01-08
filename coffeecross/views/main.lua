local viewstack = require("viewstack")

local gui = {
	group_type = "stack",
	elements = {
		{type="background"},
		{
			group_type = "grid_row",
			grid_layout = {"auto", 1, "auto"},
			elements = {
				{
					group_type = "grid_column",
					grid_layout = {1,"auto","auto", "auto", "auto"},
					elements = {
						{type="image", image="logo.png", mode="contain"},
						{
							id=1,
							focus={up=3,down=2,left="gh",right="gh"},
							type="button",
							text="Levels",
							action=function()viewstack.pushnew("world_selector")end
						},
						{
							id=2,
							focus={up=1,down=3,left="gh",right="gh"},
							type="button",
							text="Settings",
							action=function()viewstack.pushnew("settings")end
						},
						{
							id=3,
							focus={up=2,down=1,left="gh",right="gh"},
							type="button",
							text="Exit",
							action=viewstack.pop
						},
						{type="text",text="CoffeeCross, alpha 0.1"}
					}
				},
				{type="none"},
				{
					group_type="grid_column",
					grid_layout={1,"auto"},
					elements={
						{type="none"},
						{
							id="gh",
							focus={left=1, right=1},
							type="button",
							text="Github",
							action=function()love.system.openURL("https://github.com/cafehaine/coffeecross")end
						}
					}
				}
			}
		}
	}
}

return {gui=gui, opaque=true, focus=1}
