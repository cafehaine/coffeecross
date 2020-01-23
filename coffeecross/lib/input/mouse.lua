local m = {}

local viewstack = require("viewstack")
local set = require("set")
local gui_utils = require("gui.utils")
local utils = require("input.utils")

local STATES={
	NONE="NONE",
	INVALID="INVALID",
	SCROLL="DRAG",
}
BUTTONS = set.new({1, 2, 3})

local state = STATES.NONE
local action_button = nil
local startx = nil
local starty = nil
local x = nil
local y = nil

function m.pressed(x, y, button)
	if not BUTTONS:contains(button) then return end
	if action_button ~= nil then
		state = STATES.INVALID
		return
	end
	state = STATES.NONE
	action_button = button
	startx = x
	starty = y
	x = x
	y = y
end

function m.released(x, y, button)
	if not BUTTONS:contains(button) then return end
	if state == STATES.INVALID and love.mouse.isDown(unpack(BUTTONS:values())) then
		state=STATES.NONE
		return
	end
	if state == STATES.NONE then
		if button == 1 then
			viewstack.click(x, y)
		elseif button == 2 then
			--TODO scroll tool? (kinda like firefox on windows)
		elseif button == 3 then
			--TODO zoom tool?
		end
	elseif state == STATES.DRAG then
		if button == 1 then
			viewstack.drag({startx, startx, x, y})
		end
	end
	action_button = nil
end

function m.moved(newx, newy, dx, dy)
	if action_button == nil then
		return
	end
	x = newx
	y = newy
	if state == STATES.NONE and utils.distance_coords(startx, starty, x, y) > gui_utils.get_unit() * utils.DRAG_THRESHOLD then
		state = STATES.DRAG
	end

	if state == STATES.DRAG then
		if action_button == 1 then
			viewstack.drag({startx, starty, x, y})
		elseif action_button == 2 then
			viewstack.scroll(dx, dy)
		elseif action_button == 3 and dy ~= 0 then
			viewstack.zoom(-dy/80)
		end
	end
end

function m.wheel(dx, dy)
	if love.keyboard.isDown("lctrl") and dy ~= 0 then
		viewstack.zoom(dy/100)
	else
		viewstack.scroll(dx, dy)
	end
end

return m
