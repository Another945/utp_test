event_inherited(); // ride_init() de par_ride
visible = false;
grav = 0; // el jet flota, no cae

animation_add("intro", [0,0, 6,1, 12,2, 18,3, 24,4, 30,5, 36,6, 42,7, 48,8, 54,9], 54); // 10 frames, se congela en el 9
animation_add("stand", [0,0, 8,1, 16,2, 24,3], 0, 24); // 4 frames, loop real

enum rj_states {
	waiting     = 0,
	intro       = 1,
	player_jump = 2,
	flying      = 3,
}

jump_start_x = 0;
jump_start_y = 0;
jump_target_x = 0;
jump_target_y = 0;
jump_t = 0;
jump_duration = 20; // pasos que dura el salto — ajustable
jump_height = 40;   // altura del arco — ajustable

state_set(rj_states.waiting);