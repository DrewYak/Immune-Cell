HighScoresState = Class{__includes = BaseState}

high_scores = {
	['waves'] = {},
	['your-scores'] = {},
	['bot-scores'] = {},
	['total-scores'] = {}
}

local line_interval = 40
local source_state

function HighScoresState:enter(params)
	source_state = params['source-state']
end

function HighScoresState:update(dt)
	if love.keyboard.wasPressed('escape') then
		gStateMachine:change(source_state)
	end
end

function HighScoresState:render()
	love.graphics.setFont(gFonts['small'])
	love.graphics.setColor(178/255, 42/255, 28/255, 1)
	love.graphics.print(loc[lang]['click-esc'], 20, 80)

	love.graphics.setFont(gFonts['large'])
	love.graphics.setColor(1/255, 102/255, 169/255, 1)
	love.graphics.printf(loc[lang]["high-scores"], 0, 60, VIRTUAL_WIDTH, "center")	

	love.graphics.setFont(gFonts['small'])
	love.graphics.setColor(1/255, 102/255, 169/255, 1)
	love.graphics.printf(loc[lang]["final-waves"], VIRTUAL_WIDTH / 6, 160, VIRTUAL_WIDTH / 6, "center")
	love.graphics.printf(loc[lang]["your-scores"], 2 * VIRTUAL_WIDTH / 6, 160, VIRTUAL_WIDTH / 6, "center")
	love.graphics.printf(loc[lang]["bot-scores"], 3 * VIRTUAL_WIDTH / 6, 160, VIRTUAL_WIDTH / 6, "center")
	love.graphics.printf(loc[lang]["total-scores"], 4 * VIRTUAL_WIDTH / 6, 160, VIRTUAL_WIDTH / 6, "center")

	love.graphics.setFont(gFonts['medium'])
	love.graphics.setColor(1/255, 102/255, 169/255, 1)

	for i = 1, math.min(10, #high_scores['waves']) do
		love.graphics.printf(high_scores['waves'][i], VIRTUAL_WIDTH / 6, 140 + i * line_interval, VIRTUAL_WIDTH / 6, "center")
	end
	
	for i = 1, math.min(10, #high_scores['your-scores']) do
		love.graphics.printf(high_scores['your-scores'][i], 2 * VIRTUAL_WIDTH / 6, 140 + i * line_interval, VIRTUAL_WIDTH / 6, "center")
	end
	
	for i = 1, math.min(10, #high_scores['bot-scores']) do
		love.graphics.printf(high_scores['bot-scores'][i], 3 * VIRTUAL_WIDTH / 6, 140 + i * line_interval, VIRTUAL_WIDTH / 6, "center")
	end
	
	for i = 1, math.min(10, #high_scores['total-scores']) do
		love.graphics.printf(high_scores['total-scores'][i], 4 * VIRTUAL_WIDTH / 6, 140 + i * line_interval, VIRTUAL_WIDTH / 6, "center")
	end		
end