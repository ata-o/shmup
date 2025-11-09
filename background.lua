function make_background()
	stars = {}
	for i=1, 50 do
		local elem = {
			x = flr(rnd(128)),
			y = flr(rnd(128)),
			spd = rnd(1.2)+0.2
		}
		
		if elem.spd < 0.75 then
			elem.col = 1
		elseif elem.spd < 1 then
		 elem.col = 5
		 elseif elem.spd < 1.25 then
		 elem.col = 6
		else
		 elem.col = 7
		end
		
		add(stars, elem)
	end
end

function draw_background()
	for star in all(stars) do
		--if star.spd < 1.5 then
		--	pset(star.x, star.y, star.col)
		--else
		--	line(star.x, star.y, star.x, star.y-2, star.col)
		--end
		pset(star.x, star.y, star.col)
		
		if star.y >= 128 then
			star.y = 0
		end
			star.y += star.spd
	end
end