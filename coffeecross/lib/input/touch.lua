local m = {}
local viewstack = require("viewstack")
local gui_utils = require("gui.utils")
local utils = require("input.utils")

local HOLD_TIME = 0.5
local VIBRATION_DURATION=0.05

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

local function __point_list()
	local list = {}
	for _,v in pairs(points) do
		list[#list+1] = v
	end
	return list
end

function m.update(dt)
	if state == STATES.NONE then
		time = time+dt
		-- there should be only one but we don't know it's id.
		for k, point in pairs(points) do
			if time - point.time > HOLD_TIME then
				state = STATES.DRAG
				love.system.vibrate(VIBRATION_DURATION)
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
	local point = points[id]
	point_count = point_count - 1
	if point_count == 0 then
		if state == STATES.NONE then
			viewstack.click(x, y)
		elseif state == STATES.DRAG then
			local event = utils.drag_event.new(point.startx, point.starty, x, y, true)
			viewstack.drag(event)
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
	local new_point = utils.shallow_copy(point)
	new_point.x = x
	new_point.y = y

	if state == STATES.NONE and utils.distance_coords(point.startx, point.starty, x, y) > gui_utils.get_unit() * utils.DRAG_THRESHOLD then
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
		local dist_before = utils.distance(p1, p2)
		local dist_after = utils.distance(new_point, p2)
		viewstack.zoom((dist_after-dist_before)/100)
	elseif state == STATES.DRAG then
		local event = utils.drag_event.new(new_point.startx, new_point.starty, new_point.x, new_point.y, false)
		viewstack.drag(event)
	end

	points[id] = new_point
end

return m
