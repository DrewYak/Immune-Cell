InfinityPlayState = Class{__includes = BaseState}

local your_score = 0
local helper_score = 0

function InfinityPlayState:init()
    self.helper_cells = LevelMaker.createCells(COUNT_HELPER_CELLS)
    self.cell = LevelMaker.createCell(true, 1)

    gSounds['music']:play()
    gSounds['music']:setLooping(true)

    self.viruses = LevelMaker.createViruses(COUNT_VIRUSES)
end

function InfinityPlayState:update(dt)
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

    for i, c in pairs(self.helper_cells) do
        c:update(dt)
    end

    self.cell:update(dt)

    for i, v in pairs(self.viruses) do
        v:update(dt)
        for j, c in pairs(self.helper_cells) do
            if c:collides(v) then
                v:hit()
                table.remove(self.viruses, i)
                helper_score = helper_score + 1
                break
            end
        end

        if self.cell:collides(v) then 
            v:hit()
            table.remove(self.viruses, i)
            your_score = your_score + 1
            break
        end

        if v.x > WINDOW_WIDTH + 50 then
            gSounds['music']:stop()
            gSounds['lose']:play()
            gStateMachine:change('game over', {status = 'lose'})
        end
    end

    if table.getn(self.viruses) == 0 then
        gSounds['music']:stop()
        gSounds['victory']:play()
        gStateMachine:change('game over', {status = 'win'})
    end
end

function InfinityPlayState:render()
    for i, v in pairs(self.viruses) do
        v:render()
    end

    for i, c in pairs(self.helper_cells) do
        c:render()
    end

    self.cell:render()

    love.graphics.print('Wave 1: ' .. tostring(table.getn(self.viruses)), 105, 5)
    love.graphics.print('Your score: ' .. tostring(your_score), 245, 5)
    love.graphics.print('Helper score: ' .. tostring(helper_score), 425, 5)
end