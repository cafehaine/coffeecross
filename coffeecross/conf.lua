-- require settings
package.path = ""
package.cpath = ""
love.filesystem.setRequirePath("?.lua;?/init.lua;lib/?.lua;lib/?/init.lua")

-- load profile, used for MSAA setting.
local profile = require("profile")
love.filesystem.setIdentity("coffeecross")
profile.load()

function love.conf(t)
	t.identity = "coffeecross"

	t.window.title = "CoffeeCross"
	t.window.icon = "assets/icon.png"
	t.window.resizable = true
	t.window.minwidth=320
	t.window.minheight=240
	t.window.usedpiscale = false
	t.window.msaa = profile.get("settings", "msaa") and 4 or 0

	t.modules.physics = false
	t.modules.video = false
end
