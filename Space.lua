Space = Class{__includes = GameObj}

local SPRITE_HEIGHT = 64
local SPRITE_WIDTH = 64
local MAP_WIDTH = 30
local MAP_HEIGHT = 30

function Space:insertEnemies()
    self.enemiesNum = math.floor(math.random(2, 6))
    self.enemies = {}
    for x = 1, self.enemiesNum do
        table.insert(self.enemies, Enemy(math.floor(math.random(ENEMY_WIDTH, VIRTUAL_WIDTH - ENEMY_WIDTH)), math.random(0, 1)))
    end
end

function Space:reset()
    self.ship.shots = {}
    SHIP_LIVES = 5
    USER_SCORE = 0
    self:insertEnemies()
end

function Space:init()
    GameObj.init(self, 'background', SPRITE_WIDTH, SPRITE_HEIGHT, MAP_WIDTH, MAP_HEIGHT)
    self.ship = Ship()
    self:insertEnemies()
end    

function Space:render()
    for x = 1, self.totalWidth do
        for y = 1, self.totalHeight do
            love.graphics.draw(self.spriteSheet, (x - 1) * self.spriteWidth, (y - 1) * self.spriteHeight)
        end
    end
    for key, enemy in pairs(self.enemies) do
        enemy:render()
        for key2, shot2 in pairs(enemy.shots) do
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
    elseif self.ship.y - enemy.x < 0 then 
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
        for key, shot in pairs(self.ship.shots) do
            for key2, enemy in pairs(self.enemies) do
                if self.ship.shots[key].state == 'idle' and self.ship.shots[key]:detectCollision(enemy) then
                    self.ship.shots[key].state = 'collision'
                    self.ship.shots[key].animation = self.ship.shots[key].animations['collision']
                    USER_SCORE = USER_SCORE + 20
                    table.remove(self.enemies, key2)
                end
            end
        end
        for key2, enemy in pairs(self.enemies) do
            for key, shot in pairs(enemy.shots) do
                if enemy.shots[key].state == 'idle' and enemy.shots[key]:detectCollision(self.ship) then
                    enemy.shots[key].state = 'collision'
                    enemy.shots[key].animation = enemy.shots[key].animations['collision']
                    SHIP_LIVES = SHIP_LIVES - 1
                end
            end
        end
        self.ship:update(dt)
    end
end