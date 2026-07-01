// Escala para que quepa en 320x240
var target_w = 250;
var dialog_scale = target_w / sprite_get_width(spr_dialog_box_1);

pages        = [];
page_index   = 0;
trigger      = noone;
pages_loaded = false;

// Texto
text         = "";
display_text = "";
text_index   = 0.0;
text_speed   = 0.2;
finished     = false;

// Sonido
text_sound_timer = 0;

// Posición de la caja
box_w = sprite_get_width(spr_dialog_box_1) * dialog_scale;
box_h = sprite_get_height(spr_dialog_box_1) * dialog_scale;
box_x = (320 - box_w) * 0.5;
box_y = 240 - box_h - 120;

box_scale = dialog_scale;

// Mugshot
mugshot_x_pos = box_x + 15.5;
mugshot_y_pos = box_y + 17;

// Apertura
open_t   = 0;
open_spd = 0.08;
opened   = false;

current_mugshot      = -1;
current_mugshot_idle = -1;
current_speaker      = "";

// Opciones
has_options      = false;
options          = [];
option_index     = 0;
option_selected  = -1;
choosing         = false;
correct_option   = -1;

// Resultado (check/X)
showing_result = false;
result_timer   = 0;
result_correct = false;