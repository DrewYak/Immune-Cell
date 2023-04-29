Cell = Class{}

function Cell:init(isBot, speedIncrease)
    --scale_cell = 128 / 952
    scale_cell = 1

    -- self.width and self.height
    -- must be initialize
    -- before self.x and self.y
    --self.width = 1077 * scale_cell
    --self.height = 952 * scale_cell
    self.width = 150 * scale_cell
    self.height = 140 * scale_cell


    self.x = VIRTUAL_WIDTH / 2 - self.width / 2
    self.y = VIRTUAL_HEIGHT / 2 - self.height / 2

    self.dx = 0
    self.dy = 0

    self.isBot = isBot
    self.speedIncrease = speedIncrease
    self.score = 0
end

function Cell:update(dt)
    if self.isBot then
        if lastTime == nil or os.time() - lastTime >= math.random(0, 40)  then
            self.dx = CELL_SPEED * (math.random(0, 1) * 2 - 1)
            self.dy = CELL_SPEED * (math.random(0, 1) * 2 - 1) 
            lastTime = os.time()
        end
    else        
        if love.keyboard.isDown('left') then
            self.dx = -CELL_SPEED
        elseif love.keyboard.isDown('right') then
            self.dx = CELL_SPEED
        else
            self.dx = 0
        end
            
        if love.keyboard.isDown('up') then
            self.dy = -CELL_SPEED
        elseif love.keyboard.isDown('down') then
            self.dy = CELL_SPEED
        else
            self.dy = 0
        end
    end

    self.dx = self.dx * self.speedIncrease
    self.dy = self.dy * self.speedIncrease

    if self.dx < 0 then
        self.x = math.max(0, self.x + self.dx * dt)
    else
        self.x = math.min(VIRTUAL_WIDTH - self.width, self.x + self.dx * dt)
    end

    if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy * dt)
    else
        self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy * dt)
    end
end

function Cell:collides(target)
        if self.score < LEVEL_UP_1 then
            return ((self.x + self.width / 2) - (target.x))^2 + 
            ((self.y + self.height / 2) - (target.y))^2 <= COLLISION_DISTANCE_0^2
        elseif self.score < LEVEL_UP_2 then
            return ((self.x + self.width / 2) - (target.x))^2 + 
            ((self.y + self.height / 2) - (target.y))^2 <= COLLISION_DISTANCE_1^2
        elseif self.score < LEVEL_UP_3 then
            return ((self.x + self.width / 2) - (target.x))^2 + 
            ((self.y + self.height / 2) - (target.y))^2 <= COLLISION_DISTANCE_2^2
        else
            return ((self.x + self.width / 2) - (target.x))^2 + 
            ((self.y + self.height / 2) - (target.y))^2 <= COLLISION_DISTANCE_3^2
        end            
end

function Cell:render()
    if self.isBot then
        love.graphics.draw(gTextures['cell-bot'], self.x, self.y, 0, scale_cell, scale_cell)    
    else
        if self.score < LEVEL_UP_1 then
            love.graphics.draw(gTextures['cells'], gFrames['cells'][1], self.x, self.y, 0, scale_cell, scale_cell)    
        elseif self.score < LEVEL_UP_2 then
            love.graphics.draw(gTextures['cells'], gFrames['cells'][2], self.x, self.y, 0, scale_cell, scale_cell)    
        elseif self.score < LEVEL_UP_3 then
            love.graphics.draw(gTextures['cells'], gFrames['cells'][3], self.x, self.y, 0, scale_cell, scale_cell)    
        else
            love.graphics.draw(gTextures['cells'], gFrames['cells'][4], self.x, self.y, 0, scale_cell, scale_cell)    
        end            
    end 
end