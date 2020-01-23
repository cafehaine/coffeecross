local m = {}

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

return m
