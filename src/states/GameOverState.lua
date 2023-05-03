GameOverState = Class{__includes = BaseState}

local highlighted = 1
local status

local lifes
local wave
local cell
local bot_cells
local bot_score

local virus_count

function GameOverState:enter(params)
	status = params["status"]
    lifes = params["lifes"]
    wave = params["wave"]
    cell = params["cell"]
    bot_cells = params["bot-cells"]

    bot_score = params["bot-score"]

    virus_count = params["virus-count"]
end

function GameOverState:update(dt)
    if love.keyboard.wasPressed('down') then
        highlighted = 1 + highlighted % 4
        gSounds['hit']:play()
    end

    if love.keyboard.wasPressed('up') then
        if highlighted == 1 then
            highlighted = 4
        else
            highlighted = highlighted - 1
        end
        gSounds['hit']:play()
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gSounds['confirm']:play()
        
        if highlighted == 1 then
            if lifes > 0 then                
                gStateMachine:change('infinity play', {
                    ["wave"] = wave,
                    ["lifes"] = lifes,
                    ["cell"] = cell,
                    ["bot-cells"] = bot_cells,
                    ["bot-score"] = bot_score,

                    ["virus-count"] = virus_count
                })
            end
        end

        if highlighted == 3 then
            gStateMachine:change('start', {
                ["lang"] = lang,
                ["player-score"] = 0,
                ["bot-score"] = 0,
                ["wave"] = 1,
                ["lifes"] = DEFAULT_LIFES
            })
        end

        if highlighted == 4 then
            love.event.quit()
        end
    end

	if love.keyboard.wasPressed('escape') then
		love.event.quit()
	end
end

function GameOverState:render()
	love.graphics.setFont(gFonts['large'])
    if status == "win" then
	   love.graphics.printf(loc[lang]["you-win"], 0, VIRTUAL_HEIGHT / 4, 
    		VIRTUAL_WIDTH, 'center')
    elseif status == "lose" then
       love.graphics.printf(loc[lang]["you-lose"], 0, VIRTUAL_HEIGHT / 4, 
            VIRTUAL_WIDTH, 'center')        
    end

    -- info
    love.graphics.setFont(gFonts["medium"])
    love.graphics.printf(loc[lang]["final-wave"] .. tostring(wave), 0, VIRTUAL_HEIGHT / 3 + 70,
        VIRTUAL_WIDTH / 2, 'center')
    love.graphics.printf(loc[lang]["your-score"] .. tostring(cell.score), 0, VIRTUAL_HEIGHT / 3 + 140,
        VIRTUAL_WIDTH / 2, 'center')
    love.graphics.printf(loc[lang]["bot-score"] .. tostring(bot_score), 0, VIRTUAL_HEIGHT / 3 + 210,
        VIRTUAL_WIDTH / 2, 'center')
    love.graphics.printf(loc[lang]["total-score"] .. tostring(cell.score + bot_score), 0, VIRTUAL_HEIGHT / 3 + 280,
        VIRTUAL_WIDTH / 2, 'center')



	-- menu
    love.graphics.setFont(gFonts['medium'])

    if highlighted == 1 then
        if lifes > 0 then
            love.graphics.setColor(178/255, 42/255, 28/255, 1)
            love.graphics.printf("=> " .. loc[lang]["continue"] .. " <=", WINDOW_WIDTH / 2, VIRTUAL_HEIGHT / 3 + 70,
                VIRTUAL_WIDTH / 2, 'center')
        else
            love.graphics.setColor(128/255, 128/255, 128/255, 1)
            love.graphics.printf("=> " .. loc[lang]["continue"] .. " <=", WINDOW_WIDTH / 2, VIRTUAL_HEIGHT / 3 + 70,
                VIRTUAL_WIDTH / 2, 'center')
        end            
    else
        if lifes > 0 then
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.printf(loc[lang]["continue"], WINDOW_WIDTH / 2, VIRTUAL_HEIGHT / 3 + 70,
                VIRTUAL_WIDTH / 2, 'center')
        else
            love.graphics.setColor(128/255, 128/255, 128/255, 1)
            love.graphics.printf(loc[lang]["continue"], WINDOW_WIDTH / 2, VIRTUAL_HEIGHT / 3 + 70,
                VIRTUAL_WIDTH / 2, 'center')
        end            
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


    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(1, 1, 1, 1)        
    love.graphics.print(tostring(lifes), VIRTUAL_WIDTH - 30, 5)
end