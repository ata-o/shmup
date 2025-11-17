function init_pickups()
    pickups={}
end

function make_pickup(x,y)
    p = make_object()
    p.spr = 50
    p.x=x
    p.y=y
    p.sy=1
end

function draw_pickups()
    for p in all(pickups) do
        draw_object(p)
    end
end

function move_pickups()
    for p in all(pickups) do 
        move(p)
    end
end