GameOverState = Class{__includes = BaseState}

local highlighted
local status

local lifes
local wave
local cell
local bot_cells
local bot_score

local virus_count

local is_record_wave
local is_record_your_scores
local is_record_bot_scores
local is_record_total_scores

function GameOverState:enter(params)
    if params ~= nil then
    	status = params["status"]
        lifes = params["lifes"]
        wave = params["wave"]
        cell = params["cell"]
        bot_cells = params["bot-cells"]

        bot_score = params["bot-score"]

        virus_count = params["virus-count"]

        if lifes > 0 then
            highlighted = 1
        else
            highlighted = 2
        end


        if lifes == 0 then
            is_record_wave = wave > high_scores['waves'][1]
            is_record_your_scores = cell.score > high_scores["your-scores"][1]
            is_record_bot_scores = bot_score > high_scores['bot-scores'][1]
            is_record_total_scores = cell.score + bot_score > high_scores["your-scores"][1] + high_scores['bot-scores'][1]

            if is_record_wave or is_record_your_scores or is_record_bot_scores or is_record_total_scores then
                gSounds['victory']:play()
            end

            table.insert(high_scores['waves'], wave)
            table.sort(high_scores['waves'], function(a, b) return a > b end)
            table.insert(high_scores['your-scores'], cell.score)
            table.sort(high_scores['your-scores'], function(a, b) return a > b end)
            table.insert(high_scores['bot-scores'], bot_score)
            table.sort(high_scores['bot-scores'], function(a, b) return a > b end)
            table.insert(high_scores['total-scores'], cell.score + bot_score)
            table.sort(high_scores['total-scores'], function(a, b) return a > b end)

            local scores = ''
            local t = {}
            
            scores = scores .. 'waves\n'
            
            t = high_scores['waves']
            for i = 1, #t do
                scores = scores .. t[i] .. '\n'
            end

            scores = scores .. 'your-scores\n'
            t = high_scores['your-scores']
            for i = 1, #t do
                scores = scores .. t[i] .. '\n'
            end

            scores = scores .. 'bot-scores\n'
            t = high_scores['bot-scores']
            for i = 1, #t do
                scores = scores .. t[i] .. '\n'
            end

            scores = scores .. 'total-scores\n'
            t = high_scores['total-scores']
            for i = 1, #t do
                scores = scores .. t[i] .. '\n'
            end

            love.filesystem.write('virus-catcher.lst', scores)
        else
            is_record_wave = false
            is_record_your_scores = false
            is_record_bot_scores = false
            is_record_total_scores = false
        end
    end
end

function GameOverState:update(dt)
    if love.keyboard.wasPressed('down') then
        if lifes > 0 then
            highlighted = 1 + highlighted % 2
        else 
            highlighted = 2 + (highlighted - 1) % 3
        end
        gSounds['hit']:play()
    end

    if love.keyboard.wasPressed('up') then
        if lifes > 0 then
            if highlighted == 1 then
                highlighted = 2
            else
                highlighted = highlighted - 1
            end
        else
            if highlighted == 2 then
                highlighted = 4
            else
                highlighted = highlighted - 1
            end
        end
        gSounds['hit']:play()
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gSounds['confirm']:play()
        
        if highlighted == 1 then             
            gStateMachine:change('infinity play', {
                ["wave"] = wave,
                ["lifes"] = lifes,
                ["cell"] = cell,
                ["bot-cells"] = bot_cells,
                ["bot-score"] = bot_score,

                ["virus-count"] = virus_count
            })
        end

        if highlighted == 2 then
            gStateMachine:change('high scores', {
                ["source-state"] = "game over"
            })
        end

        if highlighted == 3 then
            gStateMachine:change('start')
        end

        if highlighted == 4 then
            love.event.quit()
        end
    end
end

