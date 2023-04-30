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
local lang = "en"

function StartState:update(dt)
    -- toggle highlighted option if we press an arrow key up or down
    if love.keyboard.wasPressed('down') then
        highlighted = highlighted % 4 + 1
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
            gStateMachine:change('infinity play', {
                ["lang"] = lang,
                ["player-score"] = 0,
                ["bot-score"] = 0,
                ["wave"] = 1,
                ["lifes"] = DEFAULT_LIFES
            })
        end

        if highlighted == 3 then
            if lang == "en" then
                lang = "ru"
            else
                lang = "en"
            end
        end

        if highlighted == 4 then
            love.event.quit()
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
    love.graphics.printf(loc[lang]["immune-cell"], 0, VIRTUAL_HEIGHT / 4,
        VIRTUAL_WIDTH, 'center')
    
    -- menu
    love.graphics.setFont(gFonts['medium'])

    if highlighted == 1 then
        love.graphics.setColor(178/255, 42/255, 28/255, 1)
        love.graphics.printf("=> ".. loc[lang]["infinity-game"] .. " <=", 0, VIRTUAL_HEIGHT / 3 + 70,
            VIRTUAL_WIDTH, 'center')
    else
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf(loc[lang]["infinity-game"], 0, VIRTUAL_HEIGHT / 3 + 70,
            VIRTUAL_WIDTH, 'center')
    end

    if highlighted == 2 then
        love.graphics.setColor(178/255, 42/255, 28/255, 1)
        love.graphics.printf("=> ".. loc[lang]["high-scores"] .. " <=", 0, VIRTUAL_HEIGHT / 3 + 140,
            VIRTUAL_WIDTH, 'center')
    else
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf(loc[lang]["high-scores"], 0, VIRTUAL_HEIGHT / 3 + 140,
            VIRTUAL_WIDTH, 'center')
    end

    if highlighted == 3 then
        love.graphics.setColor(178/255, 42/255, 28/255, 1)
        love.graphics.printf("=> ".. loc[lang]["language"] .. " <=", 0, VIRTUAL_HEIGHT / 3 + 210,
            VIRTUAL_WIDTH, 'center')
    else
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf(loc[lang]["language"], 0, VIRTUAL_HEIGHT / 3 + 210,
            VIRTUAL_WIDTH, 'center')
    end

    if highlighted == 4 then
        love.graphics.setColor(178/255, 42/255, 28/255, 1)
        love.graphics.printf("=> ".. loc[lang]["exit"] .. " <=", 0, VIRTUAL_HEIGHT / 3 + 280,
            VIRTUAL_WIDTH, 'center')
    else
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf(loc[lang]["exit"], 0, VIRTUAL_HEIGHT / 3 + 280,
            VIRTUAL_WIDTH, 'center')
    end

    -- reset the color
    love.graphics.setColor(1, 1, 1, 1)
end