local m = {}
local viewstack = require("viewstack")
local gui_utils = require("gui.utils")

local HOLD_TIME = 0.5

local STATES={
	NONE="NONE",
	INVALID="INVALID",
	SCROLL="SCROLL",
	DRAG="DRAG",
	ZOOM="ZOOM",
}

local points = {}
local point_count = 0
local state = STATES.NONE
local time = 0

local function __shallow_copy(table)
	local output = {}
	for k, v in pairs(table) do
		output[k] = v
	end
	return output
end

local function __point_list()
	local list = {}
	for _,v in pairs(points) do
		list[#list+1] = v
	end
	return list
end

local function __distance_coords(x1, y1, x2, y2)
	local dx = x1 - x2
	local dy = y1 - x2
	return math.sqrt(dx*dx+dy*dy)
end

local function __distance(p1, p2)
	local dx = p1.x - p2.x
	local dy = p1.y - p2.y
	return math.sqrt(dx*dx+dy*dy)
end

function m.update(dt)
	if state == STATES.NONE then
		time = time+dt
		-- there should be only one but we don't know it's id.
		for k, point in pairs(points) do
			if time - point.time > HOLD_TIME then
				state = STATES.DRAG
			end
		end
	end
end

function m.down(id, x, y)
	if point_count == 0 then
		time = 0
	end
	if point_count >= 2 or point_count == 1 and state == STATES.DRAG then
		state = STATES.INVALID
		return
	end
	point_count = point_count + 1
	if point_count == 2 then
		state = STATES.ZOOM
	end
	points[id] = {startx=x, starty=y, x=x, y=y, time=time}
end

function m.up(id, x, y)
	if not points[id] then
		return
	end
	point_count = point_count - 1
	if point_count == 0 then
		if state == STATES.NONE then
			viewstack.mousepressed(x, y, 1)
		end
		state = STATES.NONE
	elseif point_count == 1 then
		state = STATES.SCROLL
	end
	points[id] = nil
end

function m.moved(id, x, y, dx, dy)
	if not points[id] then
		return
	end
	local point = points[id]
	local new_point = __shallow_copy(point)
	new_point.x = x
	new_point.y = y

	if state == STATES.NONE and __distance_coords(point.startx, point.starty, x, y) > gui_utils.get_unit() then
		state = STATES.SCROLL
	end

	if state == STATES.SCROLL then
		-- divide by unit ?
		viewstack.scroll(dx, dy)
	elseif state == STATES.ZOOM then
		local list = __point_list()
		-- p1 = moved point, p2 = the other one
		local p1 = point == list[1] and list[1] or list[2]
		local p2 = point == list[1] and list[2] or list[1]
		local dist_before = __distance(p1, p2)
		local dist_after = __distance(new_point, p2)
		viewstack.zoom((dist_after-dist_before)/100)
	elseif state == STATES.DRAG then
		viewstack.drag(new_point)
	end

	points[id] = new_point
end

return m
