---@type Plugin
local plugin = ...

local path = "/home/conatiner/"

---@class Scanner
---@field public scans number
---@field public item Item
---@field public hasScanned boolean
Scanner = {}

---@type {[integer]: Scanner}
Scanner.scanners={}

Scanner.__index = Scanner

function Scanner.create(pos,scns)


    local scanner = setmetatable
    (
        {
            class = "Scanner",
            scans = scns,
            item = items.create(itemTypes[enum.item.disk_gold],pos,orientations.n),
            hasScanned = false
        }, Scanner
    )

    table.insert(Scanner.scanners,scanner)

    return scanner
end

--- Scan a player
function Scanner:scan()
    if self.scans > 0 then
        local posA = self.item.parentHuman.player.connection.cameraPos
        local posB = self.item.parentHuman.player.connection.cameraPos + self.item.parentHuman:getRigidBody(3).rot:forwardUnit()*3

        local hum = physics.lineIntersectAnyQuick(posA,posB,self.item.parentHuman,0,false)
        if hum then
            if hum.class == "Human" and hum.isAlive then
                self.scans = self.scans - 1
                if hum.player.team == 3 then
                    playOnce(path .. "modes/TTT/sounds/scanner/negative.pcm",4,false,self.item)
                    messagePlayerWrap(self.item.parentHuman.player,hum.player.name.." is a Traitor!")
                else
                    playOnce(path .. "modes/TTT/sounds/scanner/affirmative.pcm",4,false,self.item)
                    messagePlayerWrap(self.item.parentHuman.player,hum.player.name.." is Innocent!")
                end
            end
        end
    else
        messagePlayerWrap(self.item.parentHuman.player,"Out of Scans!")
        events.createSound(enum.sound.phone.buttons[10],self.item)
    end
end

local function tick()
    for _,scanner in ipairs(Scanner.scanners) do
        if scanner.item.parentHuman then
            if not scanner.item.parentHuman.data.eqScanner and scanner.item.parentSlot == 0 or scanner.item.parentSlot == 1 then
                scanner.item.parentHuman.data.eqScanner = true
                messagePlayerWrap(scanner.item.parentHuman.player,"Equipped Scanner")
            end

            if ( KeyPressed(scanner.item.parentHuman,enum.input.lmb) and not KeyPressed(scanner.item.parentHuman,enum.input.shift) and scanner.item.parentSlot == 0 ) or ( KeyPressed(scanner.item.parentHuman,enum.input.lmb) and KeyPressed(scanner.item.parentHuman,enum.input.shift) and scanner.item.parentSlot == 1 ) then
                if not scanner.hasScanned then
                    scanner.hasScanned = true
                    scanner:scan()
                end
            else
                scanner.hasScanned = false
            end
        end
    end
end

plugin:addHook("Logic",function ()
    tick()
end)