switch (state) {
	case mb_states.idle:
	if (t == 0) animation_play("idle");
	look_at_player();
	if (t >= idle_limit && !ds_map_empty(attack_properties)) {
		boss_choose_attack();
	}
break;

	case e_sentry.dash_attack:
		if (t == 0) {
			animation_play("dash");
			look_at_player();
		}
		if (t == dash_wait) {
			h_speed = dir * dash_speed;
		}
		if (t > dash_wait && (!can_move_x(h_speed) || t >= dash_wait + dash_limit)) {
			h_speed = 0;
			state_set(mb_states.idle);
		}
	break;
	case e_sentry.shot_burst:
	if (t == 0) {
		animation_play("shot");
		look_at_player();
		h_speed = 0;
	}
	if (t == 8 || t == 14 || t == 20) {
		var shot = instance_create_depth(x + 16*dir, y - 4, depth - 1, obj_miniboss_sentry_shot);
		shot.dir = dir;
		shot.xscale = -dir;
		var vs = 0;
		if (t == 8) vs = -2;
		else if (t == 20) vs = 2;
		shot.v_speed = vs;
		shot.h_speed = 4 * dir;
	}
	if (t >= 30) state_set(mb_states.idle);
break;
}
