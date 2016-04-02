gamestate = require "bin.gamestate"
require "bin.chupacabra"
require 'bin.obstacles'
require 'bin.move'
require "bin.people"

FLOOR = 500

local menu = {}
local game = {}
local pause = {}
local gameover = {}
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

    people = {}
    definePeople(people)
end

function game:update(dt)
    --Atualiza o ChupaCabra
    updateCC(cc, FLOOR, dt)

    --Colisao
    collisionDetectionCC(cc, obstacles)

    --Colisao com pessoas
    if cc.x < 10 then
        gamestate.switch(gameover)
        return
    end

    --Movimento do mundo
    move(dt, obstacles)

    -- geracao de obstaculos novos
    generateObstacle(obstacles, dt, 800, math.random(200, FLOOR))

    --Desenha no canvas
    love.graphics.setCanvas(canvas)
    drawCC(cc)
    drawPeople(people)
    love.graphics.setCanvas()
end

function game:draw()
    love.graphics.draw(canvas)
    canvas:clear()
    love.graphics.print(love.timer.getFPS(), 0, 0)
    drawObstacles(obstacles)
end

function game:keypressed(k)
    keysCC(k, cc)
end

function game:leave()
    cc = nil
    obstacles = nil
end

function gameover:enter()

end

function gameover:draw()
    love.graphics.print("uau")
end

function love.load()
    math.randomseed(os.clock())
    gamestate.registerEvents()
    gamestate.switch(game)
end
