function init_enemies()
	enemies = {}
	
end

function spawn_enemy(entype, x, y)
	local myen= make_object()
	myen.x=x
	myen.y=y-66

	myen.posx=x
	myen.posy=y

	myen.spr=21
	myen.hp=1
	myen.ani={21,22,23,24}
	myen.act="fly"

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
		enemy_act(enem)
		--enem.y+=1
		if enem.y>128 then
			del(enemies, enem)
		end
 	end	
end

function spawn_wave(wave)
	local entype = game.wave
	if entype==1 then
		placenems({
			{0,1,1,1,1,1,1,1,1,0},
			{0,1,1,1,1,1,1,1,1,0},
			{0,1,1,1,1,1,1,1,1,0},
			{0,1,1,1,1,1,1,1,1,0},
		})
	elseif entype==2 then
		placenems({
			{1,1,2,2,1,1,2,2,1,1},
			{1,1,2,2,1,1,2,2,1,1},
			{1,1,2,2,2,2,2,2,1,1},
			{1,1,2,2,2,2,2,2,1,1},
		})
	elseif entype==3 then	
		placenems({
			{3,3,0,2,2,2,2,0,3,3},
			{3,3,0,2,2,2,2,0,3,3},
			{3,3,0,2,2,2,2,0,3,3},
			{3,3,0,2,2,2,2,0,3,3},
		})
	elseif entype==4 then
		placenems({
			{0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,4,0,0,0,0,0},
			{0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,0,0,0,0,0,0},
		})
	end
end

function placenems(lvl)
	for y=1,4 do
		for x=1,10 do
			if lvl[y][x]!=0 then
				spawn_enemy(lvl[y][x], x*12-6, 4+y*12)
			end
		end
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

function enemy_act(enem)
	if enem.act=="fly" then
		enem.y += 1
		if enem.y>=enem.posy then
			enem.act="protec"
		end
	elseif enem.act=="protec" then
	elseif enem.act=="attac" then
	end
end