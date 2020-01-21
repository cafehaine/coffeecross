local viewstack = require("viewstack")

local toggles = {
	{"Animations", "settings", "animations"},
	{"Hints", "settings", "hints"},
	{"Anti-aliasing", "settings", "msaa"},
}

local function prev_index(id)
	if id == 1 then
		return #toggles
	end
	return id-1
end

local function next_index(id)
	if id == #toggles then
		return 1
	end
	return id+1
end


local function gen_toggle(id)
	return {
		group_type = "grid_row",
		grid_layout = {"auto", "auto"},
		elements = {
			{type="text", text=toggles[id][1]},
			{
				type="toggle",
				id=id,
				focus={up=prev_index(id), down=next_index(id)},
				profile_section=toggles[id][2],
				profile_key=toggles[id][3],
			}
		}
	}
end

local gui = {
	group_type = "popup",
	elements = {
		{
			group_type = "grid_column",
			grid_layout = {"auto", "auto", "auto", "auto"},
			elements = {
				{type="text", text="Settings"},
				gen_toggle(1),
				gen_toggle(2),
				gen_toggle(3),
			}
		}
	}
}

return {gui=gui, opaque=false, focus=1}
