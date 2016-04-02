function definePeople(people)
    people.x = -20
    people.y = 400
    people.scale = 0.3
    people.img = love.graphics.newImage("assets/pessoas.png")
end

function drawPeople(people)
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(people.img, people.x, people.y, 0, people.scale, people.scale)
end
