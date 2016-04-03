intro = require 'intro.intro'
gamestate = require "bin.gamestate"
background = require "background"
require "bin.chupacabra"
require 'bin.obstacles'
require 'bin.move'
require "bin.people"
require "bin.goat"
require "bin.whey"
require "bin.stamina"
require "bin.mouseOver"
require "bin.menuMousePress"
require "bin.infoMousePress"

FLOOR = 500
BACKGROUND_SPD = 90
OBJECTS_SPD = 220
FOREGROUND_SPD = 300

local spd_timer = 0
menu = {}
game = {}
info = {}
bambam = false
local bambam_dt = 0
local pause = {}
local gameover = {}
local canvas = love.graphics.newCanvas()

function info:enter()

    -- Global Variable
    info_names_y  = -600
    info_music_t  = 0
    info_sound    = true
    info_music    = true
    info_select   = 0
    info_hi       = 0
    helio         = 0

    -- Images
    info_returnButton    = love.graphics.newImage("assets/menu_quitButton.png")
    info_selectedButton1 = love.graphics.newImage("assets/menu_selectedButton1.png")
    info_selectedButton2 = love.graphics.newImage("assets/menu_selectedButton2.png")
    info_background      = love.graphics.newImage("assets/info_background.png")
    info_hi1             = love.graphics.newImage("assets/hi1.png")
    info_hi2             = love.graphics.newImage("assets/hi2.png")
    info_hi3             = love.graphics.newImage("assets/hi3.png")

    -- Sounds
    info_backgroundMusic  = love.audio.newSource("assets/teste.ogg","stream")

    love.audio.play(info_backgroundMusic)

    info_font = love.graphics.newFont("assets/fipps.ttf", 20)
    love.graphics.setFont(info_font)

    love.mousepressed = infoMousePressed

end

function info:draw()

    --Static

    love.graphics.draw(info_background,0,0)
    love.graphics.draw(info_returnButton, 500, 480)

    local x,y = love.mouse.getPosition()

    --Selected
    if optionMouseOver(x, y, 500,500+212,480,480+89) then
        if info_select < 0.8 then
            love.graphics.draw(info_selectedButton1, 340, 460)
        else
            love.graphics.draw(info_selectedButton2, 340, 460)
        end
    end

    --Info
    if info_hi < 0.5 then
        love.graphics.draw(info_hi1,50,325)
    elseif info_hi > 0.5 and info_hi < 1 then
        love.graphics.draw(info_hi2,50,325)
    elseif info_hi > 1 then
        love.graphics.draw(info_hi3,50,325)
    end

    if info_names_y < 120 then
        love.graphics.print("André Almeida",   500, info_names_y + 0)
        love.graphics.print("Italo Nicola",    500, info_names_y + 30)
        love.graphics.print("Lucas Augustini", 500, info_names_y + 60)
        love.graphics.print("Clarice Dellape", 500, info_names_y + 90)
        love.graphics.print("Miguel Augusto",  500, info_names_y + 120)
        love.graphics.print("Victor Luccas",   500, info_names_y + 150)
        love.graphics.print("Igor Torrente",   500, info_names_y + 180)
        love.graphics.print("Leonardo Ramos",  500, info_names_y + 210)
        love.graphics.print("Daniela Morais",  500, info_names_y + 240)
        love.graphics.print("João Spuri",      500, info_names_y + 270)
        love.graphics.print("Lucas Secomandi", 500, info_names_y + 300)
    else
        love.graphics.print("André Almeida",   500, 120)
        love.graphics.print("Italo Nicola",    500, 150)
        love.graphics.print("Lucas Augustini", 500, 180)
        love.graphics.print("Clarice Dellape", 500, 210)
        love.graphics.print("Miguel Augusto",  500, 240)
        love.graphics.print("Victor Luccas",   500, 270)
        love.graphics.print("Igor Torrente",   500, 300)
        love.graphics.print("Leonardo Ramos",  500, 330)
        love.graphics.print("Daniela Morais",  500, 360)
        love.graphics.print("João Spuri",      500, 390)
        love.graphics.print("Lucas Secomandi", 500, 420)
    end
end

