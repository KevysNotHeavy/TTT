---@type Plugin
local plugin = ...

tickRate = 62.5 --Default server tickrate

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

plugin:addHook("BulletHitHuman",function (human, bullet)
    if human.isAlive and human.player then
        human.data.deathInfo = {}
        human.data.deathInfo.refreshRate = 3
        human.data.deathInfo.hitBy = bullet.player.human
        human.data.deathInfo.playerName = human.player.name
        human.data.deathInfo.hitDistance = math.ceil(bullet.player.human.pos:dist(human.pos)*10)/10

        human.data.deathInfo.headHP = human.headHP
        human.data.deathInfo.chestHP = human.chestHP

        human.data.deathInfo.leftArmHP = human.leftArmHP
        human.data.deathInfo.rightArmHP = human.rightArmHP

        human.data.deathInfo.leftLegHP = human.leftLegHP
        human.data.deathInfo.rightLegHP = human.rightLegHP

        human.data.deathInfo.bloodLevel = human.bloodLevel

        local weaponsUsed = ""

        for i=0,1 do
            local item = bullet.player.human:getInventorySlot(i).primaryItem
            if item then
                if item.type.isGun then
                    weaponsUsed = weaponsUsed .. item.type.name
                end
            end
        end

        human.data.deathInfo.weaponUsed = weaponsUsed

        if human.player.team == 0 then
            human.data.deathInfo.teamName = "Detective"
        elseif human.player.team == 2 then
            human.data.deathInfo.teamName = "Innocent"
        elseif human.player.team == 3 then
            human.data.deathInfo.teamName = "Traitor"
        else
            human.data.deathInfo.teamName = "Unassigned"
        end
    end
end)


local currBuildingConnection = nil
plugin:addHook("PacketBuilding",function (connection)
    if connection == currBuildingConnection then
        return
    end
    currBuildingConnection = connection
end)

plugin:addHook("PostBulletCreate",function (bullet)
    if grace then
        bullet.time = 0
        bullet.vel = Vector(0,0,0)
    end
end)

