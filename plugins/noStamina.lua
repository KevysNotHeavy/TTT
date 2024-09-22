---@type Plugin
local plugin = ...

plugin:addHook("Physics",function ()
    for _,human in ipairs(humans.getAll()) do
        human.stamina = 123
    end
end)