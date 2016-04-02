function defineBar(bar)
    bar.img = love.graphics.newImage("assets/stamina.png")
    bar.left = love.graphics.newImage("assets/left.png")
    bar.right = love.graphics.newImage("assets/right.png")
end

function drawBar(bar, cc)
    love.graphics.draw(bar.left, 120, 20)
    love.graphics.draw(bar.img, 126, 20, 0, 30*(cc.stamina +160)/320, 1)
    love.graphics.draw(bar.right, 126 + 30*(cc.stamina +160)/320*bar.img:getWidth(), 20)
    love.graphics.print("stamina", 20, 20)
end
