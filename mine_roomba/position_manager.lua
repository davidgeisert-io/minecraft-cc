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

    print(string.format("Moving to %d, %d, %d, %d", x, y, z, rotation))
    local start_position = self:clone_position()
    while moving do
        stuck = not self:_try_go_to(x, y, z, order)
        if stuck then
            print("I'm Stuck!!")
            unstuck, order = self:_try_get_unstuck(start_position, {x=x, y=y, z=z}, order)
            print(string.format("I did%s succeed in freeing myself", unstuck and "" or " not"))
        end
        moving = position.x ~= x or position.y ~= y or position.z ~= z
    end

    local rotation_diff = rotation - position.rotation

    self:rotate(rotation_diff)
end

function position_manager:_try_go_to(x, y, z, order)
    moving = true
    while moving do
        local start_position = self:clone_position()
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

        if self:_compare_position(start_position, position) then
            return false
        end

        moving = not self:_compare_position(position, {x=x, y=y, z=z})
    end

    return true
end

function position_manager:_compare_position(position_a, position_b)
    return position_a.x == position_b.x and
        position_a.y == position_b.y and
        position_a.z == position_b.z
end

function position_manager:_try_get_unstuck(start_position, target_position, order)
    local moving_axis = order[1]
    local test_axis = position_manager:get_facing_axis()
    if moving_axis == test_axis then
        if test_axis == "x" then
            local diff_z = target_position.z - start_position.z
            local target_degrees = self:get_z_axis_target_rotation(diff_z)
            self:rotate(target_degrees - position.rotation)
        else
            local diff_x = target_position.x - start_position.x
            local target_degrees = self:get_x_axis_target_rotation(diff_x)
            self:rotate(target_degrees - position.rotation)
        end
        
        test_axis = self:get_facing_axis()
    end

    print(string.format("Breaking free on %s axis until I can move on my %s axis", moving_axis, test_axis))

    if moving_axis == "x" then
        local free = false
        while not free do
            local diff_x = target_position.x - start_position.x
            local target_degrees = self:get_x_axis_target_rotation(diff_x)
            self:rotate(target_degrees - position.rotation)

            local can_move = self:move_back()
            if not can_move then
                print("Well shit! I can't move!")
                return false, {"y", "z", "x"}
            end

            local diff_z = target_position.z - start_position.z
            local target_degrees = self:get_z_axis_target_rotation(diff_z)
            self:rotate(target_degrees - position.rotation)

            free = self:move_forward()
        end
        return true, {"z", "x", "y"}
    elseif moving_axis == "y" then
        local free = false
        local diff_y = start_position.y - target_position.y
        local direction = self:get_y_direction(diff_y)
        print(string.format("Diff y: %d", diff_y))
        print(string.format("Moving %s", direction))

        while not free do
            local can_move, direction = self:_try_move_any(direction)
            if not can_move then
                print("Well shit! I can't move!")
                return false, {self:get_non_facing_axis(), test_axis, "y"}
            end
            free = self:move_forward()
        end
        return true, {test_axis, moving_axis, self:get_non_facing_axis()}
    else
        local free = false
        while not free do
            local diff_z = target_position.z - start_position.z
            local target_degrees = self:get_z_axis_target_rotation(diff_z)
            self:rotate(target_degrees - position.rotation)

            local can_move = self:move_back()
            if not can_move then
                print("Well shit! I can't move!")
                return false, {"y", "x", "z"}
            end
            
            local diff_x = target_position.x - start_position.x
            local target_degrees = self:get_x_axis_target_rotation(diff_x)
            self:rotate(target_degrees - position.rotation)

            free = self:move_forward()
        end
        return true, {"x", "z", "y"}
    end
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

function position_manager:get_facing_axis()   
    return (position.rotation == 0 or position.rotation == 180)
        and "x"
        or "z"
end

function position_manager:get_non_facing_axis()
    return self:get_facing_axis() == "x"
        and "z"
        or "x"
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

function position_manager:get_opposite_direction(direction)
    if direction == "up" then
        return "down"
    end
    if direction == "down" then
        return "up"
    end
    if direction == "forward" then
        return "back"
    end
    if direction == "back" then
        return "forward"
    end
end

function position_manager:clone_position()
    local cloned = {}
    cloned.x = position.x
    cloned.y = position.y
    cloned.z = position.z
    cloned.rotation = position.rotation
    return cloned
end

function position_manager:_try_move_any(direction)
    if self:move(direction) then
        return true, direction
    elseif self:move(self:get_opposite_direction(direction)) then
        return true, self:get_opposite_direction(direction)
    end
    return false, nil
end

return position_manager