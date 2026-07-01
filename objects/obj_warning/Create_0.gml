scale_y = 0;
open_speed = 0.15;
close_speed = 0.12;
phase = 0;
anim_frame = 0;
anim_speed = 7 / 30;
anim_length = 7;
blink_count = 0;
blink_max = 3;
blink_t = 0;
blink_speed = 30;
blink_visible = false;
wait_before_close = 30;

// DIALOGO
boss_inst = noone;
dialog_pages = [];
dialog_index = 0;
dialog_loaded = false;

// Caja de dialogo (igual que obj_dialog)
var target_w = 250;
var _spr = spr_dialog_box;
var dialog_scale = target_w / sprite_get_width(_spr);
box_w = sprite_get_width(_spr) * dialog_scale;
box_h = sprite_get_height(_spr) * dialog_scale;
box_x = (320 - box_w) * 0.5;
box_y = 240 - box_h - 120;
box_scale = dialog_scale;
mugshot_x_pos = box_x + 15.5;
mugshot_y_pos = box_y + 17;

// Texto
d_text = "";
d_display_text = "";
d_text_index = 0.0;
d_text_speed = 0.2;
d_finished = false;
d_open_t = 0;
d_open_spd = 0.08;
d_opened = false;

current_mugshot = -1;
current_mugshot_idle = -1;
current_speaker = "";
is_boss_speaking = false;
scale_y = 0;
open_speed = 0.15;
// ... resto del create igual ...
audio_play(snd_warning);

show_debug_message("dialog_pages al crear: " + string(array_length(dialog_pages))); // ← al final