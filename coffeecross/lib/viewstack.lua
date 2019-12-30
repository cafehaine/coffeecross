local m = {}
local view = require("view")
local stack = {}
local stack_index = 0

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
		stack[i]:render()
	end
end

function m.update(dt)
	stack[stack_index]:update(dt)
end

function m.keypressed(k)
	stack[stack_index]:keypressed(k)
end

return m
