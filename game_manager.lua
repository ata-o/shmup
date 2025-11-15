
function debug()
	--print(ship.y, 20,20)
	--print(ship.x, 6,20)
	--print(ship.speed, 20,30)
	--lin = "sprite: " .. ship.sprite
	--print(line, 20,20)
	print(t, 5,5,7)
	print(game.lockout)
end

function make_game()
	t=0
	game={}
	game.stage = "start"
	
	game.score = 0
	game.life = 3
	game.maxlife = 4
	game.lifespr = 11
	game.lifeempty = 12
	
	game.lockout = 0
	
	game.bombs = 3
	game.bombspr = 14
	game.bombempty = 15

	start_game()
end

function draw_ui()
	print("score: " .. game.score, 40, 1, 4)
	draw_hp()
	draw_bombs()
end

function draw_hp()
	for i=1,game.maxlife do
		if game.life>=i then
			spr(game.lifespr, 1+(i*9-8),1)
		else
			spr(game.lifeempty, 1+(i*9-8),1)
		end
	end
end

function draw_bombs()
	for i=1,game.bombs do
		if game.bombs>=i then
			spr(game.bombspr, 120-(i*9-8),1)
		else
			spr(game.bombempty, 120-(i*9-8),1)
		end
	end
end

function draw_object(obj)
	local sprx=obj.x
	local spry=obj.y
	if obj.shake>0 then
		obj.shake-=1
		--sprx+=abs(sin(t/2.5)*1.2)
		--TODO: experiment with this
		if t%4 < 2 then
			sprx+=1
		end
	end
	spr(obj.spr, sprx, spry, obj.sprw, obj.sprh)
end

function make_object()
	local obj={
		x=0,
		y=0,
		flash=0,
		shake=0,
		aniframe=1,
		spr=0,
		sprw=1,
		sprh=1,
		colw=8,
		colh=8
	}
	return obj
end

function collide(a,b)
	if a == nil then
        print("a is nil", 5, 5, 7)
        return false
    end
    if a.colw == nil then
        print("a.colw is nil, a.spr=" .. a.spr, 5, 5, 7)
        return false
    end
	print(a.colw, 5,5,7)
	return not (a.x > b.x + b.colw - 1 or
			  a.x + a.colw - 1 < b.x or
			  a.y > b.y + b.colh -1 or
			  a.y + a.colh -1 < b.y)
end

function check_life()
	if game.life <= 0 then
		game.stage="over"
		game.lockout=t+30
	end
end

function check_bullet_collisions()
	for bul in all(bullets) do
		for enem in all(enemies) do
			if collide(bul, enem) then
				-- TODO: add explosion effect
				-- TODO: add enemy death anim
				sfx(3)
				game.score += 100
				
				del(bullets, bul)
				make_shwave(bul.x+4, bul.y+4, 3, 6, 9, 1)
				make_sparkle(enem.x+3, enem.y+3, 1, 9)
				
				enem.hp -= 1
				enem.flash=3
				if enem.hp <= 0 then
					kill_enemy(enem)
				end
				if #enemies == 0 then
					next_wave()
				end
			end
		end
	end
end

function move(obj)
	obj.x+=obj.sx
	obj.y+=obj.sy
end

function explode(x, y)
	make_particle(x, y)
	make_sparkle(x, y, 20, 12)
	make_shwave(x, y, 2, 25, 7, 3)
end