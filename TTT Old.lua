---@type Plugin
local plugin = ...

--JUST KEEP THIS HERE AND EVERYTHING WILL BE OK--
plugin:addEnableHandler(function(isReload) if not isReload then server:reset() end end)
plugin:addHook("PostResetGame", function() Init() end)
plugin:addHook("Logic",function () Tick() end)

plugin:addHook("ServerSend",function ()
	if allPlayers then
		for _,ply in ipairs(allPlayers) do
			if server.state == enum.state.intermission then
				ply.menuTab = enum.menu.lobby
			else
				ply.menuTab = 0
			end
		end
	end
end)

plugin:addHook("PacketBuilding", function(connection)
    for _,ply in ipairs(allPlayers) do
        if connection.player.data.showCrim and ply.data.showCrim then
            ply.criminalRating = 100
        elseif ply.team == 0 then
            ply.criminalRating = 10
        else
            ply.criminalRating = 0
        end
    end
end)

plugin:addHook("PostBulletCreate",function (bullet)
    if state == 0 then
        bullet.time = 0
        bullet.vel = Vector(0,0,0)
    end
end)

plugin:addHook("BulletHitHuman",function (human, bullet)
    if human.isAlive and human.player then
        human.data.hitBy = bullet.player.human
        human.data.playerName = human.player.name
        human.data.lastHitPos = bullet.player.human.pos:dist(human.pos)

        human.data.headHP = human.headHP
        human.data.chestHP = human.chestHP

        human.data.leftArmHP = human.leftArmHP
        human.data.rightArmHP = human.rightArmHP

        human.data.leftLegHP = human.leftLegHP
        human.data.rightLegHP = human.rightLegHP

        human.data.bloodLevel = human.bloodLevel


        local leftHand = bullet.player.human:getInventorySlot(1).primaryItem
        local rightHand = bullet.player.human:getInventorySlot(0).primaryItem

        local weaponsUsed = {}
        
        if leftHand then
            if leftHand.type.isGun then
                table.insert(weaponsUsed,leftHand.type.name)
            end 
        end

        if rightHand then
            if rightHand.type.isGun then
                table.insert(weaponsUsed,rightHand.type.name)
            end
        end

        if #weaponsUsed == 1 then
            human.data.usedWeapon = weaponsUsed[1]
        else
            human.data.usedWeapon = weaponsUsed[1].." and a "..weaponsUsed[2]
        end
    end
end)

