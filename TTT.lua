---@type Plugin
local plugin = ...

path = "/home/container/"

-- AFK X
-- WIN CONDITIONS X
-- Lobby X
-- Music X and Ambience X
-- Scanner X
-- Death Note X
-- More Maps

-- Changes
-- More Maps
-- Custom Sounds
-- Footsteps + Sneaking
-- Traitor Phone Line
-- New Bounds system
-- Red T names

local maps = { --Spawns are VecCuboids--
    { --TTT_Apartments
        name = "TTT_Apartments",
        ambience = path .. "/modes/TTT/sounds/ambience/TTT_Apartments.pcm",
        spawns = {
                    --Far Building
                    { Vector(1709.65,57.08,1655.47), Vector(1662.40,57.09,1652.52) },
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
                    --Left Building
                    { Vector(1679.47,49.08,1639.54), Vector(1676.50,49.08,1589.89) },
                    { Vector(1660.54,49.08,1584.51), Vector(1675.41,49.06,1603.36) },
                    { Vector(1675.45,49.07,1619.34), Vector(1660.60,49.09,1604.58) },
                    { Vector(1675.43,49.05,1639.26), Vector(1660.51,49.03,1620.84) },
                    { Vector(1676.57,53.08,1591.08), Vector(1679.48,52.99,1639.08) },
                    { Vector(1660.50,53.08,1639.53), Vector(1675.46,53.08,1620.52) },
                    { Vector(1660.53,53.09,1619.57), Vector(1675.42,53.08,1604.57) },
                    { Vector(1675.49,53.03,1603.14), Vector(1660.63,53.03,1584.79) },
                    { Vector(1676.54,57.08,1592.25), Vector(1679.46,57.02,1639.12) },
                    { Vector(1660.55,57.08,1639.61), Vector(1675.42,57.08,1620.57) },
                    { Vector(1660.69,57.09,1619.54), Vector(1675.42,57.09,1604.57) },
                    { Vector(1660.45,57.08,1584.53), Vector(1675.40,57.08,1603.38) },
                    --Right building
                    { Vector(1696.51,49.08,1635.60), Vector(1699.41,49.15,1590.44) },
                    { Vector(1715.47,49.08,1584.42), Vector(1700.55,49.08,1603.41) },
                    { Vector(1715.47,49.08,1604.43), Vector(1700.56,49.08,1615.42) },
                    { Vector(1715.55,49.08,1616.50), Vector(1700.73,49.07,1635.38) },
                    { Vector(1696.53,53.08,1590.96), Vector(1699.47,53.05,1635.23) },
                    { Vector(1715.30,53.07,1616.27), Vector(1700.59,53.08,1635.31) },
                    { Vector(1700.57,53.09,1615.54), Vector(1715.38,53.08,1604.56) },
                    { Vector(1700.52,53.09,1603.50), Vector(1715.37,53.08,1584.61) },
                    { Vector(1696.54,57.08,1591.68), Vector(1699.48,57.08,1635.43) },
                    { Vector(1714.82,57.08,1616.27), Vector(1700.64,57.08,1635.11) },
                    { Vector(1700.54,57.08,1604.57), Vector(1715.36,57.08,1615.38) },
                    { Vector(1700.54,57.09,1584.52), Vector(1715.14,57.08,1603.28) },
                },
        bounds = {Vector(1780.29,24.88,1692.07), Vector(1625.55,59.47,1577.68)},
    },

    {
        name = "TTT_Construction",
        ambience = path .. "/modes/TTT/sounds/ambience/TTT_Construction.pcm", --TEMP
        spawns = {
                    --Tall
                    { Vector(1094.14,25.08,1616.50), Vector(1099.44,25.07,1619.40) },
                    { Vector(1093.32,36.84,1622.81), Vector(1105.88,36.84,1628.16) },
                    { Vector(1092.28,48.84,1620.71), Vector(1106.59,48.83,1627.84) },

                    --Outside
                    { Vector(1092.85,24.71,1632.37), Vector(1117.40,24.71,1643.23) },
                    { Vector(1129.75,24.71,1635.04), Vector(1120.59,24.71,1649.66) },
                    { Vector(1145.14,24.71,1635.05), Vector(1154.73,24.71,1645.21) },

                    --Mini building
                    { Vector(1116.53,25.08,1624.87), Vector(1131.07,25.08,1631.42) },
                    
                    --Across from stairs
                    { Vector(1159.14,36.84,1630.29), Vector(1138.26,36.84,1617.84) },
                 },
        weaponSpawns = {
                        { Vector(1112.37,36.69,1622.96), Vector(1135.52,36.78,1621.26) },
                        { Vector(1135.88,36.77,1618.73), Vector(1112.38,36.77,1617.19) },
                        { Vector(1147.13,36.83,1631.03), Vector(1136.89,36.82,1628.33) },
                        { Vector(1156.55,24.82,1659.61), Vector(1159.29,24.83,1663.05) },
                        { Vector(1117.03,24.68,1646.95), Vector(1095.95,24.70,1656.73) },
                        { Vector(1099.53,24.83,1664.11), Vector(1092.41,24.85,1671.62) },
                        { Vector(1110.38,24.83,1627.09), Vector(1106.56,24.83,1624.07) },
                        { Vector(1090.14,25.18,1618.51), Vector(1093.44,25.08,1619.41) },
                        { Vector(1108.73,48.83,1618.87), Vector(1103.53,48.84,1624.96) },
                        { Vector(1148.32,24.84,1625.53), Vector(1159.12,24.83,1616.88) },
                        { Vector(1121.41,25.08,1630.72), Vector(1117.20,25.08,1625.68) },
                        { Vector(1134.73,24.84,1660.33), Vector(1131.58,24.82,1663.14) },
                       },
        barriers =  {
                        {Vector(1097.95,37.00,1619.937), eulerAnglesToRotMatrix(0,0,0)},
                        {Vector(1097.95,38.00,1619.937), eulerAnglesToRotMatrix(0,0,0)},
                    },
        bounds = {Vector(1188.25,5.05,1587.31), Vector(1058.35,127.15,1767.01)},
    },
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

--####INIT####--
local startMusic
local ended
local timeTillStart
local timeTillEnd
local gracePeriod
local roundTime
local initTeam
local phones

plugin:addHook("PostResetGame",function (reason)
    server.state = enum.state.ingame
    server.time = 11*60*60+11*60

    lobby = true
    startMusic = true
    ended = false

    timeTillStart = time("s",5)
    timeTillEnd = time("s",5)

    gracePeriod = time("m",2)
    roundTime = time("m",8)

    initTeam = false

    for _,ply in ipairs(players.getAll()) do
        ply.isReady = false
        ply.team = -1
        ply:update()
    end

    bounds.set(Vector(1656.21,36.61,1352.18), Vector(1807.56,86.26,1415.93))

    phones = {}
end)

plugin:addHook("PhysicsRigidBodies",function ()
    if allPlayers then
        for _,ply in ipairs(allPlayers) do
            if ply.connection then
                if lobby then
                    if not ply.data.moved then
                        if ply.human then
                            ply.human:setVelocity(Vector(0,0.0028,0))
                        end
                    end
                end

                if ply.human then
                    if ply.human.inputFlags ~= 0 or ply.human.strafeInput ~= 0 or ply.human.walkInput ~= 0 then
                        ply.data.moved = true
                    end
                end
            end
        end
    end
end)

    local function spawnPlayer(ply)
        if not ply.human then
            math.randomseed(os.clock())
            local randX = (math.random(0,200) - 100) / 10
            local randZ = (math.random(0,200) - 100) / 10
            humans.create(Vector(1735.98+randX,60,1382.62+randZ), eulerAnglesToRotMatrix(0,math.random(0,math.pi*2),0), ply)
        end
    end

    local function spawnPlayersAndWeapons()
        for _,hum in ipairs(allHumans) do
            hook.run("ReleaseGrab",hum)
            hum:remove()
        end

        if map.barriers then
            for _,wall in pairs(map.barriers) do
                local wall = items.create(itemTypes[enum.item.wall],wall[1],wall[2])
                wall.despawnTime = 60*60*99
                wall.hasPhysics = true
                wall.isStatic = true
                wall.parentHuman = humans[255]
            end
        end

        for _,ply in ipairs(allPlayers) do
            math.randomseed(os.clock())
            spawnRange = map.spawns[math.random(1,#map.spawns)]
            local spawn = vecRandBetween(spawnRange[1],spawnRange[2])
            local hum = humans.create(spawn, eulerAnglesToRotMatrix(0,math.random(0,math.pi*2),0), ply)
            colors = {0,1,2,3,4,5,10,11}
            hum.suitColor = colors[math.random(0,#colors)]
            hum.lastUpdatedWantedGroup = -1
            hum.isImmortal = true
        end

        for i=1,math.floor(math.clamp(#allPlayers*2.5,20,999)) do
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

            local spawnRange
            if not map.weaponSpawns then
                spawnRange = map.spawns[math.random(1,#map.spawns)]
            else
                spawnRange = map.weaponSpawns[math.random(1,#map.weaponSpawns)]
            end

            local spawn = vecRandBetween(spawnRange[1],spawnRange[2])
            local gun = items.create(itemTypes[wep.wep],spawn,eulerAnglesToRotMatrix(0,math.random(0,math.pi*2),math.pi/2))
            local mag = items.create(itemTypes[wep.mag],Vector(),orientations.n)
            if mag and gun then
                gun:mountItem(mag,0)
            end

            for i=1,2 do
                items.create(itemTypes[wep.mag],spawn,eulerAnglesToRotMatrix(math.pi/2,math.random(0,math.pi*2),math.pi/2))
            end
        end
    end

    local function endRound()
        
    end

    local currTime = 0

    local function gameLogic()
        local civs = 0
        local ts = 0
        for _,ply in ipairs(allPlayers) do
            if ply.human then
                if ply.human.isAlive then
                    if ply.team == 0 or ply.team == 2 then
                        civs = civs + 1
                    elseif ply.team == 3 then
                        ts = ts + 1
                    end
                end
            end
        end

        if not ended then
            if ts == 0 and civs == 0 then
                events.createMessage(3,"HOW! (Tie)",-1,2)
                ended = true
            elseif ts == 0 then
                events.createMessage(3,"Innocent Win!",-1,2)
                playOnce(path .. "modes/TTT/sounds/end/cWin.pcm",3,true)
                ended = true
            elseif civs == 0 then
                events.createMessage(3,"Terrorists Win!",-1,2)
                playOnce(path .. "modes/TTT/sounds/end/tWin.pcm",3,true)
                ended = true
            end
            currTime = server.ticksSinceReset
        else
            if currTime+timeTillEnd == server.ticksSinceReset then
                server:reset()
            else
                if currTime+timeTillEnd - server.ticksSinceReset > 60 then
                    server.time = currTime+timeTillEnd - server.ticksSinceReset
                else
                    server.time = 60
                end
            end
        end
    end

local function tick()
    allPlayers = players.getAll()
    allHumans = humans.getAll()
    allItems = items.getAll()

    if startMusic then
        playLoop(path .. "modes/TTT/sounds/lobby.pcm")
        startMusic = false
    end

    for _,phone in ipairs(phones) do
        if not phone.parentHuman then
            phone:remove()
            break
        else
            if not phone.parentHuman.data.hasEquipped and (phone.parentSlot == 0 or phone.parentSlot == 1) then
                phone.parentHuman.data.hasEquipped = true
                messagePlayerWrap(phone.parentHuman.player,"Equipped Traitor Walkie")
            end
        end
    end

    if lobby then
        for _,ply in ipairs(allPlayers) do
            spawnPlayer(ply)

            if not ply.data.welcomed and ply.connection then
                if events.getCount() > 2 then
                    if ply.connection:hasReceivedEvent(events[events.getCount()-2]) then
                        messagePlayerWrap(ply,"Welcome to TTT!")
                        messagePlayerWrap(ply,"Press R to Ready Up")
                        ply.data.welcomed = true
                    end
                end
            end

            if ply.human then
                if not ply.isReady and lobby and KeyPressed(ply.human,enum.input.r) then
                    ply.isReady = true
                    if ply.human then
                        ply.human:speak("I'm Ready!",2)
                    else
                        messagePlayerWrap(ply,"You Have Readied Up.")
                    end
        
                    events.createMessage(3,string.format("%s is Ready! (%s/%s)",ply.name,readiedPlayers+1,maxPlayers),-1,2)
                end
            end
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

        if readiedPlayers >= maxPlayers or fs then
            timeTillStart = timeTillStart - 1
            if timeTillStart < 60 then
                server.time = 60

                --Init Setup
                if timeTillStart <= 0 then
                    lobby = false

                    --Choose a map to play
                    math.randomseed(os.clock())

                    -----MAP------
                    map = maps[math.random(1,#maps)]

                    bounds.set(map.bounds[1],map.bounds[2]) --Set New Bounds

                    events.createMessage(3,"Map: "..map.name,-1,2) --Announce the Map

                    spawnPlayersAndWeapons()

                    stopLoop()
                    playLoop(map.ambience)
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

            if KeyPressed(human,enum.input.shift) then
                if not human.data.checkedRole then
                    if human.player then
                        if human.player.team == 0 then
                            messagePlayerWrap(human.player,"Detective")
                        elseif human.player.team == 2 then
                            messagePlayerWrap(human.player,"Innocent")
                        elseif human.player.team == 3 then
                            messagePlayerWrap(human.player,"Traitor")
                        else
                            messagePlayerWrap(human.player,"Unassigned (Grace Period)")
                        end
                        human.data.checkedRole = true
                    end
                end
            else
                human.data.checkedRole = false
            end
        end

        for _,ply in ipairs(allPlayers) do
            if not ply.data.graceAlert then
                ply.data.graceAlert = 0
            elseif ply.data.graceAlert < 60 then
                ply.data.graceAlert = ply.data.graceAlert + 1
            end
        end

        for _,itm in ipairs(allItems) do
            itm.despawnTime = 10
        end

        if gracePeriod <= 0 then
            if not initTeam then

                ToggleAFK(true)

                events.createMessage(3,"Round Starting (End of Grace Period)",-1,2)

                local livingPlayers = {}
                for _,ply in ipairs(allPlayers) do
                    if ply.human then
                        if ply.human.isAlive then
                            table.insert(livingPlayers,ply)
                        end
                    end
                end

                livingPlayers = table.shuffle(livingPlayers)

                local ttt
                if #livingPlayers <= 8 then
                    ttt = 1
                elseif #livingPlayers <= 10 then
                    ttt = 2
                else
                    ttt = 3
                end

                for i=1,#livingPlayers do
                    ---@type Player
                    local ply = livingPlayers[i]
                    if i <= ttt then
                        hook.run('SelectedPlayer', ply, 3)
                        messagePlayerWrap(ply,"You are a Traitor")
                        local phone = items.create(itemTypes[enum.item.radio],ply.human.pos:clone(),orientations.n)
                        if phone then
                            phone.computerTopLine = 3
                            table.insert(phones,phone)
                            ply.human:mountItem(phone,6)
                        end
                    elseif i == ttt+1 then
                        hook.run('SelectedPlayer', ply, 0)
                        ply.human.suitColor = 1 --black
                        ply.human.model = 1
                        ply.human.lastUpdatedWantedGroup = -1
                        messagePlayerWrap(ply,"You are the Detective")
                        ply.human:mountItem(Scanner.create(ply.human.pos:clone(),2).item,6)
                    else
                        messagePlayerWrap(ply,"You are Innocent")
                        ply.team = 2
                    end
                    ply:update()

                    ply:updateElimState(0,ply.team,nil,nil)

                    ply.human.isImmortal = false
                end

                initTeam = true
            end

            if roundTime >= 60 then
                server.time = roundTime
            else
                server.time = 60
            end

            if not ended then
                roundTime = roundTime - 1
            end

            if roundTime <= 0 and not ended then
                endRound()
            else
                gameLogic()
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

plugin:addHook("Logic",function () if players.getCount() > 0 then tick() end end)

plugin.commands["/tst"] = {
    canCall = function (player)
        return player.isAdmin
    end,
    info = "test sound",
    call = function (player, human, args)
        playLoop(path .. "modes/TTT/sounds/cWin.pcm")
    end
}

plugin.commands["/end"] = {
    canCall = function (player)
        return player.isAdmin
    end,
    info = "test sound",
    call = function (player, human, args)
        stopLoop()
    end
}

plugin.commands["/scn"] = {
    canCall = function (player)
        return player.isAdmin
    end,
    info = "test sound",
    call = function (player, human, args)
        if human then
            Scanner.create(human.pos,2)
        end
    end
}

plugin.commands["/fs"] = {
    canCall = function (player)
        return player.isAdmin
    end,
    info = "force start",
    call = function (player, human, args)
        fs = true
        timeTillStart = 0
    end
}

plugin.commands["/db"] = {
    canCall = function (player)
        return player.isAdmin
    end,
    info = "disable bounds",
    call = function (player, human, args)
        bounds.remove()
    end
}