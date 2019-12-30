local class = require("class")
local super = require("gui.widgets.base")

local wdgt = class.create(super)

function wdgt.__new(self, attrs)
	super.__new(self, attrs)
	self.focus = attrs.focus
end

function wdgt:auto_width()
	return 0
end

function wdgt:auto_height()
	return 0
end

function wdgt:render() end

function wdgt:keypressed(k, focus)
	if focus == self.id and self.focus[k] then
		return self.focus[k]
	end
	return nil
end

return wdgt
