function love.load()
	viewstack = require("viewstack")
	view = require("view")
	viewstack.push(view.new("main"))
end

function love.draw()
	viewstack.render()
end

function love.update(dt)
	viewstack.update(dt)
end

function love.keypressed(key)

end