plugin:addHook("HumanLimbInverseKinematics",function (hum,A,B,pos)
    if scanner then
        if hum:getInventorySlot(0).primaryItem == scanner and hum.throwPitch == 0 then
            if A == enum.body.torso and B == enum.body.shoulder_right then
                pos:set(Vector(-.2,0,-.6))
            end
        end

        if hum:getInventorySlot(1).primaryItem == scanner and hum.throwPitch == 0 then
            if A == enum.body.torso and B == enum.body.shoulder_left then
                pos:set(Vector(.2,0,-.6))
            end
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
    queueReset = false
    server.state = enum.state.intermission
    server.type = enum.gamemode.eliminator+16
    server.levelToLoad = "round"

    graceTime = 30 --Seconds
    grace = true
    roundTime = 10 --Minutes

    endGame = false
    initGame = false
    allTraitors = {}

    for _,ply in ipairs(players.getAll()) do
        ply.criminalRating = 0
    end
end

function Tick()
    allPlayers = players.getAll()
    allHumans = humans.getAll()

    if #allPlayers >= 1 then
        queueReset = true
    end

    --Welcome Players--
    for _,ply in ipairs(allPlayers) do
        if ply.connection and not ply.data.joined then
            ---@diagnostic disable-next-line: undefined-field
            if ply.connection.numReceivedEvents == #events then
                messagePlayerWrap(ply,"Welcome to TTT! /info for more info")
                ply.data.joined = true
            end
        end
    end

    --Main Logic
    if server.state == enum.state.intermission then
        Lobby()
    else
        Game()
    end

    if queueReset and #allPlayers == 0 then
        server:reset()
    end

    MapData()
end

function MapData() --add the ventian (wooden building small and cool)
    map = {
        {
            name = "ttt_apartments",
            spawns = {Vector(1666.57,53.08,1624.56), Vector(1678.61,53.09,1613.4), Vector(1670.7,53.08,1607.3), Vector(1671.4,49.08,1597.46), Vector(1671.77,49.08,1607.51), Vector(1685.19,47.78,1623.37), Vector(1703.9,49.08,1619.65), Vector(1705.07,53.08,1587.15), Vector(1708.69,53.07,1615.34), Vector(1705.78,53.07,1623.51), Vector(1706.51,57.08,1594.72), Vector(1707.1,48.83,1637.32), Vector(1714.73,48.83,1647.03), Vector(1715.38,50.9,1653.89), Vector(1704.38,53.09,1662.15), Vector(1711.49,53.08,1666.84), Vector(1672.15,57.08,1660.84), Vector(1661.65,57.08,1665.03), Vector(1657.49,49.33,1639.12), Vector(1654.25,53.99,1610.4)},
            weaponSpawns = {Vector(1674.97,48.45,1670.41), Vector(1658.33,49.09,1670.56), Vector(1658.35,49.07,1656.53), Vector(1658.07,49.08,1662.62), Vector(1656.73,48.96,1653.66), Vector(1693.63,49.08,1657.23), Vector(1694.45,49.08,1669.4), Vector(1689.72,49.08,1670.25), Vector(1709.48,49.09,1657.09), Vector(1713.86,49.08,1662.84), Vector(1713.97,49.08,1657.4), Vector(1713.37,49.08,1667.78), Vector(1698.24,49.08,1670.77), Vector(1713.09,53.08,1658.04), Vector(1714.09,53.08,1662.03), Vector(1713.93,53.08,1667.33), Vector(1697.88,53.08,1670.61), Vector(1693.47,53.08,1656.91), Vector(1694.16,53.08,1669.24), Vector(1689.44,53.08,1669.9), Vector(1677.41,53.08,1670.03), Vector(1682.12,53.08,1669.79), Vector(1677.07,53.07,1657.29), Vector(1674.89,53.08,1669.27), Vector(1656.48,52.86,1667.2), Vector(1658.83,53.08,1656.66), Vector(1658.06,53.09,1662.48), Vector(1659.33,57.09,1667.37), Vector(1658.35,57.08,1657.47), Vector(1658.12,57.08,1662.32), Vector(1693.76,57.08,1657.29), Vector(1677.31,57.08,1656.92), Vector(1676.92,57.08,1669.7), Vector(1683.49,57.08,1670.26), Vector(1694.95,57.08,1670.19), Vector(1688.9,57.07,1669.61), Vector(1713.35,57.08,1657.72), Vector(1714.29,57.08,1663.37), Vector(1713.45,57.08,1667.18), Vector(1674.76,49.08,1637.2), Vector(1664.11,49.07,1633.79), Vector(1661.56,49.08,1621.69), Vector(1674.65,49.08,1617.37), Vector(1663.09,49.09,1612.61), Vector(1672.89,49.08,1609.22), Vector(1673.97,49.07,1586.71), Vector(1670.1,49.08,1601.34), Vector(1678.96,48.97,1585.28), Vector(1675.5,53.03,1598.76), Vector(1666.76,53.07,1586.7), Vector(1674.57,53.09,1614.18), Vector(1666.67,53.08,1616.01), Vector(1665.76,53.07,1607.1), Vector(1673.55,53.08,1625.88), Vector(1662.26,53.08,1629.6), Vector(1662.29,53.08,1634.07), Vector(1709.02,49.08,1617.04), Vector(1713.1,49.08,1621.82), Vector(1713.08,49.08,1618.21), Vector(1713.79,49.08,1628.21), Vector(1701.49,49.07,1606.15), Vector(1707.06,49.08,1612.99), Vector(1701.77,49.08,1587.54), Vector(1714.62,49.06,1590.26), Vector(1713.43,49.09,1601.61), Vector(1714.35,49.08,1598.27), Vector(1713.14,53.08,1602.46), Vector(1714.11,53.08,1597.4), Vector(1714.87,53.06,1590.44), Vector(1702.61,53.09,1612.11), Vector(1706.15,53.08,1607.95), Vector(1701.45,53.08,1620.03), Vector(1713.13,53.08,1616.97), Vector(1713.82,53.08,1621.49), Vector(1712.9,53.07,1628.57), Vector(1703.18,57.08,1598.2), Vector(1713.07,57.08,1597.36), Vector(1714,57.07,1603.01), Vector(1702.03,57.08,1611.7), Vector(1701.94,57.08,1605.92), Vector(1713.6,57.06,1630.23), Vector(1713.78,57.08,1618.08), Vector(1713.67,57.08,1621.91)},
            bounds = {Vector(1780.29,24.88,1692.07), Vector(1625.55,59.47,1577.68)}
        },
    }

    currMap = map[1]
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
        server.time = 60*graceTime
	end
end

function Game()
    if not endGame then
        server.time = server.time - (62.5/tickRate)
    end

    for _,human in ipairs(humans.getAll()) do
        if not human.data.permanent and not human.player then
            human.despawnTime = 60*60*roundTime*1.5
            human.data.permanent = true
        end

        if human.data.deathInfo then
            if human.data.deathInfo.hitBy then
                human.data.deathInfo.refreshRate = human.data.deathInfo.refreshRate - 1/tickRate
                if human.data.deathInfo.refreshRate <= 0 then
                    human.data.deathInfo = nil
                end
            end
        end

        if not human.data.deathInfo then
            human.data.deathInfo = {}
            human.data.deathInfo.playerName = human.player.name
            human.data.deathInfo.refreshRate = 3

            if human.player.team == 0 then
                human.data.deathInfo.teamName = "Detective"
            elseif human.player.team == 2 then
                human.data.deathInfo.teamName = "Innocent"
            elseif human.player.team == 3 then
                human.data.deathInfo.teamName = "Traitor"
            else
                human.data.deathInfo.teamName = "Unassigned"
            end
        end

        if KeyPressed(human,enum.input.f) then
            if not human.data.checkedStat then
                if human.player.team == 0 then
                    messagePlayerWrap(human.player,"You are the Detective")
                elseif human.player.team == 2 then
                    messagePlayerWrap(human.player,"You are Innocent")
                elseif human.player.team == 3 then
                    messagePlayerWrap(human.player,"You are a Traitor")
                    local otherTs = ""

                    for i=1,#allTraitors do
                        local ply = allTraitors[i]
                        if i == 1 then
                            otherTs = otherTs..ply.name
                        else
                            otherTs = otherTs..", "..ply.name
                        end
                    end

                    messagePlayerWrap(human.player,"Other Traitors:"..otherTs)
                else
                    messagePlayerWrap(human.player,"You are Unassigned (Grace Period)")
                end
                human.data.checkedStat = true
            end
        else
            human.data.checkedStat = false
        end
    end

    if not initGame then
        SpawnPlayers()
        SpawnWeapons()
        initGame = true
    end

    if grace then
        AssignTeams()
    else
        Scanner()
        PlayersAlive()
    end

    DeathInformation()

    Bounds()
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

function SpawnPlayers()
    for i=1,5 do
        allPlayers = table.shuffle(allPlayers)
    end

    for i=1,#allPlayers do
        ---@type Player
        local ply = allPlayers[i]
        humans.create(currMap.spawns[i],eulerAnglesToRotMatrix(0,math.random(0,180),0),ply)
        ply.team = 4
    end

    server.time = 60*graceTime
end

function SpawnWeapons()
    for i=1,5 do
        currMap.weaponSpawns = table.shuffle(currMap.weaponSpawns)
    end

    for i=1,math.clamp(#allPlayers*3,20,999) do
        local weapon = math.random(1,100)
        if weapon <= 20 then
            weapon = "M-16" ---@diagnostic disable-line: cast-local-type
        elseif weapon > 20 and weapon <= 70 then
            weapon = math.random(1,2)
            if weapon == 1 then
                weapon = "Uzi" ---@diagnostic disable-line: cast-local-type
            else
                weapon = "9mm" ---@diagnostic disable-line: cast-local-type
            end
        else 
            weapon = "MP5" ---@diagnostic disable-line: cast-local-type
        end

        local itm = items.create(itemTypes.getByName(weapon),currMap.weaponSpawns[i],yawToRotMatrix(math.random(0,180)))
        itm.despawnTime = roundTime*1.5*60*60

        for j=1,3 do
            local itm = items.create(itemTypes.getByName(weapon.." Magazine"),currMap.weaponSpawns[i],yawToRotMatrix(math.random(0,180)))
            itm.despawnTime = roundTime*1.5*60*60
        end
    end
end

function AssignTeams()
    if server.time <= 60*1 then
        for i=1,5 do
            allPlayers = table.shuffle(allPlayers)
        end

        for i=1,#allPlayers do
            ---@type Player
            local ply = allPlayers[i]
            if i == 1 then
                ply.team = 0
                ply:update()
                ply.criminalRating = 1

                messagePlayerWrap(ply,"You are the Detective!")

                scanner = items.create(itemTypes[enum.item.disk_gold],ply.human.pos,orientations.n)
                assert(scanner)
                ply.human:mountItem(scanner,6)
                scanner.despawnTime = roundTime*60*60*1.5
                scans = 2

            elseif i <= math.ceil(#allPlayers/5) + 1 then

                ply.team = 3
                ply:update()
                messagePlayerWrap(ply,"You are a Traitor!")
                table.insert(allTraitors,ply)

            else

                ply.team = 2
                messagePlayerWrap(ply,"You are Innocent!")
                ply:update()

            end
        end

        if #allTraitors == 1 then
            events.createMessage(3,"There is 1 Traitor!",-1,2)
        else
            events.createMessage(3,string.format("There are %s Traitors!",#allTraitors),-1,2)
        end

        for _,hum in ipairs(allHumans) do
            events.createSound(enum.sound.phone.buttons[2],hum.pos,1,1)
        end

        server.time = roundTime*60*60
        grace = false
    end
end

function Scanner()
    if scanner then
        if scanner.parentHuman then
            if not scanner.parentHuman.data.alertScanner and (scanner.parentSlot == 0 or scanner.parentSlot == 1) then
                messagePlayerWrap(scanner.parentHuman.player,"Equipped Scanner")
                messagePlayerWrap(scanner.parentHuman.player,"LMB to Use")
                scanner.parentHuman.data.alertScanner = true
            end
        
            allowedScan = ( (KeyPressed(scanner.parentHuman,enum.input.lmb) and not KeyPressed(scanner.parentHuman,enum.input.shift) and scanner.parentSlot == 0) or (KeyPressed(scanner.parentHuman,enum.input.lmb) and KeyPressed(scanner.parentHuman,enum.input.shift) and scanner.parentSlot == 1) )
        
            if allowedScan then
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
end

function PlayersAlive()
    local civsAlive,tsAlive = false,false
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

    if not endGame then
        if not tsAlive then
            events.createMessage(3,"Civillians Win!",-1,2)
            endGame = true

            for _,hum in ipairs(allHumans) do
                events.createSound(enum.sound.misc.whistle,hum.pos,.8,.9)
            end

        elseif not civsAlive then
            events.createMessage(3,"Terrorists Win!",-1,2)
            endGame = true

            for _,hum in ipairs(allHumans) do
                events.createSound(enum.sound.vehicle.train[1],hum.pos,1,1)
            end
        end

        if server.time == 1*60 then
            endGame = true
            events.createMessage(3,"Stalemate! Restarting...",-1,2)
    
            for _,hum in ipairs(allHumans) do
                events.createSound(enum.sound.computer.disk_drive,hum.pos,1,1)
            end
        end

        resetTime = 10
    end

    if endGame then
        server.time = 11*60 + 11*60*60
        resetTime = resetTime - 1/62.5
        if resetTime <= 0 then
            server:reset()
        end
    end
end

function DeathInformation()
    local bodyState = [[

    Name: %s
    Role: %s
    Blood Level: %s
    Murder Weapon: %s
    Bullet Travel Distance: %s

    Head HP: %s

    Chest HP: %s

    Left Arm HP: %s
    Right Arm HP: %s

    Left Leg HP: %s
    Right Leg HP: %s













    High Blood Level / HP may be a sign of a quick death
    ]]

    for _,human in ipairs(allHumans) do
        if not human.isAlive then
            
            if not human.data.deathTicket then
                local x,y,z = rotMatrixToEulerAngles(human:getRigidBody(enum.body.torso).rot)
                human.data.deathTicket = items.create(itemTypes[enum.item.memo],Vector(),yawToRotMatrix(y+180))

                if human.data.deathInfo.hitBy then
                    if human.data.deathInfo.headHP < 100 then
                        human.data.deathInfo.headHP = " "..human.data.deathInfo.headHP
                    elseif human.data.deathInfo.headHP < 10 then
                        human.data.deathInfo.headHP = " "..human.data.deathInfo.headHP.." "
                    end

                    if human.data.deathInfo.chestHP < 100 then
                        human.data.deathInfo.chestHP = " "..human.data.deathInfo.chestHP
                    elseif human.data.deathInfo.chestHP < 10 then
                        human.data.deathInfo.chestHP = " "..human.data.deathInfo.chestHP.." "
                    end
                end

                if not human.data.deathInfo.weaponUsed then
                    human.data.deathTicket.memoText = string.format(bodyState,human.data.deathInfo.playerName,human.data.deathInfo.teamName,"","Fell/Pushed","","","","","","","")
                elseif human.data.deathInfo.hitBy == human then
                    human.data.deathTicket.memoText = string.format(bodyState,human.data.deathInfo.playerName,human.data.deathInfo.teamName,"","Suicide","","","","","","","")
                elseif human.data.deathInfo.chestHP then
                    human.data.deathTicket.memoText = string.format(bodyState,human.data.deathInfo.playerName,human.data.deathInfo.teamName,human.data.deathInfo.bloodLevel,human.data.deathInfo.weaponUsed,human.data.deathInfo.hitDistance.." m",human.data.deathInfo.headHP,human.data.deathInfo.chestHP,human.data.deathInfo.leftArmHP,human.data.deathInfo.rightArmHP,human.data.deathInfo.leftLegHP,human.data.deathInfo.rightLegHP)
                end
                
                human.data.deathTicket.isStatic = true
                human.data.deathTicket.parentHuman = humans[255]
                human.data.deathTicket.despawnTime = human.despawnTime

                human.data.deathInfo = nil
            end

            human.data.deathTicket.pos = human.pos+Vector(0,.2,0)
            human.data.deathTicket.despawnTime = 11*10*60
        end
    end
end

plugin.commands['/showt'] = {
    info = "Spawn in game for testing",
    canCall = function (ply)
        return ply.isAdmin
    end,
    call = function (ply, hum, args)
        if not ply.data.showTraitors then
            ply.data.showTraitors = true
            messagePlayerWrap(ply,"Showing Traitors")
        else
            ply.data.showTraitors = false
            messagePlayerWrap(ply,"Hiding Traitors")
        end
    end
}

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
            messagePlayerWrap(ply,"Usage: /info [traitor, detective, civ, controls]")
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
            messagePlayerWrap(ply,"Ctrl + Shift + W (While in Run) = Sprint")
            messagePlayerWrap(ply,"F - Check Role")
        end
    end
}