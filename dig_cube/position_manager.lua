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
        self:move_forward()
    elseif direction == "back" then
        self:move_back()
    elseif direction == "up" then
        self:move_up()
    elseif direction == "down" then
        self:move_down()
    end
end

function position_manager:move_forward()
    turtle.forward()
    if position.rotation == 0 then
        position.x = position.x + 1
    elseif position.rotation == 90 then
        position.z = position.z + 1
    elseif position.rotation == 180 then
        position.x = position.x - 1
    elseif position.rotation == 270 then
        position.z = position.z - 1
    end
end

function position_manager:move_back()

    turtle.back()
    if position.rotation == 0 then
        position.x = position.x - 1
    elseif position.rotation == 90 then
        position.z = position.z - 1
    elseif position.rotation == 180 then
        position.x = position.x + 1
    elseif position.rotation == 270 then
        position.z = position.z + 1
    end
end

function position_manager:move_up()
    turtle.up()
    position.y = position.y + 1
end

function position_manager:move_down()
    turtle.down()
    position.y = position.y - 1
end

return position_manager