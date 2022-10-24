PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.cell = nil
end

function PlayState:update(dt)
    if self.paused then
        if love.keyboard.wasPressed('spase') then
            self.paused = false
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        gSounds['pause']:play()
        return
    end
end