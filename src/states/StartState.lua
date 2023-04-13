--[[
    -- StartState Class --

    Author: Iakovlichev Andrew
    DrewYak7@gmail.com

    Represents the state the game is in when we've just started; should
    simply display "Immune Cell" in large text, as well as a message to press
    Enter to begin.
]]

-- the "__includes" bit here means we're going to inherit all of the methods
-- that BaseState has, so it will have empty versions of all StateMachine methods
-- even if we don't override them ourselves; handy to avoid superfluous code!
StartState = Class{__includes = BaseState}

-- whether we're highlighting "Start" or "High Scores"
local highlighted = 1

function StartState:update(dt)
    -- toggle highlighted option if we press an arrow key up or down
    if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
        highlighted = 1 + highlighted % 2
        gSounds['hit']:play()
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gSounds['confirm']:play()
        
        if highlighted == 1 then
            gStateMachine:change('play')
        end
    end

    -- we no longer have this globally, so include here
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function StartState:render()
    -- title
    love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(1/255, 102/255, 169/255, 1)
    love.graphics.printf("IMMUNE CELL", 0, VIRTUAL_HEIGHT / 3,
        VIRTUAL_WIDTH, 'center')
    
    -- menu
    love.graphics.setFont(gFonts['medium'])


    if highlighted == 1 then
        love.graphics.setColor(178/255, 42/255, 28/255, 1)
        love.graphics.printf("=> START <=", 0, VIRTUAL_HEIGHT / 2 + 70,
            VIRTUAL_WIDTH, 'center')
    else
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf("START", 0, VIRTUAL_HEIGHT / 2 + 70,
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