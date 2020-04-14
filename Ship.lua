Ship = Class {__includes = AnimatedGameObj}

local SHIP_SPEED = 200
local SHIP_HEIGHT = 24
local SHIP_WIDTH = 16

function Ship:init()
    AnimatedGameObj.init(self, 'ship', SHIP_WIDTH, SHIP_HEIGHT)
    self.animations = {
        ['idle'] = Animation(self.tiles, 1, 2, 0.05),
        ['left'] = Animation(self.tiles, 3, 4, 0.05),
        ['right'] = Animation(self.tiles, 5, 6, 0.05)
    }
    self.x = 300
    self.y = 200
    self.animation = self.animations['idle']
    self.currentFrame = self.animation:getCurrentFrame()
    self.shots = {}
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
            if love.keyboard.wasPressed('space') then
                table.insert(self.shots, Shot('up', self.x,self.y - SHIP_HEIGHT))
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
            if not moved then
                self.speedX = 0
                self.state = 'idle'
                self.animation = self.animations['idle']
            end
            if love.keyboard.wasPressed('space') then
                table.insert(self.shots, Shot('up', self.x , self.y - SHIP_HEIGHT))
            end
        end
    }
end



function Ship:update(dt)
    AnimatedGameObj.update(self, dt)
    for key, shot in pairs(self.shots) do
        if self.shots[key].destruct  or self.shots[key].y < -10 then
            table.remove(self.shots, key)
        else
            self.shots[key]:update(dt) 
        end
    end
end