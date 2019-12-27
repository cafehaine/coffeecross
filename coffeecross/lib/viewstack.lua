local m = {}

local stack = {}
local stack_index = 0

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
	local i = stack_index
	local rendered_opaque = false
	while i > 0 and not rendered_opaque do
		stack[i]:render()
		rendered_opaque = stack[i].opaque
		i = i - 1
	end
end

function m.update(dt)
	stack[stack_index]:update(dt)
end

return m
