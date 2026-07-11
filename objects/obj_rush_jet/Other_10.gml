if (state != rj_states.flying) exit;

h_speed = (keyboard_check(vk_right) - keyboard_check(vk_left)) * 4;
v_speed = (keyboard_check(vk_down) - keyboard_check(vk_up)) * 4;
scr_physics_update(false);

with (obj_player_parent) {
	show_debug_message("locked: " + string(locked) + " shoot: " + string(shoot) + " shoot_t: " + string(shoot_t) + " charge: " + string(charge) + " charge_unlocked: " + string(charge_unlocked) + " charged_shots_count: " + string(charged_shots_count) + " charged_shots_limit: " + string(charged_shots_limit) + " key_h(shoot): " + string(key_shoot));

	x = other.x;
	y = other.y - 16;
	ride_char_pos.x = x;
	ride_char_pos.y = y;
	if (animation != "idle") animation_play("idle"); // o la que uses para estar de pie
	show_debug_message("current_weapon: " + string(current_weapon) + " weapon0: " + string(weapon[0]) + " key_shoot_raw: " + string(key_shoot));

	player_shoot_check();
	player_check_dolor();
}