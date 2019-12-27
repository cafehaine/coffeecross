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
	stack[stack_index]:render()
end

function m.update(dt)
	stack[stack_index]:update(dt)
end

return m
