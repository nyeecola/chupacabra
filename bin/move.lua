function move(dt, objects)

    for i = 1, #objects do
        local object = objects[i]

        object.x = object.x - OBJECTS_SPD * dt
    end

    for i = #objects, 1, -1 do
        local object = objects[i]

        if object.x < -object.width then
            object = table.remove(objects, i)
            object = nil
        end
    end
end
