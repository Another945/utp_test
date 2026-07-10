
// =========================
// PANEL ANIMATION
// =========================
global.tv_effect = false;
select_sound_played = false;
panel_scale_y = 0;
panel_open = false;
panel_speed = 0.12;
panel_closing = false;
panel_close_speed = 0.15;
// Scanline transition
scan_active = false;
scan_y = 0;
scan_speed = 18;
scan_alpha = 0;
// Dificultad / Clase
diff_classes = ["B","S","SA"];
diff_descriptions = [
    "DIFICULTAD NORMAL\nPARA UNA MEJOR\nEXPERIENCIA.",
    "DIFICULTAD DIFICIL\nPARA JUGADORES\nEXPERIMENTADOS.",
    "DIFICULTAD EXTREMA\nPARA JUGADORES\nMUY EXPERIMENTADOS."
];
diff_selected = 0;
diff_slide_x = 0;      // offset del personaje al deslizarse
diff_slide_speed = 8;
diff_sliding = false;
// =========================
// ENUMS
// =========================
enum menu_states {
    main, game_mode, difficulty_mode, player_select, armor_select,
    multiplayer, option, key_config, stage_select, boss_intro,
    audio_settings, voice_language, weapon_get, volume
}

enum background_select {
    intro, middle, ending
}

// =========================
// STATE
// =========================
state = menu_states.main;
state_timer = 0;
substates = [0, 0, 0, 0];
changed_state = false;

// =========================
// STAGE
// =========================
stage = background_select.intro;
stage_phase = 0;

// =========================
// TIMERS
// =========================
timer = 0;
item_blink_t = 0;
input_timer = 0;
wait_t = 0;

// =========================
// TRANSITION
// =========================
transition_create(transition_types.fade_in);

// =========================
// TITLES
// =========================
titles[menu_states.main] = "";
titles[menu_states.game_mode] = _("MODO DE JUEGO");
titles[menu_states.difficulty_mode] = _("ELIJE TU DIFICULTAD");
titles[menu_states.player_select] = _("SELECCION DE JUGADOR");
titles[menu_states.option] = _("OPCIONES");
titles[menu_states.key_config] = _("CONTROLES");
titles[menu_states.audio_settings] = _("AUDIO");
titles[menu_states.voice_language] = _("VOCES");
titles[menu_states.weapon_get] = "";
titles[menu_states.volume] = _("CONTROL DE VOLUMEN");

// =========================
// MAIN
// =========================
page_items[menu_states.main] = [
    [_("EMPEZAR"), [92,136,144,20]],
    [_("OPCIONES"), [92,160,144,20]],
    [_("SALIR"), [92,184,144,20]]
];

// =========================
// GAME MODE
// =========================
page_items[menu_states.game_mode] = [
    [_("UN JUGADOR"), [92,88,144,20]]
];

// =========================
// DIFFICULTY
// =========================
page_items[menu_states.difficulty_mode] = [
    [_("FACIL"), [92,88,144,20]],
    [_("NORMAL"), [92,112,144,20]],
    [_("DIFICIL"), [92,136,144,20]]
];

// =========================
// SETTINGS
// =========================
enum e_settings { window_size }

var wsize_options = [];
var k = 0;

while ((k+1)*global.view_height + 40 <= global.screen_height) {
    wsize_options[k] = "x" + string(k+1);
    k++;
}

wsize_options[k] = "PANTALLA COMPLETA";
wsize_options[k+1] = "ESTRECHO";
global.fullscreen_index = k+1;
global.wsize_options = wsize_options; // ← aquí
if (G.mobile) {
    wsize_options = ["NORMAL","ESTRECHO"];
    global.fullscreen_index = 1;
}

page_items[menu_states.option] = [
    [_("TAMAÑO DE PANTALLA"), [64,64,200,20], wsize_options],
    [_("CONTROLES"), [64,88,144,20]],
    [_("AUDIO"), [64,112,144,20]],
    [_("EFECTO TV"), [64,136,144,20], ["OFF", "ON"]], // ← nuevo
    [_("ATRAS"), [64,160,144,20]]
];
settings_load();
settings_apply();

// =========================
// PLAYER SELECT
// =========================
page_items[menu_states.player_select] = [
    "X","ZERO","AXL","IRIS","VILE","MEGAMAN"
];

global.golden_armor_enabled = false;

// =========================
// KEY CONFIG
// =========================
page = [["",[]]];
alength = array_length(global.key_text);

for (var i = 0; i < alength; i++) {
    page[i+1] = [
        _(global.key_text[i]),
        [],
        [key_to_string(global.key_config[i]), gamepad_to_string(global.gamepad_config[i])]
    ];
}

gamepad_movement_mode_text[0] = "Directional";
gamepad_movement_mode_text[1] = "Joystick";

page[alength+1] = [_("ATRAS"), [128,32+14*(alength+1),128,24]];

page_items[menu_states.key_config] = page;

// =========================
// STAGE SELECT
// =========================
page_items[menu_states.stage_select] = [];

stage_select_positions = [
    [19,18],[67,18],[140,11],[213,18],[261,18],
    [19,182],[67,182],[140,189],[213,182],[261,182]
];

// =========================
// AUDIO
// =========================
page_items[menu_states.audio_settings] = [
    [_("LENGUAJE DE VOZ"), [64,64,144,20]],
    [_("VOLUMEN"), [64,88,144,20]],
    [_("ATRAS"), [64,112,144,20]]
];

page_items[menu_states.voice_language] = [];

