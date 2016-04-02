function newWhey(x, y, img, scale)
    whey = {}
    whey.x = x
    whey.y = y
    whey.img = img
    whey.scale = scale
    return whey
end

local createWheyTimer = 12
function updateWheys(wheys, floor, dt)
    --gera cabras em tempo aleatorio
    createWheyTimer = createWheyTimer - (1 * dt)
    if createWheyTimer < 0 then
        table.insert(wheys, newWhey(800, floor, love.graphics.newImage("assets/whey.png"), 1))
        createWheyTimer = math.random(4, 12)
    end

    for i = 1, #wheys do
        wheys[i].x = wheys[i].x - 60 * dt
    end
end

function drawWheys(wheys)
    love.graphics.setColor(255, 255, 255)
    for i = 1, #wheys do
        love.graphics.draw(wheys[i].img, wheys[i].x, wheys[i].y, 0, wheys[i].scale, wheys[i].scale)
    end
end

function collisionDetectionWhey(cc, wheys)
    for i = #wheys, 1, -1 do
        if cc.x + cc.img[frame]:getWidth()*cc.scale > wheys[i].x and cc.x + cc.img[frame]:getWidth()*cc.scale < wheys[i].x + wheys[i].img:getWidth()*wheys[i].scale then
            if (wheys[i].y <= cc.y and cc.y <= wheys[i].y + wheys[i].img:getHeight()*wheys[i].scale) or (wheys[i].y <= cc.y + cc.img[frame]:getHeight()*cc.scale and cc.y + cc.img[frame]:getHeight()*cc.scale <= wheys[i].y + wheys[i].img:getHeight()*wheys[i].scale) or (cc.y <= wheys[i].y and wheys[i].y <= cc.y + cc.img[frame]:getHeight()*cc.scale) or (cc.y <= wheys[i].y + wheys[i].img:getHeight()*wheys[i].scale and wheys[i].y + wheys[i].img:getHeight()*wheys[i].scale <= cc.y + cc.img[frame]:getHeight()*cc.scale)then
                cc.stamina = cc.stamina + 80
                table.remove(wheys, i)
                love.audio.play(wheySound[math.random(1,3)])
            end
        end
   end
end
