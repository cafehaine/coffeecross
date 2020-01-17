local class = require("class")
local super = require("gui.widgets.button")
local utils = require("gui.utils")
local viewstack = require("viewstack")
local profile = require("profile")

local wdgt = class.create(super)

function wdgt.__new(self, attrs)
	super.__new(self, attrs)
	self.world_name = attrs.world_name
	self.level_name = attrs.level_name
	self.next_levels = attrs.next_levels
end

function wdgt:action()
	viewstack.pushnew("game", self.world_name, self.level_name, self.next_levels)
end

return wdgt
