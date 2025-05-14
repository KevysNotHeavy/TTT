---@type Plugin
local mode = ...

mode:require("plugins/run")
mode:require("plugins/noStamina")
mode:require("plugins/noDamage")
mode:require("plugins/grab")
mode:require("plugins/bounds")
mode:require("plugins/inputCheck")
mode:require("plugins/afk")
mode:require("TTT")

mode.name = "TTT"
mode.author = "KevysNotHeavy"
mode.description = "A faithful recreation of the game Trouble in Terrorist Town from Garry's Mod"