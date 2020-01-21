local class = require("class")
local super = require("gui.widgets.base")
local utils = require("gui.utils")
local profile = require("profile")

local wdgt = class.create("Toggle", super)

function wdgt.__new(self, attrs)
	super.__new(self, attrs)
	self.profile_section = attrs.profile_section
	self.profile_key = attrs.profile_key
	self.focus = attrs.focus
	self.value = profile.get(self.profile_section, self.profile_key) or attrs.default or false
end

function wdgt:auto_width()
	local unit = utils.get_unit()
	return 10 * unit
end

function wdgt:auto_height()
	local unit = utils.get_unit()
	return 4 * unit
end

function wdgt:render(width, height, focus)
	local unit = utils.get_unit()
	local left = width/2-10*unit/2
	local top = height/2-4*unit/2
	-- Background
	love.graphics.setColor(0.3, 0.3, 0.3)
	love.graphics.rectangle("fill", left+unit, top+unit, 8*unit, 2*unit, unit)
	if focus == self.id then
		love.graphics.setColor(1.0, 0.7, 0.2)
	else
		love.graphics.setColor(0.1, 0.1, 0.1)
	end
	love.graphics.rectangle("fill", left+1.5*unit, top+1.5*unit, 7*unit, unit, 0.5*unit)
	-- Switch
	local switch_x = (self.value and 8 or 2) * unit
	love.graphics.setColor(0.3, 0.3, 0.3)
	love.graphics.circle("fill", left+switch_x, top+2*unit, 2*unit)
	if focus == self.id then
		love.graphics.setColor(1.0, 0.7, 0.2)
	else
		love.graphics.setColor(0.1, 0.1, 0.1)
	end
	love.graphics.circle("fill", left+switch_x, top+2*unit, 1.5*unit)

end

function wdgt:action()
	self.value = not self.value
	profile.set(self.profile_section, self.profile_key, self.value)
	profile.save()
end

function wdgt:keypressed(k, focus)
	if focus == self.id then
		if self.focus[k] then
			return self.focus[k]
		elseif k == "return" or k == "space" then
			self:action()
		end
	end

	return nil
end

function wdgt:mousepressed(x, y, button, width, height)
	self:action()
	return true
end

return wdgt
