local time = 0
local pframe = 1

function definePeople(x, y, name)
    local people = {}
    people.x = x
    people.y = y
    people.scale = 0.45
    people.img = {}
    people.img[1] = love.graphics.newImage("assets/multidao/" .. name .. "01.png")
    people.img[2] = love.graphics.newImage("assets/multidao/" .. name .. "02.png")
    return people
end

function drawPeople(people)
    for jj = 1, #people do
        love.graphics.draw(people[jj].img[pframe], people[jj].x, people[jj].y, 0, people[jj].scale, people[jj].scale)
    end
end

function updatePeople(people, dt)
    time = time + dt
    if time >= 0.45
        then
            pframe = pframe + 1
            time = 0
        end
    if pframe == 3
        then
            pframe = 1
        end
end
