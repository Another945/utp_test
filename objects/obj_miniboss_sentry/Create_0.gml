event_inherited(); // par_miniboss

max_hp = 12;
hp = max_hp;
idle_limit = 40;

dash_speed = 6;
dash_wait = 10;
dash_limit = 40;

animation_add("idle",  [0, 0], 0);
animation_add("intro", [0, 1, 10, 2, 20, 0], 20);
animation_add("dash",  [0, 3, 6, 4], 6);
animation_add("shot",  [0, 5, 12, 6, 24, 0], 24);
animation_add("death", [0, 8], 0);

// Enum propio para sus ataques (rango bajo, no choca con boss_states ni con mb_states)
enum e_sentry {
	dash_attack,
	shot_burst
}

attack_properties[? e_sentry.dash_attack] = [1,   1/3]; // caro: se recupera lento
//attack_properties[? e_sentry.shot_burst]  = [1/2, 1/4]; // barato: se puede repetir seguido