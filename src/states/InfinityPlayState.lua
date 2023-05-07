InfinityPlayState = Class{__includes = BaseState}

local lifes
local wave
local cell
local bot_cells

local viruses
local virus_count
local virus_speed_coef
local bot_score

local time_start_wave

function InfinityPlayState:enter(params)
    wave = params["wave"]

    -- The value of the wave -1 means that 
    -- the infinite game has started and is not continuing.
    if wave == -1 then
        wave = 1
        lifes = INITIAL_LIFES
        cell = LevelMaker.createCell(false, 1)
        bot_cells = LevelMaker.createBotCells(INITIAL_COUNT_BOT_CELLS)
        bot_score = 0

        virus_count = INITIAL_VIRUS_COUNT
        virus_speed_coef = INITIAL_VIRUS_SPEED_COEF
        viruses = LevelMaker.createViruses(virus_count, virus_speed_coef)
    else
        lifes = params["lifes"]
        cell = params["cell"]
        bot_cells = params["bot-cells"]
        bot_score = params["bot-score"]

        virus_count = params["virus-count"]
        virus_speed_coef = INITIAL_VIRUS_SPEED_COEF + 0.5 * (wave - 1)
        viruses = LevelMaker.createViruses(virus_count, virus_speed_coef)
    end

    time_start_wave = love.timer.getTime()

    gSounds['music']:play()
    gSounds['music']:setLooping(true)
end

function InfinityPlayState:update(dt)
    if self.paused then
        if love.keyboard.wasPressed('space') or love.keyboard.wasPressed('escape') then
            self.paused = false
            gSounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') or love.keyboard.wasPressed('escape') then
        self.paused = true
        gSounds['pause']:play()
        return
    end

    for i, c in pairs(bot_cells) do
        c:update(dt)
    end

    cell:update(dt)

    for i, v in pairs(viruses) do
        v:update(dt)
        for j, c in pairs(bot_cells) do
            if c:collides(v) then
                v:hit()
                table.remove(viruses, i)
                c.score = c.score + 1
                bot_score = bot_score + 1
                if c.score == LEVEL_UP_1 or c.score == LEVEL_UP_2 or c.score == LEVEL_UP_3 then
                    gSounds['level-up']:play()  
                end
                break
            end
        end

        if cell:collides(v) then 
            v:hit()
            table.remove(viruses, i)
            cell.score = cell.score + 1
            if cell.score == LEVEL_UP_1 or cell.score == LEVEL_UP_2 or cell.score == LEVEL_UP_3 then
                gSounds['level-up']:play()   
            end            
            break
        end

        if v.x > WINDOW_WIDTH + 50 then
            lifes = lifes - 1
            gSounds['music']:stop()

            if lifes == 0 then
                local is_record_wave = wave > high_scores['waves'][1]
                local is_record_your_scores = cell.score > high_scores["your-scores"][1]
                local is_record_bot_scores = bot_score > high_scores['bot-scores'][1]
                local is_record_total_scores = cell.score + bot_score > high_scores["your-scores"][1] + high_scores['bot-scores'][1]

                if is_record_wave or is_record_your_scores or is_record_bot_scores or is_record_total_scores then
                    gSounds['victory']:play()
                else
                    gSounds['lose']:play()
                end 
            else                   
                gSounds['lose']:play()
            end
            
            gStateMachine:change('game over', {
                ["status"] = 'lose',
                ["lifes"] = lifes,
                ["wave"] = wave,
                ["cell"] = cell,
                ["bot-cells"] = bot_cells,

                ["bot-score"] = bot_score,

                ["virus-count"] = virus_count
            })
        end
    end

    if table.getn(viruses) == 0 then
        wave = wave + 1
        virus_speed_coef = virus_speed_coef + 0.5
        virus_count = virus_count + math.random(1, 3)

        gSounds['short-victory']:play()

        viruses = LevelMaker.createViruses(virus_count, virus_speed_coef)

        if wave % 3 == 0 then
            LevelMaker.addBotCell(bot_cells)
        end
        time_start_wave = love.timer.getTime()
    end
end

function InfinityPlayState:render()
    for i, v in pairs(viruses) do
        v:render()
    end

    for i, c in pairs(bot_cells) do
        c:render()
    end

    cell:render()

    if love.timer.getTime() - time_start_wave < 2 then
        love.graphics.setFont(gFonts['large'])
        love.graphics.setColor(1/255, 102/255, 169/255, 1)
        love.graphics.printf(loc[lang]["wave"] .. tostring(wave), 20, VIRTUAL_HEIGHT / 9, VIRTUAL_WIDTH, 'left')
    end

    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(1, 1, 1, 1)        
    love.graphics.print(loc[lang]["wave-info"] .. tostring(wave) .. ':' .. tostring(table.getn(viruses)), 105, 5)
    love.graphics.print(loc[lang]["your-score"] .. tostring(cell.score), 235, 5)
    love.graphics.print(loc[lang]["bot-score"] .. tostring(bot_score), 415, 5)
    love.graphics.printf(loc[lang]["lifes"] .. tostring(lifes), VIRTUAL_WIDTH - 125, 5, 115, "right")

    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.setColor(1/255, 102/255, 169/255, 1)        
        love.graphics.printf(loc[lang]["pause"], 0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, "center")
    end
end
