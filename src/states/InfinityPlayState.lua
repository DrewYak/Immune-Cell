InfinityPlayState = Class{__includes = BaseState}

local wave = 1
local virus_count = INITIAL_VIRUS_COUNT
local speed_coef = INITIAL_SPEED_COEF
local time_start_wave = 0
local bot_score = 0
local lifes = 0

function InfinityPlayState:init()
    if self.bot_cells == nil then 
        self.bot_cells = LevelMaker.createBotCells(COUNT_BOT_CELLS)
    end

    if self.cell == nil then 
        self.cell = LevelMaker.createCell(false, 1)
    end

    gSounds['music']:play()
    gSounds['music']:setLooping(true)

    self.viruses = LevelMaker.createViruses(virus_count, speed_coef)
    time_start_wave = love.timer.getTime()
end

function InfinityPlayState:enter(params)
    self.cell.score = params["player-score"]
    bot_score = params["bot-score"]
    wave = params["wave"]
    lifes = params["lifes"]

    speed_coef = 0.5 * (wave - 1)
    if wave == 1 then
        virus_count = INITIAL_VIRUS_COUNT
        speed_coef = INITIAL_SPEED_COEF
    end
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

    for i, c in pairs(self.bot_cells) do
        c:update(dt)
    end

    self.cell:update(dt)

    for i, v in pairs(self.viruses) do
        v:update(dt)
        for j, c in pairs(self.bot_cells) do
            if c:collides(v) then
                v:hit()
                table.remove(self.viruses, i)
                c.score = c.score + 1
                bot_score = bot_score + 1
                break
            end
        end

        if self.cell:collides(v) then 
            v:hit()
            table.remove(self.viruses, i)
            self.cell.score = self.cell.score + 1
            if self.cell.score == LEVEL_UP_1 or self.cell.score == LEVEL_UP_2 or self.cell.score == LEVEL_UP_3 then
                gSounds['level-up']:play()   
            end            
            break
        end

        if v.x > WINDOW_WIDTH + 50 then
            lifes = lifes - 1
            gSounds['music']:stop()
            gSounds['lose']:play()
            gStateMachine:change('game over', {
                ["status"] = 'lose',
                ["player-score"] = self.cell.score,
                ["bot-score"] = bot_score,
                ["wave"] = wave,
                ["lifes"] = lifes
            })
        end
    end

    if table.getn(self.viruses) == 0 then
        wave = wave + 1
        speed_coef = speed_coef + 0.5
        virus_count = virus_count + math.random(1, 3)

        gSounds['short-victory']:play()

        self.viruses = LevelMaker.createViruses(virus_count, speed_coef)
        time_start_wave = love.timer.getTime()
    end
end

function InfinityPlayState:render()
    for i, v in pairs(self.viruses) do
        v:render()
    end

    for i, c in pairs(self.bot_cells) do
        c:render()
    end

    self.cell:render()

    if love.timer.getTime() - time_start_wave < 2 then
        love.graphics.setFont(gFonts['large'])
        love.graphics.setColor(1/255, 102/255, 169/255, 1)
        love.graphics.printf(loc[lang]["wave"] .. tostring(wave), 20, VIRTUAL_HEIGHT / 9, VIRTUAL_WIDTH, 'left')
    end

    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(1, 1, 1, 1)        
    love.graphics.print(loc[lang]["wave-info"] .. tostring(wave) .. ':' .. tostring(table.getn(self.viruses)), 105, 5)
    love.graphics.print(loc[lang]["your-score"] .. tostring(self.cell.score), 245, 5)
    love.graphics.print(loc[lang]["bot-score"] .. tostring(bot_score), 425, 5)
    love.graphics.print(tostring(lifes), VIRTUAL_WIDTH - 30, 5)
end
