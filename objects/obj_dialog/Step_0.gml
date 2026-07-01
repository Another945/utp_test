if (!pages_loaded) {
    if (array_length(pages) > 0) {
        pages_loaded = true;
        dialog_load_page(id);
    }
    exit;
}

if (!opened) {
    open_t += open_spd;
    if (open_t >= 1) {
        open_t = 1;
        opened = true;
    }
    exit;
}

if (text_index < string_length(text)) {
    var prev_index = floor(text_index);
    text_index += text_speed;
    display_text = string_copy(text, 1, floor(text_index));
    if (floor(text_index) > prev_index) {
        audio_play_sound(snd_text, 0, false);
    }
} else {
    display_text = text;
    finished = true;
}

// Input
if (keyboard_check_pressed(global.key_config[e_key.shoot]) && !showing_result) {
    if (!finished) {
        // Completar texto instantáneo
        text_index   = string_length(text);
        display_text = text;
        finished     = true;
    } else if (choosing) {
        // Confirmar opción seleccionada -> mostrar resultado primero
        option_selected = option_index;
        choosing        = false;
        showing_result  = true;
        result_correct  = (correct_option == -1) || (option_selected == correct_option);
        result_timer    = 60; // 1 segundo a 60fps antes de avanzar
    } else {
        page_index++;
        if (page_index < array_length(pages)) {
            dialog_load_page(id);
        } else {
            if (instance_exists(trigger)) {
                trigger.option_selected = option_selected;
                trigger.dialog_done     = true;
                trigger.dialog_inst     = noone;
            }
            if (instance_exists(obj_player_parent))
                obj_player_parent.locked = false;
            instance_destroy();
        }
    }
}

// Navegar opciones con arriba/abajo
if (choosing && finished) {
    if (keyboard_check_pressed(global.key_config[e_key.up])) {
        option_index = max(0, option_index - 1);
        audio_play_sound(snd_text, 0, false);
    }
    if (keyboard_check_pressed(global.key_config[e_key.down])) {
        option_index = min(array_length(options) - 1, option_index + 1);
        audio_play_sound(snd_text, 0, false);
    }
}

// Mostrar resultado (check/X) y luego avanzar
if (showing_result) {
    result_timer--;
    if (result_timer <= 0) {
        showing_result = false;
        page_index++;
        if (page_index < array_length(pages)) {
            dialog_load_page(id);
        } else {
            if (instance_exists(trigger)) {
                trigger.option_selected = option_selected;
                trigger.dialog_done     = true;
                trigger.dialog_inst     = noone;
            }
            if (instance_exists(obj_player_parent))
                obj_player_parent.locked = false;
            instance_destroy();
        }
    }
}