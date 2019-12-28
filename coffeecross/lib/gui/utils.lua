local m = {}

local GLYPHS = [[ABCDEFGHIJKLMNOPQRSTUVWXYZ]]
local FONT = love.graphics.newImageFont("assets/font.png", GLYPHS)

function m.get_font()
	return FONT
end

return m