page_items[menu_states.volume] = [
    [_("EFECTOS"), [64,64,144,20]],
    [_("MUSICA DE FONDO"), [64,88,144,20]],
    [_("ATRAS"), [64,112,144,20]]
];

// =========================
// WEAPON GET
// =========================
weapon_get_props = {
    player: {
        x:320,y:0,
        move_from:{x:-320,y:0},
        move_to:{x:40,y:0,interval:[0,60]},
        new_weapon:weapons.homing_torpedo,
        wp_slot:2,
        visible:false,
        palette_array:[0,0,0,0,0,0],
        palette_sprite:noone,
        palette_index:0,
        palette_swap:false
    },
    blink_limit:75,
    dark_limit:120,
    instances:[]
};

// =========================
// BOSS INTRO
// =========================
enum boss_intros { eclipse }
boss_intro[boss_intros.eclipse] = boss_intro_eclipse;

// =========================
// MENU CONTROL
// =========================
items = page_items[menu_states.main];
items_length = array_length(items);

selected_item = 0;
selected_item_next = 0;
item_y = 0;

sound = false;

// =========================
// INPUT
// =========================
inputting = true;
hinput = false;
vinput = false;
hinput_p = false;
vinput_p = false;
enter = false;

key_left = false;      key_p_left = false;
key_right = false;     key_p_right = false;
key_up = false;        key_p_up = false;
key_down = false;      key_p_down = false;
key_jump = false;      key_p_jump = false;
key_dash = false;      key_p_dash = false;
key_shoot = false;     key_p_shoot = false;
key_shoot2 = false;    key_p_shoot2 = false;
key_special = false;   key_p_special = false;
key_wp1 = false;       key_p_wp1 = false;
key_wp2 = false;       key_p_wp2 = false;
key_start = false;     key_p_start = false;

scr_keys_reset();

// =========================
// BUTTONS
// =========================
buttons = ds_list_create();
btn_length = 0;

// =========================
// PALETTE
// =========================
palette_init();

// =========================
// BACKGROUND
// =========================
layer_id = layer_get_id("BG");
layer_bg = layer_background_get_id(layer_id);

// =========================
// BOSS DATA
// =========================
boss_intro_sprite = noone;
boss_intro_index = 0;
boss_inst = noone;
boss_object = noone;
boss_room = noone;

boss_name = "";
boss_name_show = false;
boss_defeated = false;

loading_text = "";
activate_sprites = true;
diff_title = "SELECCIONAR CLASE";
// =========================
// LOGO ANIMATION (defaults)
// =========================
intro_playing = false;
music_intro_done = true;
music_check_delay = 0;
reveal = 0;
reveal_speed = 0.02;
glitch_timer = 0;
glitch_offset = 0;
flash = 0;
flash_done = false;
glow_phase = 0;
logo_frame = 0;

// =========================
// FORCE STATE / MAIN INIT
// =========================
if (global.start_menu_force_state) {
    global.start_menu_force_state = false;
    state = global.start_menu_state;
    state_timer = 0;
    changed_state = true;
    items = page_items[state];
    items_length = array_length(items);
    selected_item = selected_item_next;
    selected_item_next = 0;
    activate_sprites = true;
} else if (state == menu_states.main) {
    music_play("tittlethemenew");
    intro_playing = true;
    music_intro_done = false;
    music_check_delay = 10;
}

// =========================
// CHARACTER SELECT SPRITES
// =========================
global.char_select_sprites = [
    spr_player_x, spr_player_zero, spr_player_axl,
    spr_player_iris, spr_player_vile, spr_player_megaman
];

background_index = 0;

animation2_init();
can_activate_sprites = true;

for (var i = 0; i <= P_EXT4; i++) {
    armor[i] = "";
    tmp_armor[i] = "";
    armor_index[i] = 0;
    tmp_armor_index[i] = 0;
}

var index = global.character_selected_index[0];
armor = global.player_character_armor[index];
armor_index = global.player_character_armor_index[index];

menu_edge_init();
menu_armor_load(0);
menu_player_select_sprites_load();
// =========================
// CURTAIN EFFECT
// =========================
curtain_active = false;
curtain_t = 0;
curtain_duration = 20;
curtain_dark = false; // true = semitransparente (player select)
// ── FONDO CIRCUITO ──────────────────────────
var _cols = 10;
var _rows = 8;
circuit_cols = _cols;
circuit_rows = _rows;
circuit_cell_w = room_width  / (_cols - 1);
circuit_cell_h = room_height / (_rows - 1);

// Nodos: posición con pequeño offset aleatorio
circuit_nodes = array_create(_cols * _rows);
for (var r = 0; r < _rows; r++) {
    for (var c = 0; c < _cols; c++) {
        var _nx = c * circuit_cell_w + irandom_range(-6, 6);
        var _ny = r * circuit_cell_h + irandom_range(-6, 6);
        circuit_nodes[r * _cols + c] = [_nx, _ny];
    }
}

// Segmentos horizontales y verticales
circuit_segs = [];
var _si = 0;
for (var r = 0; r < _rows; r++) {
    for (var c = 0; c < _cols - 1; c++) {
        circuit_segs[_si++] = [r * _cols + c, r * _cols + c + 1, 0, random(1)];
    }
}
for (var r = 0; r < _rows - 1; r++) {
    for (var c = 0; c < _cols; c++) {
        circuit_segs[_si++] = [r * _cols + c, (r+1) * _cols + c, 0, random(1)];
    }
}
circuit_seg_count = _si;

// Pulsos activos: [seg_index, progreso 0..1, velocidad, color_t]
circuit_pulses = [];
circuit_pulse_count = 0;
circuit_pulse_timer = 0;