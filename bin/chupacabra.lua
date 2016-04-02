function defineCC(cc, floor)
    cc.x = love.graphics.getWidth()/2
    cc.y = floor
    cc.v = 0
    cc.stamina = 0
    cc.cooldown = 0
    cc.scale = 0.15
    cc.img = love.graphics.newImage("assets/chupacabra.png")
end

function updateCC(cc, floor, dt)
    cc.x = cc.x + cc.stamina * dt
    cc.y = cc.y - cc.v * dt
    if cc.y + cc.img:getHeight() * cc.scale >= floor then
        cc.y = floor - cc.img:getHeight() * cc.scale
        cc.v = 0
    end
    cc.v = cc.v - 190*dt

    if cc.cooldown > 0 then
        cc.cooldown = cc.cooldown - dt
    else
        cc.cooldown = 0
    end
end

function drawCC(cc)
    love.graphics.setColor(255, 255, 255)
    if cc.cooldown > 0 then
        if cc.cooldown > 1.5 then
            love.graphics.draw(cc.img, cc.x, cc.y, 0, cc.scale, cc.scale)
        elseif cc.cooldown > 1 then

        elseif cc.cooldown > 0.5 then
            love.graphics.draw(cc.img, cc.x, cc.y, 0, cc.scale, cc.scale)
        end
    else
        love.graphics.draw(cc.img, cc.x, cc.y, 0, cc.scale, cc.scale)
    end
end

function keysCC(k, cc)
    if k == "up" and cc.y + cc.img:getHeight() * cc.scale >= FLOOR then
        cc.v = 200
    end
end

function collisionDetectionCC(cc, obstacles)
    if cc.cooldown <= 0 then
        for i = 1, #obstacles do
            if cc.x + cc.img:getWidth()*cc.scale > obstacles[i].x and cc.x + cc.img:getWidth()*cc.scale < obstacles[i].x + obstacles[i].width then
                if (obstacles[i].y <= cc.y and cc.y <= obstacles[i].y + obstacles[i].height) or (obstacles[i].y <= cc.y + cc.img:getHeight()*cc.scale and cc.y + cc.img:getHeight()*cc.scale <= obstacles[i].y + obstacles[i].height) or (cc.y <= obstacles[i].y and obstacles[i].y <= cc.y + cc.img:getHeight()*cc.scale) or (cc.y <= obstacles[i].y + obstacles[i].height and obstacles[i].y + obstacles[i].height <= cc.y + cc.img:getHeight()*cc.scale)then
                    cc.stamina = cc.stamina -40
                    cc.cooldown = 2
                end
            end
       end
   end
end
