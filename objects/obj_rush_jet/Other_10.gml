if (state != rj_states.flying) exit;

h_speed = (keyboard_check(vk_right) - keyboard_check(vk_left)) * 4;
v_speed = (keyboard_check(vk_down) - keyboard_check(vk_up)) * 4;
scr_physics_update(false);

with (obj_player_parent) {
	x = other.x;
	y = other.y - 16;
	ride_char_pos.x = x;
	ride_char_pos.y = y;
	if (animation != "idle") animation_play("idle"); // o la que uses para estar de pie
	player_shoot_check();
}