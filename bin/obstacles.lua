local COOLDOWN_START = 2
local SCALE = 0.25

local cooldown = COOLDOWN_START
local obstacle_frame = 1
local obstacle_frame_timer = 0

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

function animateObstacles(dt)
    obstacle_frame_timer = obstacle_frame_timer + dt
    if obstacle_frame_timer > 0.2 then
        obstacle_frame_timer = 0
        obstacle_frame = obstacle_frame + 1
        if obstacle_frame == 4 then
            obstacle_frame = 1
        end
    end
end

function drawObstacleAnimation(obstacle)
    love.graphics.draw(obstacle.image[obstacle_frame], obstacle.x, obstacle.y, 0, SCALE, SCALE)
end

-- function to draw every obstacle
function drawObstacles(obstacles)

    -- TODO: show image too
    for i = 1, #obstacles do
        local obstacle = obstacles[i]

        if obstacle.image ~= nil then
            love.graphics.setColor(255, 255, 255)
            drawObstacleAnimation(obstacle)
        else
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
end

-- function to procedurally generate obstacles
function createRandomObstacle()
    local fat_bird = {}
    local campfire = {}
    for i = 1, 3 do
        fat_bird[i] = love.graphics.newImage('assets/birdFat' .. i .. '.png')
        campfire[i] = love.graphics.newImage('assets/fogueira' .. i .. '.png')
    end

    local obstacles = {
        newObstacle(
            80,
            40,
            {r = 255, g = 0, b = 255},
            nil,
            800,
            FLOOR - 80 - 1
        ),
        newObstacle(
            campfire[1]:getHeight() * SCALE,
            campfire[1]:getWidth() * SCALE,
            {r = 255, g = 0, b = 0},
            campfire,
            800,
            FLOOR - campfire[1]:getHeight() * SCALE - 1
        ),
        newObstacle(
            fat_bird[1]:getHeight() * SCALE,
            fat_bird[1]:getWidth() * SCALE,
            {r = 0, g = 0, b = 255},
            fat_bird,
            800,
            math.random(280, 400)
        )
    }

    local selected = math.random(3)

    return obstacles[selected]
end

function generateObstacle(obstacles, dt)
    cooldown = cooldown - dt

    if cooldown < 0 then
        cooldown = COOLDOWN_START
        table.insert(obstacles, #obstacles + 1, createRandomObstacle())
    end
end
