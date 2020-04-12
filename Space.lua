Space = Class{__includes = GameObj}

local SPRITE_HEIGHT = 64
local SPRITE_WIDTH = 64
local MAP_WIDTH = 30
local MAP_HEIGHT = 30

function Space:init()
    GameObj.init(self, 'background', SPRITE_WIDTH, SPRITE_HEIGHT, MAP_WIDTH, MAP_HEIGHT)
end    

function Space:render()
    for x = 1, self.totalWidth do
        for y = 1, self.totalHeight do
            love.graphics.draw(self.spriteSheet, (x - 1) * self.spriteWidth, (y - 1) * self.spriteHeight)
        end
    end
end