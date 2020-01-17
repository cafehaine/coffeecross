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

local GAMEPAD_DEADZONE = 0.15

local gamepad_scroll_x = 0
local gamepad_scroll_y = 0
local gamepad_zoom = 0

local ARROW_KEYS = {
	up    = {x=0,  y=1},
	down  = {x=0,  y=-1},
	left  = {x=-1, y=0},
	right = {x=1,  y=0},
}

function love.load()
	love.keyboard.setKeyRepeat(true)
	viewstack = require("viewstack")
	viewstack.pushnew("main")
	local profile = require("profile")
	profile.load()
end

function love.draw()
	viewstack.render()
end

function love.update(dt)
	local scroll_x = nil
	local scroll_y = nil
	if math.abs(gamepad_zoom) > GAMEPAD_DEADZONE then
		viewstack.zoom(gamepad_zoom * dt)
	end
	if math.abs(gamepad_scroll_y) > GAMEPAD_DEADZONE then
		scroll_y = gamepad_scroll_y * dt
	end
	if math.abs(gamepad_scroll_x) > GAMEPAD_DEADZONE then
		scroll_x = gamepad_scroll_x * dt
	end
	if scroll_x or scroll_y then
		viewstack.scroll(scroll_x or 0, scroll_y or 0)
	end

	viewstack.update(dt)
end

function love.textinput(text)
	if text == "+" and love.keyboard.isDown("lctrl", "rctrl") then
		viewstack.zoom(0.15)
	elseif text == "-" and love.keyboard.isDown("lctrl", "rctrl") then
		viewstack.zoom(-.15)
	end
end


function love.keypressed(key, scancode, isrepeat)
	if key == "f11" then
		--TODO use a setting to store fullscreen mode (desktop/exclusive)
		local fullscreen = love.window.getFullscreen()
		love.window.setFullscreen(not fullscreen)
	elseif ARROW_KEYS[key] ~= nil and love.keyboard.isDown("lctrl", "rctrl") then
		local scroll = ARROW_KEYS[key]
		viewstack.scroll(scroll.x*0.1, scroll.y*0.1)
	else
		viewstack.keypressed(key)
	end
end

function love.gamepadpressed(joystick, button)
	local key = GAMEPAD_MAPPINGS[button]
	if key then
		love.event.push("keypressed", key)
	end
end

function love.mousepressed(x, y, button, istouch)
	if istouch then
		return
	end
	viewstack.mousepressed(x, y, button)
end

function love.touchpressed(id, x, y)
	viewstack.mousepressed(x, y, 1)
end

function love.gamepadaxis(joystick, axis, value)
	if axis == "rightx" then
		gamepad_scroll_x = value
	elseif axis == "righty" then
		gamepad_scroll_y = value
	elseif axis == "lefty" then
		gamepad_zoom = value
	end
end

function love.wheelmoved(x, y)
	viewstack.zoom(y/100)
end

function love.resize(w, h)
	viewstack.resize(w, h)
end
