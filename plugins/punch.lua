---@type Plugin
local plugin = ...

---@param hum Human
---@param key number
function KeyPressed(hum,key)
    if bit32.band(hum.inputFlags,key) == key and bit32.band(hum.lastInputFlags,key) == key then
        return true
    else
        return false
    end
end

local timeTillIdle = 60*3

plugin:addHook("Logic",function ()
        for _,human in ipairs(humans.getAll()) do
            if not human.data.body then
                human:getRigidBody(enum.body.pelvis).data.human, human:getRigidBody(enum.body.stomach).data.human, human:getRigidBody(enum.body.torso).data.human, human:getRigidBody(enum.body.head).data.human = human, human, human, human
                
                human:getRigidBody(enum.body.pelvis).data.hurt, human:getRigidBody(enum.body.stomach).data.hurt, human:getRigidBody(enum.body.torso).data.hurt, human:getRigidBody(enum.body.head).data.hurt = "chestHP", "chestHP", "chestHP", "headHP"
                
                human:getRigidBody(enum.body.hand_left).data.hand = true
                human:getRigidBody(enum.body.hand_left).data.clicks = 0
                human:getRigidBody(enum.body.hand_right).data.hand = true
                human:getRigidBody(enum.body.hand_right).data.clicks = 0

                human.data.body = true
            end

            if human:getRigidBody(enum.body.hand_left).data.clicks > 3 then
                human:getRigidBody(enum.body.hand_left).data.clicks = 3
            elseif human:getRigidBody(enum.body.hand_left).data.clicks > 0 then
                human:getRigidBody(enum.body.hand_left).data.clicks = human:getRigidBody(enum.body.hand_left).data.clicks - 1/40
            else
                human:getRigidBody(enum.body.hand_left).data.clicks = 0
            end

            if human:getRigidBody(enum.body.hand_right).data.clicks > 3 then
                human:getRigidBody(enum.body.hand_right).data.clicks = 3
            elseif human:getRigidBody(enum.body.hand_right).data.clicks > 0 then
                human:getRigidBody(enum.body.hand_right).data.clicks = human:getRigidBody(enum.body.hand_right).data.clicks - 1/40
            else
                human:getRigidBody(enum.body.hand_right).data.clicks = 0
            end

            if not human.data.timeTillIdle then
                human.data.timeTillIdle = timeTillIdle
            else
                if human.data.timeTillIdle > 0 then
                    human.data.timeTillIdle = human.data.timeTillIdle - 1
                else
                    human.data.timeTillIdle = 0
                end
            end

            if (not human:getInventorySlot(1).primaryItem or not human:getInventorySlot(1).primaryItem or (not human:getInventorySlot(1).primaryItem and not human:getInventorySlot(1).primaryItem)) then
                if not human.data.emptiedHands then
                    human.data.timeTillIdle = timeTillIdle
                    human.data.emptiedHands = true
                end
            else
                human.data.emptiedHands = false
            end

            if KeyPressed(human,enum.input.rmb) and not human:getInventorySlot(0).primaryItem then
                human.data.blockRight = true
                human.data.timeTillIdle = timeTillIdle
            else
                human.data.blockRight = false
            end

            if KeyPressed(human,enum.input.rmb) and not human:getInventorySlot(1).primaryItem then
                human.data.blockLeft = true
                human.data.timeTillIdle = timeTillIdle
            else
                human.data.blockLeft = false
            end

            if KeyPressed(human,enum.input.lmb) and not KeyPressed(human,enum.input.shift) and not human:getInventorySlot(0).primaryItem then
                human.data.punchRight = true
                human.data.timeTillIdle = timeTillIdle
                if not human.data.clickedR then
                    human:getRigidBody(enum.body.hand_right).data.clicks = human:getRigidBody(enum.body.hand_right).data.clicks + 1
                    human.data.clickedR = true
                end
            else
                human.data.punchRight = false
                human:getRigidBody(enum.body.hand_right).data.hasHit = false
                human.data.clickedR = false
            end

            if KeyPressed(human,enum.input.lmb) and KeyPressed(human,enum.input.shift) and not human:getInventorySlot(1).primaryItem then
                human.data.punchLeft = true
                human.data.timeTillIdle = timeTillIdle
                if not human.data.clickedL then
                    human:getRigidBody(enum.body.hand_left).data.clicks = human:getRigidBody(enum.body.hand_left).data.clicks + 1
                    human.data.clickedL = true
                end
            else
                human.data.punchLeft = false
                human:getRigidBody(enum.body.hand_left).data.hasHit = false
                human.data.clickedL = false
            end
        end
end)

