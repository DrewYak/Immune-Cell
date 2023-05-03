Cell = Class{}

function Cell:init(isBot, speedIncrease)
    -- self.width and self.height
    -- must be initialize before 
    -- self.x and self.y
    self.width = 150
    self.height = 140

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
        if self.score < LEVEL_UP_1 then
            love.graphics.draw(gTextures['cells'], gFrames['cells'][9], self.x, self.y)    
        elseif self.score < LEVEL_UP_2 then
            love.graphics.draw(gTextures['cells'], gFrames['cells'][10], self.x, self.y)    
        elseif self.score < LEVEL_UP_3 then
            love.graphics.draw(gTextures['cells'], gFrames['cells'][11], self.x, self.y)    
        else
            love.graphics.draw(gTextures['cells'], gFrames['cells'][12], self.x, self.y)    
        end            
    else
        if self.score < LEVEL_UP_1 then
            love.graphics.draw(gTextures['cells'], gFrames['cells'][1], self.x, self.y)    
        elseif self.score < LEVEL_UP_2 then
            love.graphics.draw(gTextures['cells'], gFrames['cells'][2], self.x, self.y)    
        elseif self.score < LEVEL_UP_3 then
            love.graphics.draw(gTextures['cells'], gFrames['cells'][3], self.x, self.y)    
        else
            love.graphics.draw(gTextures['cells'], gFrames['cells'][4], self.x, self.y)    
        end            
    end 
end