plugin:addHook("HumanLimbInverseKinematics",function (hum,A,B,pos)
    if hum:getInventorySlot(0).primaryItem == scanner and state ~= 0 and not gameEnd then
        if A == enum.body.torso and B == enum.body.shoulder_right then
            pos:set(Vector(-.2,0,-.6))
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

function Init()
    server.type = enum.gamemode.eliminator+16
	server.levelToLoad = "round"
	server.state = enum.state.intermission
    server.time = 60*60*2

    for _,ply in ipairs(players.getAll()) do
        ply.isReady = false
    end

    map = {
        {
            name = "ttt_theatre",
            spawns = {Vector(1290.2,25.08,1268.58), Vector(1282.34,25.08,1272.16), Vector(1288.83,25.08,1282.39), Vector(1285.75,25.09,1297.33), Vector(1289.98,25.08,1306.82), Vector(1294.86,25.08,1277.22), Vector(1307.04,25.09,1301.65), Vector(1269.27,25.08,1303.67), Vector(1268.97,25.08,1279.26), Vector(1275.92,25.09,1267.54), Vector(1272.27,29.09,1292.92), Vector(1276.95,29.08,1287.28), Vector(1271.25,29.08,1285.86), Vector(1286.55,29.08,1290.39), Vector(1291,29.08,1294.06), Vector(1297.58,29.08,1287.31), Vector(1305.78,29.08,1286.36), Vector(1305.57,29.08,1291.86), Vector(1285.98,25.09,1309.25), Vector(1285.23,25.09,1288.15)},
            walls = {
                {pos = Vector(1285.97,25,1264.18), rot = orientations.n},
                {pos = Vector(1285.97,26,1264.18), rot = orientations.n},
                {pos = Vector(1311.82,25,1290.02), rot = orientations.e},
                {pos = Vector(1311.82,26,1290.02), rot = orientations.e},
                {pos = Vector(1268.18,25,1294), rot = orientations.e},
                {pos = Vector(1268.18,26.3,1294), rot = orientations.e},
            }

        },

        {
            name = "ttt_apartments",
            spawns = {Vector(1666.57,53.08,1624.56), Vector(1678.61,53.09,1613.4), Vector(1670.7,53.08,1607.3), Vector(1671.4,49.08,1597.46), Vector(1671.77,49.08,1607.51), Vector(1685.19,47.78,1623.37), Vector(1703.9,49.08,1619.65), Vector(1705.07,53.08,1587.15), Vector(1708.69,53.07,1615.34), Vector(1705.78,53.07,1623.51), Vector(1706.51,57.08,1594.72), Vector(1707.1,48.83,1637.32), Vector(1714.73,48.83,1647.03), Vector(1715.38,50.9,1653.89), Vector(1704.38,53.09,1662.15), Vector(1711.49,53.08,1666.84), Vector(1672.15,57.08,1660.84), Vector(1661.65,57.08,1665.03), Vector(1657.49,49.33,1639.12), Vector(1654.25,53.99,1610.4)},
            weaponSpawns = {Vector(1674.97,48.45,1670.41), Vector(1658.33,49.09,1670.56), Vector(1658.35,49.07,1656.53), Vector(1658.07,49.08,1662.62), Vector(1656.73,48.96,1653.66), Vector(1693.63,49.08,1657.23), Vector(1694.45,49.08,1669.4), Vector(1689.72,49.08,1670.25), Vector(1709.48,49.09,1657.09), Vector(1713.86,49.08,1662.84), Vector(1713.97,49.08,1657.4), Vector(1713.37,49.08,1667.78), Vector(1698.24,49.08,1670.77), Vector(1713.09,53.08,1658.04), Vector(1714.09,53.08,1662.03), Vector(1713.93,53.08,1667.33), Vector(1697.88,53.08,1670.61), Vector(1693.47,53.08,1656.91), Vector(1694.16,53.08,1669.24), Vector(1689.44,53.08,1669.9), Vector(1677.41,53.08,1670.03), Vector(1682.12,53.08,1669.79), Vector(1677.07,53.07,1657.29), Vector(1674.89,53.08,1669.27), Vector(1656.48,52.86,1667.2), Vector(1658.83,53.08,1656.66), Vector(1658.06,53.09,1662.48), Vector(1659.33,57.09,1667.37), Vector(1658.35,57.08,1657.47), Vector(1658.12,57.08,1662.32), Vector(1693.76,57.08,1657.29), Vector(1677.31,57.08,1656.92), Vector(1676.92,57.08,1669.7), Vector(1683.49,57.08,1670.26), Vector(1694.95,57.08,1670.19), Vector(1688.9,57.07,1669.61), Vector(1713.35,57.08,1657.72), Vector(1714.29,57.08,1663.37), Vector(1713.45,57.08,1667.18), Vector(1674.76,49.08,1637.2), Vector(1664.11,49.07,1633.79), Vector(1661.56,49.08,1621.69), Vector(1674.65,49.08,1617.37), Vector(1663.09,49.09,1612.61), Vector(1672.89,49.08,1609.22), Vector(1673.97,49.07,1586.71), Vector(1670.1,49.08,1601.34), Vector(1678.96,48.97,1585.28), Vector(1675.5,53.03,1598.76), Vector(1666.76,53.07,1586.7), Vector(1674.57,53.09,1614.18), Vector(1666.67,53.08,1616.01), Vector(1665.76,53.07,1607.1), Vector(1673.55,53.08,1625.88), Vector(1662.26,53.08,1629.6), Vector(1662.29,53.08,1634.07), Vector(1709.02,49.08,1617.04), Vector(1713.1,49.08,1621.82), Vector(1713.08,49.08,1618.21), Vector(1713.79,49.08,1628.21), Vector(1701.49,49.07,1606.15), Vector(1707.06,49.08,1612.99), Vector(1701.77,49.08,1587.54), Vector(1714.62,49.06,1590.26), Vector(1713.43,49.09,1601.61), Vector(1714.35,49.08,1598.27), Vector(1713.14,53.08,1602.46), Vector(1714.11,53.08,1597.4), Vector(1714.87,53.06,1590.44), Vector(1702.61,53.09,1612.11), Vector(1706.15,53.08,1607.95), Vector(1701.45,53.08,1620.03), Vector(1713.13,53.08,1616.97), Vector(1713.82,53.08,1621.49), Vector(1712.9,53.07,1628.57), Vector(1703.18,57.08,1598.2), Vector(1713.07,57.08,1597.36), Vector(1714,57.07,1603.01), Vector(1702.03,57.08,1611.7), Vector(1701.94,57.08,1605.92), Vector(1713.6,57.06,1630.23), Vector(1713.78,57.08,1618.08), Vector(1713.67,57.08,1621.91)},
            bounds = {Vector(1780.29,24.88,1692.07), Vector(1625.55,59.47,1577.68)}
        },
    }

    currMap = map[2]

    gameEnd = false

    state = 0
end

function Tick()
    allPlayers = players.getAll()
    allHumans = humans.getAll()

    --Welcome Players--
    for _,ply in ipairs(allPlayers) do
        if ply.connection then
            if not ply.data.joined and ply.connection.numReceivedEvents == #events then
                messagePlayerWrap(ply,"Welcome to TTT! /info for more info")
                ply.data.joined = true
            end
        end
    end

    if #allPlayers > 0 then
        if server.state == 1 then
            Lobby()
        end
    end

    if server.state == 2 then
        Game()
    end

    for _,hum in ipairs(humans.getAll()) do
        if hum.despawnTime < 60*60*1 and not hum.player then
            hum.despawnTime = 60*60*10
        end
    end
end

function Lobby()
	local readiedPlayers = 0
	for _,ply in ipairs(allPlayers) do
		if ply.isReady and ply.account then
			readiedPlayers = readiedPlayers + 1
		end
	end

    if #allPlayers < 3 and readiedPlayers == #allPlayers then
        chat.announce("Need 3 or More Players to start")
        readiedPlayers = 0
        for _,ply in ipairs(allPlayers) do
            ply.isReady = false
        end
    end

	if readiedPlayers == 0 then
		server.time = 2*60*60
	end

	if readiedPlayers >= 1 then
		server.time = server.time - 1
	end

	if readiedPlayers >= #players.getNonBots()/2 then
		if server.time > 10*60 then
			server.time = 10*60
		end
	end

	if readiedPlayers == #players.getNonBots() or server.time <= 30 then
		server.state = enum.state.ingame
	end
end

function Game()
    for _,human in ipairs(allHumans) do
        if not human.isAlive then
            if human.player then
                human.data.player = human.player
            end

            if state == 0 then
                human.data.player.team = 4
            end

            if not human.data.deathTicket then
                human.data.deathTicket = items.create(itemTypes[enum.item.memo],human.pos,orientations.n)
                assert(human.data.deathTicket)

                if not human.data.chestHP or human.data.hitBy == human then
                    human.data.usedWeapon = "Suicide/Mysterious Death"
                    human.data.chestHP = " 0 "
                    human.data.headHP = " 0 "
                    human.data.leftArmHP = 0
                    human.data.rightArmHP = 0
                    human.data.leftLegHP = 0
                    human.data.rightLegHP = 0
                    human.data.lastHitPos = 0
                    human.data.bloodLevel = 0
                else
                    if human.data.chestHP < 100 then
                        if human.data.chestHP >= 10 then
                            human.data.chestHP = " "..human.data.chestHP
                        else
                            human.data.chestHP = " 0 "
                        end
                    end

                    if human.data.headHP < 100 then
                        if human.data.headHP >= 10 then
                            human.data.headHP = " "..human.data.headHP
                        else
                            human.data.headHP = " 0 "
                        end
                    end
                end

                local bodyState = [[

    Name: %s
    Role: %s
    Blood Level: %s
    Murder Weapon: %s
    Bullet Travel Distance: %s m
                                    _________
                                    |       |
                                    |  %s  |
                                    |       |
                                    _________
                                      |   |
                                 __ _________ __
                                |  ||       ||  |
                                |  ||       ||  |
                                |  ||       ||  |
                                |  ||       ||  |
                                |  ||  %s  ||  | L %s / R %s
                                |  ||       ||  |
                                |  ||       ||  |
                                |__|_________|__|
                                    |  | |  |
    Hint: High Blood Level / HPs    |  | |  |
    = Quick Death                   |  | |  | L %s / R %s]]

                local team
                if human.data.player.team == 3 then
                    team = "Traitor"
                elseif human.data.player.team == 2 then
                    team = "Innocent"
                elseif human.data.player.team == 4 then
                    team = "Unassigned"
                else
                    team = "Detective"
                end

                human.data.deathTicket.memoText = string.format(bodyState,
                human.data.player.name,team,human.data.bloodLevel,human.data.usedWeapon,math.ceil(human.data.lastHitPos * 10) / 10,

                human.data.headHP,human.data.chestHP,human.data.leftArmHP,human.data.rightArmHP,human.data.leftLegHP,human.data.rightLegHP
                )

                human.data.deathTicket.isStatic = true
                human.data.deathTicket.parentHuman = humans[255]

                human.data.usedWeapon = nil
                human.data.chestHP = nil
                human.data.HeadHP = nil
                human.data.leftArmHP = nil
                human.data.rightArmHP = nil
                human.data.leftLegHP = nil
                human.data.rightLegHP = nil
                human.data.playerName = nil
                human.data.bloodLevel = nil
            end

            human.data.deathTicket.pos = human.pos+Vector(0,.2,0)
            human.data.deathTicket.despawnTime = 11*10*60
        end
    end

    --Spawn The Players--
    if not spawned then
        totalTraitors = 0

        for i=1,5 do
            allPlayers = table.shuffle(allPlayers)
            currMap.weaponSpawns = table.shuffle(currMap.weaponSpawns)
        end

        for i=1,#allPlayers do
            ---@type Player
            local ply = allPlayers[i]
            humans.create(currMap.spawns[i],eulerAnglesToRotMatrix(0,math.random(0,180),0),ply)
            ply.team = 4
        end


        for i=1,#allPlayers*3 do
            local weapon = math.random(1,100)
            if weapon <= 20 then
                weapon = "M-16"
            elseif weapon > 20 and weapon <= 70 then
                weapon = math.random(1,2)
                if weapon == 1 then
                    weapon = "Uzi"
                else
                    weapon = "9mm"
                end
            else
                weapon = "MP5"
            end

            --chat.announce(weapon)

            local itm = items.create(itemTypes.getByName(weapon),currMap.weaponSpawns[i],yawToRotMatrix(math.random(0,180)))
            itm.despawnTime = 11*60*60

            for j=1,2 do
                local itm = items.create(itemTypes.getByName(weapon.." Magazine"),currMap.weaponSpawns[i],yawToRotMatrix(math.random(0,180)))
                itm.despawnTime = 11*60*60
            end
        end

        if currMap.walls then
            for _,wall in ipairs(currMap.walls) do
                local itm = items.create(itemTypes[enum.item.wall],wall.pos,wall.rot)
                itm.hasPhysics = true
                itm.isStatic = true
                itm.parentHuman = humans[255]
                itm.despawnTime = 60*60*20
            end
        end

        spawned = true
        server.time = 60*21
    end

    --Assign Players and Tell Them Their Roles--
    if server.time == 60 and state == 0 then
        for i=1,5 do
            allPlayers = table.shuffle(allPlayers)
        end

        for i=1,#allPlayers do
            ---@type Player
            local ply = allPlayers[i]
            if i == 1 then
                ply.data.showCrim = false
                ply.team = 0
                ply:update()

                messagePlayerWrap(ply,"You are the Detective!")

                scanner = items.create(itemTypes[enum.item.disk_gold],ply.human.pos,orientations.n)
                assert(scanner)
                ply.human:mountItem(scanner,6)
                scans = 2
            elseif i <= math.ceil(#allPlayers/5) + 1 and i ~= 1 then
                ply.data.showCrim = true
                ply.team = 3
                ply:update()
                messagePlayerWrap(ply,"You are a Traitor!")
                totalTraitors = totalTraitors + 1
            else
                ply.data.showCrim = false
                ply.team = 2
                messagePlayerWrap(ply,"You are Innocent!")
                ply:update()
            end
        end

        if totalTraitors == 1 then
            events.createMessage(3,"There is 1 Traitor!",-1,2)
        else
            events.createMessage(3,string.format("There are %s Traitors!",totalTraitors),-1,2)
        end

        for _,hum in ipairs(allHumans) do
            events.createSound(enum.sound.phone.buttons[2],hum.pos,1,1)
        end
        
        state = 1

        server.time = 60*60*10

        for _,ply in ipairs(allPlayers) do
            ply:updateElimState(0,-1,players[255],nil)
        end
    end

    if state == 1 then
        TeamsAlive()
        Scanner()

        for _,human in ipairs(allHumans) do
            if KeyPressed(human,enum.input.f) then
                if not human.data.checkedStat then
                    if human.player.team == 0 then
                        messagePlayerWrap(human.player,"You are the Detective")
                    elseif human.player.team == 2 then
                        messagePlayerWrap(human.player,"You are Innocent")
                    else
                        messagePlayerWrap(human.player,"You are a Traitor")
                    end
                    human.data.checkedStat = true
                end
            else
                human.data.checkedStat = false
            end
        end
    end

    Bounds()

    if not gameEnd then
        server.time = server.time - 1
    end
end

function Scanner()
    if scanner.parentHuman then
        if KeyPressed(scanner.parentHuman,enum.input.lmb) and not KeyPressed(scanner.parentHuman,enum.input.shift) and scanner.parentSlot == 0 and scanner.parentHuman.player.team ~= 3 then
            if not  scanning then
                if scans > 0 then
                    ---@param hum Human
                    for _,hum in ipairs(allHumans) do
                        if hum.pos:dist(scanner.pos) <= 2 and hum ~= scanner.parentHuman and hum.isAlive then
                            local hit = physics.lineIntersectHuman(hum,scanner.pos,scanner.rot:forwardUnit()*.5,0)
                            if hit then
                                if hum.player.team == 3 then
                                    messagePlayerWrap(scanner.parentHuman.player,string.format("%s is a Traitor!",hum.player.name))
                                    events.createSound(enum.sound.phone.buttons[1],scanner.pos,1,.5)
                                else
                                    messagePlayerWrap(scanner.parentHuman.player,string.format("%s is Innocent!",hum.player.name))
                                    events.createSound(enum.sound.phone.buttons[1],scanner.pos,9,.9)
                                end

                                scans = scans - 1
                            end
                        end
                    end
                else
                    messagePlayerWrap(scanner.parentHuman.player,"No Scans Left")
                end

                scanning = true
            end
        else
            scanning = false
        end
    end
end

function TeamsAlive()
    civsAlive,tsAlive = false,false
    for _,ply in ipairs(allPlayers) do
        if ply.human then
            if ply.human.isAlive then
                if ply.team == 0 or ply.team == 2 then
                    civsAlive = true
                    break
                end
            end
        end
    end

    for _,ply in ipairs(allPlayers) do
        if ply.human then
            if ply.human.isAlive then
                if ply.team == 3 then
                    tsAlive = true
                    break
                end
            end
        end
    end

    if not gameEnd then
        if not tsAlive then
            events.createMessage(3,"Civillians Win!",-1,2)
            gameEnd = true

            for _,hum in ipairs(allHumans) do
                events.createSound(enum.sound.misc.whistle,hum.pos,.8,.9)
            end

        elseif not civsAlive then
            events.createMessage(3,"Terrorists Win!",-1,2)
            gameEnd = true

            for _,hum in ipairs(allHumans) do
                events.createSound(enum.sound.vehicle.train[1],hum.pos,1,1)
            end
        end

        if server.time == 1*60 then
            gameEnd = true
            events.createMessage(3,"Stalemate! Restarting...",-1,2)
    
            for _,hum in ipairs(allHumans) do
                events.createSound(enum.sound.computer.disk_drive,hum.pos,1,1)
            end
        end

        resetTime = 10
    end

    if gameEnd then
        server.time = 11*60 + 11*60*60
        resetTime = resetTime - 1/62.5
        if resetTime <= 0 then
            server:reset()
        end
    end
end

function Bounds()
    if currMap.bounds then
        for _,ply in ipairs(allPlayers) do
            if ply.human and not isVectorInCuboid(ply.human.pos,currMap.bounds[1],currMap.bounds[2]) then
                if server.ticksSinceReset % 20 == 0 then
                    ply.human.chestHP = ply.human.chestHP - 2
                end

                if server.ticksSinceReset % 40 == 0 then
                    messagePlayerWrap(ply,"You are out of bounds!")
                end
            end
        end
    end
end

plugin.commands['/spawn'] = {
    info = "Spawn in game for testing",
    canCall = function (ply)
        return ply.isAdmin
    end,
    call = function (ply, hum, args)
        if not hum then
            if not args[1] then
                humans.create(ply.connection.cameraPos,orientations.n,ply)
            else
                ---@diagnostic disable-next-line: param-type-mismatch
                humans.create(Vector(tonumber(args[1]),tonumber(args[2]),tonumber(args[3])),orientations.n,ply)
            end
        end
    end
}

plugin.commands['/unspawn'] = {
    info = "Spawn in game for testing",
    canCall = function (ply)
        return ply.isAdmin
    end,
    call = function (ply, hum, args)
        if hum then
            hum:remove()
        end
    end
}

plugin.commands["/info"] = {
    alias = {"/about","/serverinfo","/howtoplay"},
    info = "Get basic info about TTT",
    call = function (ply,hum,args)

        if #args == 0 then
            messagePlayerWrap(ply,"/info [traitor, detective, civ, controls]")
        elseif args[1] == "detective" then
            messagePlayerWrap(ply,"Detective")
            messagePlayerWrap(ply,"Click on a player to scan them and figure out their role (w/ disk)")
            messagePlayerWrap(ply,"Eliminate the Traitors to Win")
        elseif args[1] == "civ" then
            messagePlayerWrap(ply,"Civillians/Innocent")
            messagePlayerWrap(ply,"Keep the detective safe, they can scan suspicious players")
            messagePlayerWrap(ply,"Eliminate the Traitors to Win")
        elseif args[1] == "traitor" then
            messagePlayerWrap(ply,"Traitor")
            messagePlayerWrap(ply,"Keep fellow traitors safe")
            messagePlayerWrap(ply,"Don't let the detective scan you")
            messagePlayerWrap(ply,"Eliminate the Detective and Innocents to Win")
        elseif args[1] == "controls" then
            messagePlayerWrap(ply,"Ctrl (While Running) = Run")
            messagePlayerWrap(ply,"F - Check Role")
        end
    end
}