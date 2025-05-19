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

    leftArmHP: %s
    rightArmHP: %s

    chestHP: %s

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
    human.data.bulletHit = bullet.type
    human.data.bulletDistance = math.floor(bullet.pos:dist(human.pos))
    human.data.player = human.player
end)

plugin:addHook("PostHumanDamage",function (human)
    if human.isAlive then
        human.data.headHP = math.clamp(human.headHP,0,100)

        human.data.chestHP = math.clamp(human.chestHP,0,100)

        human.data.leftArmHP = math.clamp(human.leftArmHP,0,100)
        human.data.rightArmHP = math.clamp(human.rightArmHP,0,100)

        human.data.leftLegHP = math.clamp(human.leftLegHP,0,100)
        human.data.rightLegHP = math.clamp(human.rightLegHP,0,100)
    end
end)

plugin:addHook("Logic",function ()
    if not lobby then
        for _,human in pairs(humans.getAll()) do
            if not human.data.deathNote then
                if not human.isAlive then
                    chat.announce("ran")
                    local note = items.create(itemTypes[enum.item.memo],human.pos:clone(),orientations.n)
                
                    math.randomseed(os.clock())
                    local saying = sayings[math.random(1,#sayings)]

                    local ply = human.data.player or human.player or "Not Found"
                    local nameSpace = 54 - string.len(saying) - string.len(ply.name)
                    local nameSpacing = ""
                
                    for i=1,nameSpace do
                        nameSpacing = nameSpacing .. " "
                    end

                    local bullet = human.data.bulletHit or "N/A"

                    if bullet == 0 then
                        bullet = "AK-47"
                    elseif bullet == 1 then
                        bullet = "M-16"
                    elseif bullet == 2 then
                        bullet = "UZI / 9mm"
                    end

                    local team = ply.team or "N/A"

                    if team == 0 then
                        team = "Detective"
                    elseif team == 3 then
                        team = "Traitor"
                    else
                        team = "Innocent"
                    end

                    note.memoText = string.format(memoText,ply.name,nameSpacing,saying,bullet,human.data.bulletDistance or "N/A",team,human.data.headHP,human.data.leftArmHP,human.data.rightArmHP,human.data.chestHP,human.data.leftLegHP,human.data.rightLegHP)
                    note.parentHuman = humans[255]
                    note.despawnTime = 60*60*99
                    human.data.deathNote = note
                end
            else
                human.data.deathNote.pos = human.pos + Vector(0,1.3,0)


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