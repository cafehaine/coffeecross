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

function love.gamepadpressed(joystick, button)
	local key = nil
	if button == "a" or button == "start" then
		key = "return"
	elseif button == "b" or button == "back" then
		key = "escape"
	elseif button == "dpup" then
		key = "up"
	elseif button == "dpdown" then
		key = "down"
	elseif button == "dpleft" then
		key = "left"
	elseif button == "dpright" then
		key = "right"
	elseif button == "leftshoulder" or button == "rightshoulder" then
		key = "tab"
	end
	if key then
		love.event.push("keypressed", key)
	end
end
