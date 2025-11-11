function make_bullet(cnt)
	bullet_count = flr(cnt/2)
	for i=-bullet_count, bullet_count do
		local bul = make_object()
		bul.x=ship.x
		bul.y=ship.y-5
		bul.speed=5
		bul.spr=32
		bul.orient=i
		add(bullets, bul)
	end
end

function init_bullets()
	bullets={}
end

function draw_bullets()
	for bul in all(bullets) do
		draw_object(bul)
 	end
end

function move_bullets()
	for bul in all(bullets) do
		bul.y -= bul.speed
		bul.x += bul.orient * (bul.speed/8)
	
		--bul.spr += 1
		--if bul.spr > 36 then
		--	bul.spr = 32
		--end

 		if bul.y < -8 or bul.x < -8 or bul.x > 127 then
			del(bullets, bul)
		end
 	end
end