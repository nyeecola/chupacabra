local COOLDOWN_START = 2

local cooldown = COOLDOWN_START

-- function that creates and returns a new obstacle
function newObstacle(height, width, color, image, x, y)
    return {
        height = height,
        width = width,
        x = x,
        y = y,
        color = color,
        image = image
    }
end

-- function to draw every obstacle
function drawObstacles(obstacles)

    -- TODO: show image too
    for i = 1, #obstacles do
        local obstacle = obstacles[i]
        
        love.graphics.setColor(
            obstacle.color.r,
            obstacle.color.g,
            obstacle.color.b
        )
        love.graphics.rectangle(
            'fill',
            obstacle.x,
            obstacle.y,
            obstacle.width,
            obstacle.height
        )
    end
end

-- function to procedurally generate obstacles
function createRandomObstacle(x, y)
    local obstacles = {
        newObstacle(
            100,
            50,
            {r = 255, g = 0, b = 255},
            nil,
            x,
            y
        ),
        newObstacle(
            60,
            100,
            {r = 255, g = 0, b = 0},
            nil,
            x,
            y
        ),
        newObstacle(
            50,
            50,
            {r = 0, g = 0, b = 255},
            nil,
            x,
            y
        )
    }

    local selected = math.random(3)

    return obstacles[selected]
end

function generateObstacle(obstacles, dt, x, y)
    cooldown = cooldown - dt

    if cooldown < 0 then
        cooldown = COOLDOWN_START
        table.insert(obstacles, #obstacles, createRandomObstacle(x, y))
    end
end
