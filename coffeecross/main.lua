function love.load()
	level = require("lib.level")
	current_level = level.new("levels/beginner/02.txt")
end

function love.draw()
	current_level:draw(0, 0, 5)
end

function love.update(dt)

end

function love.keypressed(key)

end
