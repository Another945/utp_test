event_inherited(); // enemy_init()

enum mb_states {
	intro = 200, // fuera del rango de boss_states (100-107) y de los ataques custom de cada hijo (0-99)
	idle  = 201,
}

// --- Compatibilidad con scr_weapon_collision ---
is_boss = true;          // i-frames tipo boss + auto state_set(boss_states.death) al morir
boss_buffer = 0;
boss_buffer_level = 0;

// --- Identidad de la pelea ---
miniboss_key = room_get_name(room) + "_" + string(object_index);
persist_defeat = true; // true = no vuelve a aparecer si ya lo mataste y reentras al room

// --- Salud ---
max_hp = 12;
hp = max_hp;
damageable = false; // se activa al terminar el intro

// --- Sistema de ataques (idéntico al de par_boss) ---
attack_properties = ds_map_create();
attack_energy = ds_map_create();
attack_object_condition = ds_map_create();
idle_limit = 40;
exit_door = noone;
death_animation = "death";
drop_hp = true;
gate_inst = noone;

if (persist_defeat && ds_map_exists(global.miniboss_defeated, miniboss_key)) {
	instance_destroy();
	exit;
}
exit_door = noone;
state_set(mb_states.intro, 0, [0,0,0,0,0]);
if (exit_door != noone) exit_door.locked_by_boss = true;