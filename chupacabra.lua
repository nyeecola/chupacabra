function defineCC(chupacabra, floor)
    chupacabra.x = love.graphics.getWidth()/2
    chupacabra.y = floor
    chupacabra.v = 0
    chupacabra.stamina = 0
    chupacabra.grounded = true
    chupacabra.img = love.graphics.newImage("assets/chupacabra.png")
end

function moveCC(chupacabra, floor, dt)
    chupacabra.x = chupacabra.x + chupacabra.stamina * dt
    chupacabra.y = chupacabra.y - chupacabra.v * dt
    if chupacabra.y > floor then
        chupacabra.y = floor
        chupacabra.v = 0
    end
    chupacabra.v = chupacabra.v - 190*dt
end

function drawCC(chupacabra)
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(cc.img, cc.x, cc.y, 0, 0.15, 0.15)
end

function keysCC(k)
    if k == "up" then
        cc.v = 200
    end
end
