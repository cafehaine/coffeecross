local viewstack = require("viewstack")

return {
	group_type = "grid_row",
	grid_layout = {"auto", 1},
	elements = {
		{
			group_type = "grid_column",
			grid_layout = {1,"auto","auto"},
			elements = {
				{type="image", image="logo"},
				{
					type="button",
					text="Levels",
					action=function()end
				},
				{
					type="button",
					text="Exit",
					action=viewstack.pop
				}
			}
		},
		{type="none"}
	}
}
