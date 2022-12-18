for i=1,16 do
    turtle.select(i)
    if turtle.refuel(0) then
        local c = turtle.getItemCount()
        turtle.refuel(c)
    end
end

turtle.select(1)