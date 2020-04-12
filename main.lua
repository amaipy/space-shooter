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
require 'Space'
require 'Ship'
require 'Enemy'

space = Space()
ship = Ship()

enemy = Enemy()

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
end

function love.resize(w, h)
    push:resize(w, h)
end


function love.update(dt)
    ship:update(dt)
    enemy:update(dt)
end


function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.draw()
    push:apply('start')

    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setFont(smallFont)
    love.graphics.printf("Welcome to Pong!", 0, 20, VIRTUAL_WIDTH, 'center')
    love.graphics.printf("Press Enter to Play", 0, 32, VIRTUAL_WIDTH, 'center')

    space:render()
    ship:render()

    enemy:render()
    push:apply('end')

end
