event_inherited(); // enemy_init()
is_boss = true;
boss_buffer = 0;
boss_buffer_level = 0;
grav = 0; // vuela, no cae

max_hp = 20;
hp = max_hp;
damageable = false;

attack_properties = ds_map_create();
attack_energy = ds_map_create();
attack_object_condition = ds_map_create();
idle_limit = 50;

screen_offset_x = 200; // qué tan atrás del borde derecho de cámara se ancla durante la pelea

enum mbf_states {
	waiting = 0, // fuera de pantalla, esperando a que el auto-scroll lo alcance
	intro   = 1,
	idle    = 2,
}
state_set(mbf_states.waiting, 0, [0,0,0,0,0]);