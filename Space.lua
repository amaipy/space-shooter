Space = Class{}

local SPRITE_HEIGHT = 64
local SPRITE_WIDTH = 64
local MAP_WIDTH = 30
local MAP_HEIGHT = 30
local SPRITESHEET = 'background'

function Space:insertEnemies()
    self.enemiesNum = math.floor(math.random(2, 6))
    self.enemies = {}
    for x = 1, self.enemiesNum do
        table.insert(self.enemies, Enemy(math.floor(math.random(ENEMY_WIDTH, VIRTUAL_WIDTH - ENEMY_WIDTH))))
    end
end

function Space:reset()
    self:insertEnemies()
    self.ship.shots = {}
    if USER_SCORE > HIGHEST_SCORE then
        HIGHEST_SCORE = USER_SCORE
    end
    SHIP_LIVES = 5
    USER_SCORE = 0
end

function Space:init()
    self.spriteSheet  = love.graphics.newImage('graphics/' .. SPRITESHEET .. '.png')
    self.ship = Ship()
    self:insertEnemies()
end    

function Space:render()
    for x = 1, MAP_WIDTH do
        for y = 1, MAP_HEIGHT do
            love.graphics.draw(self.spriteSheet, (x - 1) * SPRITE_WIDTH, (y - 1) * SPRITE_HEIGHT)
        end
    end
    for key, enemy in pairs(self.enemies) do
        enemy:render()
        for key2, shot in pairs(enemy.shots) do
            enemy.shots[key2]:render() 
        end
    end
    self.ship:render()
    for key, shot in pairs(self.ship.shots) do
        self.ship.shots[key]:render() 
    end
end

function Space:behaviorEnemy(dt, enemy, offsetX)
    if self.ship.x - enemy.x > 0 then
        enemy.speedX = ENEMY_SPEED - offsetX
        enemy.state = 'walking'
        enemy.animation = enemy.animations['walking']
    elseif self.ship.x - enemy.x < 0 then 
        enemy.speedX = -ENEMY_SPEED + offsetX
        enemy.state = 'walking'
        enemy.animation = enemy.animations['walking']
    else
        enemy.speedX = 0
        enemy.state = 'idle'
        enemy.animation = enemy.animations['idle']
    end
end

function Space:update(dt)
    if SHIP_LIVES > 0 then
        if #self.enemies == 0 then
            self:insertEnemies()
        end
        for key2, enemy in pairs(self.enemies) do
            offsetX = ENEMY_WIDTH
            self:behaviorEnemy(dt, enemy, offsetX)
            enemy:update(dt)
        end
        for key2, enemy in pairs(self.enemies) do
            for key, shot in pairs(enemy.shots) do
                if enemy.shots[key].state == 'idle' and enemy.shots[key]:detectCollision(self.ship) then
                    enemy.shots[key].state = 'collision'
                    enemy.shots[key].animation = enemy.shots[key].animations['collision']
                    sounds['ship_hit']:play()
                    SHIP_LIVES = SHIP_LIVES - 1
                end
            end
            for key3, shot in pairs(self.ship.shots) do
                if self.ship.shots[key3].state == 'idle' and self.ship.shots[key3]:detectCollision(enemy) then
                    self.ship.shots[key3].state = 'collision'
                    self.ship.shots[key3].animation = self.ship.shots[key3].animations['collision']
                    USER_SCORE = USER_SCORE + 20
                    sounds['enemy_hit']:play()
                    table.remove(self.enemies, key2)
                end
            end
        end
        self.ship:update(dt)
    end
end