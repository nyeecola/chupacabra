gamestate = require "bin.gamestate"
require "bin.chupacabra"
require 'bin.obstacles'
require 'bin.move'
require "bin.people"
require "bin.goat"

FLOOR = 500

background = require("background")

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
    goats = {}

    cc = {}
    defineCC(cc, FLOOR)

    people = {}
    definePeople(people)

	background.enter_bg()
    
    jumpSound = love.audio.newSource("assets/pulo.ogg", "static")
    goatSound = love.audio.newSource("assets/cabra-morrendo.ogg", "static")
    deathSound = love.audio.newSource("assets/chupacabra-morrendo.ogg", "static")
    mobSound = love.audio.newSource("assets/multidao.ogg", "static")
end

function game:update(dt)
	background.update_bg(dt)

    --Atualiza o ChupaCabra
    updateCC(cc, FLOOR, dt)
    updateGoats(goats, FLOOR, dt)
    
    --Colisao com obstaculos
    collisionDetectionCC(cc, obstacles)

    --Colisao com pessoas
    if cc.x < 10 then
        gamestate.switch(gameover)
        love.audio.play(mobSound)
        love.audio.play(deathSound)
        return
    end

    --Colisao com cabra
    collisionDetectionGoat(cc, goats)

    --Colisao com wall
    if cc.x > 650 and cc.stamina > 0 then
        cc.stamina = 0
    end

    --Movimento do mundo
    move(dt, obstacles)

    -- geracao de obstaculos novos
    generateObstacle(obstacles, dt)

    --Desenha no canvas
    love.graphics.setCanvas(canvas)
    drawCC(cc)
    drawPeople(people)
    drawGoats(goats)
    love.graphics.setCanvas()
end

function game:draw()
	background.draw_bg()

    --Desenha o canvas
    love.graphics.draw(canvas)
    canvas:clear()
    --FPS
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
