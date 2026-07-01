switch(phase) {

    case 0: // ABRIENDO + ANIMACION
        scale_y += open_speed;
        if (scale_y >= 1) scale_y = 1;
        anim_frame += anim_speed;
        if (anim_frame >= anim_length) {
            anim_frame = anim_length - 1;
            phase = 1;
            blink_t = blink_speed;
            blink_visible = false;
        }
    break;

    case 1: // PARPADEANDO 3 VECES
        blink_t--;
        if (blink_t <= 0) {
            blink_t = blink_speed;
            blink_visible = !blink_visible;
            if (blink_visible) {
                audio_play(snd_warning);
                blink_count++;
                if (blink_count >= blink_max) {
                    blink_t = wait_before_close;
                    phase = 2;
                }
            }
        }
    break;

 case 2: // ESPERANDO Y CERRANDO WARNING
    if (blink_t > 0) {
        blink_t--;
    } else {
        show_debug_message("Intentando pasar a dialogo, pages: " + string(array_length(dialog_pages)));
        scale_y -= close_speed;
        if (scale_y <= 0) {
            scale_y = 0;
            if (array_length(dialog_pages) > 0) {
                phase = 3;
                dialog_index = 0;
                warning_load_page();
            } else {
                if (instance_exists(boss_inst)) {
                    boss_inst.warning_done = true;
                }
                instance_destroy();
            }
        }
    }
break;

  case 3: // DIALOGO
    // Apertura del panel
    if (!d_opened) {
        d_open_t += d_open_spd;
        if (d_open_t >= 1) {
            d_open_t = 1;
            d_opened = true;
        }
        exit;
    }

    // Avanzar texto
    if (d_text_index < string_length(d_text)) {
        var prev = floor(d_text_index);
        d_text_index += d_text_speed;
        d_display_text = string_copy(d_text, 1, floor(d_text_index));
        if (floor(d_text_index) > prev) {
            audio_play_sound(snd_text, 0, false);
        }
    } else {
        d_display_text = d_text;
        d_finished = true;
    }

    // Input
    if (keyboard_check_pressed(global.key_config[e_key.shoot])) {
        if (!d_finished) {
            d_text_index = string_length(d_text);
            d_display_text = d_text;
            d_finished = true;
        } else {
            dialog_index++;
            if (dialog_index < array_length(dialog_pages)) {
                // Cerrar panel antes de cambiar de speaker
                phase = 5; // fase de cierre entre páginas
            } else {
                phase = 4; // cerrar todo
            }
        }
    }
break;

case 4: // CERRAR PANEL FINAL
    d_open_t -= d_open_spd * 2;
    if (d_open_t <= 0) {
        d_open_t = 0;
        if (instance_exists(boss_inst)) {
            boss_inst.warning_done = true;
        }
        instance_destroy();
    }
break;

case 5: // CERRAR PARA CAMBIAR DE SPEAKER
    d_open_t -= d_open_spd * 2;
    if (d_open_t <= 0) {
        d_open_t = 0;
        warning_load_page(); // cargar siguiente página
        phase = 3; // volver a abrir
    }
break;
}