local background = {}

local timer = 0

function spawn_cloud()
	local x = 800
	local y = math.random(0, 250)
	table.insert(clouds, #clouds+1, {x = x, y = y})
end

function spawn_sun()
	sun_position_x = 400
	sun_position_y = -125
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
	-- Clock for cloud spawning
	
	-- Red Green and Blue variables for color shifting
	color_r, color_g, color_b = 86,131,209
	-- Images
	cloud_image = love.graphics.newImage("imagens/cloud.png")
	sun_image = love.graphics.newImage("imagens/sun.png")
	moon_image = love.graphics.newImage("imagens/moon.png")

	-- Spawning the first cloud
	spawn_cloud()
	spawn_sun()
	spawn_moon()

	day_state = 1
	night_state = 1


	day_cicle_speed = 15

end

function background.update_bg(dt)
	-- Spawning clouds
	timer = timer + dt
	if timer > math.random(3, 6) then
		spawn_cloud()
		timer = 0
	end

	-- Moving clouds
	for i = 1, #clouds do
		clouds[i].x = clouds[i].x - 125 * dt
	end
	-- print(#clouds)

	-- Removing clouds
	for i = #clouds, 1, -1 do
		if clouds[i].x < -400 then
			table.remove(clouds, i)
		end
	end


	if day_state == 1 then
		twilight(dt)
	end

	if day_state == 2 then
		night(dt)
	end

	if day_state ==3 then
		dawn(dt)
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
end

return background