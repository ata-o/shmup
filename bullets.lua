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

function make_ebullet(enem)
	local ebul = make_object()
	ebul.x=enem.x
	ebul.y=enem.y
	ebul.spr=48
	ebul.ani={48,49,50,49}
	ebul.anispd=0.5
	ebul.sy=1
	ebul.colw=6
	ebul.colh=6
	
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