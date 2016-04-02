function newGoat(x, y, img, scale)
    goat = {}
    goat.x = x
    goat.y = y
    goat.v = 200
    goat.img = img
    goat.scale = scale
    return goat
end

function updateGoats(goats, floor, dt)
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
        if cc.x + cc.img:getWidth()*cc.scale > goats[i].x and cc.x + cc.img:getWidth()*cc.scale < goats[i].x + goats[i].img:getWidth()*goats[i].scale then
            if (goats[i].y <= cc.y and cc.y <= goats[i].y + goats[i].img:getHeight()*goats[i].scale) or (goats[i].y <= cc.y + cc.img:getHeight()*cc.scale and cc.y + cc.img:getHeight()*cc.scale <= goats[i].y + goats[i].img:getHeight()*goats[i].scale) or (cc.y <= goats[i].y and goats[i].y <= cc.y + cc.img:getHeight()*cc.scale) or (cc.y <= goats[i].y + goats[i].img:getHeight()*goats[i].scale and goats[i].y + goats[i].img:getHeight()*goats[i].scale <= cc.y + cc.img:getHeight()*cc.scale)then
                cc.stamina = cc.stamina +40
                table.remove(goats, i)
            end
        end
   end
end