local offsetX = 0.05
local offsetY = -.02
local offsetZ = -0.3
local punchInX = -0.05
local punchInY = 0.09
local punchInZ = 0.40

local blockOffsetX = 0.05
local blockOffsetY = 0.25

plugin:addHook("HumanLimbInverseKinematics",function (human, A, B, pos, destinationAxis, unk_vecA, unk_a, rot, strength, unk_vecB, unk_vecC, flags)
if human:getRigidBody(enum.body.hand_right).data.clicks then

    local deltaIn = 0.08 * 4
    local deltaOut = 0.2 * 4

    local yLookOffset = math.clamp(-human.viewPitch/4.5,-1,1)

    if not human.data.addedXPunchL then
        human.data.addedXPunchL, human.data.addedYPunchL, human.data.addedZPunchL = 0,0,0
        human.data.addedXPunchR, human.data.addedYPunchR, human.data.addedZPunchR = 0,0,0
    end

if not human.data.grabbingLeft and not human.data.grabbingRight then
    if human.data.timeTillIdle ~= 0 then
        if not human:getInventorySlot(0).primaryItem then
            if A == enum.body.torso and B == enum.body.shoulder_right then

                strength.value = strength.value * (4-human:getRigidBody(enum.body.hand_right).data.clicks+2)/4

                if not human.data.blockRight then
                    if not human.data.punchRight then
                        --Handle X
                        if human.data.addedXPunchR > 0 then
                            human.data.addedXPunchR = human.data.addedXPunchR - deltaIn
                        else
                            human.data.addedXPunchR = 0
                        end

                        --Handle Y
                        if human.data.addedYPunchR > 0 then
                            human.data.addedYPunchR = human.data.addedYPunchR - deltaIn
                        else
                            human.data.addedYPunchR = 0
                        end

                        --Handle Z
                        if human.data.addedZPunchR > 0 then
                            human.data.addedZPunchR = human.data.addedZPunchR - deltaIn
                        else
                            human.data.addedZPunchR = 0
                        end

                        human:getRigidBody(enum.body.hand_right).data.punching = false
                    else
                        --Handle X
                        if human.data.addedXPunchR < punchInX then
                            human.data.addedXPunchR = human.data.addedXPunchR + deltaOut
                        end

                        --Handle Y
                        if human.data.addedYPunchR < punchInY then
                            human.data.addedYPunchR = human.data.addedXPunchR + deltaOut
                        else
                            human.data.addedYPunchR = punchInY
                        end

                        --Handle Z
                        if human.data.addedZPunchR < punchInZ then
                            human.data.addedZPunchR = human.data.addedZPunchR + deltaOut
                        else
                            human.data.addedZPunchR = punchInZ
                        end

                        human:getRigidBody(enum.body.hand_right).data.punching = true
                    end

                    pos:set(Vector(-offsetX-human.data.addedXPunchR,offsetY+human.data.addedYPunchR+yLookOffset,offsetZ-human.data.addedZPunchR))
                    rot.value = math.rad(40)
                else
                    pos:set(Vector(-offsetX-blockOffsetX,offsetY+blockOffsetY+yLookOffset,offsetZ))
                end
            end
        end

        if not human:getInventorySlot(1).primaryItem then
            if not human:getInventorySlot(0).primaryItem then
                if A == enum.body.torso and B == enum.body.shoulder_left then
                    strength.value = strength.value * (4-human:getRigidBody(enum.body.hand_left).data.clicks+2)/4
                    
                    if not human.data.blockLeft then
                        leftHandLogic(human,offsetX,offsetY,offsetZ,deltaIn,deltaOut,punchInX,punchInY,punchInZ,yLookOffset,pos)
                        rot.value = math.rad(-40)
                    else
                        pos:set(Vector(offsetX+blockOffsetX,offsetY+blockOffsetY+yLookOffset,offsetZ))
                    end
                end
            elseif human:getInventorySlot(0).primaryItem.type.numHands <= 1 and not human:getInventorySlot(0).primaryItem.data.twoHands then
                if A == enum.body.torso and B == enum.body.shoulder_left then
                    strength.value = strength.value * (4-human:getRigidBody(enum.body.hand_left).data.clicks+2)/4

                    if not human.data.blockLeft then
                        leftHandLogic(human,offsetX,offsetY,offsetZ,deltaIn,deltaOut,punchInX,punchInY,punchInZ,yLookOffset,pos)
                        rot.value = math.rad(-40)
                    else
                        pos:set(Vector(offsetX,offsetY+blockOffsetY+yLookOffset,offsetZ))
                    end
                end
            end
        end
    else
        human:getRigidBody(enum.body.hand_left).data.punching = false
        human:getRigidBody(enum.body.hand_right).data.punching = false
    end
else
    human:getRigidBody(enum.body.hand_left).data.punching = false
    human:getRigidBody(enum.body.hand_right).data.punching = false
    human.data.timeTillIdle = 0
end

end
end)

