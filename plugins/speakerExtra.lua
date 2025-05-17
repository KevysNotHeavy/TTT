local plugin = ...

function playOnce(filepath,earshot,is2D,item)
    local sound = Speaker.create(item or items[255],earshot)
    sound.player = players[255]
    sound.destroyItem = false
    sound:loadAudioFile(filepath)
    if is2D then
        sound:toggle2D()
    end
    sound:play()
end

sLoop = false

function playLoop(filepath)
    Ambience = Speaker.create(items[255])
    Ambience.player = players[254]
    Ambience.destroyItem = false
    Ambience:loadAudioFile(filepath)
    Ambience:toggle2D()
    Ambience:play()
    sLoop = false
end

function stopLoop()
    sLoop = true
    Ambience:destroy()
end

plugin:addHook("Logic",function ()
    if Ambience then
        if Ambience.errorFrames > 8 and not sLoop then
            local tempFile = Ambience.currentPath
            Ambience:destroy()
            playLoop(tempFile)
        end
    end
end)