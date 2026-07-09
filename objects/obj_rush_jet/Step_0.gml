t = state_timer++;
animation_update(true); // faltaba esto — sin esto, la animación nunca avanza de frame

switch (state) {

	case rj_states.waiting:
		// espera a que el trigger lo active
	break;

	case rj_states.intro:
		if (t == 0) {
			visible = true;
			sprite_index = spr_rush_jet_intro;
			animation_play("intro");
		}
		if (t == 60) { // 54 (último frame) + un pequeño margen antes de saltar
			state_set(rj_states.player_jump);
		}
	break;

	case rj_states.player_jump:
		if (t == 0) {
			jump_target_x = x;
			jump_target_y = y - 20; // ajusta según la altura real del sprite del jet
			jump_start_x = obj_player_parent.x;
			jump_start_y = obj_player_parent.y;
			with (obj_player_parent) {
				state_set(states.jump);
			}
		}
		jump_t++;
		var progress = clamp(jump_t / jump_duration, 0, 1);
		with (obj_player_parent) {
			x = lerp(other.jump_start_x, other.jump_target_x, progress);
			y = lerp(other.jump_start_y, other.jump_target_y, progress) - (sin(progress * pi) * other.jump_height);
		}
		if (progress >= 1) {
		with (obj_player_parent) {
	h_speed = 0; v_speed = 0;
	locked = false; // ← faltaba esto — sin esto, ni siquiera se lee el input de disparo
	ride_inst = other.id;
	ride_char_pos = { x: x, y: y };
	state_set(states.ride, 0, [0,0,0,0,0]);

}
			sprite_index = spr_rush_jet_stand;
			animation_play("stand");
			state_set(rj_states.flying);
		}
	break;

	case rj_states.flying:
	// el movimiento real corre en Other_10 (event_user(0)), disparado por states.ride del jugador
break;
}