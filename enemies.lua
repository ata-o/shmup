function init_enemies()
	enemies = {}
	 for i=1,2 do
		spawn_enemy(0+(i*20))
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

function spawn_wave(wave)
	for i=1,2 do
		spawn_enemy(rnd(120))
	end
end

function next_wave()
	game.wave += 1
	if game.wave > 4 then
		game.stage = "win"
	else
		game.wavetime = 80
		game.stage = "wavetext"
	end
	
end