---@type Plugin
local plugin = ...

plugin:addHook("PhysicsRigidBodies",function ()
    for _,human in pairs(allHumans) do
        if human.player then

            local castOffset = 0
            local volume = 100

            if human.zoomLevel == 0 and not KeyPressed(human,enum.input.ctrl) then
                castOffset = 0.3
                volume = 100
            elseif human.zoomLevel == 0 then
                castOffset = 0.1
                volume = 100
            elseif human.zoomLevel == 1 and human.player.data.moved then
                castOffset = 0.1
                volume = 60
                if not KeyPressed(human,enum.input.ctrl) and not human.vehicle then
                    human.inputFlags = human.inputFlags + 8
                end
            end

            if human.movementState == 0 and human.isStanding then
                local leftFoot = human:getRigidBody(enum.body.shin_left)
                local rightFoot = human:getRigidBody(enum.body.shin_right)

                if not leftFoot.data.soundCooled then
                    leftFoot.data.soundCooled = 0
                    rightFoot.data.soundCooled = 0
                end

                local posA = leftFoot.pos+Vector(0,0.001,0)
                local posB = leftFoot.pos-Vector(0,castOffset,0)
                local leftHit = physics.lineIntersectLevel(posA,posB,false).hit
                if leftHit then
                    if not leftFoot.data.hit and leftFoot.data.soundCooled <= 0 then
                        events.createSound(enum.sound.weapon.bullet.hit_metal2,leftFoot.pos,0.26*(volume/100),4)
                        leftFoot.data.hit = true
                        leftFoot.data.soundCooled = 10
                    end
                else
                    leftFoot.data.hit = false
                    leftFoot.data.soundCooled = leftFoot.data.soundCooled - 1
                end

                local posA = rightFoot.pos+Vector(0,0.001,0)
                local posB = rightFoot.pos-Vector(0,castOffset,0)
                local rightHit = physics.lineIntersectLevel(posA,posB,false).hit
                if rightHit then
                    if not rightFoot.data.hit then
                        events.createSound(enum.sound.weapon.bullet.hit_metal2,rightFoot.pos,0.26*(volume/100),4)
                        rightFoot.data.hit = true
                        rightFoot.data.soundCooled = 10
                    end
                else
                    rightFoot.data.hit = false
                    rightFoot.data.soundCooled = rightFoot.data.soundCooled - 1
                end
            end
        end
    end
end)