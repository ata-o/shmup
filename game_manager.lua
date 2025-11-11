
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
	spr(obj.spr, obj.x, obj.y, obj.sprw, obj.sprh)
end

function collide(a,b)
	return not (a.x > b.x + 7 or
			  a.x + 7 < b.x or
			  a.y > b.y + 7 or
			  a.y + 7 < b.y)
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
					sfx(2)
					del(enemies, enem)
					make_particle(enem.x+3, enem.y+3)
					make_sparkle(enem.x+3, enem.y+3, 20, 12)
					make_shwave(enem.x+4, enem.y+4, 2, 25, 7, 3.5)

					if #enemies == 0 then
						next_wave()
					end
				end
			end
		end
	end
end