PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.cells = LevelMaker.createCells(3)
    self.cell = LevelMaker.createCell(true, 1)

    gSounds['music']:play()
    gSounds['music']:setLooping(true)

    self.viruses = LevelMaker.createViruses(COUNT_VIRUSES)
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

    for i, c in pairs(self.cells) do
        c:update(dt)
    end

    self.cell:update(dt)

    for i, v in pairs(self.viruses) do
        v:update(dt)
        for j, c in pairs(self.cells) do
            if c:collides(v) then
                v:hit()
                table.remove(self.viruses, i)
                break
            end
        end
        
        if self.cell:collides(v) then 
            v:hit()
            table.remove(self.viruses, i)
            break
        end
    end

    if table.getn(self.viruses) == 0 then
        gSounds['music']:stop()
        gSounds['victory']:play()
        self.paused = true
        gStateMachine:change('game over', {status = 'win'})
    end
end

function PlayState:render()
    for i, v in pairs(self.viruses) do
        v:render()
    end

    for i, c in pairs(self.cells) do
        c:render()
    end

    self.cell:render()

    love.graphics.print('Virus count: ' .. tostring(table.getn(self.viruses)), 105, 5)
end