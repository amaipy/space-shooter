WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGTH = 243

math.randomseed(os.time())
love.graphics.setDefaultFilter("nearest", "nearest")

Class = require 'class'
push = require 'push'

require 'Animation'
require 'GameObj'
require 'AnimatedGameObj'
require 'Shot'
require 'Ship'
require 'Enemy'
require 'Space'


space = Space()

USER_SCORE = 0

function love.load()
    

    love.window.setTitle('space-shooter')

    smallFont = love.graphics.newFont('/fonts/m5x7.ttf', 16)
    mediumFont = love.graphics.newFont('/fonts/m5x7.ttf', 32)
    largeFont = love.graphics.newFont('/fonts/m5x7.ttf', 48)

    sounds = {
        ['paddle_hit'] = love.audio.newSource('/sounds/paddle_hit.wav', 'static'),
        ['point_scored'] = love.audio.newSource('/sounds/point_scored.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('/sounds/wall_hit.wav', 'static')
    }

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGTH, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    love.keyboard.keysPressed = {}
    love.keyboard.keysReleased = {}
end

function love.resize(w, h)
    push:resize(w, h)
end


function love.update(dt)
    space:update(dt)
    love.keyboard.keysPressed = {}
    love.keyboard.keysReleased = {}
end

-- global key pressed function
function love.keyboard.wasPressed(key)
    if (love.keyboard.keysPressed[key]) then
        return true
    else
        return false
    end
end

-- global key released function
function love.keyboard.wasReleased(key)
    if (love.keyboard.keysReleased[key]) then
        return true
    else
        return false
    end
end

-- called whenever a key is pressed
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
    if key == 'r' and space.shipLives == 0 then
        space.shipLives = 5
        USER_SCORE = 0
        space:insertEnemies()
        space.ship.shots = {}
    end

    love.keyboard.keysPressed[key] = true
end

-- called whenever a key is released
function love.keyreleased(key)
    love.keyboard.keysReleased[key] = true
end


function love.draw()
    push:apply('start')
    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)
    love.graphics.setDefaultFilter("nearest", "nearest")
    space:render()
    if space.shipLives <= 0 then
        love.graphics.setFont(mediumFont)
        love.graphics.printf("Game Over! Press R to restart", 0, 50, VIRTUAL_WIDTH, 'center')    
    else
        love.graphics.setFont(smallFont)
        love.graphics.printf("Score: " .. USER_SCORE .. " Lives: " .. space.shipLives , 0, 50, VIRTUAL_WIDTH, 'center')
    end
    push:apply('end')

end
