function init_pickups()
    pickups={}
end

function make_pickup(x,y)
    p = make_object()
    p.spr = 38
    p.x=x
    p.y=y
    p.sy=0.5
    add(pickups, p)
end

function draw_pickups()
    for p in all(pickups) do
        local col=7
        if t%4<2 then
            col=14
        end
        for i=1,15 do
            pal(i,col) 
        end
        draw_outline(p)
        pal()
        draw_object(p)
    end
end

function move_pickups()
    for p in all(pickups) do 
        move(p)
        if p.y > 128 then
            del(pickups, p)
        end
    end
end

function check_pickup_collisions()
    for p in all(pickups) do
        if collide(p, ship) then
            game.cher += 1
            del(pickups, p)
            make_shwave(p.x+4,p.y+4, 3, 6, 14, 1)
            sfx(30)
        end
    end
end