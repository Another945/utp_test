if (!triggered && place_meeting(x, y, obj_player_parent)) {
	triggered = true;
	with (obj_player_parent) { locked = true; }
	var r = instance_nearest(x, y, obj_rush_jet);
	show_debug_message("rush jet encontrado: " + string(r != noone) + " - id: " + string(r));
	with (r) { state_set(rj_states.intro, 0, [0,0,0,0,0]); }
}