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
end

function game:update(dt)
    --Atualiza o ChupaCabra
    updateCC(cc, FLOOR, dt)

    --Colisao
    collisionDetectionCC(cc, obstacles)

    --Movimento do mundo
    move(dt, obstacles)

    -- geracao de obstaculos novos
    generateObstacle(obstacles, dt, 800, math.random(200, FLOOR))

    --Desenha no canvas
    love.graphics.setCanvas(canvas)
    drawCC(cc)
    love.graphics.setCanvas()
end

function game:draw()
    love.graphics.draw(canvas)
    canvas:clear()
    love.graphics.print(cc.cooldown, 0, 0)
    drawObstacles(obstacles)
end

function game:keypressed(k)
    keysCC(k, cc)
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
