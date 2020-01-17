local class = require("class")
local super = require("gui.widgets.button")
local utils = require("gui.utils")
local viewstack = require("viewstack")

local wdgt = class.create(super)

function wdgt.__new(self, attrs)
	super.__new(self, attrs)
	self.level = attrs.level
	self.next_levels = attrs.next_levels
end

function wdgt:action()
	viewstack.pushnew("game", self.level, self.next_levels)
end

return wdgt
