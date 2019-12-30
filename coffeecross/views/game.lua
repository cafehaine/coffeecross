local viewstack = require("viewstack")
local level = require("level")

function init(level_path)
	return {gui={
		group_type = "stack",
		elements = {
			{type="background"},
			{type="game", level=level.new(level_path)}
		}
	}, opaque=true, focus=1}
end

return init
