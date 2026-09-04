-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- HYPRLAND MAIN CONFIG (MODULAR LUA ENTRYPOINT)         --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Load configurations in logical order
require("lua.env")
require("lua.monitors")
require("lua.autostart")
require("lua.look")
require("lua.animations")
require("lua.input")
require("lua.keybinds")
require("lua.rules")
