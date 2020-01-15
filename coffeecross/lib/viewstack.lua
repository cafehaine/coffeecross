local m = {}
local view = require("view")
local stack = {}
local stack_index = 0
local showfocus = true
local debug = false
local transitioning = false
local transition_timer = 0
local transition_direction = "push"
local transition_canvas = love.graphics.newCanvas(love.graphics.getDimensions())
local TRANSITION_DURATION = 0.1

function m.resize(w, h)
	transition_canvas = love.graphics.newCanvas(w, h)
end

function m.pushnew(path, ...)
	m.push(view.new(path, ...))
end

function m.clear()
	stack_index = 1
	for i=2, #stack do
		stack[i] = nil
	end
end

function m.push(view)
	stack_index = stack_index + 1
	stack[stack_index] = view
	if stack_index ~= 1 then
		transitioning = true
		transition_timer = 0
		transition_direction = "push"
	end
end

function m.pop()
	if stack_index <= 0 then
		error("Stack is empty!")
	end

	stack_index = stack_index - 1

	transitioning = true
	transition_timer = 0
	transition_direction = "pop"

	if stack_index <= 0 then
		love.event.quit()
	end
end

function debug_print(lines)
	love.graphics.setColor(0,0,0)
	for i=1, #lines do
		love.graphics.print(lines[i], 1, (i-1)*20+1)
	end
	love.graphics.setColor(0,1,0)
	for i=1, #lines do
		love.graphics.print(lines[i], 0, (i-1)*20+0)
	end

end

function m.render()
	local first_opaque = stack_index+1
	local found_opaque = false
	while first_opaque > 0 and not found_opaque do
		first_opaque = first_opaque - 1
		found_opaque = stack[first_opaque].opaque
	end

	if transitioning and transition_direction == "push" then
		for i=math.max(first_opaque-1,1), stack_index-1 do
			stack[i]:render()
		end
		love.graphics.setCanvas(transition_canvas)
		love.graphics.clear()
		stack[stack_index]:render(showfocus)
		love.graphics.setCanvas()
		love.graphics.setColor(1,1,1,transition_timer/TRANSITION_DURATION)
		love.graphics.draw(transition_canvas, 0, 0)

	elseif transitioning and transition_direction == "pop" then
		for i=first_opaque, stack_index do
			stack[i]:render()
		end
		love.graphics.setCanvas(transition_canvas)
		love.graphics.clear()
		stack[stack_index+1]:render()
		love.graphics.setCanvas()
		love.graphics.setColor(1,1,1,1-transition_timer/TRANSITION_DURATION)
		love.graphics.draw(transition_canvas, 0, 0)

	else
		for i=first_opaque, stack_index do
			stack[i]:render(showfocus)
		end
	end

	if debug then
		local viewstack = {}
		for i=1, #stack do
			viewstack[i] = stack[i].name
			if i == stack_index then
				viewstack[i] = viewstack[i]:upper()
			end
		end
		debug_print{
			"fps: "..love.timer.getFPS(),
			"stack: "..table.concat(viewstack, " > "),
			"stack index: "..stack_index,
			"transitioning: "..(transitioning and "true" or "false"),
			"transition_direction: "..transition_direction,
			"transition_timer: "..transition_timer,
		}
	end
end

function m.update(dt)
	stack[stack_index]:update(dt)
	if transitioning then
		transition_timer = transition_timer + dt
	end
	if transition_timer > TRANSITION_DURATION then
		transitioning = false
	end
end

function m.keypressed(k)
	if k == "f12" then
		debug = not debug
	end
	showfocus = true
	stack[stack_index]:keypressed(k)
end

function m.mousepressed(x, y, button)
	showfocus = false
	stack[stack_index]:mousepressed(x, y, button)
end

function m.scroll(x, y)
	stack[stack_index]:scroll(x, y)
end

function m.zoom(value)
	stack[stack_index]:zoom(value)
end

return m
