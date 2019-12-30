local m = {}

local GLYPHS = [[ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789]]
local FONT = love.graphics.newImageFont("assets/font.png", GLYPHS)

function m.get_font()
	return FONT
end

function m.get_unit()
	local width, height = love.window.getMode()

	return math.min(width, height) / 100
end

return m