function GameOverState:render()
	love.graphics.setFont(gFonts['large'])
    if is_record_wave or is_record_your_scores or is_record_bot_scores or is_record_total_scores then
        love.graphics.setColor(1/255, 102/255, 169/255, 1)
        love.graphics.printf(loc[lang]["new-record"], 0, VIRTUAL_HEIGHT / 8 - 20, VIRTUAL_WIDTH, 'center')
    end
    love.graphics.setColor(1, 1, 1, 1)  
    love.graphics.printf(loc[lang]["remaining-lives"] .. tostring(lifes), 0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, 'center')

    -- info
    love.graphics.setFont(gFonts["medium"])
    love.graphics.setColor(1, 1, 1, 1)  
    if is_record_wave then love.graphics.setColor(1/255, 102/255, 169/255, 1) else love.graphics.setColor(1, 1, 1, 1) end
    love.graphics.printf(loc[lang]["final-wave"] .. tostring(wave), 0, VIRTUAL_HEIGHT / 3 + 70, VIRTUAL_WIDTH / 2, 'center')

    if is_record_your_scores then love.graphics.setColor(1/255, 102/255, 169/255, 1) else love.graphics.setColor(1, 1, 1, 1) end
    love.graphics.printf(loc[lang]["your-score"] .. tostring(cell.score), 0, VIRTUAL_HEIGHT / 3 + 140, VIRTUAL_WIDTH / 2, 'center')

    if is_record_bot_scores then love.graphics.setColor(1/255, 102/255, 169/255, 1) else love.graphics.setColor(1, 1, 1, 1) end
    love.graphics.printf(loc[lang]["bot-score"] .. tostring(bot_score), 0, VIRTUAL_HEIGHT / 3 + 210, VIRTUAL_WIDTH / 2, 'center')

    if is_record_total_scores then love.graphics.setColor(1/255, 102/255, 169/255, 1) else love.graphics.setColor(1, 1, 1, 1) end
    love.graphics.printf(loc[lang]["total-score"] .. tostring(cell.score + bot_score), 0, VIRTUAL_HEIGHT / 3 + 280, VIRTUAL_WIDTH / 2, 'center')

	-- menu
    love.graphics.setFont(gFonts['medium'])

    if lifes > 0 then
        -- Available menu items: "continue" and "high-scores"
        if highlighted == 1 then
            love.graphics.setColor(178/255, 42/255, 28/255, 1)
            love.graphics.printf("=> " .. loc[lang]["continue"] .. " <=", WINDOW_WIDTH / 2, VIRTUAL_HEIGHT / 3 + 70,
                VIRTUAL_WIDTH / 2, 'center')
        else
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.printf(loc[lang]["continue"], WINDOW_WIDTH / 2, VIRTUAL_HEIGHT / 3 + 70,
                VIRTUAL_WIDTH / 2, 'center')
        end            

        if highlighted == 2 then
            love.graphics.setColor(178/255, 42/255, 28/255, 1)
            love.graphics.printf("=> " .. loc[lang]["high-scores"] .. " <=", WINDOW_WIDTH / 2, VIRTUAL_HEIGHT / 3 + 140,
                VIRTUAL_WIDTH / 2, 'center')
        else
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.printf(loc[lang]["high-scores"], WINDOW_WIDTH / 2, VIRTUAL_HEIGHT / 3 + 140,
                VIRTUAL_WIDTH / 2, 'center')
        end
    else
        -- Available menu items: "high-scores", "main-menu" and "exit"
        if highlighted == 2 then
            love.graphics.setColor(178/255, 42/255, 28/255, 1)
            love.graphics.printf("=> " .. loc[lang]["high-scores"] .. " <=", WINDOW_WIDTH / 2, VIRTUAL_HEIGHT / 3 + 140,
                VIRTUAL_WIDTH / 2, 'center')
        else
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.printf(loc[lang]["high-scores"], WINDOW_WIDTH / 2, VIRTUAL_HEIGHT / 3 + 140,
                VIRTUAL_WIDTH / 2, 'center')
        end

        if highlighted == 3 then
            love.graphics.setColor(178/255, 42/255, 28/255, 1)
            love.graphics.printf("=> " .. loc[lang]["main-menu"] .. " <=", WINDOW_WIDTH / 2, VIRTUAL_HEIGHT / 3 + 210,
                VIRTUAL_WIDTH / 2, 'center')
        else
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.printf(loc[lang]["main-menu"], WINDOW_WIDTH / 2, VIRTUAL_HEIGHT / 3 + 210,
                VIRTUAL_WIDTH / 2, 'center')
        end

        if highlighted == 4 then
            love.graphics.setColor(178/255, 42/255, 28/255, 1)
            love.graphics.printf("=> " .. loc[lang]["exit"] .. " <=", WINDOW_WIDTH / 2, VIRTUAL_HEIGHT / 3 + 280,
                VIRTUAL_WIDTH / 2, 'center')
        else
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.printf(loc[lang]["exit"], WINDOW_WIDTH / 2, VIRTUAL_HEIGHT / 3 + 280,
                VIRTUAL_WIDTH / 2, 'center')
        end
    end
end