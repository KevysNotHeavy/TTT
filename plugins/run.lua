---@type Plugin
local plugin = ...

plugin.name = "Run"
plugin.author = "KevysNotHeavy"
plugin.description = "Adds running. BIG thanks to Jpsh for the memory value!"

plugin:addHook("HumanLimbInverseKinematics",function (human, A, B, pos, b, c, d, e, strength)
    if human.data.isRunning then
        if A == enum.body.pelvis and B == enum.body.foot_left or B == enum.body.foot_right then
            strength.value = .2
        end
    end
end)

---@param hum Human
---@param key number
function KeyPressed(hum,key)
    if bit32.band(hum.inputFlags,key) == key and bit32.band(hum.lastInputFlags,key) == key then
        return true
    else
        return false
    end
end

plugin:addHook("Logic",function ()
    for _,human in ipairs(humans.getAll()) do
        if KeyPressed(human,enum.input.shift) and KeyPressed(human,enum.input.ctrl) and math.ceil(human.walkInput) == 1 then
            if not human.data.toggleRun then
                if human.data.isRunning then
                    human.data.isRunning = false
                    messagePlayerWrap(human.player,"Running (Off)")
                else
                    human.data.isRunning = true
                    messagePlayerWrap(human.player,"Running (On)")
                end
                human.data.toggleRun = true
            end
        else
            human.data.toggleRun = false
        end

        if human.data.isRunning and human.zoomLevel == 0 and human.data.recoveryTime <= 0 then
            memory.writeFloat(memory.getAddress(human)+0x118,2)
        end

        if not human.isStanding then
            human.data.recoveryTime = .5
        else
            if human.data.recoveryTime > 0 then
                human.data.recoveryTime = human.data.recoveryTime - 1/62.5
            end
        end
    end
end)