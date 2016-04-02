function definePeople(people)
    people.x = 10
    people.y = 450
    people.scale = 0.3
    people.img = love.graphics.newImage("assets/people.png")
end

function drawPeople(people)
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(people.img, people.x, people.y, 0, people.scale, people.scale)
end
