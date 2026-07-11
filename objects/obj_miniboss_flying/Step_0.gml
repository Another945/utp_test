if (global.paused && global.pause_type != pause_types.boss_death) exit;
event_inherited(); // par_enemy (física base; con grav=0 no cae)

t = state_timer++;
var cam_right = camera_get_view_x(view_camera[0]) + camera_get_view_width(view_camera[0]);

switch (state) {

	case mbf_states.waiting:
		if (cam_right + screen_offset_x >= x) {
			state_set(mbf_states.intro);
		}
	break;

	case mbf_states.intro:
		if (t == 0) {
			damageable = false;
			animation_play("intro");
		}
		x = cam_right - screen_offset_x;
		if (t == 40) {
			damageable = true;
			state_set(mbf_states.idle);
		}
	break;

	case mbf_states.idle:
		x = cam_right - screen_offset_x;
		if (t == 0) animation_play("idle");
		if (t >= idle_limit && !ds_map_empty(attack_properties)) {
			boss_choose_attack();
		}
	break;

	case boss_states.death:
		if (t == 0) {
			damageable = false;
			animation_play("death");
			audio_play(snd_boss_explosion_x1);
		}
		if (t >= 5 && t <= 35 && (t mod 4 == 0)) {
			instance_create_depth(x + irandom_range(-20,20), y + irandom_range(-20,20), depth - 1, explode_FX);
		}
		if (t == 60) instance_destroy();
	break;

	default:
		event_user(1); // el hijo maneja sus ataques, igual que el resto de bosses
}