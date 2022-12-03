local position_manager = require("position_manager")
local mining_manager = {}

function mining_manager.start(x, y, z)


    x_remainder = math.abs(x) - 1
    y_remainder = math.abs(y)
    z_remainder = math.abs(z)
    work_direction_bit = z / math.abs(z)

    position_manager.init()

    while y_remainder > 0 do
        if x_remainder > 0 then
            if turtle.detect() then
                turtle.dig()
            end
            position_manager.move_forward()
            x_remainder = x_remainder - 1            
        elseif z_remainder > 0 then
            direction = self.get_direction_of_work(work_direction_bit)
            position_manager.rotae(direction)
            if turtle.detect() then
                turtle.dig()
            end
            position_manager.move_forward()
            x_remainder = math.abs(x) - 1
            z_remainder = z_remainder - 1
        else
            position_manager.rotate(180)
            if turtle.detectDown() then
                turtle.digDown()
            end
            position_manager.move_down()
            x_remainder = math.abs(x) - 1
            z_remainder = math.abs(z)
            y_remainder = y_remainder - 1
        end        
    end
end


function mining_manager.get_direction_of_work(direction_bit)
    if position.rotation == 0 then
        if z > 0 then
            return "right"
        else
            return "left"
        end
    elseif position.rotation == 180 then
        if z > 0 then
            return "left"
        else
            return "right"
        end
    end
    return nil
end

return mining_manager