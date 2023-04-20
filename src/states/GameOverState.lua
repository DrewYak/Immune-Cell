GameOverState = Class{__includes = BaseState}

local highlighted = 1

function GameOverState:enter(params)
	self.status = params.status
	--self.last_virus = params.last_virus
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
    if self.status == 'win' then
	   love.graphics.printf('YOU WIN!', 0, VIRTUAL_HEIGHT / 3, 
    		VIRTUAL_WIDTH, 'center')
    elseif self.status == 'lose' then
       love.graphics.printf('YOU LOSE!', 0, VIRTUAL_HEIGHT / 3, 
            VIRTUAL_WIDTH, 'center')        
    end

	-- menu
    love.graphics.setFont(gFonts['medium'])

    if highlighted == 1 then
        love.graphics.setColor(178/255, 42/255, 28/255, 1)
        love.graphics.printf("=> TRY AGAIN <=", 0, VIRTUAL_HEIGHT / 2 + 70,
            VIRTUAL_WIDTH, 'center')
    else
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf("TRY AGAIN", 0, VIRTUAL_HEIGHT / 2 + 70,
            VIRTUAL_WIDTH, 'center')
    end

    if highlighted == 2 then
        love.graphics.setColor(178/255, 42/255, 28/255, 1)
        love.graphics.printf("=> HIGH SCORES <=", 0, VIRTUAL_HEIGHT / 2 + 140,
            VIRTUAL_WIDTH, 'center')
    else
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf("HIGH SCORES", 0, VIRTUAL_HEIGHT / 2 + 140,
            VIRTUAL_WIDTH, 'center')
    end

    -- reset the color
    love.graphics.setColor(1, 1, 1, 1)
end