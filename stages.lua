
function draw_game()
		draw_background()
		draw_ship()
		draw_bullets()
		draw_enemies()
		draw_particles()
		draw_shwaves()
		draw_ui()
end

function update_game()
		game.blinkt+=1
		t+=1
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
	print("shoot 'em bb", 40, 45, blink())
	print("press ❎ key to start", 20, 80, blink())
end

function update_start()
	if btn(4) == false and btn(5) == false then
		btnreleased = true
	end
	if btnreleased  then
		if btnp(4) or btnp(5) then
			--music(-1, 3000)
			btnreleased = false
			start_game()
			game.wave=0
			next_wave()
		end
	end
end

function draw_wavetext()
	draw_game()
	print("wave ".. game.wave, 56, 40, blink())
end

function update_wavetext()
	update_game()
	game.wavetime -= 1
	if game.wavetime <= 0 then
		game.stage="game"
		spawn_wave(game.wave)
	end
end

function draw_gameover()
	cls(8)
	print("game over!", 45, 45,6)
	print("final score: ".. game.score, 30, 60, 6)
	print("press ❎ key to restart", 20, 80, blink())

end

function update_gameover()
	if btn(4) == false and btn(5) == false then
		btnreleased = true
	end
	if btnreleased  then
		if btnp(4) or btnp(5) then
			btnreleased = false
			--music(0)
			start_game()
		end
	end
end

function draw_win()
	cls(3)
	print("congratulations!", 30, 45,6)
	print("final score: " .. game.score, 30, 60, 6)
	print("press any key to restart", 20, 80, blink())
end

function update_win()
	if btn(4) == false and btn(5) == false then
		btnreleased = true
	end
	if btnreleased  then
		if btnp(4) or btnp(5) then
			btnreleased = false
			--music(0)
			start_game()
		end
	end
end

function start_game()
	game.stage="start"

	game.score = 0
	game.life = game.maxlife
	game.blinkt = 1
 	make_background()
	make_ship()
	init_bullets()
	init_enemies()
	init_particles()
	init_shwaves()
end

function blink() 
	local banim = {5,5,5,5,5,5,5,5,5,5,5,6,6,7,7,6,6,5}

	if game.blinkt > #banim then
		game.blinkt = 1
	end

	return banim[game.blinkt]
end