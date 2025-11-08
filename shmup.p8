pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
--main

function _init()
	cls(0)
	make_game()
end

function _draw()
	cls(0)
	--debug()
	if game.stage=="game" then
		draw_game()
	elseif game.stage=="start" then
		draw_start()
	elseif game.stage=="over" then
		draw_gameover()
	end
end

function _update()
	if game.stage=="game" then
		t+=1
		update_game()
	elseif game.stage=="start" then
		update_start()
	elseif game.stage=="over" then
		update_gameover()
	end
end



-->8
--ship

function make_ship()
	ship={}
	ship.x=64
	ship.y=64

	
	--sprites
	ship.spr = 1
	ship.defaultspr = 1
	ship.bankfront = 18
	ship.bankback = 19
	ship.bankleft = 2
	ship.bankright = 3
	
	ship.flamespr = 5

	ship.shottimer = 0

	ship.invulnerable = 0
	
	ship.muzzle=0
	
	ship.speed = 2
	ship.xceed = ship.speed
	ship.yceed = ship.speed
	
	screen={}
	screen.high=120
	screen.low=0
end

function draw_ship_sprites()
	draw_object(ship)
	spr(ship.flamespr,ship.x,ship.y+7)
	if ship.muzzle >0 then
		circfill(ship.x+3, ship.y-2, ship.muzzle, 7)
	end
end

function draw_ship()
	--todo: use pal color flash when hit
	if ship.invulnerable > 0 then
		if sin(t/4) < 0.5 then
			draw_ship_sprites()
		end
	else
		draw_ship_sprites()
	end
end

function move_ship()
	player_move()
	ship.flamespr += 1
	if ship.flamespr>9 then
		ship.flamespr=5
	end
end

function check_ship_bounds()
	screen_teleport(screen.low,screen.high)
end

function check_collisions()
	--check collisions with enemies
	for enem in all(enemies) do
		if collide(ship, enem) and ship.invulnerable == 0 then
			game.life -= 1
			sfx(2)
			ship.invulnerable = 200
			make_particle(ship.x+3, ship.y+3, true)
		end
		if ship.invulnerable > 0 then
			ship.invulnerable -= 1
		end
	end
end

function dvd_move()
	ship.x += ship.xceed
	ship.y += ship.yceed
end

function player_move()
	ship.spr = ship.defaultspr
	if (btn(0)) then
	 ship.spr = ship.bankleft
		ship.x -= ship.speed
	end
	if (btn(1)) then
		ship.spr = ship.bankright
		ship.x += ship.speed
	end
	if (btn(2)) then
	 	ship.spr = ship.bankfront
		ship.y -= ship.speed
	end
	if (btn(3)) then
		ship.spr = ship.bankback
		ship.y += ship.speed
	end
	if (btn(5)) then
		if ship.shottimer > 0 then
			ship.shottimer -= 1
		else
			ship.shottimer = 3
			ship.muzzle=5
			make_bullet(1)
			sfx(0)
		end
	end
	
	if ship.muzzle > 0 then
		ship.muzzle-=1
	end
end

function screen_bounds(low, high)
	if (ship.x > high) then
		ship.x = high
	end
	if (ship.x < low) then
		ship.x = low
	end
	if (ship.y > high) then
		ship.y = high
	end
	if (ship.y < low) then
		ship.y = low
	end
end

function screen_teleport(low, high)
	if (ship.x > high) then
		ship.x = low
	end
	if (ship.x < low) then
		ship.x = high
	end
	if (ship.y > high) then
		ship.y = low
	end
	if (ship.y < low) then
		ship.y = high
	end
end

function dvd_bounce(low, high)
	if (ship.x > high) then
		ship.xceed = -ship.xceed
	end
	if (ship.x < low) then
		ship.xceed = -ship.xceed
	end
	if (ship.y > high) then
		ship.yceed = -ship.yceed
	end
	if (ship.y < low) then
		ship.yceed = -ship.yceed
	end
	if (ship.x == ship.y) then
		ship.x +=1
	end
end

-->8
--bullets

function make_bullet(cnt)
	bullet_count = flr(cnt/2)
	for i=-bullet_count, bullet_count do
		local bul = {
			x=ship.x,
			y=ship.y-5,
			speed=5,
			spr=32,
			orient=i
		}
		add(bullets, bul)
	end
end

function init_bullets()
	bullets={}
end

function draw_bullets()
	for bul in all(bullets) do
		draw_object(bul)
 	end
end

function move_bullets()
	for bul in all(bullets) do
		bul.y -= bul.speed
		bul.x += bul.orient * (bul.speed/8)
	
		bul.spr += 1
		if bul.spr > 36 then
			bul.spr = 32
		end

 		if bul.y < -8 or bul.x < -8 or bul.x > 127 then
			del(bullets, bul)
		end
 	end
end
-->8
--game manager

function debug()
	--print(ship.y, 20,20)
	--print(ship.x, 6,20)
	--print(ship.speed, 20,30)
	--lin = "sprite: " .. ship.sprite
	--print(line, 20,20)
	--print(ship.x, 6,20)
