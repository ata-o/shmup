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
		update_game()
	elseif game.stage=="start" then
		update_start()
	elseif game.stage=="over" then
		update_gameover()
	end
	--flush_bullets()
end



-->8
--ship

function make_ship()
	ship={}
	ship.x=64
	ship.y=64

	
	--sprites
	ship.sprite = 1
	ship.defaultspr = 1
	ship.bankfront = 18
	ship.bankback = 19
	ship.bankleft = 2
	ship.bankright = 3
	
	ship.flamespr = 5
	
	ship.muzzle=0
	
	ship.speed = 2
	ship.xceed = ship.speed
	ship.yceed = ship.speed
	
	screen={}
	screen.high=120
	screen.low=0
end

function draw_ship()
	spr(ship.sprite, ship.x, ship.y)
	spr(ship.flamespr,ship.x,ship.y+7)
	if ship.muzzle >0 then
		circfill(ship.x+3, ship.y-2, ship.muzzle, 7)
	end
end

function move_ship()
	player_move()
	ship.flamespr += 1
	if ship.flamespr>9 then
		ship.flamespr=5
	end
end

function ship_bounds()
	screen_bounds(screen.low,screen.high)
end

function dvd_move()
	ship.x += ship.xceed
	ship.y += ship.yceed
end

function player_move()
	ship.sprite = ship.defaultspr
	if (btn(0)) then
	 sfx(1)
	 ship.sprite = ship.bankleft
		ship.x -= ship.speed
	end
	if (btn(1)) then
		sfx(1)
		ship.sprite = ship.bankright
		ship.x += ship.speed
	end
	if (btn(2)) then
	 ship.sprite = ship.bankfront
		ship.y -= ship.speed
	end
	if (btn(3)) then
		ship.sprite = ship.bankback
		ship.y += ship.speed
	end
	if (btnp(5)) then
		ship.muzzle=5
		make_bullet(1)
		sfx(0)
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
	for i=-bullet_count,bullet_count do
		local bul = {
			x=ship.x,
			y=ship.y-5,
			speed=5,
			sprite=32,
			orient=i
		}
		add(bullets, bul)
	end
end

function init_bullets()
	bullets={}
end

function draw_bullets()
	print(#bullets)
	for i=1, #bullets do
 	spr(bullets[i].sprite, bullets[i].x, bullets[i].y)
 end	
end

function move_bullets()
	for i=#bullets,1,-1 do
		bullets[i].y -= bullets[i].speed
		bullets[i].x += bullets[i].orient * (bullets[i].speed/8)
	
		
		bullets[i].sprite += 1
		if bullets[i].sprite > 36 then
			bullets[i].sprite = 32
		end

 		if bullets[i].y < -8 
			or bullets[i].x < -8
			or bullets[i].x > 127
			 then
			deli(bullets, i)
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
	game.score = 10000
	game.life = 3
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
	for i=1,game.life do
		if game.life>=i then
			spr(game.lifespr, i*9-8,1)
		else
			spr(game.lifeempty, i*9-8,1)
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


-->8
--background

function make_background()
	stars = {}
	for i=1, 100 do
		local elem = {
			x = flr(rnd(128)),
			y = flr(rnd(128)),
			spd = rnd(1.5)+0.5 
		}
		
		if elem.spd < 0.75 then
			elem.col = 1
		elseif elem.spd < 1 then
		 elem.col = 13
		elseif elem.spd < 1.5 then
			elem.col = 3
		else
		 elem.col = 7
		end
		
		add(stars, elem)
	end
end

function draw_background()
	for i=1, #stars do
		local x = stars[i].x
		local y = stars[i].y
		local col = stars[i].col
		if stars[i].spd < 1.5 then
			pset(x, y, col)
		else
			line(x, y, x, y-2, col)
		end
		
		
		if stars[i].y >= 128 then
			stars[i].y = 0
		end
			stars[i].y += stars[i].spd
	end
end
-->8
--stages

function draw_game()
		draw_background()
		draw_ship()
		draw_bullets()
		draw_ui()
end

function update_game()
		move_ship()
		move_bullets()
		ship_bounds()
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
 game.stage="game"
 make_background()
	make_ship()
	init_bullets()
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
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000bb00000000000003bb30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00b77b000000000003b7cb3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00baab000000000036b11b6333388333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00baab00000000003b3993b33bb00bb3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00baab00000000000009900003b7cb30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00033000000000000000000000311300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000055000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00bbbb0000000000000000000000000000bbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0baaaab000bbbb000000000000bbbb000baaaab00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
baa77aab0baaaab0000bb0000baaaab0baa77aab0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ba7777ab0ba77ab000b77b000ba77ab0ba7777ab0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ba7777ab0ba77ab000baab000ba77ab0ba7777ab0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
baa77aab0baaaab0000330000baaaab0baa77aab0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0baaaab000bbbb000000000000bbbb000baaaab00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00bbbb0000000000000000000000000000bbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
00010000190501b0301e05021030220501b0101b0001e0000d7000b70009700097000870008700097000b7000c7000c7000c7000e7000e7000e70010700000000000000000000000000000000000000000000000
000300000305003050020400101005100021000210002100021000210002100041000410004100041001320013200132001320013200142001420000000000000000000000000000000000000000000000000000
