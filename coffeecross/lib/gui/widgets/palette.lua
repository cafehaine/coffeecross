local class = require("class")
local super = require("gui.widgets.base")

local wdgt = class.create(super)

function wdgt.__new(self, attrs)
	super.__new(self, attrs)
	self.action = attrs.action
	self.focus = attrs.focus
	self.palette = attrs.palette
end

function wdgt:auto_width()
	return 0
end

function wdgt:auto_height()
	return 40 --TODO compute something
end

function wdgt:render(width, height, focus)
	-- Border
	love.graphics.clear(1, 0, 1)
end

function wdgt:keypressed(k, focus)
	if focus == self.id then
		if self.focus[k] then
			return self.focus[k]
		elseif k == "return" then
			self.action()
		end
	end

	return nil
end

return wdgt
