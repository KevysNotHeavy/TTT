---@type Plugin
local plugin = ...

local sayings = {"Went Peacefully","Born Shit, Died Shit","Ate Shit","Smelled Like Roses :sob:","Took a Dirt Nap","Stared at the Gun Barrel","Smelled Something Smoking","Lived a Good Life","Laid To Rest","Only the Good Die Young"}

local memoText =
[[


    %s%s%s



    Killed By: %s
    Distance: %s

    Team: %s

    headHP: %s

    chestHP: %s

    leftArmHP: %s
    rightArmHP: %s

    leftLegHP: %s
    rightLegHP: %s

      _____________     _____________     _____________
     |             |   |             |   |             |
     |____     ____|   |____     ____|   |____     ____|
          |   |             |   |             |   |
          |   |             |   |             |   |
          |   |             |   |             |   |
          |   |             |   |             |   |
          |   |  _          |   |  _          |   |  _
           \_/  |_|          \_/  |_|          \_/  |_|
]]

plugin:addHook("BulletHitHuman",function (human, bullet)
    local slot1 = bullet.player.human:getInventorySlot(0).primaryItem
    local slot2 = bullet.player.human:getInventorySlot(1).primaryItem

    local wep1 = nil
    local wep2 = nil

    if slot1 then
        if slot1.type.isGun then
            wep1 = slot1.type.name
        end
    end

    if slot2 then
        if slot2.type.isGun then
            wep2 = slot2.type.name
        end
    end

    local weapons
    if wep1 and wep2 then
        weapons = wep1 .." and ".. wep2
    elseif wep1 then
        weapons = wep1
    elseif wep2 then
        weapons = wep2
    else
        if bullet.type == 0 then
            weapons = "AK-47"
        elseif bullet.type == 1 then
            weapons = "M-16"
        elseif bullet.type == 2 then
            weapons = "Uzi OR 9mm"
        end
    end

    human.data.bulletHit = weapons
    human.data.bulletDistance = math.floor(bullet.pos:dist(human.pos)).."m"
    human.data.player = human.player
    human.data.timeTillResetInfo = 60*3
end)

plugin:addHook("Logic",function ()
    if not lobby then
        for _,human in pairs(humans.getAll()) do

            if not human.data.deathNote then

                --Reset so we can account for deaths related to falling or pbeing pushed etc.
                if human.data.timeTillResetInfo then
                    human.data.timeTillResetInfo = human.data.timeTillResetInfo - 1

                    if human.data.timeTillResetInfo <= 0 then
                        human.data.bulletHit = nil
                        human.data.bulletDistance = nil
                        human.data.player = nil

                        human.data.timeTillResetInfo = nil
                    end
                end

                if not human.isAlive then
                    local note = items.create(itemTypes[enum.item.memo],human.pos:clone(),orientations.n)
                
                    math.randomseed(os.clock())
                    local saying = sayings[math.random(1,#sayings)]

                    local ply = human.data.player or human.player or "Not Found"
                    local nameSpace = 55 - string.len(saying) - string.len(ply.name)
                    local nameSpacing = ""
                
                    for i=1,nameSpace do
                        nameSpacing = nameSpacing .. " "
                    end

                    local bullet = human.data.bulletHit or "Fell / Pushed"

                    if bullet == 0 then
                        bullet = "AK-47"
                    elseif bullet == 1 then
                        bullet = "M-16"
                    elseif bullet == 2 then
                        bullet = "UZI / 9mm"
                    end

                    local team = ply.team or "N / A"

                    if team == 0 then
                        team = "Detective" ---@diagnostic disable-line: cast-local-type
                    elseif team == 3 then
                        team = "Traitor" ---@diagnostic disable-line: cast-local-type
                    else
                        team = "Innocent" ---@diagnostic disable-line: cast-local-type
                    end

                    
                    --health = human.data.headHP,human.data.leftArmHP,human.data.rightArmHP,human.data.chestHP,human.data.leftLegHP,human.data.rightLegHP
                    health = {math.clamp(human.headHP,0,100),math.clamp(human.chestHP,0,100),math.clamp(human.leftArmHP,0,100),math.clamp(human.rightArmHP,0,100),math.clamp(human.leftLegHP,0,100),math.clamp(human.rightLegHP,0,100)}

                    note.memoText = string.format(memoText,ply.name,nameSpacing,saying,bullet,human.data.bulletDistance or "N / A",team,health[1],health[2],health[3],health[4],health[5],health[6])
                    note.parentHuman = humans[255]
                    note.despawnTime = 60*60*99
                    human.data.deathNote = note
                end
            else
                human.data.deathNote.pos = human:getRigidBody(1).pos + Vector(0,1.3,0)


                local closestPlayer = {ply=nil,dist=math.huge}

                for _,ply in pairs(players.getAll()) do
                    if ply.connection and ply.human then
                        if not physics.lineIntersectLevel(ply.connection.cameraPos,human.data.deathNote.pos,false).hit then
                            if human.data.deathNote.pos:dist(ply.connection.cameraPos) < closestPlayer.dist then
                                closestPlayer.dist = human.data.deathNote.pos:dist(ply.connection.cameraPos)
                                closestPlayer.ply = ply
                            end
                        end
                    end
                end

                if closestPlayer.ply then
                    local nill, y = rotMatrixToEulerAngles(getRotMatrixLookingAt(closestPlayer.ply.connection.cameraPos,human.data.deathNote.pos))

                    human.data.deathNote.rot = eulerAnglesToRotMatrix(math.rad(-90),y,0)
                end
            end
        end
    end
end)