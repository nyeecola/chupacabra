local intro = {}
local time = 0
local imagens = {}
local ii= 1
local num = 415

function intro:update(dt)
    time = time + dt
    if time >= 0.04
        then
            ii= ii+ 1
            time = 0
        end
    if ii>= num
        then
            gamestate.switch(menu)
        end
    if ii== 54
        then
            love.audio.play(sound_rcg)
        end
    if ii== 237
        then
            love.audio.play(sound_bg)
        end
    if love.keyboard.isDown("return")  or love.keyboard.isDown(" ")
        then
            love.audio.stop(sound_rcg)
            love.audio.stop(sound_bg)
            gamestate.switch(menu)
        end
end

function intro:enter()
    sound_rcg = love.audio.newSource("intro/rcg.ogg", "static")
    sound_bg = love.audio.newSource("intro/bg.ogg", "static")

    for i=1,num,1
    do
        table.insert(imagens, #imagens+1,
                     love.graphics.newImage("intro/intro_png/intro_" .. i.. ".png"))
    end
end

function intro:draw()
    love.graphics.draw(imagens[ii], 16, 12)
end

return intro
