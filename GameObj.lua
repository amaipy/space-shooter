require 'Util'

GameObj = Class{}

function GameObj:init(spriteSheet, spriteWidth, spriteHeight, totalWidth, totalHeight)
    self.spriteSheet  = love.graphics.newImage('graphics/' .. spriteSheet .. '.png')
    self.totalWidth   = totalWidth
    self.totalHeight  = totalHeight
    self.spriteWidth  = spriteWidth
    self.spriteHeight = spriteHeight
    self.tiles = loadSpritesheet(self.spriteSheet, self.spriteWidth, self.spriteHeight)
end    

function GameObj:getTile(x, y)
    return self.tiles[(y - 1) * self.totalWidth + x]
end

function GameObj:setTile(x, y, id)
    self.tiles[(y - 1) * self.totalWidth + x] = id
end