---@type Plugin
local plugin = ...

bounds = {vec={Vector(),Vector()}}

---Set the boundaries for the level
---@param vecA Vector
---@param vecB Vector
function bounds.set(vecA,vecB)
    bounds.vec[1] = vecA
    bounds.vec[2] = vecB
end

---Removes the boundaries for the level
function bounds.remove()
    bounds.vec[1] = Vector()
    bounds.vec[2] = Vector()
end

local warnTime = 5*60

local function tick()
    for _,human in ipairs(humans.getAll()) do
        if human.isAlive then
            if bounds.vec[1] ~= Vector() and bounds.vec[2] ~= Vector() then

                if not human.data.warnTime then
                    human.data.warnTime = 0
                end

                
                if not isVectorInCuboid(human.pos,bounds.vec[1],bounds.vec[2]) then

                    if human.data.warnTime == 0 then
                        messagePlayerWrap(human.player,"Return to Bounds! (5s)")
                        events.createSound(enum.sound.phone.buttons[10],human.pos)
                    end

                    human.data.warnTime = human.data.warnTime + 1

                    if human.data.warnTime >= warnTime then
                        if not human.data.riseUp then
                            human.data.riseUp = 0
                        end

                        human.data.riseUp = human.data.riseUp + 1/60

                        if not human.data.slam then
                            if human.data.riseUp >= 1 then
                                human.data.riseUp = -1
                                human.data.slam = true
                                human:speak("!BYE EVERYONE!",2)
                            else
                                human:addVelocity(Vector(0,0.01,0))
                            end
                        end

                        if human.data.slam then
                            if human.data.riseUp < 0 then
                                human:addVelocity(Vector(0,-0.02,0))
                            else
                                if not human.data.kill then
                                    human.data.kill = 0
                                end

                                if human.data.kill <= 1 then
                                    human.data.kill = human.data.kill + 1/60
                                else
                                    human.isAlive = false
                                end
                            end
                        end
                    end
                else
                    human.data.kill = 0
                    human.data.slam = false
                    human.data.riseUp = 0
                    if not human.data.warnTime then
                        human.data.warnTime = 0
                    end

                    if human.data.warnTime ~= 0 then
                        messagePlayerWrap(human.player,"Back in Bounds.")
                    end

                    human.data.warnTime = 0
                end
            end
        end
    end
end

plugin:addHook("Logic",function() tick() end)