
function init_particles()
	--explods = {}
	particles = {}
end

function make_particle(x,y, isblue)
	--first big particle, then smaller ones
	local part={
		x=x,
		y=y,
		sx=0,
		sy=0,
		age=0,
		maxage=0,
		size=10,
		blue=isblue,
		spark=spark 
	}

	add(particles, part)
	for i=1,30 do
		local part={
			x=x,
			y=y,
			sx=(rnd()-0.5)*4,
			sy=(rnd()-0.5)*4,
			age=rnd(2),
			maxage=10+rnd(10),
			size=1+rnd(4),
			blue=isblue
		}

		add(particles, part)
	end
end

function particle_color(age, isblue)
	local age_colors = {
		{5, 10},
		{7, 9},
		{10, 8},
		{12, 2},
		{15, 5}
	}
	if isblue then
		age_colors = {
			{5, 6},
			{7, 12},
			{10, 13},
			{12, 1},
			{15, 1}
		}
	end
	for _, age_color in ipairs(age_colors) do
		if age > age_color[1] then
			pc = age_color[2]
		end
	end
	return pc

end

function make_sparkle(x,y, cnt, speed) 
	for i=1,cnt do
		local part={
			x=x,
			y=y,
			sx=(rnd()-0.5)*speed,
			sy=(rnd()-1)*speed,
			age=rnd(2),
			maxage=10+rnd(10),
			size=1+rnd(4),
			spark=true
		}

		add(particles, part)
	end
end

function draw_particles()
	for part in all(particles) do
		if part.spark then
			pset(part.x, part.y, 7)
		else
			circfill(part.x, part.y, part.size, particle_color(part.age, part.blue))
		end

		part.x += part.sx
		part.y += part.sy

		part.sx *= 0.85
		part.sy *= 0.85
		part.age += 1

		if part.age > part.maxage then
			part.size -= 0.5
			if part.size < 0 then
				del(particles, part)
			end
		end
	end
end

function init_shwaves()
	shwaves = {}
end

function make_shwave(x,y, r, maxr, col, speed)
	local sw={
		x=x,
		y=y,
		r=r,
		maxr=maxr,
		col=col,
		speed=speed
	}
	add(shwaves, sw)
end

function draw_shwaves()
	for sw in all(shwaves) do
		circ(sw.x, sw.y, sw.r, sw.col)
		sw.r += sw.speed
		if sw.r > sw.maxr then
			del(shwaves, sw)
		end
	end
end