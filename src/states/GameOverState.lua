GameOverState = Class{__includes = BaseState}

function GameOverState:enter()
	--self.score = params.score
	--self.last_virus = params.last_virus
end

function GameOverState:update(dt)
	if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
		gStateMachine:change('start')
	end

	if love.keyboard.wasPressed('escape') then
		love.event.quit()
	end
end

function GameOverState:render()
	love.graphics.setFont(gFonts['large'])
	love.graphics.printf('GAME OVER', 0, VIRTUAL_HEIGHT / 3, 
		VIRTUAL_WIDTH, 'center')
end