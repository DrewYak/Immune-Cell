Cell = Class{}

function Cell:init(isSelected, speedIncrease)
    --scale_cell = 128 / 952
    scale_cell = 1

    -- self.width and self.height
    -- must be initialize
    -- before self.x and self.y
    --self.width = 1077 * scale_cell
    --self.height = 952 * scale_cell
    self.width = 145 * scale_cell
    self.height = 128 * scale_cell


    self.x = VIRTUAL_WIDTH / 2 - self.width / 2
    self.y = VIRTUAL_HEIGHT / 2 - self.height / 2

    self.dx = 0
    self.dy = 0

    self.isSelected = isSelected
    self.speedIncrease = speedIncrease
end

function Cell:update(dt)
    if self.isSelected then
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
    else
        if lastTime == nil or os.time() - lastTime >= math.random(0, 40)  then
            self.dx = CELL_SPEED * (math.random(0, 1) * 2 - 1)
            self.dy = CELL_SPEED * (math.random(0, 1) * 2 - 1) 
            lastTime = os.time()
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
    return ((self.x + self.width / 2) - (target.x))^2 + 
    ((self.y + self.height / 2) - (target.y))^2 <= COLLISION_DISTANCE^2
end

function Cell:render()
    love.graphics.draw(gTextures['cell'], self.x, self.y, 0, scale_cell, scale_cell)
end