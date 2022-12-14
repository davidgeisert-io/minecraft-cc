local string_utils = require("string_utils")
local inventory = {}

function inventory:has_space(direction)
    local block_exists, block_details = self:inspect_direction(direction)
    if not block_exists then 
        return true
    end

    for i=1, 16 do
        if turtle.getItemCount(i) == 0 then
            return true
        end
    end    

    for i=1, 16 do
        if turtle.getItemSpace(i) > 0 then
            turtle.select(i)
            local item_details = turtle.getItemDetail()
            if self:compare_direction(direction) or self:fuzzy_compare(block_details, item_details) then
                return true
            end
        end
    end

    return false
end

function inventory:inspect_direction(direction) 
    if direction == "down" then
        return turtle.inspectDown()
    elseif direction == "up" then
        return turtle.inspectUp()
    else
        return turtle.inspect()
    end
end

function inventory:compare_direction(direction)
    if direction == "down" then
        return turtle.compareDown()
    elseif direction == "up" then
        return turtle.compareUp()
    else
        return turtle.compare()
    end
end

function inventory:fuzzy_compare(block_details, item_details)
    if block_details == nil or item_details == nil then
        return false
    end

    local block_names = string_utils.split(block_details.name, ":")
    local item_names = string_utils.split(item_details.name, ":")
    local b_length = table.getn(block_names)
    local i_length = table.getn(item_names)

    if block_names[1] ~= item_names[1] or b_length ~= i_length then
        return false
    end

    if b_length > 1 then
        block_names = string_utils.split(block_names[2], "_")
        item_names = string_utils.split(item_names[2], "_")
        return table.getn(block_names) > 1 and block_names[1] == item_names[1]
    end

    return false
end

function inventory:dump_load()
    for i=1, 16 do
        turtle.select(i)
        local item_count = turtle.getItemCount()
        turtle.drop(item_count)
    end
end

return inventory