PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.cell = nil

    self.virus = Virus(18)
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

    self.virus:update(dt)
end

function PlayState:render()
    self.virus:render()
end