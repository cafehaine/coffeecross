local m = {}
m.__index = m

function m.new()
	return m
end

function m.auto_width()
	return 0
end

function m.auto_height()
	return 0
end

function m.render()
end

return m
