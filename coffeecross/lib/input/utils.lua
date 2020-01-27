local m = {}

local class = require("class")

m.DRAG_THRESHOLD = 1.2

function m.shallow_copy(table)
	local output = {}
	for k, v in pairs(table) do
		output[k] = v
	end
	return output
end

function m.distance_coords(x1, y1, x2, y2)
	local dx = x1 - x2
	local dy = y1 - y2
	return math.sqrt(dx*dx+dy*dy)
end

function m.distance(p1, p2)
	local dx = p1.x - p2.x
	local dy = p1.y - p2.y
	return math.sqrt(dx*dx+dy*dy)
end

m.drag_event = class.create("DragEvent")

function m.drag_event.__new(self, ...)
	local args = {...}

	if #args == 5 or #args == 4 then -- "manual" mode
		self.startx = args[1]
		self.starty = args[2]
		self.x = args[3]
		self.y = args[4]
		self.final = args[5] == true -- handle passing nil
	else
		for _,v in ipairs(args) do
			print(v)
		end
		error("Not implemented")
	end
end

function m.drag_event:__tostring()
	return ("DragEvent: {startx=%d, starty=%d, x=%d, y=%d, final=%s}"):format(self.startx, self.starty, self.x, self.y, self.final)
end
return m
