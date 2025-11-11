function init_enemies()
	enemies = {}
	
end

function spawn_enemy(x, entype)
	local myen= make_object()
	myen.x=x
	myen.y=-8
	myen.spr=21
	myen.hp=5
	myen.ani={21,22,23,24}

	--red flame
	if entype == 2 then
		myen.spr = 148 --149
		myen.ani={148,149}
	end
	if entype == 3 then
		myen.spr = 184 --187
		myen.ani={184,185,186,187}
	end
	if entype == 4 then
		myen.spr = 208
		myen.ani={208,210}
		myen.sprw=2
		myen.sprh=2
		myen.colh=16
		myen.colw=16
	end
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

		--animate
		enem.aniframe += 0.4
		enem.spr = enem.ani[flr(enem.aniframe)]
		if flr(enem.aniframe) >= #enem.ani then
			enem.aniframe = 1
		end
		draw_object(enem)
		pal()
 	end	
end

function move_enemies()
	for enem in all(enemies) do
 		enem.y += 0.5

		if enem.y>128 then
			del(enemies, enem)
		end
 	end	
end

function spawn_wave(wave)
	for i=1,2 do
		local entype = game.wave
		spawn_enemy(rnd(120), entype)
	end
end

function next_wave()
	game.wave += 1
	if game.wave > 4 then
		game.stage = "win"
		game.lockout=t+30
		music(4)
	else
		if wave == 1 then
			music(0)
		else
			music(3)
		end
		game.wavetime = 80
		game.stage = "wavetext"
	end
	
end