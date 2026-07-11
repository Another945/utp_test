if (active && instance_exists(obj_player_parent) && obj_player_parent.state == states.death) {
	active = false;
	global.autoscroll_active = false;
}

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

var cam_left = camera_get_view_x(view_camera[0]);
var cam_width = camera_get_view_width(view_camera[0]);

if (instance_exists(obj_rush_jet)) {
	with (obj_rush_jet) {
		var target_x = clamp(x, cam_left + other.edge_margin, cam_left + cam_width - other.edge_margin);
		var dx = target_x - x;
		if (dx != 0) {
			var moved = move_x(dx);
			if (!moved) {
				with (obj_player_parent) {
					player_state_set(states.death, 0, [0,0,0,0,0]);
				}
			}
		}
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