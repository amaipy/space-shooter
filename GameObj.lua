require 'Util'

GameObj = Class{}

function GameObj:init(spriteSheet, spriteWidth, spriteHeight)
    self.spriteSheet  = love.graphics.newImage('graphics/' .. spriteSheet .. '.png')
    self.spriteWidth  = spriteWidth
    self.spriteHeight = spriteHeight
    self.tiles = loadSpritesheet(self.spriteSheet, self.spriteWidth, self.spriteHeight)
    self.animations = {}
    self.state = 'idle'
    self.x = 0 
    self.y = 0
    self.speedX = 0
    self.speedY = 0
    self.animation = {}
    self.behaviors = {}
    self.currentFrame = {}
end    

function GameObj:update(dt)
    self.behaviors[self.state](dt)
    self.animation:update(dt)
    self.currentFrame = self.animation:getCurrentFrame()
    self.x = math.max(0, math.min(self.x + self.speedX * dt, VIRTUAL_WIDTH - self.spriteWidth))
    self.y = self.y + self.speedY * dt
end

function GameObj:render()
    love.graphics.draw(self.spriteSheet, self.currentFrame, self.x, self.y)
end

function GameObj:detectCollision(otherObj)
    return self.x >= otherObj.x - otherObj.spriteWidth/2 and self.x <= otherObj.x + otherObj.spriteWidth/2  and self.y <= otherObj.y and self.y >= otherObj.y - otherObj.spriteHeight / 2
end