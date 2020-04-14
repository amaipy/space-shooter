WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

math.randomseed(os.time())
love.graphics.setDefaultFilter("nearest", "nearest")

Class = require 'class'
push = require 'push'

require 'Animation'
require 'GameObj'
require 'Shot'
require 'Ship'
require 'Enemy'
require 'Space'

space = Space()

USER_SCORE = 0
SHIP_LIVES = 5 
HIGHEST_SCORE = 0

function love.load()
    love.window.setTitle('Spacecrest')
    love.window.setIcon(love.image.newImageData('/graphics/icon.png') )
    smallFont = love.graphics.newFont('/fonts/m5x7.ttf', 16)
    mediumFont = love.graphics.newFont('/fonts/m5x7.ttf', 32)
    sounds = {
        ['enemy_hit'] = love.audio.newSource('/sounds/enemy_hit.wav', 'static'),
        ['ship_hit'] = love.audio.newSource('/sounds/ship_hit.wav', 'static'),
        ['laser'] = love.audio.newSource('/sounds/laser.wav', 'static'),
        ['main_theme'] = love.audio.newSource('/sounds/main_theme.wav', 'static')
    }
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })
    sounds['main_theme']:setVolume(0.1)
    sounds['main_theme']:setLooping(true)
    sounds['main_theme']:play()
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

function love.keyboard.wasPressed(key)
    if (love.keyboard.keysPressed[key]) then
        return true
    else
        return false
    end
end

function love.keyboard.wasReleased(key)
    if (love.keyboard.keysReleased[key]) then
        return true
    else
        return false
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
    if key == 'r' and SHIP_LIVES == 0 then
        space:reset()
    end
    love.keyboard.keysPressed[key] = true
end

function love.keyreleased(key)
    love.keyboard.keysReleased[key] = true
end

function love.draw()
    push:apply('start')
    love.graphics.setDefaultFilter("nearest", "nearest")
    space:render()
    if SHIP_LIVES <= 0 then
        love.graphics.setFont(mediumFont)
        love.graphics.printf("Game Over! Press R to restart", 0, 50, VIRTUAL_WIDTH, 'center')    
    else
        love.graphics.setFont(smallFont)
        love.graphics.printf("Score: " .. USER_SCORE .. "  High Score: " .. HIGHEST_SCORE .. "  Lives: " .. SHIP_LIVES , 0, 50, VIRTUAL_WIDTH, 'center')
    end
    push:apply('end')

end
