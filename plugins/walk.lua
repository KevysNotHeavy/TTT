---@type Plugin
local plugin = ...

plugin:addHook("PhysicsRigidBodies",function ()
    for _,human in pairs(allHumans) do
        local castOffset
        local volume

        if human.zoomLevel == 0 and not KeyPressed(human,enum.input.ctrl) then
            castOffset = 0.3
            volume = 100
        elseif human.zoomLevel == 0 then
            castOffset = 0.1
            volume = 100
        elseif human.zoomLevel == 1 then
            castOffset = 0.1
            volume = 60
            human.inputFlags = human.inputFlags + 8
        end

        if human.movementState == 0 then
            local leftFoot = human:getRigidBody(enum.body.shin_left)
            local rightFoot = human:getRigidBody(enum.body.shin_right)

            local posA = leftFoot.pos+Vector(0,0.001,0)
            local posB = leftFoot.pos-Vector(0,castOffset,0)
            local leftHit = physics.lineIntersectLevel(posA,posB,false).hit
            if leftHit then
                if not leftFoot.data.hit then
                    events.createSound(enum.sound.weapon.bullet.hit_metal2,leftFoot.pos,0.26*(volume/100),4)
                    leftFoot.data.hit = true
                end
            else
                leftFoot.data.hit = false
            end

            local posA = rightFoot.pos+Vector(0,0.001,0)
            local posB = rightFoot.pos-Vector(0,castOffset,0)
            local rightHit = physics.lineIntersectLevel(posA,posB,false).hit
            if rightHit then
                if not rightFoot.data.hit then
                    events.createSound(enum.sound.weapon.bullet.hit_metal2,rightFoot.pos,0.26*(volume/100),4)
                    rightFoot.data.hit = true
                end
            else
                rightFoot.data.hit = false
            end
        end
    end
end)