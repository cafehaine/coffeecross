local m = {}

local GLYPHS = [[ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789abcdefghijklmnopqrstuvwxyz]]
local FONT = love.graphics.newImageFont("assets/font.png", GLYPHS)

function m.get_font()
	return FONT
end

function m.get_unit()
	local width, height = love.window.getMode()

	return math.min(width, height) / 100
end

-- Scale factor to obtain a font with a height of unit
function m.get_unit_font_scale()
	return m.get_unit() / FONT:getHeight()
end

-- Sane default font size
function m.get_font_scale()
	return m.get_unit_font_scale() * 4
end

return m
