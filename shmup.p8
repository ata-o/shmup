pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
function _draw()
	cls(0)
	debug()
	draw_ship()
	draw_bullet()
	
end

function _init()
	cls(0)
	make_ship()
	make_bullet()
end

function _update()
	move_ship()
	move_bullet()
	ship_bounds()
end

function debug()
--debug
	print(ship.y, 20,20)
	print(ship.x, 6,20)
	print(ship.speed, 20,30)
	print(ship.x, 6,20)
end
-->8
function make_ship()
	ship={}
	ship.x=32
	ship.y=64
	ship.sprite = 1
	ship.speed = 2
	ship.xceed = ship.speed
	ship.yceed = ship.speed
	screen={}
	screen.high=120
	screen.low=0
end

function draw_ship()
	spr(ship.sprite, ship.x, ship.y)
end

function move_ship()
	player_move()
end

function ship_bounds()
	screen_bounds(screen.low,screen.high)
end

function dvd_move()
	ship.x += ship.xceed
	ship.y += ship.yceed
end

function player_move()
	if (btn(0)) then
		ship.x -= ship.speed
	end
	if (btn(1)) then
		ship.x += ship.speed
	end
	if (btn(2)) then
		ship.y -= ship.speed
	end
	if (btn(3)) then
		ship.y += ship.speed
	end
	if (btnp(5)) then
		bullet.x=ship.x
		bullet.y=ship.y-4
		sfx(0)
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
	bullet.y=ship.y-3
	bullet.speed=5
	bullet.sprite=3
end

function draw_bullet()
	spr(bullet.sprite, bullet.x, bullet.y)
end

function move_bullet()
	bullet.y -= bullet.speed
end
__gfx__
00000000000880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000b33b0000000000000bb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000bb33bb00000000000b77b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000b333333b0000000000baab00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000bb3335bb0000000000baab00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000b37a5b00000000000baab00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000b15b000000000000033000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000bb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100002f7502b750287501b75024750217501f750167501a7501c75016750297501375010750000000b75009750087500000000000000000000000000000000000000000000000000000000000000000000000
