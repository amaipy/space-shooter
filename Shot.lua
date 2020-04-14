Shot = Class {__includes = GameObj}

local SHOT_SPEED = 500

local SHOT_WIDTH = 16

function Shot:init(orientation, x, y)
    local shot_height = 16
    local tile_end = 5
    local name = 'en_shot'
    if orientation == 'up' then
        shot_height = 32
        tile_end = 7 
        name = 'sh_shot'
    end
    GameObj.init(self, name, SHOT_WIDTH, shot_height)
    self.animations = {
        ['idle'] = Animation(self.tiles, 1, 2, 1),
        ['collision'] = Animation(self.tiles, 3, tile_end, 0.1)
    }
    self.x = x
    self.y = y
    self.destruct = false
    self.startCollision = 0
    self.animation = self.animations['idle']
    self.currentFrame = self.animation:getCurrentFrame()
    self.behaviors = {
        ['idle'] = function(dt)
            if orientation == 'up' then
                self.speedY = -SHOT_SPEED
            else
                self.speedY = SHOT_SPEED
            end
        end,
        ['collision'] = function(dt)
            self.speedY = 0
            if self.animation.currentFrame == self.animation.quadStart then
                if self.startCollision > 10 then
                    self.destruct = true
                else 
                    self.startCollision = self.startCollision + 1
                end     
            end
        end
    }
end