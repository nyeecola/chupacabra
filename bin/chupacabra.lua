local time = 0
frame = 1

function defineCC(cc, floor)
    cc.x = love.graphics.getWidth()/2
    cc.y = floor
    cc.v = 0
    cc.stamina = 0
    cc.cooldown = 0
    cc.scale = 0.75
    cc.img = {}
    cc.img_bam = {}
    cc.img[1] = love.graphics.newImage("assets/cc/01.png")
    cc.img[2] = love.graphics.newImage("assets/cc/02.png")
    cc.img[3] = love.graphics.newImage("assets/cc/03.png")
    cc.img[4] = love.graphics.newImage("assets/cc/04.png")
    cc.img_bam[1] = love.graphics.newImage("assets/cc_bam/01_bam.png")
    cc.img_bam[2] = love.graphics.newImage("assets/cc_bam/02_bam.png")
    cc.img_bam[3] = love.graphics.newImage("assets/cc_bam/03_bam.png")
    cc.img_bam[4] = love.graphics.newImage("assets/cc_bam/04_bam.png")
end

function updateCC(cc, floor, dt)
    time = time + dt
    if time >= 0.06
        then
            frame = frame + 1
            time = 0
        end
    if frame == 4
        then
            frame = 1
        end
    cc.x = cc.x + cc.stamina * dt
    cc.y = cc.y - cc.v * dt * 2
    if cc.y + cc.img[frame]:getHeight() * cc.scale >= floor then
        cc.y = floor - cc.img[frame]:getHeight() * cc.scale
        cc.v = 0
    end
    cc.v = cc.v - 390*dt

    if cc.cooldown > 0 then --When Chupa Cabra dies
        cc.cooldown = cc.cooldown - dt
    else
        cc.cooldown = 0
    end
end

function drawCC(cc)
    love.graphics.setColor(255, 255, 255)
    if cc.cooldown > 0 then
        if cc.cooldown > 1.5 then
            love.graphics.draw(cc.img[frame], cc.x, cc.y, 0, cc.scale, cc.scale)
        elseif cc.cooldown > 1 then

        elseif cc.cooldown > 0.5 then
            love.graphics.draw(cc.img[frame], cc.x, cc.y, 0, cc.scale, cc.scale)
        end
    else
        love.graphics.draw(cc.img[frame], cc.x, cc.y, 0, cc.scale, cc.scale)
    end
end

function keysCC(k, cc)
    if k == "up" and cc.y + cc.img[frame]:getHeight() * cc.scale >= FLOOR then
        cc.v = 200
        love.audio.play(jumpSound)
        cc.x = cc.x + 35

    end
end

function collisionDetectionCC(cc, obstacles)
    if cc.cooldown <= 0 then
        for i = 1, #obstacles do
            if cc.x < obstacles[i].x + obstacles[i].width and
               obstacles[i].x < cc.x + cc.img[frame]:getWidth()*cc.scale and
               cc.y < obstacles[i].y + obstacles[i].height and
               obstacles[i].y < cc.y + cc.img[frame]:getHeight()*cc.scale then
                    cc.stamina = cc.stamina -40
                    cc.cooldown = 2
                    love.audio.play(collisionSound)
            end
       end
   end
end
