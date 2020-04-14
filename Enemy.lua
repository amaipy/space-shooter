Enemy = Class {__includes = GameObj}

ENEMY_SPEED = 120
ENEMY_HEIGHT = 16
ENEMY_WIDTH = 16

function Enemy:init(x)
    GameObj.init(self, 'enemy', ENEMY_WIDTH, ENEMY_HEIGHT)
    self.animations = {
        ['idle'] = Animation(self.tiles, 1, 1, 0.1),
        ['walking'] = Animation(self.tiles, 1, 4, 0.1)
    }
    self.x = x
    self.animation = self.animations['idle']
    self.shots = {}
    self.limit = 1
    self.currentFrame = self.animation:getCurrentFrame()
    self.behaviors = {
        ['idle'] = function(dt)
            self:shot(dt)
        end,
        ['walking'] = function(dt)
            self:shot(dt)
        end
    }
end

function Enemy:shot(dt)
    if #self.shots < self.limit then
        table.insert(self.shots, Shot('down', self.x, self.y))
    end
end

function Enemy:update(dt)
    GameObj.update(self, dt)
    for key, shot in pairs(self.shots) do
        if self.shots[key].destruct  or self.shots[key].y > VIRTUAL_HEIGHT then
            table.remove(self.shots, key)
        else
            self.shots[key]:update(dt) 
        end
    end
end