--[[
	Author: Iakovlichev Andrew
	DrewYak7@gmail.com

	Helper functions.
]]

function GenerateQuads(atlas, tilewidth, tileheight)
	local sheetWidth = atlas:getWidth() / tilewidth
	local sheetHeight = atlas:getHeight() / tileheight

	local sheetcounter = 1
	local spritesheet = {}

	for y = 0, sheetHeight - 1 do
		for x = 0, sheetWidth - 1 do
			spritesheet[sheetcounter] = love.graphics.newQuad(x * tilewidth, y * tileheight,
				tilewidth, tileheight, atlas:getDimensions()) 
			sheetcounter = sheetcounter + 1
		end
	end

	return spritesheet
end