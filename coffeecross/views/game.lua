local viewstack = require("viewstack")
local level = require("level")

function init(level_path)
	local lvl = level.new(level_path)
	return {gui={
		group_type = "stack",
		elements = {
			{type="background"},
			{
				type="game",
				id="game",
				focus={up="pal", down="pal"},
				level=lvl
			},
			{
				group_type="grid_column",
				grid_layout={1,"auto"},
				elements={
					{type="none"},
					{
						type="palette",
						id="pal",
						focus={up="game", down="game"},
						palette=lvl.__palette
					}
				}
			}
		}
	}, opaque=true, focus=1}
end

return init
