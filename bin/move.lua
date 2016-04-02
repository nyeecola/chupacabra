GENERAL_DELAY = 0.012
GENERAL_SPEED = 2

local last_move_delay = 0

function move(dt, objects)
    last_move_delay = last_move_delay + dt

    if last_move_delay < GENERAL_DELAY then
        return
    end
        
    for i = 1, #objects do
        local object = objects[i]

        object.x = object.x - GENERAL_SPEED

        if object.x < -object.width then
            -- object = table.remove(objects, i)
            object = nil
        end
    end
    
    last_move_delay = 0
end
