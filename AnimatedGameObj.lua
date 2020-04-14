AnimatedGameObj = Class{__includes = GameObj}

function AnimatedGameObj:init(fileName, width, height)
    GameObj.init(self, fileName, width, height, width, height)
    self.animations = {}
    self.state = 'idle'
    self.offsetX = offsetX
    self.offsetY = offsetY
    self.x = 0 
    self.y = 0
    self.speedX = 0
    self.speedY = 0
    self.animation = {}
    self.behaviors = {}
    self.currentFrame = {}
end    

function AnimatedGameObj:update(dt)
    self.behaviors[self.state](dt)
    self.animation:update(dt)
    self.currentFrame = self.animation:getCurrentFrame()
    self.x = self.x + self.speedX * dt
    self.y = self.y + self.speedY * dt
end

function AnimatedGameObj:render()
    love.graphics.draw(self.spriteSheet, self.currentFrame, self.x, self.y)
end

function AnimatedGameObj:detectCollision(otherObj)
    return self.x >= otherObj.x - otherObj.spriteWidth/2 and self.x <= otherObj.x + otherObj.spriteWidth/2  and self.y <= otherObj.y and self.y >= otherObj.y - otherObj.spriteHeight / 2
end