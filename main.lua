intro = require 'intro.intro'
gamestate = require "bin.gamestate"
background = require("background")
require "bin.chupacabra"
require 'bin.obstacles'
require 'bin.move'
require "bin.people"
require "bin.goat"
require "bin.stamina"

FLOOR = 500

local menu = {}
game = {}
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

    staminaBar = {}
    defineBar(staminaBar)

    cc = {}
    defineCC(cc, FLOOR)

    people = {}
    definePeople(people)

	background.enter_bg()
    
    jumpSound = love.audio.newSource("assets/pulo.ogg", "static")
    goatSound = love.audio.newSource("assets/cabra-morrendo.ogg", "static")
    gameOverSound = love.audio.newSource("assets/game-over.ogg", "static")
    collisionSound = love.audio.newSource("assets/colisao.ogg", "static")
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
        love.audio.play(gameOverSound)
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

    -- animacao de obstaculos
    animateObstacles(dt)

    --Desenha no canvas
    love.graphics.setCanvas(canvas)
    drawCC(cc)
    drawPeople(people)
    drawGoats(goats)
    drawBar(staminaBar, cc)
    love.graphics.setCanvas()
end

function game:draw()
	background.draw_bg()

    love.graphics.setColor(255, 255, 255)
    drawObstacles(obstacles)
    love.graphics.setColor(255, 255, 255)

    --Desenha o canvas
    love.graphics.draw(canvas)
    canvas:clear()
    --FPS
    love.graphics.print(love.timer.getFPS(), 0, 0)
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
    local font = love.graphics.newFont("assets/font.ttf", 20)
    love.graphics.setFont(font)
    math.randomseed(os.clock())
    gamestate.registerEvents()
    gamestate.switch(intro)
    --gamestate.switch(game)
end