function info:update(dt)

    info_names_y   = info_names_y + dt*100
    info_music_t   = info_music_t + dt
    info_select    = info_select  + dt
    info_hi        = info_hi      + dt

    if info_hi > 1.5 then
        info_hi = 0
    end

    if info_select > 1.6 then
        info_select = 0
    end

    if info_music then
        if info_music_t > 69 then
            love.audio.rewind(info_backgroundMusic)
            love.audio.play(info_backgroundMusic)
            info_music_t = 0
        end
    else
        love.audio.pause(info_backgroundMusic)
        info_music_t = 70
    end
end

function info:leave()

    info_names_y  = nil
    info_music_t  = nil
    info_sound    = nil
    info_music    = nil

    info_returnButton    = nil
    info_selectedButton1 = nil
    info_selectedButton2 = nil
    info_background      = nil
    info_hi1             = nil
    info_hi2             = nil
    info_hi3             = nil

    love.audio.stop(info_backgroundMusic)
    info_backgroundMusic = nil

    info_font = nil

end

function menu:enter()

    -- Global Variable
    menu_sound      = true
    menu_music      = true
    menu_music_time = 0
    menu_select     = 0

    -- Images
    background.enter_bg()
    menu_title           = love.graphics.newImage("assets/menu_title.png")
    menu_startButton     = love.graphics.newImage("assets/menu_startButton.png")
    menu_infoButton      = love.graphics.newImage("assets/menu_infoButton.png")
    menu_quitButton      = love.graphics.newImage("assets/menu_quitButton.png")
    menu_musicButtonOn   = love.graphics.newImage("assets/menu_musicButtonOn.png")
    menu_musicButtonOff  = love.graphics.newImage("assets/menu_musicButtonOff.png")
    menu_soundButtonOn   = love.graphics.newImage("assets/menu_soundButtonOn.png")
    menu_soundButtonOff  = love.graphics.newImage("assets/menu_soundButtonOff.png")
    menu_selectedButton1 = love.graphics.newImage("assets/menu_selectedButton1.png")
    menu_selectedButton2 = love.graphics.newImage("assets/menu_selectedButton2.png")

   -- Sounds
    menu_backgroundMusic  = love.audio.newSource("assets/musica-menu-inicial.ogg","stream")
    menu_buttonPressSound = love.audio.newSource("assets/teste.ogg","static")
    menu_easterEggSound   = love.audio.newSource("assets/teste.ogg","static")

    love.audio.play(menu_backgroundMusic)

    love.mousepressed = menuMousePressed
end

function menu:draw()

    -- Static
    background.draw_bg()
    background.draw_fg()
    love.graphics.draw(menu_title, 250, 15, 0, 0.65, 0.65)
    love.graphics.draw(menu_startButton, 294, 190)
    love.graphics.draw(menu_infoButton, 294, 279)
    love.graphics.draw(menu_quitButton, 294, 368)

    -- Variable
    if menu_sound then
        love.graphics.draw(menu_soundButtonOn,668,528)
    else
        love.graphics.draw(menu_soundButtonOff,668,528)
    end

    if menu_music then
        love.graphics.draw(menu_musicButtonOn,730,528)
    else
        love.graphics.draw(menu_musicButtonOff,730,528)
    end

    local x,y = love.mouse.getPosition()

    -- Selected
        -- Start
    if optionMouseOver(x,y,294,294+212,190,190+89) then
        if menu_select < 0.8 then
            love.graphics.draw(menu_selectedButton1,110,190)
        else
            love.graphics.draw(menu_selectedButton2,110,190)
        -- Info
        end
    elseif optionMouseOver(x,y,294,294+212,279,279+89) then
        if menu_select < 0.8 then
            love.graphics.draw(menu_selectedButton1,110,279)
        else
            love.graphics.draw(menu_selectedButton2,110,279)
        end
        -- Quit
    elseif optionMouseOver(x,y,294,294+212,368,368+89) then
        if menu_select < 0.8 then
            love.graphics.draw(menu_selectedButton1,110,368)
        else
            love.graphics.draw(menu_selectedButton2,110,368)
        end
    end
end

function menu:update(dt)
    background.update_bg(dt)

    menu_music_time = menu_music_time + dt
    menu_select     = menu_select     + dt

    if menu_select > 1.6 then
        menu_select = 0
    end

    if menu_music then
        if menu_music_time > 69 then
            love.audio.rewind(menu_backgroundMusic)
            love.audio.play(menu_backgroundMusic)
            menu_music_time = 0
        end
    else
        love.audio.pause(menu_backgroundMusic)
        menu_music_time = 70
    end
