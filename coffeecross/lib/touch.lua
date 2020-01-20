local m = {}
local viewstack = require("viewstack")

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
local gesture_points = 0
local state = STATES.NONE
local time = 0

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
	points[id] = {startx=x, starty=y, time = time}
end

function m.up(id, x, y)
	if not points[id] then
		return
	end
	point_count = point_count - 1
	if point_count == 0 then
		if state == STATES.NONE then
			viewstack.mousepressed(x, y, 1)
			print("CLICK", x, y)
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

	if state == STATES.NONE then
		state = STATES.SCROLL
	end

	if state == STATES.SCROLL then
		-- divide by unit ?
		viewstack.scroll(dx, dy)
		print(state, dx, dy)
	elseif state == STATES.ZOOM then
		-- TODO maths
		print(state)
	elseif state == STATES.DRAG then
		viewstack.drag(dx, dy)
		print(state, dx, dy)
	end
end

return m
