var cam_right = camera_get_view_x(view_camera[0]) + camera_get_view_width(view_camera[0]);

switch (state) {

	case e_sky.spread_shot:
		x = cam_right - screen_offset_x; // sigue anclado, es un ataque a distancia
		if (t == 0) {
			animation_play("attack");
			look_at_player();
		}
		if (t == 12) {
			for (var i = -1; i <= 1; i++) {
				var s = instance_create_depth(x - 16, y, depth - 1, obj_miniboss_sky_shot);
				s.h_speed = -3;
				s.v_speed = i * 2;
			}
		}
		if (t >= 30) state_set(mbf_states.idle);
	break;

	case e_sky.dash_charge:
		if (t == 0) {
			animation_play("dash");
			return_y = y; // recuerda su altura para volver después
		}
		if (t < 15) {
			// Fase 1: se lanza hacia el jugador (rompe el anclaje a cámara)
			var dir_to_player = sign(obj_player_parent.x - x);
			var dir_y = sign(obj_player_parent.y - y);
			h_speed = dir_to_player * dash_speed;
			v_speed = dir_y * (dash_speed * 0.5);
		} else if (t < 40) {
			// Fase 2: vuelve a su carril y altura, cerca del borde de cámara
			var target_x = cam_right - screen_offset_x;
			h_speed = sign(target_x - x) * dash_return_speed;
			v_speed = sign(return_y - y) * dash_return_speed;
		} else {
			h_speed = 0;
			v_speed = 0;
			x = cam_right - screen_offset_x;
			y = return_y;
			state_set(mbf_states.idle);
		}
	break;
}