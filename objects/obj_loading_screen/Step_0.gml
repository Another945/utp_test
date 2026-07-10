show_debug_message("loading phase: " + string(phase) + " timer: " + string(timer));
timer++;
spin_angle -= 6;

switch (phase) {
	case loading_phase.wait:
		if (timer >= wait_time) {
			phase = loading_phase.showing;
			timer = 0;
		}
	break;
	case loading_phase.showing:
		if (timer >= show_time) {
			room_goto(global.loading_next_room);
		}
	break;
}