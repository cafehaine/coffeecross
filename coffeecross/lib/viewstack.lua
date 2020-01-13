local m = {}
local view = require("view")
local stack = {}
local stack_index = 0
local showfocus = true
local debug = false

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
end

function m.pop()
	if stack_index <= 0 then
		error("Stack is empty!")
	end

	stack[stack_index] = nil
	stack_index = stack_index - 1

	if stack_index <= 0 then
		love.event.quit()
	end
end

function m.render()
	local i = stack_index+1
	local found_opaque = false
	while i > 0 and not found_opaque do
		i = i - 1
		found_opaque = stack[i].opaque
	end

	for i=i, #stack do
		stack[i]:render(showfocus)
	end
	if debug then
		love.graphics.setColor(0,0,0)
		love.graphics.print("fps: "..love.timer.getFPS(), 1, 1)
		love.graphics.print("stack index: "..stack_index, 1, 21)
		love.graphics.setColor(0,1,0)
		love.graphics.print("fps: "..love.timer.getFPS(), 0, 0)
		love.graphics.print("stack index: "..stack_index, 0, 20)
	end
end

function m.update(dt)
	stack[stack_index]:update(dt)
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

return m
