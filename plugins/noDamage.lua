---@type Plugin
local plugin = ...

plugin:addHook("Physics",function ()
    for _,hum in ipairs(humans.getAll()) do
        hum.isBleeding = false
        hum.damage = 0
    end
end)