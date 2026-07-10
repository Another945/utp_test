with (obj_player_parent) {
	dest_x = x + (walk_speed * 130);
	walking_to_x = true;
}

global.loading_next_room = rm_test_slopes2; // la room REAL final

var t = instance_create_depth(0, 0, -10000, obj_transition_effect);
t.transition_type = transition_types.clock_wipe;
t.transition_limit = 120;
t.color = c_black;
t.next_room = rm_loading; // primero vamos a la room de carga