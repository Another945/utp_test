show_debug_message("autoscroll zone step - active: " + string(active) + " player exists: " + string(instance_exists(obj_player_parent)));
if (!active) {
	if (instance_exists(obj_player_parent)
	&& point_in_rectangle(obj_player_parent.x, obj_player_parent.y, bbox_left, bbox_top, bbox_right, bbox_bottom)) {
		active = true;
		global.current_camera = id; // toma el control, ninguna otra zona puede pisarlo
	}
	exit;
}

// Empuja el rango de cámara hacia la derecha cada paso — obj_camera_rds ya está
// forzado a seguir esto por su propio clamp (min_x - XView > 0 => ox positivo)
global.camera_min_x += scroll_speed;
global.camera_max_x += scroll_speed;

// Si el jugador se queda atrás del borde izquierdo de cámara, recibe daño
if (instance_exists(obj_player_parent)) {
	var cam_left = camera_get_view_x(view_camera[0]);
	if (obj_player_parent.x < cam_left + edge_margin) {
		if (edge_damage_cooldown <= 0) {
			with (obj_player_parent) {
				dolor_damage = other.edge_damage;
				player_state_set(states.dolor, 0, [0,0,0,0,0]);
			}
			edge_damage_cooldown = 30;
		}
	}
}
if (edge_damage_cooldown > 0) edge_damage_cooldown--;