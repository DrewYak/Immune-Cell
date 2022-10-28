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

--[[
    Utility function for slicing tables, a la Python.
    https://stackoverflow.com/questions/24821045/does-lua-have-something-like-pythons-slice
]]
function table.slice(tbl, first, last, step)
    local sliced = {}
  
    for i = first or 1, last or #tbl, step or 1 do
      sliced[#sliced+1] = tbl[i]
    end
  
    return sliced
end

--[[
    This function is specifically made to piece out the viruses from the
    sprite sheet. Since the sprite sheet has non-uniform sprites within,
    we have to return a subset of GenerateQuads.
]]
function GenerateQuadsViruses(atlas)
	return table.slice(GenerateQuads(atlas, 256, 256), 1, 43)
end