GameOverState = Class{__includes = BaseState}

local highlighted = 1
local status = "win"
local lang = "en"
local player_score = 0
local bot_score = 0
local final_wave = 0
local lifes = 0

function GameOverState:enter(params)
	status = params["status"]
    lang = params["lang"]
    player_score = params["player-score"]
    bot_score = params["bot-score"]
    final_wave = params["wave"]
    lifes = params["lifes"]
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
                    ["lang"] = lang,
                    ["player-score"] = player_score,
                    ["bot-score"] = bot_score,
                    ["wave"] = final_wave,
                    ["lifes"] = lifes
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
    love.graphics.printf(loc[lang]["final-wave"] .. tostring(final_wave), 0, VIRTUAL_HEIGHT / 3 + 70,
        VIRTUAL_WIDTH / 2, 'center')
    love.graphics.printf(loc[lang]["your-score"] .. tostring(player_score), 0, VIRTUAL_HEIGHT / 3 + 140,
        VIRTUAL_WIDTH / 2, 'center')
    love.graphics.printf(loc[lang]["bot-score"] .. tostring(bot_score), 0, VIRTUAL_HEIGHT / 3 + 210,
        VIRTUAL_WIDTH / 2, 'center')
    love.graphics.printf(loc[lang]["total-score"] .. tostring(player_score + bot_score), 0, VIRTUAL_HEIGHT / 3 + 280,
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