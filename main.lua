--[[
    Author: Andrew Iakovlichev 
    DrewYak7@gmail.com

	A game in which the immune cell with bot-cells must catch and eat viruses and bacteria.

    Music and sounds:
    https://freesound.org/people/joshuaempyre/sounds/251461/
    https://freesound.org/people/LittleRobotSoundFactory/sounds/270467/
    https://freesound.org/people/shinephoenixstormcrow/sounds/337049/
    https://freesound.org/people/qubodup/sounds/195486/

]]

require 'src/Dependencies'

--[[
    Called just once at the beginning of the game; used to set up
    game objects, variables, etc. and prepare the game world.
]]
function love.load()
    -- set love's default filter to "nearest-neighbor", which essentially
    -- means there will be no filtering of pixels (blurriness), which is
    -- important for a nice crisp, 2D look
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- seed the RNG so that calls to random are always random
    math.randomseed(os.time())

    love.window.setTitle('Virus Catcher')
    love.window.setIcon(love.image.newImageData('graphics/window_icon.png'))

    gFonts = {
        ['small'] = love.graphics.newFont('fonts/ShantellSans-MediumItalic.ttf', 20),
        ['medium'] = love.graphics.newFont('fonts/ShantellSans-MediumItalic.ttf', 40),
        ['large'] = love.graphics.newFont('fonts/ShantellSans-MediumItalic.ttf', 80)
    }
    love.graphics.setFont(gFonts['small'])

    gTextures = {
    	['background'] = love.graphics.newImage('graphics/background.png'),
        ['viruses'] = love.graphics.newImage('graphics/viruses.png'),
        ['cells'] = love.graphics.newImage('graphics/cells.png'),
        ['bot-cells'] = love.graphics.newImage('graphics/bot_cells.png')        
    }

    gFrames = {
        ['viruses'] = GenerateQuadsViruses(gTextures['viruses']),
        ['cells'] = GenerateQuadsCells(gTextures['cells']),
        ['bot-cells'] = GenerateQuadsBotCells(gTextures['bot-cells'])
    } 

    
    -- initialize our virtual resolution, which will be rendered within our
    -- actual window no matter its dimensions
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    gSounds = {
        ['hit'] = love.audio.newSource('sounds/hit.wav', 'static'),
        ['confirm'] = love.audio.newSource('sounds/confirm.wav', 'static'),
        ['pause'] = love.audio.newSource('sounds/pause.wav', 'static'),
        ['virus-hit'] = love.audio.newSource('sounds/virus-hit.wav', 'static'),
        ['victory'] = love.audio.newSource('sounds/victory.mp3', 'static'),
        ['lose'] = love.audio.newSource('sounds/lose.mp3', 'static'),
        ['short-victory'] = love.audio.newSource('sounds/short-victory.mp3', 'static'),
        ['level-up'] = love.audio.newSource('sounds/level-up.mp3', 'static'),

        ['music'] = love.audio.newSource('sounds/music.mp3', 'stream')
    }

    -- the state machine we'll be using to transition between various states
    -- in our game instead of clumping them together in our update and draw
    -- methods
    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['high scores'] = function() return HighScoresState() end,
        ['infinity play'] = function() return InfinityPlayState() end,
        ['game over'] = function() return GameOverState() end
    }
    gStateMachine:change('start')

    loadHighScores()

    -- a table we'll use to keep track of which keys have been pressed this
    -- frame, to get around the fact that LÖVE's default callback won't let us
    -- test for input from within other functions
    love.keyboard.keysPressed = {}
end

--[[
    Called whenever we change the dimensions of our window, as by dragging
    out its bottom corner, for example. In this case, we only need to worry
    about calling out to `push` to handle the resizing. Takes in a `w` and
    `h` variable representing width and height, respectively.
]]
function love.resize(w, h)
    push:resize(w, h)
end

--[[
    Called every frame, passing in `dt` since the last frame. `dt`
    is short for `deltaTime` and is measured in seconds. Multiplying
    this by any changes we wish to make in our game will allow our
    game to perform consistently across all hardware; otherwise, any
    changes we make will be applied as fast as possible and will vary
    across system hardware.
]]
function love.update(dt)
    -- this time, we pass in dt to the state object we're currently using
    gStateMachine:update(dt)

    -- reset keys pressed
    love.keyboard.keysPressed = {}
end

--[[
    A callback that processes key strokes as they happen, just the once.
    Does not account for keys that are held down, which is handled by a
    separate function (`love.keyboard.isDown`). Useful for when we want
    things to happen right away, just once, like when we want to quit.
]]
function love.keypressed(key)
    -- add to our table of keys pressed this frame
    love.keyboard.keysPressed[key] = true
end

--[[
    A custom function that will let us test for individual keystrokes outside
    of the default `love.keypressed` callback, since we can't call that logic
    elsewhere by default.
]]
function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

--[[
    Called each frame after update; is responsible simply for
    drawing all of our game objects and more to the screen.
]]
function love.draw()
    -- begin drawing with push, in our virtual resolution
    push:apply('start')

    -- background should be drawn regardless of state, scaled to fit our
    -- virtual resolution
    local backgroundWidth = gTextures['background']:getWidth()
    local backgroundHeight = gTextures['background']:getHeight()

    love.graphics.draw(gTextures['background'], 
        -- draw at coordinates 0, 0
        0, 0, 
        -- no rotation
        0)
    
    -- use the state machine to defer rendering to the current state we're in
    gStateMachine:render()
    
    -- display FPS for debugging
    -- comment out to remove and
    -- uncomment to use
    -- displayFPS()
    
    push:apply('end')
end

function displayFPS()
    -- simple FPS display across all states
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 8, 35)
end

function loadHighScores()
    love.filesystem.setIdentity('virus-catcher')

    if not love.filesystem.getInfo('virus-catcher.lst') then
        local scores = ''
        scores = scores .. 'waves\n' .. '0\n'
        scores = scores .. 'your-scores\n' ..'0\n'
        scores = scores .. 'bot-scores\n' ..'0\n'
        scores = scores .. 'total-scores\n' ..'0\n'        
        love.filesystem.write('virus-catcher.lst', scores)
    end

    local n
    for line in love.filesystem.lines('virus-catcher.lst') do
        n = tonumber(line) 
        if n == nil then
            t = high_scores[string.gsub(line, "\n", "")] 
        else
            table.insert(t, n)
        end
    end
end
