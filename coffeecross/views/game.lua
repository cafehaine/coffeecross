local viewstack = require("viewstack")
local level = require("level")
local game = require("gui.widgets.game")

local function hint()
	game.active_widget:hint()
end

function init(level_path, next_levels)
	local lvl = level.new(level_path)
	return {
		gui={
			group_type = "stack",
			elements = {
				{type="background"},
				{
					type="game",
					id="game",
					focus={up="menu", down="pal", tab="pal"},
					level=lvl,
					next_levels = next_levels
				},
				{
					group_type="grid_column",
					grid_layout={"auto",1,"auto"},
					elements={
						{
							group_type="grid_row",
							grid_layout={"auto", 1, "auto"},
							elements = {
								{
									focus={up="pal", down="game", left="hint", right="hint"},
									id="menu",
									type="button",
									text="Menu",
									action=function()viewstack.pushnew("gamepopup")end
								},
								{type="none"},
								{
									focus={left="menu", right="menu"},
									id="hint",
									type="button",
									text="Hint",
									action=hint
								}
							}
						},
						{type="none"},
						{
							group_type="grid_row",
							grid_layout={1,"auto",1},
							elements={
								{type="none"},
								{
									type="palette",
									id="pal",
									focus={up="game", down="menu", tab="game"},
									palette=lvl.palette
								},
								{type="none"}
							}
						}
					}
				}
			}
		},
		opaque=true,
		focus="game",
		keybinds={
			escape=function()viewstack.pushnew("gamepopup")end
		}
	}
end

return init
