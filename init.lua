---@type Plugin
local mode = ...

--mode:require("plugins/run")
mode:require("plugins/noStamina")
mode:require("plugins/noDamage")
mode:require("plugins/grab")
mode:require("plugins/bounds")
mode:require("plugins/inputCheck")
mode:require("plugins/afk")
mode:require("plugins/speaker")
mode:require("plugins/speakerExtra")
mode:require("plugins/coloredNames")
mode:require("plugins/walk")
mode:require("plugins/scanner")
mode:require("plugins/deathNote")
mode:require("plugins/punch")

mode:require("TTT")

mode.name = "TTT"
mode.author = "KevysNotHeavy"
mode.description = "A faithful recreation of the game Trouble in Terrorist Town from Garry's Mod"