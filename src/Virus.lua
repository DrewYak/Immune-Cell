Virus = Class{}

function Virus:init(number)
	self.x = 0
	self.y = VIRTUAL_HEIGHT / 2

	self.width =256
	self.height = 256

	self.number = number

	self.inPlay = true
end

function Virus:update(dt)
	self.dx = VIRUS_SPEED
	self.dy = 0

	self.x = self.x + self.dx * dt 
	self.y = self.y + self.dy * dt 

end

function Virus:render()
	love.graphics.draw(gTextures['viruses'],
		gFrames['viruses'][self.number],
		self.x, self.y)
end