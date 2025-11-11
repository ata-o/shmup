function make_ship()
	ship=make_object()
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
		circfill(ship.x+4, ship.y-2, ship.muzzle, 7)
	end
end

function draw_ship()
	--todo: use pal color flash when hit
	if game.life > 0 then
		if ship.invulnerable > 0 then
			if sin(t/4) < 0.5 then
				draw_ship_sprites()
			end
		else
			draw_ship_sprites()
		end
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
			sfx(1)
			ship.invulnerable = 200
			make_particle(ship.x+3, ship.y+3, true)
			make_sparkle(ship.x+3, ship.y+3, 20, 12)
			make_shwave(ship.x+3, ship.y+3, 2, 25, 7, 3.5)
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