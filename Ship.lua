Ship = Class {}

local SHIP_SPEED = 200
local SHIP_HEIGHT = 24
local SHIP_WIDTH = 16

function Ship:init()
    GameObj.init(self, 'ship', SHIP_WIDTH, SHIP_HEIGHT, SHIP_WIDTH, SHIP_HEIGHT)
    self.animations = {
        ['idle'] = Animation(self.tiles, 1, 2, 0.05),
        ['left'] = Animation(self.tiles, 3, 4, 0.05),
        ['right'] = Animation(self.tiles, 5, 6, 0.05)
    }
    self.state = 'idle'
    self.x = 300
    self.y = 100
    self.speedX = 0
    self.speedY = 0
    self.animation = self.animations['idle']
    self.currentFrame = self.animation:getCurrentFrame()
    self.behaviors = {
        ['idle'] = function(dt)
            if love.keyboard.isDown('left') then
                self.speedX = -SHIP_SPEED
                self.state = 'walking'
                self.animations['left']:restart()
                self.animation = self.animations['left']
            elseif love.keyboard.isDown('right') then
                self.speedX = SHIP_SPEED
                self.state = 'walking'
                self.animations['right']:restart()
                self.animation = self.animations['right']
            else
                self.speedX = 0
            end
            if love.keyboard.isDown('up') then
                self.speedY = -SHIP_SPEED
            elseif love.keyboard.isDown('down') then
                self.speedY = SHIP_SPEED
            else
                self.speedY = 0
            end
        end,
        ['walking'] = function(dt)
            local moved = false
            if love.keyboard.isDown('left') then
                self.speedX = -SHIP_SPEED
                moved = true
            elseif love.keyboard.isDown('right') then
                self.speedX = SHIP_SPEED
                moved = true
            end
            if love.keyboard.isDown('up') then
                self.speedY = -SHIP_SPEED
            elseif love.keyboard.isDown('down') then
                self.speedY = SHIP_SPEED
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

function Ship:update(dt)
    self.behaviors[self.state](dt)
    self.animation:update(dt)
    self.currentFrame = self.animation:getCurrentFrame()
    self.x = self.x + self.speedX * dt
    self.y = self.y + self.speedY * dt
end

function Ship:render()
    love.graphics.draw(self.spriteSheet, self.currentFrame, self.x, self.y)
end