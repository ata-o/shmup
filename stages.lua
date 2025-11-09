
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

function draw_wavetext()
	draw_game()
	print("wave ".. game.wave, 40, 60)
end

function update_wavetext()
	update_game()
end

function draw_gameover()
	cls(8)
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
	game.wave=1
 	game.stage="wavetext"
	game.score = 0
	game.life = game.maxlife
 	make_background()
	make_ship()
	init_bullets()
	init_enemies()
	init_particles()
	init_shwaves()
end