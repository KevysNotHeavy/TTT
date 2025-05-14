---@type Plugin
local plugin = ...

killsTillKick = 1

function ToggleAFK(bool)
    AFK = bool
end

plugin:addHook("PlayerDelete",function (player)
    if player.human then
        player.human:remove()
    end
end)

plugin:addHook("PostResetGame",function (reason)
    for _,ply in ipairs(players.getAll()) do
        if not ply.data.gamesPast then
            ply.data.gamesPast = 0
        else
            ply.data.gamesPast = ply.data.gamesPast + 1
        end

        if ply.data.gamesPast >= 3 then
            ply.data.afkCount = 0
        end
    end

    AFK = false
end)

plugin:addHook("Logic",function ()
    if AFK then
        for _,ply in ipairs(players.getAll()) do
            if ply.connection then
                if not ply.data.initIdle then
                    ply.data.idleTime = 0
                    ply.data.gamesPast = 0
                    ply.data.afkCount = 0
                    ply.data.initIdle = true
                end

                if ply.human then
                    if ply.human.inputFlags ~= 0 or ply.human.strafeInput ~= 0 or ply.human.walkInput ~= 0 then
                        ply.data.idleTime = 0
                        ply.data.warnAFK = false
                    else
                        ply.data.idleTime = ply.data.idleTime + 1
                    end

                    if ply.data.idleTime >= 60*50 then
                        if not ply.data.warnAFK then
                            if ply.data.afkCount >= killsTillKick then
                                messagePlayerWrap(ply,"You are about to be kicked for being AFK!")
                            else
                                messagePlayerWrap(ply,"You are about to be killed for being AFK!")
                            end
                            ply.data.warnAFK = true
                        end
                    end

                    ply.data.lastViewPitch2 = ply.human.viewPitch2
                    ply.data.lastViewYaw2 = ply.human.viewYaw2

                    if ply.data.idleTime >= 60*60 then
                        if ply.data.afkCount >= killsTillKick then
                            chat.announce(ply.name.." was kicked for being AFK")
                            ply.connection.timeoutTime = 999999999
                        else
                            chat.announce(ply.name.." was killed for being AFK")
                            ply.human:remove()
                            ply.data.idleTime = 0
                            ply.data.warnAFK = false
                            ply.data.afkCount = ply.data.afkCount + 1
                        end
                    end
                end
            end
        end
    end
end)