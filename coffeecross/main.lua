function love.load()
	love.keyboard.setKeyRepeat(true)
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
	if key == "f11" then
		--TODO use a setting to store fullscreen mode (desktop/exclusive)
		local fullscreen = love.window.getFullscreen()
		love.window.setFullscreen(not fullscreen)
	end
	viewstack.keypressed(key)
end
