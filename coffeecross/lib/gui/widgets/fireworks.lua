local class = require("class")
local super = require("gui.widgets.base")
local utils = require("gui.utils")
local profile = require("profile")

local wdgt = class.create("Fireworks", super)

local PARTICLE_TEXTURE = love.graphics.newImage("assets/particle.png")
local MAX_PARTICLE_LIFE = 1
local PARTICLE_COUNT = 100

local function HSV(h, s, v)
	-- Original code from https://love2d.org/wiki/HSV_color
	if s <= 0 then return v,v,v end
	h, s, v = h*6, s, v
	local c = v*s
	local x = (1-math.abs((h%2)-1))*c
	local m,r,g,b = (v-c), 0,0,0
	if h < 1     then r,g,b = c,x,0
	elseif h < 2 then r,g,b = x,c,0
	elseif h < 3 then r,g,b = 0,c,x
	elseif h < 4 then r,g,b = 0,x,c
	elseif h < 5 then r,g,b = x,0,c
	else              r,g,b = c,0,x
	end return r+m, g+m, b+m
end

local function randomColor()
	return HSV(love.math.random(), 1, 1)
end

function wdgt.__new(self, attrs)
	super.__new(self, attrs)
	self.psystem = love.graphics.newParticleSystem(PARTICLE_TEXTURE)
	self.psystem:setParticleLifetime(0.8 * MAX_PARTICLE_LIFE, MAX_PARTICLE_LIFE)
	self.psystem:setRadialAcceleration(0, 200)
	self.psystem:setLinearDamping(2)
	self.psystem:setSpread(2*math.pi)
	self.psystem:setSpeed(1)
	self.psystem:setSizes(0.1, 0.1, 0)
	self.psystem:setEmissionRate(0)
	self.psystem:emit(PARTICLE_COUNT)
	self.psystem:setColors(1, 1, 1, 1, 1, 1, 1, 0)
	self.timer = 0
	wdgt:__randomize()
end

function wdgt:__randomize()
	self.color = {randomColor()}
	self.x = love.math.random()
	self.y = love.math.random()
end

function wdgt:auto_width()
	return 0
end

function wdgt:auto_height()
	return 0
end

function wdgt:render(width, height)
	if profile.get("settings", "animations") then
		love.graphics.setBlendMode("add")
		love.graphics.setColor(self.color)
		local scale = utils.get_unit()/2
		love.graphics.draw(self.psystem, width*self.x, height*self.y, 0, scale, scale)
		love.graphics.setBlendMode("alpha")
	end
end

function wdgt:update(dt)
	if profile.get("settings", "animations") then
		self.psystem:update(dt)
		self.timer = self.timer + dt
		if self.timer > MAX_PARTICLE_LIFE then
			self.timer = 0
			self:__randomize()
			self.psystem:emit(PARTICLE_COUNT)
		end
	end
end

return wdgt
