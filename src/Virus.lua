Virus = Class{}

function Virus:init(number, shiftLeft, speed_coef)
	-- actual quad's sizes!
	-- initialize before self.x and self.y
	self.width = 256
	self.height = 256

	self.x = -self.width * VIRUS_SCALE - shiftLeft
	self.y = math.random(self.height * VIRUS_SCALE / 2, 
		VIRTUAL_HEIGHT - self.height * VIRUS_SCALE / 2)
	self.r = math.random() * 2 * math.pi
	self.direction = math.random(0, 1) * 2 - 1

	self.dx = math.random(VIRUS_SPEED_X * speed_coef / 2.5, VIRUS_SPEED_X)
	self.dy = math.random(VIRUS_SPEED_Y * speed_coef / 10, VIRUS_SPEED_Y)
	self.dr = VIRUS_ROT_SPEED


	self.number = number

	self.inPlay = true
end

function Virus:update(dt)
	self.x = self.x + self.dx * dt 
	if (self.y <= self.height * VIRUS_SCALE / 2) or (self.y >= VIRTUAL_HEIGHT - self.height * VIRUS_SCALE / 2) then
		self.direction = -self.direction
	end
	self.y = self.y + self.direction * self.dy * dt
	self.r = self.r + self.dr * dt
end

function Virus:hit()
	gSounds['virus-hit']:play()
	
	self.inPlay = false
end

function Virus:render()
	if self.inPlay then
		love.graphics.draw(gTextures['viruses'],
			gFrames['viruses'][self.number],
			self.x, self.y, self.r, 
			VIRUS_SCALE, VIRUS_SCALE, self.width / 2, self.height / 2)
	end
end