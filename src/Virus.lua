Virus = Class{}

function Virus:init(number)
	self.x = 0
	self.y = VIRTUAL_HEIGHT / 2
	self.r = 0
	self.direction = math.random(0, 1) * 2 - 1

	self.dx = VIRUS_SPEED_X
	self.dy = math.random(VIRUS_SPEED_Y / 10, VIRUS_SPEED_Y)
	self.dr = VIRUS_ROT_SPEED

	self.width = 256
	self.height = 256

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

function Virus:render()
	love.graphics.draw(gTextures['viruses'],
		gFrames['viruses'][self.number],
		self.x, self.y, self.r, 
		VIRUS_SCALE, VIRUS_SCALE, self.width / 2, self.height / 2)
end