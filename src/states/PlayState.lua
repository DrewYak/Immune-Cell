PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.cell = LevelMaker.createCell()
    self.viruses = LevelMaker.createViruses(20)
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

    for i, v in pairs(self.viruses) do
        v:update(dt)
        if cell:collides(v) then
            v:hit()
            table.remove(self.viruses, i)
        end
    end

    if table.getn(self.viruses) == 0 then
        gSounds['victory']:play()
        self.paused = true
    end

    self.cell:update(dt)
end

function PlayState:render()
    for i = 1, #self.viruses do
        self.viruses[i]:render()
    end

    self.cell:render()
    love.graphics.print('Virus count: ' .. tostring(table.getn(self.viruses)), 105, 5)
end