end

function make_game()
	game={}
	game.stage = "start"
	game.score = 0
	game.life = 3
	game.maxlife = 4
	game.lifespr = 11
	game.lifeempty = 12
	
	game.bombs = 3
	game.bombspr = 14
	game.bombempty = 15
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
	spr(obj.spr, obj.x, obj.y)
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
	end
end

function check_bullet_collisions()
	for bul in all(bullets) do
		for enem in all(enemies) do
			if collide(bul, enem) then
				-- TODO: add explosion effect
				-- TODO: add enemy death anim
				sfx(4)
				game.score += 100
				
				del(bullets, bul)
				
				enem.hp -= 1
				enem.flash=3
				if enem.hp <= 0 then
					sfx(3)
					del(enemies, enem)
					make_particle(enem.x+3, enem.y+3)
				end
			end
		end
	end
end

-->8
--background

function make_background()
	stars = {}
	for i=1, 50 do
		local elem = {
			x = flr(rnd(128)),
			y = flr(rnd(128)),
			spd = rnd(1.2)+0.2
		}
		
		if elem.spd < 0.75 then
			elem.col = 1
		elseif elem.spd < 1 then
		 elem.col = 8
		else
		 elem.col = 7
		end
		
		add(stars, elem)
	end
end

function draw_background()
	for star in all(stars) do
		--if star.spd < 1.5 then
		--	pset(star.x, star.y, star.col)
		--else
		--	line(star.x, star.y, star.x, star.y-2, star.col)
		--end
		pset(star.x, star.y, star.col)
		
		if star.y >= 128 then
			star.y = 0
		end
			star.y += star.spd
	end
end
-->8
--stages

function draw_game()
		draw_background()
		draw_ship()
		draw_bullets()
		draw_enemies()
		draw_particles()
		draw_ui()
end

function update_game()
		move_ship()
		move_bullets()
		move_enemies()

		check_ship_bounds()
		check_bullet_collisions()
		check_collisions()
		check_life()
end

function draw_start()
	cls(1)
	print("shoot 'em bb", 40, 45,12)
	print("press ❎ key to start", 20, 80, 7)
end

function update_start()
	if btnp(5) then
		start_game()
	end
end

function draw_gameover()
	cls(2)
	print("game over!", 45, 45,6)
	print("final score: ".. game.score, 30, 60,6)
	print("press ❎ key to restart", 20, 80, 7)
end

function update_gameover()
	if btnp(5) then
		start_game()
	end
end

function start_game()
	t=0
 	game.stage="game"
	game.score = 0
	game.life = game.maxlife
 	make_background()
	make_ship()
	init_bullets()
	init_enemies()
	init_particles()
end
-->8

function init_enemies()
	enemies = {}
	 for i=1,5 do
		spawn_enemy(20+(i*20))
	 end
end

function spawn_enemy(x)
	local myen={
		x=x,
		y=-8,
		spr=21,
		hp=5,
		flash=0
	}
	add(enemies, myen)
end

function draw_enemies()
	for enem in all(enemies) do
		if enem.flash > 0 then
			enem.flash -= 1
			--todo: use pal to make new enemies
			for i=1,15 do
				pal(i,7)
			end
		end
		draw_object(enem)
		pal()
 	end	
end

function move_enemies()
	for enem in all(enemies) do
 		enem.y += 0.5
		enem.spr += 0.4
		if enem.spr >= 25 then
			enem.spr = 21
		end

		if enem.y>128 then
			del(enemies, enem)
		end
 	end	
end


-->8
--particles

function init_particles()
	--explods = {}
	particles = {}
end

function make_particle(x,y, isblue)
	--first big particle, then smaller ones
	local part={
		x=x,
		y=y,
		sx=0,
		sy=0,
		age=0,
		maxage=0,
		size=10,
		blue=isblue 
	}

	add(particles, part)
	for i=1,30 do
		local part={
			x=x,
			y=y,
			sx=(rnd()-0.5)*4,
			sy=(rnd()-0.5)*4,
			age=rnd(2),
			maxage=10+rnd(10),
			size=1+rnd(4),
			blue=isblue
		}

		add(particles, part)
	end
end

function particle_color(age, isblue)
	local age_colors = {
		{5, 10},
		{7, 9},
		{10, 8},
		{12, 2},
		{15, 5}
	}
	if isblue then
		age_colors = {
			{5, 12},
			{7, 11},
			{10, 9},
			{12, 6},
			{15, 3}
		}
	end
	for _, age_color in ipairs(age_colors) do
		if age > age_color[1] then
			pc = age_color[2]
		end
	end
	return pc

end

function draw_particles()
	for part in all(particles) do
		circfill(part.x, part.y, part.size, particle_color(part.age, part.blue))

		part.x += part.sx
		part.y += part.sy

		part.sx *= 0.85
		part.sy *= 0.85
		part.age += 1

		if part.age > part.maxage then
			part.size -= 0.5
			if part.size < 0 then
				del(particles, part)
			end
		end
	end
end

