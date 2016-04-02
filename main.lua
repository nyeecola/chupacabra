gamestate = require "bin.gamestate"
require "bin.chupacabra"
require 'bin.obstacles'
require 'bin.move'

FLOOR = 400

local menu = {}
local game = {}
local pause = {}
local canvas = love.graphics.newCanvas()

function menu:enter()

end

function menu:draw()

end

function menu:leave()

end

function game:enter()
    obstacles = {}

    cc = {}
    defineCC(cc, FLOOR)

    for i = 1, 3 do
        obstacles[i] = generateObstacle(math.random(600), math.random(200, 500))
        print(obstacles[i].x, obstacles[i].y)
    end
end

function game:update(dt)
    --Movimento do ChupaCabra
    moveCC(cc, FLOOR, dt)

    -- movimento do mundo
    move(dt, obstacles)

    --Desenha no canvas
    love.graphics.setCanvas(canvas)
    drawCC(cc)
    love.graphics.setCanvas()
end

function game:draw()
    love.graphics.draw(canvas)
    canvas:clear()
    love.graphics.print(love.timer.getFPS(), 0, 0)
    drawObstacles(obstacles)
end

function game:keypressed(k)
    keysCC(k)
end

function game:leave()
    cc = nil
    obstacles = nil
end

function love.load()
    math.randomseed(os.clock())
    gamestate.registerEvents()
    gamestate.switch(game)
end
