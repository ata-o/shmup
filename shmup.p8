pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
function _draw()
	cls(0)
	--debug()
	draw_ship()
	draw_bullet()
	draw_ui()
end

function _init()
	cls(0)
	make_game()
	make_ship()
	make_bullet()
end

function _update()
	move_ship()
	move_bullet()
	ship_bounds()
end



-->8
function make_ship()
	ship={}
	ship.x=32
	ship.y=64

	
	--sprites
	ship.sprite = 1
	ship.defaultspr = 1
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
	 ship.sprite = ship.bankleft
		ship.x -= ship.speed
	end
	if (btn(1)) then
		ship.sprite = ship.bankright
		ship.x += ship.speed
	end
	if (btn(2)) then
		ship.y -= ship.speed
	end
	if (btn(3)) then
		ship.y += ship.speed
	end
	if (btnp(5)) then
		ship.muzzle=5
		bullet.x=ship.x
		bullet.y=ship.y-4
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
function make_bullet()
	bullet={}
	bullet.x=ship.x
	bullet.y=-10
	bullet.speed=5
	bullet.sprite=16
end

function draw_bullet()
	spr(bullet.sprite, bullet.x, bullet.y)
end

function move_bullet()
	bullet.y -= bullet.speed
end
-->8
function debug()
	--print(ship.y, 20,20)
	--print(ship.x, 6,20)
	--print(ship.speed, 20,30)
	lin = "sprite: " .. ship.sprite
	print(line, 20,20)
	--print(ship.x, 6,20)
end

function make_game()
	game={}
	game.score = 32000
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

__gfx__
00000000000880000008300000038000000000000000000000000000000000000000000000000000000000000880088008800880000000000000099000000000
00000000003bb300003b30000003b300000000000000000000000000000000000000000000000000000000008888888880088008000000000000660000005500
00700700036bb630003b63000036b30000000000000aa000000aa000000aa00000caac00000aa000000000008888888880000008000000000000600000005000
0007700036bbbb63003bb630036bb3000000000000c77c000007700000c77c000cccccc000c77c00000000008888888880000008000000000011610000115100
000770003bb7cbb3037cbb3003bbc7300000000000cccc00000cc00000cccc00000cc00000cccc00000000000888888008000080000000000111111001000010
0070070003b11b300311bb3003bb113000000000000cc000000cc000000cc00000000000000cc000000000000088880000800800000000000111111001000010
00000000003553000055b300003b55000000000000000000000cc000000000000000000000000000000000000008800000088000000000000111111001000010
00000000000990000009900000099000000000000000000000000000000000000000000000000000000000000000000000000000000000000011110000111100
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000bb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00b77b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00baab00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00baab00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00baab00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00033000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100002f7502b750287501b75024750217501f750167501a7501c75016750297501375010750000000b75009750087500000000000000000000000000000000000000000000000000000000000000000000000
