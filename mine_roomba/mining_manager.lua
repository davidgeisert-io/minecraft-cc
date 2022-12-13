local position_manager = require("position_manager")
local mining_manager = {}

function mining_manager:start(x, y, z)

    print("Begin Mining")

    x_remainder = math.abs(x) - 1
    y_remainder = math.abs(y)
    z_remainder = math.abs(z)
    local total = x_remainder * y_remainder * z_remainder
    local work_direction_bit = z / math.abs(z)

    position_manager:init()

    while y_remainder > 0 do
        percent_complete = ((x_remainder * y_remainder * z_remainder) / total) * 100
        print (tostring(percent_complete).."%".."Complete")
        if turtle.getFuelLevel() == 0 then
            print("Out of fuel. Attempt to refuel...")
            for i=1,16 do
                turtle.select(i)
                turtle.refuel(1)
            end
            turtle.select(1)
        elseif x_remainder > 0 then
            if turtle.detect() then
                turtle.dig()
            end
            if position_manager:move_forward() then
                x_remainder = x_remainder - 1          
            end  
        elseif z_remainder > 0 then
            local direction = self:get_direction_of_work(work_direction_bit)
            if direction then 
                position_manager:rotate_direction(direction)
            end
            if turtle.detect() then
                turtle.dig()
            end
            
            if position_manager:move_forward() then
                position_manager:rotate_direction(direction)
                x_remainder = math.abs(x) - 1
                z_remainder = z_remainder - 1
            end
        else
            position_manager:rotate(180)
            if y > 0 then 
                if turtle.detectUp() then
                    turtle.digUp()
                end
            else
                if turtle.detectDown() then
                    turtle.digDown()
                end
            end
            local did_move = false
            if y > 0 then
                did_move = position_manager:move_up()
            else
                did_move = position_manager:move_down()
            end

            if did_move then
                x_remainder = math.abs(x) - 1
                z_remainder = math.abs(z)
                y_remainder = y_remainder - 1
                work_direction_bit = -work_direction_bit
            end
        end        
    end
end


function mining_manager:get_direction_of_work(direction_bit)
    if position.rotation == 0 then
        if direction_bit > 0 then
            return "right"
        else
            return "left"
        end
    elseif position.rotation == 180 then
        if direction_bit > 0 then
            return "left"
        else
            return "right"
        end
    end
    return nil
end

return mining_manager