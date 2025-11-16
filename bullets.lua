function make_bullet(cnt)
	bullet_count = flr(cnt/2)
	for i=-bullet_count, bullet_count do
		local bul = make_object()
		bul.x=ship.x+1
		bul.y=ship.y-5
		bul.speed=5
		bul.spr=32
		bul.orient=i
		bul.colw=6
		bul.bulmode=true
		add(bullets, bul)
	end
end

function make_ebullet_spread(enem, num, spd, base)
	--360/8 -> 1/8
	if base==nil then
		base=0
	end
	for i=1,num do
		make_ebullet(enem, 1/num*i+base, spd)
	end
end

function make_ebullet(enem, ang, spd)
	local ebul = make_object()
	ebul.x=enem.x+3
	ebul.y=enem.y+3

	if enem.type==4 then
		ebul.x=enem.x + 7
		ebul.y=enem.y + 13
	end
	ebul.spr=48
	ebul.ani={48,49,50,49}
	ebul.anispd=0.5
	
	ebul.sx=sin(ang)*spd
	ebul.sy=cos(ang)*spd

	ebul.colw=2
	ebul.colh=2
	ebul.bulmode=true
	
	enem.flash=3
	add(ebullets, ebul)
	sfx(29)
end

function init_bullets()
	bullets={}
	ebullets={}
end

function draw_bullets()
	for bul in all(bullets) do
		draw_object(bul)
 	end
	for bul in all(ebullets) do
		animate(bul)
		draw_object(bul)
 	end
end

function move_bullets()
	for bul in all(bullets) do
		bul.y -= bul.speed
		bul.x += bul.orient * (bul.speed/8)

 		if bul.y < -8 or bul.x < -8 or bul.x > 127 then
			del(bullets, bul)
		end
 	end

	for bul in all(ebullets) do
		move(bul)
		if bul.y < -8 or bul.x < -8 or bul.x > 127 or bul.y<-8  then
			del(ebullets, bul)
		end
	end
end