end

function menu:leave()

    menu_sound      = nil
    menu_music      = nil
    menu_music_time = nil

    menu_title           = nil
    menu_startButton     = nil
    menu_infoButton      = nil
    menu_quitButton      = nil
    menu_musicButtonOn   = nil
    menu_musicButtonOff  = nil
    menu_soundButtonOn   = nil
    menu_soundButtonOff  = nil
    menu_selectedButton1 = nil
    menu_selectedButton2 = nil

    love.audio.stop(menu_backgroundMusic)
    menu_backgroundMusic  = nil
    menu_buttonPressSound = nil
    menu_easterEggSound   = nil

end

function game:enter()
    font = love.graphics.newFont("assets/font.ttf", 20)
    love.graphics.setFont(font)

    score = 0

    obstacles = {}
    goats = {}
    wheys = {}
    explosions = {}

    staminaBar = {}
    defineBar(staminaBar)

    cc = {}
    defineCC(cc, FLOOR)

    people = {}
    definePeople(people)

	background.enter_bg()

    --Images
    helio_pedrini        = love.graphics.newImage("assets/helio.png")

    --Sounds
    jumpSound = love.audio.newSource("assets/pulo.ogg", "static")
    goatSound = love.audio.newSource("assets/cabra-morrendo.ogg", "static")
    backgroundSound = love.audio.newSource("assets/musica-jogo.ogg", "stream")

    --explosionSound = love.audio.newSource("assets/explosion.ogg", "static")
    wheySound = {}
    wheySound[1] = love.audio.newSource("assets/hora-do-show.ogg", "static")
    wheySound[2] = love.audio.newSource("assets/bodybuilder-porra.ogg", "static")
    wheySound[3] = love.audio.newSource("assets/trapezio-descendente.ogg", "static")
    gameOverSound = love.audio.newSource("assets/game-over.ogg", "static")
    collisionSound = love.audio.newSource("assets/colisao.ogg", "static")
    helio_toasty          = love.audio.newSource("assets/TOASTY!.ogg")

    love.audio.play(backgroundSound)
end

function game:update(dt)

    -- dirt hack
    spd_timer = spd_timer + dt
    if cc.stamina < 5 and spd_timer > 0.3 then
        cc.stamina = cc.stamina + 7
        spd_timer = 0
    end

    --Att explosoes
    for i = 1, #explosions do
        explosions[i].timer = explosions[i].timer + dt
        if explosions[i].timer > 0.1 then
            explosions[i].frame = explosions[i].frame +1
            explosions[i].timer = 0
        end
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
    drawExplosions(explosions)
    love.graphics.setCanvas()

    if bambam == true and bambam_dt < 2.5 then
        bambam_dt = bambam_dt + dt
    elseif bambam == true and bambam_dt >= 2.5 then
        bambam = false
        unkeysCC('down', cc)
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
    --love.graphics.print(love.timer.getFPS(), 0, 0)

    --Score
    love.graphics.print("Score: " .. string.format("%.0f", score), 600, 20)
    helio = tonumber(string.format("%.0f", score))

    --helio pedrine
    if helio == 102 or helio == 358 then
        love.audio.play(helio_toasty);
        love.graphics.draw(helio_pedrini,650,450);
    end
    -- draw foreground
    background.draw_fg()
end

function game:keypressed(k)
    keysCC(k, cc)
    if k == "return" then
        gamestate.push(pause)
    end
end

function game:focus(f)
    if not f then
        gamestate.push(pause)
    end
end

function game:keyreleased(k)
    unkeysCC(k, cc)
end

function game:leave()
    love.audio.stop(backgroundSound)
    cc = nil
    obstacles = nil
end

function pause:draw()
    love.graphics.print("PAUSE", 360, love.graphics.getHeight()/2)
end

function pause:keypressed(key, code)
    if key == "return" then
        gamestate.pop()
    end
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
    love.graphics.print("Press Return to Restart", 250, 540)
    love.graphics.print("Press 'M' to Menu", 250, 560)
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
    if k == "m" then
        gamestate.switch(menu)
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

function love.keypressed(k)
    if k == "escape" then
        love.event.push("quit")
    end
end
