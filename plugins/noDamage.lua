---@type Plugin
local plugin = ...

plugin:addHook("HumanLimbInverseKinematics",function ()
    for _,hum in ipairs(humans.getAll()) do
        hum.isBleeding = false
        hum.damage = 0
    end
end)