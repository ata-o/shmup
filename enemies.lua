function init_enemies()
	enemies = {}
	
end

function spawn_enemy(entype, x, y, enwait)
	local myen= make_object()
	myen.x=1.5*(x-32)
	myen.y=y-66

	myen.posx=x
	myen.posy=y

	myen.sx=0
	myen.sy=0

	myen.type=entype

	myen.spr=21
	myen.hp=1
	myen.ani={21,22,23,24}

	myen.anispd=0.4

	myen.act="fly"
	myen.shakertime=0

	myen.wait=enwait

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
		animate(enem)
		draw_object(enem)
		pal()
 	end	
end

function move_enemies()
	for enem in all(enemies) do
		enemy_act(enem)
		--enem.y+=1
		
		if enem.act != "fly" then
			if enem.y>128 or enem.x<-8 or enem.x>128 then
				del(enemies, enem)
			end
		end
 	end
	picktimer()
end

function spawn_wave(wave)
	sfx(28)
	attackfreq=60
	nextfire=0
	local wave = game.wave
	if wave==1 then
		--space invaders
		placenems({
			{0,1,1,1,1,1,1,1,1,0},
			{0,1,1,1,1,1,1,1,1,0},
			{0,1,1,1,1,1,1,1,1,0},
			{0,1,1,1,1,1,1,1,1,0},
		})
	elseif wave==2 then
		--red tutorial
		placenems({
			{1,1,2,2,1,1,2,2,1,1},
			{1,1,2,2,1,1,2,2,1,1},
			{1,1,2,2,2,2,2,2,1,1},
			{1,1,2,2,2,2,2,2,1,1},
		})
	elseif wave==3 then
		--spin tutorial
		placenems({
			{3,3,0,1,1,1,1,0,3,3},
			{3,3,0,1,1,1,1,0,3,3},
			{3,3,0,1,1,1,1,0,3,3},
			{3,3,0,1,1,1,1,0,3,3},
		})
	elseif wave==4 then
 	--spin tutorial
 	
 		placenems({
			{3,3,0,1,1,1,1,0,3,3},
 			{3,3,0,1,1,1,1,0,3,3},
 			{3,3,0,1,1,1,1,0,3,3},
 			{3,3,0,1,1,1,1,0,3,3}
 	})
 	elseif wave==5 then
 	--chess
 	
 		placenems({
			{3,1,3,1,2,2,1,3,1,3},
 			{1,3,1,2,1,1,2,1,3,1},
 			{3,1,3,1,2,2,1,3,1,3},
 			{1,3,1,2,1,1,2,1,3,1}
 	})
 	elseif wave==6 then
 	--yellow tutorial
 	
 		placenems({
			{1,1,1,0,4,0,0,1,1,1},
 			{1,1,0,0,0,0,0,0,1,1},
 			{1,1,0,1,1,1,1,0,1,1},
 			{1,1,0,1,1,1,1,0,1,1}
 	})

 	elseif wave==7 then
 	--double yellow
 	
 		placenems({
			{3,3,0,1,1,1,1,0,3,3},
 			{4,0,0,2,2,2,2,0,4,0},
 			{0,0,0,2,1,1,2,0,0,0},
 			{1,1,0,1,1,1,1,0,1,1}
 		})
 	elseif wave==8 then
 	--hell
 	
 		placenems({
			{0,0,1,1,1,1,1,1,0,0},
 			{3,3,1,1,1,1,1,1,3,3},
 			{3,3,2,2,2,2,2,2,3,3},
 			{3,3,2,2,2,2,2,2,3,3}
 	})
 	elseif wave==9 then
 	--boss
 	
 		placenems({
			{0,0,0,0,0,0,0,0,0,0},
 			{0,0,0,0,4,0,0,0,0,0},
 			{0,0,0,0,0,0,0,0,0,0},
 			{0,0,0,0,0,0,0,0,0,0}
 	})
 	end
end

function	placenems(lvl)
	for y=1,4 do
		for x=1,10 do
			if lvl[y][x]!=0 then
				spawn_enemy(lvl[y][x], x*12-6, 4+y*12, x*3)
			end
		end
	end
end

function next_wave()
	game.wave += 1
	if game.wave > 9 then
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
	if enem.wait>0 then
		enem.wait -= 1
		return
	end

	if enem.act=="fly" then
		--interpolation
		--x += (targetx - x) / n
		enem.x += (enem.posx - enem.x)/8
		enem.y += (enem.posy - enem.y)/8

		
		if abs(enem.y-enem.posy) < 0.7 then
			enem.y = enem.posy
			enem.x = enem.posx

			enem.act="protec"
		end
	elseif enem.act=="protec" then
	elseif enem.act=="attac" then
		if enem.type==1 then
			enem.sy=1.7
			enem.sx=sin(t/45)
			if enem.x<32 then
				enem.x+=1-(enem.x/32)
			end

			if enem.x>88 then
				enem.x+=(enem.x-88)/32
			end
		elseif enem.type==2 then
			enem.sy=2.5
			enem.sx=sin(t/25)
			if enem.x<32 then
				enem.x+=1-(enem.x/32)
			end

			if enem.x>88 then
				enem.x-=(enem.x-88)/32
			end
		elseif enem.type==3 then
			if enem.sx==0 then
				--flying down
				enem.sy=2
				if ship.y <= enem.y then
					enem.sy=0
					if ship.x <= enem.x then
					enem.sx=-2
					else
					enem.sx=2
					end
				end
			end
		elseif enem.type==4 then
			enem.sy=0.2
			if enem.y>110 then
				enem.sy=1
			else
				if t%25==0 then
					make_ebullet_spread(enem, 8, 1.3, rnd())
				end
			end
		end
		move(enem)
	end
end

function kill_enemy(enem)
	sfx(2)
	del(enemies, enem)
	explode(enem.x+3, enem.y+4)

	if enem.act=="attac" then
		if rnd() < 0.5 then
			pick_attacker()
		end
	end
end

function picktimer()
	if game.stage != "game" then
		return
	end
	-- dice = rnd({1,2,3,4,5,6})
	--local seconds = flr(time())
	--local stuff = seconds % 60

	if t>nextfire then
		pick_fire()
		nextfire=t+20+rnd(20)
	end

	if t%attackfreq==0 then
		pick_attacker()
	end
end

function pick_fire()
	local maxnum = min(10, #enemies)

	for myen in all(enemies) do
		if myen.type==4 and rnd()<0.5 and myen.act=="protec" then
			make_ebullet_spread(myen, 8, 1.3, rnd())
		end
	end

	local ind = flr(rnd(maxnum))
	ind = #enemies - ind
	local myen = enemies[ind]

	if myen==nil then 
		return 
	end

	if myen.act=="protec" then
		if myen.type==4 then
			make_ebullet_spread(myen, 8, 1.3, rnd())
		elseif myen.type==2 then
			make_ebullet_aimed(myen, 2)
		else
			make_ebullet(myen, 0, 2)
		end
	end
end

function pick_attacker()
	local maxnum = min(10, #enemies)

	local ind = flr(rnd(maxnum))
	ind = #enemies - ind
	local myen = enemies[ind]

	if myen==nil then 
		return 
	end

	if myen.act=="protec" then
		myen.act="attac"
		myen.anispd*=3
		myen.shake=60
		myen.wait=60
	end
end