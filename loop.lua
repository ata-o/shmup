function _init()
	cls(0)
	make_game()
end

function _draw()
	cls(0)
	--debug()
	if game.stage=="game" then
		draw_game()
	elseif game.stage=="start" then
		draw_start()
	elseif game.stage=="wavetext" then
		draw_wavetext()
	elseif game.stage=="over" then
		draw_gameover()
	end
end

function _update()
	if game.stage=="game" then
		t+=1
		update_game()
	elseif game.stage=="start" then
		update_start()
	elseif game.stage=="wavetext" then
		update_wavetext()
	elseif game.stage=="over" then
		update_gameover()
	end
end
