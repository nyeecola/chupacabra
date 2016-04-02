gamestate = require("gamestate")
require("chupacabra")

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
    --Movimento do ChupaCabra
    moveCC(cc, FLOOR, dt)

    --Desenha no canvas
    love.graphics.setCanvas(canvas)
    drawCC(cc)
    love.graphics.setCanvas()
end

function game:draw()
    love.graphics.draw(canvas)
    canvas:clear()
    love.graphics.print(love.timer.getFPS(), 0, 0)
end

function game:keypressed(k)
    keysCC(k)
end

function game:leave()
    cc = nil
end

function love.load()
    math.randomseed(os.clock())
    gamestate.registerEvents()
    gamestate.switch(game)
end
