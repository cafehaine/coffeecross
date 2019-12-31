function love.conf(t)
	-- require settings
	package.path = ""
	package.cpath = ""
	love.filesystem.setRequirePath("?.lua;?/init.lua;lib/?.lua;lib/?/init.lua")

	-- LÖVE settings
	t.identity = "coffeecross"

	t.window.title = "CoffeeCross"
	t.window.resizable = true
	t.window.minwidth=320
	t.window.minheight=240
	t.window.msaa = 8

	t.modules.physics = false
	t.modules.video = false
end
