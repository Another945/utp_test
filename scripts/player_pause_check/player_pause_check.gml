function player_pause_check() {
	if (key_p_start) {
		play_sound(pause_open)
		if (G.pause_type != pause_types.door) {
			pause_set(!global.paused, pause_types.normal);
		}
	}


}
