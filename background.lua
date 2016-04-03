local background = {}

local cloud_timer = 0
local trees_timer = 0
local front_trees_timer = 0

function spawn_cloud()
	local x = 800
	local y = math.random(0, 250)
	table.insert(clouds, #clouds+1, {x = x, y = y})
end

function spawn_sun()
	sun_position_x = 400
	sun_position_y = -125
end

function spawn_initial_trees()
	local x = -50
	local y = math.random(290, 310)
	table.insert(trees, #trees+1, {x = x, y = y})

	x = 200
	y = math.random(290, 310)
	table.insert(trees, #trees+1, {x = x, y = y})

    x = 450
	y = math.random(290, 310)
	table.insert(trees, #trees+1, {x = x, y = y})
end

function spawn_initial_front_trees()
	local x = -50
	local y = math.random(480,500)
	table.insert(front_trees, #front_trees+1, {x = x, y = y})

	x = 200
	y = math.random(480,500)
	table.insert(front_trees, #front_trees+1, {x = x, y = y})

    x = 450
	y = math.random(480,500)
	table.insert(front_trees, #front_trees+1, {x = x, y = y})

    x = 650
	y = math.random(480,500)
	table.insert(front_trees, #front_trees+1, {x = x, y = y})
end

function spawn_trees()
	local x = 800
	local y = math.random(290, 310)
	table.insert(trees, #trees+1, {x = x, y = y})
end

function spawn_front_trees()
	local x = 800
	local y = math.random(480, 500)
	table.insert(front_trees, #front_trees+1, {x = x, y = y})
end

function spawn_ground()
	ground_x = 0
	ground_y = 450
end

function spawn_moon()
	moon_position_x = 500
	moon_position_y = 75
	moon_image_alpha = 0
end

function twilight(dt)
	-- Moving sun
	sun_position_y = sun_position_y + 20 * day_cicle_speed * dt
	sun_position_x = sun_position_x + day_cicle_speed * dt

	if color_r > 0 then
		color_r = color_r - 5 * day_cicle_speed * dt
	end
	if color_g > 25 then
		color_g = color_g - 5 * day_cicle_speed * dt
	end
	if color_b > 50 then
		color_b = color_b - 5 * day_cicle_speed * dt
	end

	if sun_position_y > 600 then
		day_state = 2
	end
end

function night(dt)
	if moon_image_alpha < 255 and night_state == 1 then
		moon_image_alpha = moon_image_alpha + 20 * day_cicle_speed * dt
	else
		moon_image_alpha = moon_image_alpha - 20 * day_cicle_speed * dt
		if moon_image_alpha > 0 then
			night_state = 2
		else
			night_state = 1
			day_state = 3
			sun_position_x = 400
			sun_position_y = -125
		end
	end
end

function dawn(dt)
	-- Moving sun
	-- sun_position_y = sun_position_y + 200 * dt
	-- sun_position_x = sun_position_x + 20* dt

	if color_r < 46 then
		color_r = color_r + 5 * day_cicle_speed * dt
	end
	if color_g < 91 then
		color_g = color_g + 5 * day_cicle_speed * dt
	end
	if color_b < 180 then
		color_b = color_b + 5 * day_cicle_speed * dt
	else
		day_state = 1
	end
end

function background.enter_bg()
	-- Table wich contains all clouds
	clouds = {}
	trees = {}
	front_trees = {}
	-- Clock for cloud spawning

	-- Red Green and Blue variables for color shifting
	color_r, color_g, color_b = 86,131,209
	-- Images
	cloud_image = love.graphics.newImage("imagens/cloud.png")
	sun_image = love.graphics.newImage("imagens/sun.png")
	moon_image = love.graphics.newImage("imagens/moon.png")
	trees_image = love.graphics.newImage("imagens/trees.png")
	ground_image = love.graphics.newImage("imagens/ground.png")

	-- Spawning the first cloud
	spawn_cloud()
	spawn_sun()
	spawn_moon()
	spawn_initial_trees()
	spawn_initial_front_trees()
	spawn_ground()


	day_state = 1
	night_state = 1


	day_cicle_speed = 0.3

end

function background.update_bg(dt)
	-- Spawning clouds
	cloud_timer = cloud_timer + dt
	if cloud_timer > math.random(8, 10) then
		spawn_cloud()
		cloud_timer = 0
	end

	-- Moving clouds
	for i = 1, #clouds do
		clouds[i].x = clouds[i].x - (BACKGROUND_SPD - 65) * dt
	end

	-- Removing clouds
	for i = #clouds, 1, -1 do
		if clouds[i].x < -400 then
			table.remove(clouds, i)
		end
	end

	-- Day state
	if day_state == 1 then
		twilight(dt)
	end

	if day_state == 2 then
		night(dt)
	end

	if day_state ==3 then
		dawn(dt)
	end

	-- Spawning trees
	trees_timer = trees_timer + dt
	if trees_timer > math.random(4, 10) then
		spawn_trees()
		trees_timer = 0
	end

	-- Moving trees
	for i = 1, #trees do
		trees[i].x = trees[i].x - BACKGROUND_SPD * dt
	end

	-- Removing trees
	for i = #trees, 1, -1 do
		if trees[i].x < -800 then
			table.remove(trees, i)
		end
	end

	-- Spawning front trees
	front_trees_timer = front_trees_timer + dt
	if front_trees_timer > math.random(2, 6) then
		spawn_front_trees()
		front_trees_timer = 0
	end

	-- Moving front trees
	for i = 1, #front_trees do
		front_trees[i].x = front_trees[i].x - FOREGROUND_SPD * dt
	end

	-- Removing front trees
	for i = #front_trees, 1, -1 do
		if front_trees[i].x < -800 then
			table.remove(front_trees, i)
		end
	end

end

function background.draw_bg()
	love.graphics.draw(sun_image, sun_position_x, sun_position_y)
	love.graphics.setColor(255, 255, 255, moon_image_alpha)
	love.graphics.draw(moon_image, moon_position_x, moon_position_y)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setBackgroundColor(color_r, color_g, color_b)

	for i = 1, #clouds do
		love.graphics.draw(cloud_image, clouds[i].x, clouds[i].y)
	end

	love.graphics.draw(ground_image, ground_x, ground_y)

	for i = 1, #trees do
		love.graphics.draw(trees_image, trees[i].x, trees[i].y)
	end
end

function background.draw_fg()
    love.graphics.setColor(255, 255, 255)
    for i = 1, #front_trees do
		love.graphics.draw(trees_image, front_trees[i].x, front_trees[i].y)
	end
end

return background
