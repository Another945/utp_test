event_inherited(); // enemy_init()

sprite_battle = sprite_index; // el sprite que le pusiste al objeto en el editor (para idle/dash/shot/death)
enum mb_states {
	warning = 198, // nuevo: antes de caer
	falling = 199,
	intro   = 200,
	idle    = 201,
}

warning_done = false;
warning_created = false;
visible = false; // el boss no se ve hasta que termine el aviso

sprite_stand = sprite_index; // el hijo lo sobrescribe con su spr_..._stand
sprite_intro = sprite_index; // el hijo lo sobrescribe con su spr_..._intro

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

should_be_destroyed = (persist_defeat && ds_map_exists(global.miniboss_defeated, miniboss_key));

state_set(mb_states.warning, 0, [0,0,0,0,0]);