__gfx__
00000000000880000008300000038000000000000000000000000000000000000000000000000000000000000880088008800880000000000000099000000000
00000000003bb300003b30000003b300000000000000000000000000000000000000000000000000000000008888888880088008000000000000660000005500
00700700036bb630003b63000036b30000000000000aa000000aa000000aa00000caac00000aa000000000008888888880000008000000000000600000005000
0007700036bbbb63003bb630036bb3000000000000c77c000007700000c77c000cccccc000c77c00000000008888888880000008000000000011610000115100
000770003bb7cbb3037cbb3003bbc7300000000000cccc00000cc00000cccc00000cc00000cccc00000000000888888008000080000000000111111001000010
0070070003b11b300311bb3003bb113000000000000cc000000cc000000cc00000000000000cc000000000000088880000800800000000000111111001000010
00000000003556000055b300003b55000000000000000000000cc000000000000000000000000000000000000008800000088000000000000111111001000010
00000000000990000009900000099000000000000000000000000000000000000000000000000000000000000000000000000000000000000011110000111100
00000000000000000000000000000000000000000330033003300330033003300330033000000000000000000000000000000000000000000000000000000000
000bb00000000000003bb30000000000000000003bb33bb33bb33bb33bb33bb33bb33bb300000000000000000000000000000000000000000000000000000000
00b77b000000000003b7cb3000000000000000003bbbbbb33bbbbbb33bbbbbb33bbbbbb300000000000000000000000000000000000000000000000000000000
00baab000000000036b11b6333388333000000003b7717b33b7717b33b7717b33b7717b300000000000000000000000000000000000000000000000000000000
00baab00000000003b3993b33bb00bb3000000000b7117b00b7117b00b7117b00b7117b000000000000000000000000000000000000000000000000000000000
00baab00000000000009900003b7cb30000000000037730000377300003773000037730000000000000000000000000000000000000000000000000000000000
00033000000000000000000000311300000000000303303003033030030330300303303000000000000000000000000000000000000000000000000000000000
00000000000000000000000000055000000000000300003030000003030000300330033000000000000000000000000000000000000000000000000000000000
00bbbb0000000000000000000000000000bbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0baaaab000bbbb000000000000bbbb000baaaab00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
baa77aab0baaaab0000bb0000baaaab0baa77aab0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ba7777ab0ba77ab000b77b000ba77ab0ba7777ab0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ba7777ab0ba77ab000baab000ba77ab0ba7777ab0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
baa77aab0baaaab0000330000baaaab0baa77aab0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0baaaab000bbbb000000000000bbbb000baaaab00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00bbbb0000000000000000000000000000bbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000055555555000000005500000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000005555555500500000555555555050000000000000000000000000000000000000000000000000000000000000000000
00070000000000000000999999999000055222222222250005552522252555000000005550000000000000000000000000000000000000000000000000000000
00000007700007000099999999999900552228888822255005552828282555500055555055550000000000000000000000000000000000000000000000000000
000000070000000009999aaaaaaa9900522889998888225055555528288855000055005055555000000000000000000000000000000000000000000000000000
0000709a79a000000999977777aa99905228999aa988225055522522822825000050022000255000000000000000000000000000000000000000000000000000
000009a7777a90000999a777777a9990522889a77a98825555288955899285550050002200050000000000000000000000000000000000000000000000000000
07000a77777a0000099aa777777aa99025228aa77798822505529999999885550055022000000050000000000000000000000000000000000000000000000000
0000aa7777770070099aa777777aa99052288aa77a98822505559999999885550050550000005050000000000000000000000000000000000000000000000000
00777777777770000099a777777aa99052229aaaaa99822005529998889985500000000000000550000000000000000000000000000000000000000000000000
0000aa7777aa77000099aa7777aa9990552298999a99822505589822558982550000550000005550000000000000000000000000000000000000000000000000
00000077a9aa0000009999aaaaa99990052229999998822500528999225552550000000500005050000000000000000000000000000000000000000000000000
00007770007700000099999aaa999999055252222882225000555222555555500000055500500050000000000000000000000000000000000000000000000000
00000000770700000009999999999990005522222222525000055552255555500000505522555500000000000000000000000000000000000000000000000000
07000000000007000000009999990000000055555555000000000050555500000000000000555500000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000555550000000000000000000000000000000555000000000000000000000000000000000000000000000000000
__sfx__
00010000190501b0301e05021030220501b0101b0001e0000d7000b70009700097000870008700097000b7000c7000c7000c7000e7000e7000e70010700000000000000000000000000000000000000000000000
000300000305003050020400101005100021000210002100021000210002100041000410004100041001320013200132001320013200142001420000000000000000000000000000000000000000000000000000
02030000336502d65027650236501f6501d6501b6501865016630146201362011610106000f6000e6000e6000e6000e6001710017000170001700000000000000000000000000000000000000000000000000000
000100003565008650256500e65016650126501165012650136500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00010000066502c6502b6000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011800000c050110500c050110500c050130500c050150500c050130500c0500c050110500c050130500c050110500c050130500c050110500000000000000000000000000000000000000000000000000000000
