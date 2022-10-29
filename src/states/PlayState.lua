PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.cell = nil

    self.viruses = LevelMaker.createViruses(40000)
end

function PlayState:update(dt)
    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        gSounds['pause']:play()
        return
    end

    for i = 1, #self.viruses do
        self.viruses[i]:update(dt)
    end

end

function PlayState:render()
    for i = 1, #self.viruses do
        self.viruses[i]:render()
    end
end