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
        if(math.random(1, 20) == 10) then
            table.insert(goats, newGoat(800, FLOOR, love.graphics.newImage("assets/explosiveGoat.png"), 1, true))
        else
            table.insert(goats, newGoat(800, FLOOR, love.graphics.newImage("assets/goat.png"), 1, false))
        end
        createGoatTimer = math.random(2, 6)
    end

    for i = 1, #goats do
        goats[i].x = goats[i].x - 60 * dt
        goats[i].y = goats[i].y - goats[i].v * dt
        if goats[i].y + goats[i].img:getHeight() * goats[i].scale >= floor then
            goats[i].y = floor - goats[i].img:getHeight() * goats[i].scale
            goats[i].v = 200
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

function collisionDetectionGoat(cc, goats)
    for i = #goats, 1, -1 do
        if cc.x < goats[i].x + goats[i].img:getWidth()*goats[i].scale and
           goats[i].x < cc.x + cc.img[frame]:getWidth()*cc.scale and
           cc.y < goats[i].y + goats[i].img:getHeight()*goats[i].scale and
           goats[i].y < cc.y + cc.img[frame]:getHeight()*cc.scale then
               if goats[i].explosive then
                   cc.stamina = cc.stamina -40
               else
                   cc.stamina = cc.stamina +40
               end
               table.remove(goats, i)
               love.audio.play(goatSound)
        end
   end
end
