local position_manager = {

}

function position_manager:init()
    position = {}
    position.x = 0
    position.y = 0
    position.z = 0
    position.rotation = 0
end


function position_manager:_update_rotation(degrees)
    local unsafe_rotation = position.rotation + degrees
    if math.abs(unsafe_rotation) >= 360 then
        unsafe_rotation = (math.abs(unsafe_rotation) / unsafe_rotation ) * (unsafe_rotation - 360)
    end

    if unsafe_rotation == -270 then
        position.rotation = 90
    elseif unsafe_rotation == -180 then
        position.rotation = 180
    elseif unsafe_rotation == -90 then
        position.rotation = 270
    else
        position.rotation = unsafe_rotation
    end
end

function position_manager:rotate(degrees)

    local degrees_of_rotation = math.abs(degrees)
    if degrees < 0 then
        
        while degrees_of_rotation > 0 do
            turtle.turnLeft()
            degrees_of_rotation = degrees_of_rotation - 90
            self:_update_rotation(-90)            
        end
    else

        while degrees_of_rotation > 0 do
            turtle.turnRight()
            degrees_of_rotation = degrees_of_rotation - 90
            self:_update_rotation(90)
        end
    end    
end

function position_manager:rotate_to(degrees)
    local rotation_diff = degrees - position.rotation
    self:rotate(rotation_diff)
end

function position_manager:rotate_direction(direction)
    if direction == "left" then
        self:rotate_left()
    elseif direction == "right" then
        self:rotate_right()
    end
end

function position_manager:rotate_left()
    self:rotate(-90)
end

function position_manager:rotate_right()
    self:rotate(90)
end

function position_manager:move(direction)
    if direction == "forward" then
        return self:move_forward()
    elseif direction == "back" then
        return self:move_back()
    elseif direction == "up" then
        return self:move_up()
    elseif direction == "down" then
        return self:move_down()
    end
end

function position_manager:move_forward()
    
    if turtle.forward() then
        self:update_position(1)
        return true
    end
    return false
end

function position_manager:update_position(direction_modifier)
    if position.rotation == 0 then
        position.x = position.x + direction_modifier
    elseif position.rotation == 90 then
        position.z = position.z + direction_modifier
    elseif position.rotation == 180 then
        position.x = position.x - direction_modifier
    elseif position.rotation == 270 then
        position.z = position.z - direction_modifier
    end
end

function position_manager:move_back()

    if turtle.back() then
        self:update_position(-1)
    end
    return false
end

function position_manager:move_up()
    if turtle.up() then
        position.y = position.y + 1
        return true
    end
    return false
end

function position_manager:move_down()
    if turtle.down() then
        position.y = position.y - 1
        return true
    end
    return false
end


function position_manager:go_to(x, y, z, rotation, order)
    moving = true

    if not order then
        order = {"y", "z", "x"}
    end

    while moving do
        for i,v in ipairs(order) do
            if v == "x" and position.x ~=x then
                self:go_to_x(x)
            end

            if v == "y" and position.y ~= y then
                self:go_to_y(y)
            end

            if v == "z" and position.z ~= z then
                self:go_to_z(z)
            end            
        end
        moving = position.x ~= x or position.y ~= y or position.z ~= z
    end

    local rotation_diff = rotation - position.rotation

    self:rotate(rotation_diff)
end

function position_manager:go_to_x(destination_x)
    local diff_x = destination_x - position.x
    local target_degrees = self:get_x_axis_target_rotation(diff_x)
    self:rotate(target_degrees - position.rotation)
    while position.x ~= destination_x do
        if not self:move_forward() then
            return false
        end
    end
    return true
end

function position_manager:go_to_y(destination_y)
    local diff_y = destination_y - position.y
    local direction = self:get_y_direction(diff_y)
    while position.y ~= destination_y do
        if not self:move(direction) then
            return false
        end
    end
    return true
end


function position_manager:go_to_z(destination_z)
    local diff_z = destination_z - position.z
    local target_degrees = self:get_z_axis_target_rotation(diff_z)
    self:rotate(target_degrees - position.rotation)

    while position.z ~= destination_z do
        if not self:move_forward() then
            return false
        end
    end
    return true
end

function position_manager:get_z_axis_target_rotation(disposition)
    if disposition > 0 then 
        return 90
    end

    return 270
end

function position_manager:get_x_axis_target_rotation(disposition)
    if disposition > 0 then
        return 0
    end

    return 180
end

function position_manager:get_y_direction(disposition)
    if disposition > 0 then 
        return "up"
    end
    return "down"
end

function position_manager:clone_position()
    local cloned = {}
    cloned.x = position.x
    cloned.y = position.y
    cloned.z = position.z
    cloned.rotation = position.rotation
    return cloned
end

return position_manager