function leftHandLogic(human,offsetX,offsetY,offsetZ,deltaIn,deltaOut,punchInX,punchInY,punchInZ,yLookOffset,pos)
        if not human.data.punchLeft then
            --Handle X
            if human.data.addedXPunchL > 0 then
                human.data.addedXPunchL = human.data.addedXPunchL - deltaIn
            else
                human.data.addedXPunchL = 0
            end

            --Handle Y
            if human.data.addedYPunchL > 0 then
                human.data.addedYPunchL = human.data.addedXPunchL - deltaIn
            else
                human.data.addedYPunchL = 0
            end

            --Handle Z
            if human.data.addedZPunchL > 0 then
                human.data.addedZPunchL = human.data.addedZPunchL - deltaIn
            else
                human.data.addedZPunchL = 0
            end

            human:getRigidBody(enum.body.hand_left).data.punching = false
        else
            --Handle X
            if human.data.addedXPunchL < punchInX then
                human.data.addedXPunchL = human.data.addedXPunchL + deltaOut
            end

            --Handle Y
            if human.data.addedYPunchL < punchInY then
                human.data.addedYPunchL = human.data.addedYPunchL + deltaOut
            else
                human.data.addedYPunchL = punchInY
            end

            --Handle Y
            if human.data.addedZPunchL < punchInZ then
                human.data.addedZPunchL = human.data.addedZPunchL + deltaOut
            else
                human.data.addedZPunchL = punchInZ
            end

            human:getRigidBody(enum.body.hand_left).data.punching = true
        end

    pos:set(Vector(offsetX+human.data.addedXPunchL,offsetY+human.data.addedYPunchL+yLookOffset,offsetZ-human.data.addedZPunchL))
end

plugin:addHook("CollideBodies",function (A, B, posA, posB, normal)
    ---@type RigidBody
    local hand
    ---@type RigidBody
    local body
    if A.data.hand and not B.data.hand and B.type == 0 then
        hand = A
        body = B
    elseif B.data.hand and not A.data.hand and A.type == 0 then
        hand = B
        body = A
    end

    if body and hand then
        if hand.data.punching then
            local speed = hand.vel:length()-body.vel:length()

            if speed > 0.065 and not hand.data.hasHit and hand.data.clicks < 2 then
                --chat.announce(tostring(hand.data.clicks))
                if body.data.human then
                    if body.data.hurt then
                        if body.data.hurt == "chestHP" then
                            body.data.human[body.data.hurt] = body.data.human[body.data.hurt] - 60*speed*1.5
                            body.vel = body.vel + (hand.vel-body.vel)
                        else
                            body.data.human[body.data.hurt] = body.data.human[body.data.hurt] - 60*speed*5
                            body.vel = body.vel + (hand.vel-body.vel)
                        end

                        events.createBulletHit(1,hand.pos,normal)
                        hand.data.hasHit = true
                    end
                end
            end
        end
    end
end)