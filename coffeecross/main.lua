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

local GAMEPAD_SCROLL_X = 0
local GAMEPAD_SCROLL_Y = 0
local GAMEPAD_ZOOM = 0

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
	local settings = require("settings")
	settings.load()
end

function love.draw()
	viewstack.render()
end

function love.update(dt)
	local scroll_x = nil
	local scroll_y = nil
	if math.abs(GAMEPAD_ZOOM) > GAMEPAD_DEADZONE then
		viewstack.zoom(GAMEPAD_ZOOM * dt)
	end
	if math.abs(GAMEPAD_SCROLL_Y) > GAMEPAD_DEADZONE then
		scroll_y = GAMEPAD_SCROLL_Y * dt
	end
	if math.abs(GAMEPAD_SCROLL_X) > GAMEPAD_DEADZONE then
		scroll_x = GAMEPAD_SCROLL_X * dt
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

function love.mousepressed(x, y, button)
	viewstack.mousepressed(x, y, button)
end

function love.gamepadaxis(joystick, axis, value)
	if axis == "rightx" then
		GAMEPAD_SCROLL_X = value
	elseif axis == "righty" then
		GAMEPAD_SCROLL_Y = value
	elseif axis == "lefty" then
		GAMEPAD_ZOOM = value
	end
end

function love.wheelmoved(x, y)
	viewstack.zoom(y/100)
end

function love.resize(w, h)
	viewstack.resize(w, h)
end
