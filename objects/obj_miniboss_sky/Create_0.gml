event_inherited(); // obj_miniboss_flying

max_hp = 20;
hp = max_hp;
idle_limit = 50;
screen_offset_x = 220; // qué tan atrás del borde derecho se ancla

dash_speed = 7;
dash_return_speed = 4;
return_y = 0; // se calcula al empezar la embestida

animation_add("intro",  [0,0, 10,1, 20,2], 30);
animation_add("idle",   [0,3, 12,4], 0, 12);
animation_add("attack", [0,5, 8,6, 16,5], 16);
animation_add("dash",   [0,7], 0);
animation_add("death",  [0,8], 0);

enum e_sky {
	spread_shot,
	dash_charge
}

attack_properties[? e_sky.spread_shot] = [1/2, 1/4]; // barato, frecuente
attack_properties[? e_sky.dash_charge] = [1,   1/3]; // caro, ocasional