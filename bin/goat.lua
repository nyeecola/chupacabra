function newGoat(x, y, img, scale, explosive)
    goat = {}
    goat.x = x
    goat.y = y
    goat.v = 200
    goat.img = img
    goat.scale = scale
    goat.explosive = explosive
    return goat
end

local createGoatTimer = -1
function updateGoats(goats, floor, dt)
    --Gera cabras em tempo aleatorio
    createGoatTimer = createGoatTimer - (1 * dt)
    if createGoatTimer < 0 then
        if(math.random(1, 8) == 5) then
            table.insert(goats, newGoat(800, FLOOR, love.graphics.newImage("assets/explosiveGoat.png"), 0.5, true))
        else
            table.insert(goats, newGoat(800, FLOOR, love.graphics.newImage("assets/goat.png"), 0.5, false))
        end
        createGoatTimer = math.random(4, 8)
    end

    for i = 1, #goats do
        goats[i].x = goats[i].x - 60 * dt
        goats[i].y = goats[i].y - goats[i].v * dt
        if goats[i].y + goats[i].img:getHeight() * goats[i].scale >= floor then
            goats[i].y = floor - goats[i].img:getHeight() * goats[i].scale
            goats[i].v = math.random(260, 350)
        end
        goats[i].v = goats[i].v - 190*dt
    end
end

function drawGoats(goats)
    love.graphics.setColor(255, 255, 255)
    for i = 1, #goats do
        love.graphics.draw(goats[i].img, goats[i].x, goats[i].y, 0, goats[i].scale, goats[i].scale)
    end
end

function newExplosion(x, y)
    exp = {}
    exp.x = x
    exp.y = y
    exp.frame = 1
    exp.imgs = {love.graphics.newImage("assets/explosion/explosion1.png"),
                love.graphics.newImage("assets/explosion/explosion2.png"),
                love.graphics.newImage("assets/explosion/explosion3.png")}
    exp.timer = 0
    table.insert(explosions, exp)
end

function drawExplosions(explosions)
    for i = #explosions, 1, -1 do
        if explosions[i].frame == 4 then
            table.remove(explosions, i)
        else
            love.graphics.draw(explosions[i].imgs[explosions[i].frame], explosions[i].x, explosions[i].y)
        end
    end
end

function collisionDetectionGoat(cc, goats)
    for i = #goats, 1, -1 do
        if cc.x < goats[i].x + goats[i].img:getWidth()*goats[i].scale and
           goats[i].x < cc.x + cc.img[frame]:getWidth()*cc.scale and
           cc.y < goats[i].y + goats[i].img:getHeight()*goats[i].scale and
           goats[i].y < cc.y + cc.img[frame]:getHeight()*cc.scale then
               if goats[i].explosive then
                   cc.stamina = cc.stamina -50
               else
                   cc.stamina = cc.stamina +40
               end
               if goats[i].explosive then
                   newExplosion(goats[i].x, goats[i].y)
                   --love.audio.play(explosionSound)
               end
               table.remove(goats, i)
               love.audio.play(goatSound)
        end
   end
end
