local plugin =...
plugin.name = 'Coloured Name Stuff'
plugin.author = 'Jpsh'
plugin.description = 'For Kevys TTT mode'

local traitors = {}
local detectives = {}

local listAddress = memory.getBaseAddress() + 0x5a74a7c0
local pairs, readInt, writeInt = _G.pairs, _G.memory.readInt, _G.memory.writeInt

--This will be added to RosaServer as human:update() one day. It does not create an event.
local function UPDATE_FUNC_REIMPLEMENTATION(man)
    local offset = man.index
    if offset then
        local addr = listAddress + (offset * 4)
        local cur = readInt(addr)
        writeInt(addr, cur + 1)
    end
end

plugin:addHook("SelectedPlayer", function (ply, team)
    ply.team = team
    local ind = ply.index
    --plugin:print(string.format('Adding %s to team %s', ply.name, team))
    if team == 0 then
        detectives[ind] = true
        traitors[ind] = nil
    elseif team == 3 then
        detectives[ind] = nil
        traitors[ind] = true
    else
        plugin:warn(string.format('Unexpected team \"%s\" ran through SelectedPlayer', team))
    end
end)

plugin:addHook("PostResetGame", function (ply, team)
    traitors = {}
    detectives = {}
    for i = 0, 255 do --Incase people leave, wipes the unused indexes aswell.
        players[i].criminalRating = 0
    end
end)


local lastCon = nil
plugin:addHook("PacketBuilding",function (con)
    if con == lastCon then
        return
    end

    lastCon = con

    local conPly = con.player
    if conPly == nil then
        return
    end
    local bool = traitors[conPly.index] == true
    for ind, _ in pairs(traitors) do
        local ply = players[ind]
        if ply.isActive then
            ply.criminalRating = bool and 100 or 0
            local man = ply.human
            if man then--This is vital AND stupid.
                man.lastUpdatedWantedGroup = bool and 2 or 0
                UPDATE_FUNC_REIMPLEMENTATION(man)
            end
        else
            traitors[ind] = nil
        end
    end
end)

plugin:addHook("PostLogic",function ()
    for ind, _ in pairs(detectives) do
        local ply = players[ind]
        if ply.isActive then
            ply.criminalRating = 25
        else
            detectives[ind] = nil
        end
    end
end)