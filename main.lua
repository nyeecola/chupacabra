intro = require 'intro.intro'
gamestate = require "bin.gamestate"
background = require("background")
require "bin.chupacabra"
require 'bin.obstacles'
require 'bin.move'
require "bin.people"
require "bin.goat"
require "bin.whey"
require "bin.stamina"

FLOOR = 500
BACKGROUND_SPD = 90
OBJECTS_SPD = 220
FOREGROUND_SPD = 300

local spd_timer = 0
local menu = {}
game = {}
bambam = false
local bambam_dt = 0
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
    score = 0

    obstacles = {}
    goats = {}
    wheys = {}

    staminaBar = {}
    defineBar(staminaBar)

    cc = {}
    defineCC(cc, FLOOR)

    people = {}
    definePeople(people)

	background.enter_bg()

    jumpSound = love.audio.newSource("assets/pulo.ogg", "static")
    goatSound = love.audio.newSource("assets/cabra-morrendo.ogg", "static")
    wheySound = {}
    wheySound[1] = love.audio.newSource("assets/hora-do-show.ogg", "static")
    wheySound[2] = love.audio.newSource("assets/bodybuilder-porra.ogg", "static")
    wheySound[3] = love.audio.newSource("assets/trapezio-descendente.ogg", "static")
    gameOverSound = love.audio.newSource("assets/game-over.ogg", "static")
    collisionSound = love.audio.newSource("assets/colisao.ogg", "static")

end

function game:update(dt)

    -- dirt hack
    spd_timer = spd_timer + dt
    if cc.stamina < 5 and spd_timer > 0.3 then
        cc.stamina = cc.stamina + 7
        spd_timer = 0
    end

    --Atualiza fundo
	background.update_bg(dt)

    --Atualiza o ChupaCabra
    updateCC(cc, FLOOR, dt)
    updateGoats(goats, FLOOR, dt)
    updateWheys(wheys, FLOOR-40, dt)

    --Atualiza pontuacao
    score = score + dt

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
    collisionDetectionWhey(cc, wheys)

    --Colisao com wall
    if cc.x > 550 and cc.stamina > 0 then
        OBJECTS_SPD = 270
        COOLDOWN_START = 0.8
        COOLDOWN_MAX = 2
        cc.stamina = 0
    end

    if cc.x < 450 then
        OBJECTS_SPD = 220
        COOLDOWN_START = 1.2
        COOLDOWN_MAX = 2.6
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
    drawWheys(wheys)
    drawPeople(people)
    drawGoats(goats)
    drawBar(staminaBar, cc)
    love.graphics.setCanvas()

    if bambam == true and bambam_dt < 2.5 then
        bambam_dt = bambam_dt + dt
    elseif bambam == true and bambam_dt >= 2.5 then
        bambam = false
        bambam_dt = 0
    end

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

    --Score
    love.graphics.print("Score: " .. string.format("%.0f", score), 600, 20)

    -- draw foreground
    background.draw_fg()
end

function game:keypressed(k)
    keysCC(k, cc)
end

function game:leave()
    cc = nil
    obstacles = nil
end

function gameover:enter()
    imgs = {cc = love.graphics.newImage("assets/cc/01.png"),
            people = love.graphics.newImage("assets/people.png"),
            campfire = {love.graphics.newImage("assets/fogueira1.png"),
                        love.graphics.newImage("assets/fogueira2.png"),
                        love.graphics.newImage("assets/fogueira3.png")}}
    timer = 0
    frame = 1
end

function gameover:update(dt)
    timer = timer + dt

    if timer > 0.2 then
        timer = 0
        if frame == 3 then
            frame = 1
        else
            frame = frame +1
        end
    end
end

function gameover:draw()
    font = love.graphics.newFont("assets/font.ttf", 80)
    love.graphics.setFont(font)
    love.graphics.print("GAME OVER", 160, 200)
    font = love.graphics.newFont("assets/font.ttf", 40)
    love.graphics.setFont(font)
    love.graphics.print("Score: " .. string.format("%.0f", score), 300, 300)
    font = love.graphics.newFont("assets/font.ttf", 20)
    love.graphics.setFont(font)
    love.graphics.print("Press Return to Restart", 250, 560)
    love.graphics.draw(imgs.cc, 470, 400, math.pi/2, 0.75, 0.75)
    love.graphics.draw(imgs.campfire[frame], 340, 370, 0, 0.6, 0.6)
    love.graphics.setColor(255, 255, 255, 140)
    love.graphics.draw(imgs.cc, 470, 400, math.pi/2, 0.75, 0.75)
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(imgs.people, 230, 380, 0, 0.5, 0.5)
end

function gameover:keypressed(k)
    if k == "return" then
        gamestate.switch(game)
    end
end

function love.load()
    font = love.graphics.newFont("assets/font.ttf", 20)
    love.graphics.setFont(font)
    math.randomseed(os.clock())
    gamestate.registerEvents()
    gamestate.switch(intro)
    --gamestate.switch(game)
end
