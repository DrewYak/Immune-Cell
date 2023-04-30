GameOverState = Class{__includes = BaseState}

local highlighted = 1
local status = "win"
local lang = "en"
local player_score = 0
local bot_score = 0

function GameOverState:enter(params)
	status = params["status"]
    lang = params["lang"]
    player_score = params["player-score"]
    bot_score = params["bot-score"]
end

function GameOverState:update(dt)
    if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
        highlighted = 1 + highlighted % 2
        gSounds['hit']:play()
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gSounds['confirm']:play()
        
        if highlighted == 1 then
            gStateMachine:change('infinity play')
        end
    end

	if love.keyboard.wasPressed('escape') then
		love.event.quit()
	end
end

function GameOverState:render()
	love.graphics.setFont(gFonts['large'])
    if status == "win" then
	   love.graphics.printf(loc[lang]["you-win"], 0, VIRTUAL_HEIGHT / 3, 
    		VIRTUAL_WIDTH, 'center')
    elseif status == "lose" then
       love.graphics.printf(loc[lang]["you-lose"], 0, VIRTUAL_HEIGHT / 3, 
            VIRTUAL_WIDTH, 'center')        
    end

	-- menu
    love.graphics.setFont(gFonts['medium'])

    if highlighted == 1 then
        love.graphics.setColor(178/255, 42/255, 28/255, 1)
        love.graphics.printf("=> " .. loc[lang]["continue"] .. " <=", 0, VIRTUAL_HEIGHT / 2 + 70,
            VIRTUAL_WIDTH, 'center')
    else
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf(loc[lang]["continue"], 0, VIRTUAL_HEIGHT / 2 + 70,
            VIRTUAL_WIDTH, 'center')
    end

    if highlighted == 2 then
        love.graphics.setColor(178/255, 42/255, 28/255, 1)
        love.graphics.printf("=> " .. loc[lang]["high-scores"] .. " <=", 0, VIRTUAL_HEIGHT / 2 + 140,
            VIRTUAL_WIDTH, 'center')
    else
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf(loc[lang]["high-scores"], 0, VIRTUAL_HEIGHT / 2 + 140,
            VIRTUAL_WIDTH, 'center')
    end

    -- reset the color
    love.graphics.setColor(1, 1, 1, 1)
end