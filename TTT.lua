---@type Plugin
local plugin = ...

local maps = { --Spawns are VecCuboids--
    { --TTT_Apartments
        name = "TTT_Apartments",
        spawns = {  { Vector(1709.65,57.08,1655.47), Vector(1662.40,57.09,1652.52) },
                    { Vector(1656.54,57.09,1671.38), Vector(1675.36,57.09,1656.67) },
                    { Vector(1695.45,57.09,1656.47), Vector(1676.64,57.09,1667.32) },
                    { Vector(1683.74,57.08,1671.46), Vector(1676.38,57.04,1668.58) },
                    { Vector(1695.71,57.08,1668.16), Vector(1688.37,57.07,1671.50) },
                    { Vector(1715.04,57.09,1671.33), Vector(1696.65,57.09,1656.63) },
                    { Vector(1709.95,53.08,1652.77), Vector(1662.35,53.07,1655.47) },
                    { Vector(1675.46,53.08,1656.74), Vector(1656.60,53.06,1671.28) },
                    { Vector(1695.31,53.08,1656.49), Vector(1676.72,53.03,1667.33) },
                    { Vector(1683.68,53.08,1671.48), Vector(1676.45,53.02,1668.51) },
                    { Vector(1696.71,53.09,1656.52), Vector(1715.37,53.08,1671.38) },
                    { Vector(1710.07,49.08,1652.44), Vector(1662.52,49.08,1655.47) },
                    { Vector(1675.58,49.08,1656.88), Vector(1656.66,49.06,1671.21) },
                    { Vector(1695.46,49.08,1656.51), Vector(1676.59,49.07,1667.42) },
                    { Vector(1683.51,49.09,1671.48), Vector(1676.39,49.09,1668.33) },
                    { Vector(1695.71,49.08,1668.29), Vector(1688.46,49.08,1671.53) },
                    { Vector(1696.62,49.08,1656.69), Vector(1715.24,49.08,1671.34) },
                },
        bounds = {Vector(1780.29,24.88,1692.07), Vector(1625.55,59.47,1577.68)}
    }
}

local map = {}

plugin:addEnableHandler(function(isReload)
    if not isReload then
        server:reset()
    end
    
    server.levelToLoad = "round"
    
    server.type = enum.gamemode.eliminator+16
end)

plugin:addHook("HumanDamage",function (human)
    if human.isImmortal then
        return hook.override
    end
end)

plugin:addHook("BulletHitHuman",function (human, bullet)
    if human.isImmortal then
        if bullet.player.data.graceAlert >= 60 then
            messagePlayerWrap(bullet.player,"Grace Period: Damage is Disabled!")
            bullet.player.data.graceAlert = 0
        end
    end
end)

local currConnection = nil
plugin:addHook("PacketBuilding",function (connection)
    if allPlayers then
        if connection == currConnection then
            return
        end

        currBuildingConnection = connection

        if connection.player.team == 3 then
            for _,ply in ipairs(allPlayers) do
                if ply.team == 3 then
                    ply.criminalRating = 100
                end
            end
        else
            for _,ply in ipairs(allPlayers) do
                ply.criminalRating = 0
            end
        end

        for _,ply in ipairs(allPlayers) do
            if ply.team == 0 then
                ply.criminalRating = 25
            end
        end
    end
end)

---comment
---@param unit string
---@param time number
local function time(unit,time)
    if unit == "s" then
        return time*60 + 60
    elseif unit == "m" then
        return time*3600 + 60
    end
end

plugin:addHook("PostResetGame",function (reason)
    server.state = enum.state.ingame
    server.time = 11*60*60+11*60

    lobby = true

    timeTillStart = time("s",5)

    gracePeriod = time("s",30)
    roundTime = time("m",8)

    initTeam = false

    for _,ply in ipairs(players.getAll()) do
        ply.isReady = false
        ply.team = -1
        ply:update()
    end
    
end)

