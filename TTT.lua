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

plugin:addHook("BulletHitHuman",function (human, bullet)
    if human.isAlive then
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

        print(leftHand)
        print(rightHand)

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

    if #allPlayers > 0 then
        if server.state == 1 then
            Lobby()
        end
    end

    if server.state == 2 then
        Game()
    end

    for _,hum in ipairs(humans.getAll()) do
        if hum.despawnTime < 60*60*1 then
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

		if #allPlayers < 3 then
			notEnoughPlayers = true
		end
	end

	if readiedPlayers == #players.getNonBots() or server.time <= 30 then
		server.state = enum.state.ingame
	end
end

function Game()
    for _,human in ipairs(allHumans) do
        if not human.isAlive then
            if not human.data.deathTicket then
                human.data.deathTicket = items.create(itemTypes[enum.item.memo],human.pos,orientations.n)
                assert(human.data.deathTicket)

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

                local bodyState = [[

    
    Name: %s
    Role: %s
    Blood Level: %s
    Murder Weapon: %s
    Bullet Travel Distance: %sm     _________
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
                if human.player.team == 3 then
                    team = "Traitor"
                elseif human.player.team == 2 then
                    team = "Innocent"
                else
                    team = "Detective"
                end

                human.data.deathTicket.memoText = string.format(bodyState,
                human.data.playerName,team,human.data.bloodLevel,human.data.usedWeapon,math.ceil(human.data.lastHitPos * 10) / 10,

                human.data.headHP,human.data.chestHP,human.data.leftArmHP,human.data.rightArmHP,human.data.leftLegHP,human.data.rightLegHP
                )

                human.data.deathTicket.isStatic = true
                human.data.deathTicket.parentHuman = humans[255]
            end

            human.data.deathTicket.pos = human.pos+Vector(0,.2,0)
            human.data.deathTicket.despawnTime = 11*10*60
        end
    end

    --Spawn The Players--
    if not spawned then
        selectedDetective = false
        totalTraitors = 0

        for i=1,5 do
            allPlayers = table.shuffle(allPlayers)
        end

        for i=1,#allPlayers do
            ---@type Player
            local ply = allPlayers[i]
            humans.create(currMap.spawns[i],eulerAnglesToRotMatrix(0,math.random(0,180),0),ply)
        end

        players[255]:updateElimState(0,-1,nil,nil)

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
        server.time = 60*16
    end

    --Assign Players and Tell Them Their Roles--
    if server.time == 60 and state == 0 then
        for i=1,5 do
            allPlayers = table.shuffle(allPlayers)
        end

        for i=1,#allPlayers do
            ---@type Player
            local ply = allPlayers[i]
            if i <= math.ceil(#allPlayers/5) then
                ply.team = 3
                ply:update()
                messagePlayerWrap(ply,"You are a Traitor!")
                totalTraitors = totalTraitors + 1
            elseif not selectedDetective then
                ply.team = 0
                ply:update()
                messagePlayerWrap(ply,"You are the Detective!")
                scanner = items.create(itemTypes[enum.item.disk_gold],ply.human.pos,orientations.n)
                assert(scanner)
                ply.human:mountItem(scanner,0)
                scans = 2
                selectedDetective = true
            else
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
        
        state = 1

        server.time = 60*60*10
    end

    if state == 1 then
        TeamsAlive()
        Scanner()
    end

    Bounds()

    if not gameEnd then
        server.time = server.time - 1
    end
end

function Scanner()
    if scanner.parentHuman then
        if KeyPressed(scanner.parentHuman,enum.input.lmb) and scanner.parentSlot == 0 and scanner.parentHuman.player.team ~= 3 then
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