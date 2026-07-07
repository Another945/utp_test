if (should_be_destroyed) {
	with (obj_player_parent) {
		locked = false;
	}
	if (exit_door != noone) exit_door.locked_by_boss = false;
	music_play(global.stage_music);
	instance_destroy(self, false); // false = no dispara el evento Destroy (sin explosión/sonido)
	exit;
}
// Mismo guard que par_boss: deja correr el step durante la pausa de muerte de boss
if (global.paused && global.pause_type != pause_types.boss_death) exit;
event_inherited(); // física base de par_enemy

t = state_timer++;

switch (state) {
case mb_states.warning:
	if (!warning_created) {
		warning_created = true;
		var _wx = camera_get_view_x(view_camera[0]) + camera_get_view_width(view_camera[0]) / 2;
		var _wy = camera_get_view_y(view_camera[0]) + camera_get_view_height(view_camera[0]) / 2 - 40;
		var _w = instance_create_depth(_wx, _wy, depth - 10, obj_warning);
		_w.boss_inst = id;
	}
	if (warning_done) {
		visible = true;
		state_set(mb_states.falling);
	}
break;
case mb_states.falling:
	if (t == 0) {
		damageable = false;
		sprite_index = sprite_stand;
		animation_play("stand");
		if (exit_door != noone) exit_door.locked_by_boss = true;
	}
	if (is_on_floor()) {
		v_speed = 0;
		state_set(mb_states.intro);
	}
break;

case mb_states.intro:
	if (t == 0) {
		sprite_index = sprite_intro;
		animation_play("boss_intro");
	}
	if (t == 180) { // 60 para llegar al último frame + 120 (2 seg a 60fps) sostenido ahí
		sprite_index = sprite_battle;
		damageable = true;
		with (obj_player_parent) {
			locked = false;
		}
		state_set(mb_states.idle);
	}
break;

	case mb_states.idle:
		if (t == 0) animation_play("idle");
		look_at_player();
		if (t >= idle_limit) {
			boss_choose_attack(); // salta directo al estado de ataque elegido por el hijo
		}
	break;

	case boss_states.death:
	if (t == 0) {
		damageable = false;
		h_speed = 0; v_speed = 0;
		animation_play(death_animation);
		audio_play(snd_boss_explosion_x1);
		if (persist_defeat) global.miniboss_defeated[? miniboss_key] = true;
	}
	if (t >= 5 && t <= 35 && (t mod 4 == 0)) {
	instance_create_depth(x + irandom_range(-20, 20), y + irandom_range(-20, 20), depth - 1, explode_FX);
}
	if (t == 10) {
	audio_resume_all();
	pause_set(false);
	music_play(global.stage_music);
	if (exit_door != noone) exit_door.locked_by_boss = false;
	with (obj_player_parent) {
		immortal = false;
	}
}
	if (t == 40 && drop_hp) {
		for (var i = 0; i < 3; i++) {
			var inst = instance_create_depth(x + irandom_range(-16, 16), y, depth - 1, obj_pickup_heart);
			inst.v_speed = -3 - random(2);
			inst.h_speed = irandom_range(-2, 2);
		}
	}
	if (t == 60) instance_destroy();
break;

	default:
		event_user(1); // el hijo maneja aquí sus propios ataques (igual que obj_chill_penguin)
}