plugin:addHook("PhysicsRigidBodies",function ()
    if allPlayers then
        for _,ply in ipairs(allPlayers) do
            if not ply.connection then
                if ply.human then
                    ply.human:setVelocity(Vector(0,0.0028,0))
                end
            end
        end
    end
end)

    local function spawnPlayer(ply)
        if not ply.human then
            math.randomseed(os.clock())
            local randX = (math.random(0,200) - 100) / 50
            local randZ = (math.random(0,200) - 100) / 50
            humans.create(Vector(1735.98+randX,60,1382.62+randZ), eulerAnglesToRotMatrix(0,math.random(0,math.pi*2),0), ply)
        end
    end

    local function spawnPlayersAndWeapons()
        for _,hum in ipairs(allHumans) do
            hum:remove()
        end

        for _,ply in ipairs(allPlayers) do
            math.randomseed(os.clock())
            spawnRange = map.spawns[math.random(1,#map.spawns)]
            local spawn = vecRandBetween(spawnRange[1],spawnRange[2])
            local hum = humans.create(spawn, eulerAnglesToRotMatrix(0,math.random(0,math.pi*2),0), ply)
            hum.isImmortal = true
        end

        for i=1,#allPlayers do
            math.randomseed(os.clock())
            local weapon = math.random(1,100)
            local weapons = {
                {wep=enum.item.m16, mag=enum.item.m16_mag},
                {wep=enum.item.ak47, mag=enum.item.ak47_mag},
                {wep=enum.item.uzi, mag=enum.item.uzi_mag},
                {wep=enum.item.pistol, mag=enum.item.pistol_mag}
            }

            local wep = {wep=0,mag=0}
            if weapon <= 12 then
                wep = weapons[1]
            elseif weapon <= 24 then
                wep = weapons[2]
            elseif weapon <= 62 then
                wep = weapons[3]
            elseif weapon <= 100 then
                wep = weapons[4]
            end

            spawnRange = map.spawns[math.random(1,#map.spawns)]
            local spawn = vecRandBetween(spawnRange[1],spawnRange[2])
            local gun = items.create(itemTypes[wep.wep],spawn,eulerAnglesToRotMatrix(0,math.random(0,math.pi*2),math.pi/2))
            local mag = items.create(itemTypes[wep.mag],Vector(),orientations.n)
            if mag and gun then
                gun:mountItem(mag,0)

                gun.despawnTime = gracePeriod + roundTime + 60*10
                mag.despawnTime = gracePeriod + roundTime + 60*10
            end

            for i=1,2 do
                local mag = items.create(itemTypes[wep.mag],spawn,eulerAnglesToRotMatrix(math.pi/2,math.random(0,math.pi*2),math.pi/2))
                mag.despawnTime = gracePeriod + roundTime + 60*10
            end
        end
    end

    local function endRound()
        
    end

local function tick()
    allPlayers = players.getAll()
    allHumans = humans.getAll()

    if lobby then
        bounds.set(Vector(1656.21,36.61,1352.18), Vector(1807.56,86.26,1415.93))

        for _,ply in ipairs(allPlayers) do
            spawnPlayer(ply)
        end

        maxPlayers = #allPlayers-2

        if maxPlayers < 3 then
            maxPlayers = 3
        end

        readiedPlayers = 0
        for _,ply in ipairs(allPlayers) do
            if ply.isReady then
                readiedPlayers = readiedPlayers + 1
            end
        end

        maxPlayers = 1

        if readiedPlayers >= maxPlayers then
            timeTillStart = timeTillStart - 1
            if timeTillStart < 60 then
                server.time = 60

                --Init Setup
                if timeTillStart <= 0 then
                    lobby = false

                    --Choose a map to play
                    math.randomseed(os.clock())
                    map = maps[math.random(1,#maps)]

                    bounds.set(map.bounds[1],map.bounds[2]) --Set New Bounds

                    events.createMessage(3,"Map: "..map.name,-1,2) --Announce the Map

                    spawnPlayersAndWeapons()
                end
            else
                server.time = timeTillStart
            end
        end

        --END--
    else
        --Starting the game

        --Keep all corpses
        for _,human in ipairs(allHumans) do
            if not human.player then
                human.despawnTime = 10
            end
        end

        for _,ply in ipairs(allPlayers) do
            if not ply.data.graceAlert then
                ply.data.graceAlert = 0
            elseif ply.data.graceAlert < 60 then
                ply.data.graceAlert = ply.data.graceAlert + 1
            end
        end

        if gracePeriod <= 0 then
            if not initTeam then
                allPlayers = table.shuffle(allPlayers)

                local ttt
                if #allPlayers <= 8 then
                    ttt = 1
                elseif #allPlayers <= 10 then
                    ttt = 2
                else
                    ttt = 3
                end

                for i=1,#players do
                    ---@type Player
                    local ply = allPlayers[i]
                    if i <= ttt then
                        ply.team = 3
                        messagePlayerWrap(ply,"You are a Traitor")
                    elseif i == ttt+1 then
                        ply.team = 0
                        messagePlayerWrap(ply,"You are a Detective")
                    else
                        messagePlayerWrap(ply,"You are Innocent")
                        ply.team = 2
                    end
                    ply:update()

                    ply.human.isImmortal = false
                end

                initTeam = true
            end
            roundTime = roundTime - 1

            if roundTime >= 60 then
                server.time = roundTime
            else
                server.time = 60
            end

            if roundTime <= 0 then
                endRound()
            end
        else
            gracePeriod = gracePeriod - 1

            if gracePeriod >= 60 then
                server.time = gracePeriod
            else
                server.time = 60
            end
        end

        --END--
    end
end

plugin:addHook("Logic",function () tick() end)

plugin.commands["/ready"] = {
    info = "Ready Up",
    call = function (ply)
        if not ply.isReady then
            ply.isReady = true
            if ply.human then
                ply.human:speak("I'm Ready!",2)
            else
                messagePlayerWrap(ply,"You Have Readied Up.")
            end

            events.createMessage(3,string.format("%s is Ready! (%s/%s)",ply.name,readiedPlayers+1,maxPlayers),-1,2)
        end
    end
}