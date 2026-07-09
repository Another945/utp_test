show_debug_message("autoscroll zone step - active: " + string(active) + " player exists: " + string(instance_exists(obj_player_parent)));

if (!active) {
	if (instance_exists(obj_player_parent)
	&& point_in_rectangle(obj_player_parent.x, obj_player_parent.y, bbox_left, bbox_top, bbox_right, bbox_bottom)) {
		active = true;
		global.current_camera = id;
		global.autoscroll_active = true;
		global.autoscroll_target_x = camera_get_view_x(view_camera[0]);
	}
	exit;
}

// Empuja el scroll hacia la derecha cada paso, a velocidad fija
global.autoscroll_target_x += scroll_speed;

show_debug_message("autoscroll_active: " + string(global.autoscroll_active) + " target_x: " + string(global.autoscroll_target_x) + " real XView: " + string(camera_get_view_x(view_camera[0])));

var cam_left = camera_get_view_x(view_camera[0]);
var cam_width = camera_get_view_width(view_camera[0]);

if (instance_exists(obj_rush_jet)) {
	// Montado en el Rush Jet: la cámara lo confina dentro de todo lo visible
	with (obj_rush_jet) {
		x = clamp(x, cam_left + other.edge_margin, cam_left + cam_width - other.edge_margin);
	}
} else if (instance_exists(obj_player_parent)) {
	// A pie (sin jet): mantiene el daño por quedarse atrás
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