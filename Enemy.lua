Enemy = Class {}

local ENEMY_SPEED = 300
local ENEMY_HEIGHT = 16
local ENEMY_WIDTH = 16

function Enemy:init()
    GameObj.init(self, 'enemy', ENEMY_WIDTH, ENEMY_HEIGHT, ENEMY_WIDTH, ENEMY_HEIGHT)
    self.animations = {
        ['idle'] = Animation(self.tiles, 1, 1, 0.1),
        ['walking'] = Animation(self.tiles, 1, 4, 0.1)
    }
    self.state = 'idle'
    self.x = 200
    self.y = 0
    self.speedX = 0
    self.speedY = 0
    self.animation = self.animations['idle']
    self.currentFrame = self.animation:getCurrentFrame()
    self.behaviors = {
        ['idle'] = function(dt)
            if love.keyboard.isDown('left') then
                self.speedX = -ENEMY_SPEED
                self.state = 'walking'
                self.animation = self.animations['walking']
            elseif love.keyboard.isDown('right') then
                self.speedX = ENEMY_SPEED
                self.state = 'walking'
                self.animation = self.animations['walking']
            else
                self.speedX = 0
            end
            if love.keyboard.isDown('up') then
                self.speedY = -ENEMY_SPEED
            elseif love.keyboard.isDown('down') then
                self.speedY = ENEMY_SPEED
            else
                self.speedY = 0
            end
        end,
        ['walking'] = function(dt)
            local moved = false
            if love.keyboard.isDown('left') then
                self.speedX = -ENEMY_SPEED
                moved = true
            elseif love.keyboard.isDown('right') then
                self.speedX = ENEMY_SPEED
                moved = true
            end
            if love.keyboard.isDown('up') then
                self.speedY = -ENEMY_SPEED
            elseif love.keyboard.isDown('down') then
                self.speedY = ENEMY_SPEED
            else
                if not moved then
                    self.speedX = 0
                    self.state = 'idle'
                    self.animation = self.animations['idle']
                end
                self.speedY = 0
                
            end
        end
    }
end

function Enemy:update(dt)
    self.behaviors[self.state](dt)
    self.animation:update(dt)
    self.currentFrame = self.animation:getCurrentFrame()
    self.x = self.x + self.speedX * dt
    self.y = self.y + self.speedY * dt
end

function Enemy:render()
    love.graphics.draw(self.spriteSheet, self.currentFrame, self.x, self.y)
end