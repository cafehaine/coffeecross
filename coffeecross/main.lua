local GAMEPAD_MAPPINGS = {
	a="return",
	start="return",

	b="escape",
	back="escape",

	x="delete",

	dpup = "up",
	dpdown = "down",
	dpleft = "left",
	dpright = "right",

	leftshoulder = "tab",
	rightshoulder = "tab"
}

function love.load()
	love.keyboard.setKeyRepeat(true)
	viewstack = require("viewstack")
	viewstack.pushnew("main")
	local settings = require("settings")
	settings.load()
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
	local key = GAMEPAD_MAPPINGS[button]
	if key then
		love.event.push("keypressed", key)
	end
end

function love.mousepressed(x, y, button)
	viewstack.mousepressed(x, y, button)
end
