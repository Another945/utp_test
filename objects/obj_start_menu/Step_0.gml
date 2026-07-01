/// =========================
/// INPUT
/// =========================

#region Input
if (keyboard_check_pressed(ord("R"))){
	game_restart()
}
scr_keys_update();

vinput_p = key_p_down - key_p_up;
hinput_p = key_p_right - key_p_left;

hinput = key_right - key_left;
vinput = key_down - key_up;

enter = key_p_start || keyboard_check_pressed(vk_enter);

var previous_selected_item = selected_item;
#endregion
// ── ACTUALIZAR PULSOS ───────────────────────
circuit_pulse_timer--;
if (circuit_pulse_timer <= 0) {
    circuit_pulse_timer = irandom_range(3, 8);
    if (circuit_pulse_count < 20) {
        var _si = irandom(circuit_seg_count - 1);
        circuit_pulses[circuit_pulse_count++] = [_si, 0, 0.012 + random(0.018), random(1)];
    }
}

for (var i = circuit_pulse_count - 1; i >= 0; i--) {
    circuit_pulses[i][1] += circuit_pulses[i][2];
    if (circuit_pulses[i][1] >= 1) {
        // al llegar al final, activa el segmento y elimina el pulso
        circuit_segs[circuit_pulses[i][0]][2] = 1;
        circuit_segs[circuit_pulses[i][0]][3] = circuit_pulses[i][3];
        array_delete(circuit_pulses, i, 1);
        circuit_pulse_count--;
    }
}

// Fade de segmentos encendidos
for (var i = 0; i < circuit_seg_count; i++) {
    if (circuit_segs[i][2] > 0)
        circuit_segs[i][2] = max(0, circuit_segs[i][2] - 0.004);
}

#region Buttons
switch(state) {

    case menu_states.player_select:
        buttons[|0] = [spr_start_menu_arrow_right,0,256,96];
        buttons[|1] = [spr_start_menu_arrow_left,0,4,96];
        buttons[|2] = [spr_player_select_capsule,0,12,14];
    break;

    case menu_states.key_config:
        buttons[|0] = [spr_start_menu_keyboard,0,214,4];
        buttons[|1] = [spr_start_menu_gamepad,0,264,4];
    break;

    case menu_states.armor_select:
        buttons[|0] = [spr_armor_scroll_arrows,0,-100,-100];
    break;
}
btn_length = ds_list_size(buttons);
#endregion


/// =========================
/// TIMERS
/// =========================
#region Timers

if (wait_t > 0) {
    wait_t--;
    if (wait_t == 0) {
        var tran = transition_create(transition_types.fade_out_and_fade_in);
        tran.transition_limit = input_timer;
        tran.wait_timer = 10;
        switch(state) {
            case menu_states.boss_intro:
            case menu_states.game_mode:
            case menu_states.weapon_get:
                music_stop(1000);
            break;
        }
    }
    exit;
}

if (input_timer > 0) {
    if (can_activate_sprites) {
        activate_sprites = true;
        can_activate_sprites = false;
    }
    input_timer--;
    inputting = false;
    if (input_timer == 0) inputting = true;
}

if (timer > 0) {
    timer--;
    if (timer == 0) {
        state = state_next;
        state_timer = 0;
        changed_state = true;
        items = items_next;
        items_length = array_length(items);
        selected_item = selected_item_next;
        selected_item_next = 0;
        can_activate_sprites = true;
        ds_list_clear(buttons);
        btn_length = 0;

        panel_closing = true;
        curtain_active = true;
        curtain_t = 0;
        curtain_dark = (state == menu_states.player_select || state == menu_states.armor_select);
    }
}

// PANEL CLOSING
if (panel_closing) {
    panel_scale_y -= panel_close_speed;
    if (panel_scale_y <= 0) {
        panel_scale_y = 0;
        panel_closing = false;
    }
}

// PANEL ANIMATION
if (panel_open) {
    panel_scale_y += panel_speed;
    if (panel_scale_y >= 1) {
        panel_scale_y = 1;
        panel_open = false;
    }
}

if (curtain_active) {
    curtain_t++;
    if (curtain_t >= curtain_duration) {
        curtain_active = false;
        panel_open = true;
        panel_scale_y = 0;
    }
}

var _in_submenu = (state != menu_states.main && 
                   state != menu_states.player_select &&
                   state != menu_states.armor_select &&
                   state != menu_states.stage_select &&
                   state != menu_states.boss_intro &&
                   state != menu_states.weapon_get);

if (!_in_submenu && state != menu_states.difficulty_mode) {
    panel_scale_y = 0;
    panel_open = false;
}

#endregion


/// =========================
/// SPRITES / BACKGROUND
/// =========================
#region Animated Sprites

if (activate_sprites) {
    activate_sprites = false;
    layer_x(layer_id, 0);

    switch(state) {
        case menu_states.main:
            layer_background_sprite(layer_bg, noone);
            layer_background_blend(layer_bg, c_black);
			    layer_hspeed(layer_id, 0);      // ← AGREGA ESTO
    layer_vspeed(layer_id, 0);      // ← Y ESTO
    layer_x(layer_id, 0);           // ← Y ESTO
    layer_y(layer_id, 0);           // ← Y ESTO
            animation2_init();
        break;

        case menu_states.game_mode:
        case menu_states.difficulty_mode:
        case menu_states.option:
        case menu_states.key_config:
        case menu_states.audio_settings:
        case menu_states.voice_language:
        case menu_states.volume:
            layer_background_sprite(layer_bg, noone);
            layer_background_blend(layer_bg, c_black);
        break;

        case menu_states.player_select:
            layer_background_change(layer_bg, spr_player_select_background2);
            layer_background_blend(layer_bg, c_white);
            layer_hspeed(layer_id, 1.5);
            selected_item = global.character_selected_index[0];
            armor_index = global.player_character_armor_index[selected_item];
            background_index = selected_item % 5;
            armor = G.player_character_armor[selected_item];
            switch (FULL) {
                case "black": background_index = 2; break;
                case "white": background_index = 5; break;
                default: background_index = selected_item % 5; break;
            }
        break;

        case menu_states.armor_select:
            layer_background_sprite(layer_bg, noone);
            layer_background_blend(layer_bg, c_black);
            layer_hspeed(layer_id, 0);
            menu_armor_load(global.character_selected_index[0]);
            menu_armor_update_colors();
        break;

        case menu_states.stage_select:
            var wlen = array_length(weapon_get_props.instances);
            for (var i = 0; i < wlen; i++) {
                instance_destroy(weapon_get_props.instances[i]);
            }
            if (wlen) {
                weapon_get_props.instances = [];
                weapon_get_props.player.visible = false;
                weapon_get_props.player.palette_sprite = noone;
                weapon_get_props.player.palette_swap = false;
            }
            layer_background_sprite(layer_bg, noone);
            layer_background_blend(layer_bg, c_black);
            animation2_init();
            animation2_add(spr_stage_selecter, 1/5, 0, 0);
            animation2_add(spr_stage_selecter2, 1/5, 176, 85);
        break;

        case menu_states.weapon_get:
            layer_background_change(layer_bg, spr_player_select_background2);
            layer_background_blend(layer_bg, c_white);
            layer_hspeed(layer_id, 1.5);
        break;
    }
}
if (!inputting) exit;

#endregion


/// =========================
/// STATE CHANGE
/// =========================
#region Changed State

if (changed_state) {
    changed_state = false;
    switch(state) {

        case menu_states.stage_select:
            music_play("stageselectfinal");
        break;

        case menu_states.voice_language:
            var voice_languages = player_voice_languages_get();
            var alength = array_length(voice_languages);
            page = [["", []]];
            selected_item = alength - 1;
            for (var i = 0; i < alength; i++) {
                page[i] = [
                    _(voice_languages[i]),
                    [92, 64 + 20*i, 144, 20]
                ];
                if (voice_languages[i] == G.voice_language)
                    selected_item = i;
            }
            previous_selected_item = selected_item;
            items = page;
            items_length = array_length(items);
        break;

        case menu_states.boss_intro:
            state_timer = 0;
        break;
    }
}

#endregion


// ── STEP: logo animation ──
if (state == menu_states.main || state == menu_states.game_mode || 
    state == menu_states.difficulty_mode || state == menu_states.option ||
    state == menu_states.key_config || state == menu_states.audio_settings ||
    state == menu_states.voice_language || state == menu_states.volume) {

    if (reveal < 1) {
        reveal += reveal_speed;
        glitch_timer++;
        if (glitch_timer > 4) {
            glitch_timer = 0;
            glitch_offset = irandom_range(-2, 2);
        }
    } else {
        reveal = 1;
        if (!flash_done) {
            flash = 1;
            flash_done = true;
        }
        logo_frame += 0.2;
        if (logo_frame >= sprite_get_number(spr_new_start_menu)) {
            logo_frame = 0;
        }
    }

    if (flash > 0) {
        flash -= 0.08;
        if (flash < 0) flash = 0;
    }

    glow_phase += 0.05;
}

// ── Desbloquear intro cuando reveal llega a 1 ──
if (state == menu_states.main && intro_playing && reveal >= 1) {
    if (music_check_delay > 0) {
        music_check_delay--;
    } else if (enter || !audio_is_playing(global.music_playing_index)) {
        intro_playing = false;
        music_stop();
        music_play("OptionsTheme");
		        enter = false;        // ← AGREGA ESTO
        key_p_start = false;  // ← Y ESTO
    }
}


/// =========================
/// STATE SWITCH
/// =========================
switch (state) {

#region Main
case menu_states.main:
    if (intro_playing) {
        if (music_check_delay > 0) {
            music_check_delay--;
        } else if (enter || !audio_is_playing(global.music_playing_index)) {
            intro_playing = false;
            music_stop();
            music_play("OptionsTheme");
        }
        break;
    }
    menu_update_item_v();
    menu_update_item_click();
    if (enter) {
        switch(selected_item) {
            case 0: state_next = menu_states.game_mode; break;
            case 1: state_next = menu_states.option; break;
            case 2: game_end(); exit; break;
        }
        audio_play(snd_select_option);
        panel_closing = true;
        curtain_active = true;
        curtain_t = 0;
        curtain_dark = (state_next == menu_states.player_select);
        menu_set_state(state_next, 0, 30, true);
    }
break;
#endregion

#region Game Mode
case menu_states.game_mode:
    menu_update_item_v();
    menu_update_item_click();
    if (enter) {
        switch(selected_item) {
            case 0:
                if (!select_sound_played) {
                    audio_play(snd_select_option);
                    select_sound_played = true;
                }
                panel_closing = true;
                curtain_active = true;
                curtain_t = 0;
                curtain_dark = true;
                menu_set_state(menu_states.player_select, 0, 30, true);
            break;
        }
    }
break;
#endregion

#region Difficulty Mode
case menu_states.difficulty_mode:

    // Deslizar personaje a la izquierda
    if (diff_sliding) {
        diff_slide_x -= diff_slide_speed;
        if (diff_slide_x <= -160) {
            diff_slide_x = -160;
            diff_sliding = false;
            panel_open = true;
            panel_scale_y = 0;
        }
        break;
    }

    // Navegar entre clases
    if (hinput_p != 0) {
        diff_selected = clamp(diff_selected + hinput_p, 0, array_length(diff_classes) - 1);
        audio_play(snd_item_changed);
    }

if (enter) {
    global.difficulty = diff_selected;
    audio_play(snd_player_success);
    var tran = transition_create(transition_types.blink);
    tran.color = c_white;
    tran.transition_limit = 16;
    var fade = transition_create(transition_types.fade_out);
    fade.alpha_start = 0;
    fade.alpha_end = 1;
    fade.color = c_black;
    fade.transition_limit = 40;
    fade.auto_destroy = true; // ← se destruye al terminar
    alarm[0] = 40; // cambiar room exactamente cuando termina el fade
}
break;
#endregion

#region Player Select
case menu_states.player_select:
    for (var i = 0; i < btn_length; i++) {
        var b = buttons[|i];
        b[1] = (menu_button_pressed(b) || ((hinput == 1 && i == 0) || (hinput == -1 && i == 1)));
        if (menu_button_inside(b) && mouse_check_button_released(mb_left)) {
            if (i == 1) hinput_p = -1;
            else if (i == 0) hinput_p = 1;
            else vinput_p = -1;
        }
        buttons[|i] = b;
    }
    if (vinput_p == -1) {
        panel_closing = true;
        curtain_active = true;
        curtain_t = 0;
        curtain_dark = true;
        menu_set_state(menu_states.armor_select);
        tmp_armor = armor;
        tmp_armor_index = armor_index;
        break;
    }
    menu_update_item_h();
    global.character_selected_index[0] = selected_item;
    if (selected_item < array_length(global.player_character_armor)) {
        armor_index = G.player_character_armor_index[selected_item];
        armor = G.player_character_armor[selected_item];
    }
    switch (FULL) {
        case "black": background_index = 2; break;
        case "white": background_index = 5; break;
        case "nightmare": background_index = 4; break;
        default: background_index = selected_item % 5; break;
    }
    var w = 96;
    if (point_in_rectangle(mouse_x, mouse_y, 160 - w, 0, 160 + w, global.view_width) && mouse_check_button_released(mb_left)) enter = true;
    if (enter && selected_item != pl_char.iris && selected_item != pl_char.vile) {
        diff_slide_x = 0;
        diff_sliding = true;
        diff_selected = 0;
        global.character_selected[0] = global.character_object[selected_item];
        music_stop(1000);
        audio_play(snd_player_success);
		diff_title = "ELIGE LA DIFICULTAD";
        state = menu_states.difficulty_mode;
        state_timer = 0;
        changed_state = true;
        items = page_items[menu_states.difficulty_mode];
        items_length = array_length(items);
        // Mantener el fondo del player select
        layer_background_change(layer_bg, spr_player_select_background2);
        layer_background_blend(layer_bg, c_white);
        layer_hspeed(layer_id, 1.5);
    }
break;
#endregion

#region Armor Select
case menu_states.armor_select:
    var c = G.character_selected_index[0];
    if (substates[0] == 0) {
        var t_dir = -1, next_item = -1;
        if (vinput_p == -1) t_dir = e_dir.up;
        else if (vinput_p == 1) t_dir = e_dir.down;
        else if (hinput_p == -1) t_dir = e_dir.left;
        else if (hinput_p == 1) t_dir = e_dir.right;
        if (t_dir != -1) next_item = menu_edges[selected_item, t_dir];
        for (var i = 0; i <= pl_btn.confirm; i++) {
            if (item_show[i]) {
                var r = item_rect[i];
                if (mouse_check_button_pressed(mb_left)) {
                    if (point_in_rectangle(mouse_x, mouse_y, r[0], r[1], r[2], r[3])) {
                        next_item = i;
                        enter = true;
                    }
                }
            }
        }
        if (next_item != -1) {
            selected_item = next_item;
            menu_armor_update_colors();
        }
        if (enter) {
            switch (selected_item) {
                case pl_btn.back:
                    panel_closing = true;
                    curtain_active = true;
                    curtain_t = 0;
                    curtain_dark = true;
                    menu_set_state(menu_states.player_select);
                    tmp_armor = armor;
                    tmp_armor_index = armor_index;
                    selected_item_next = c;
                break;
                case pl_btn.confirm:
                    panel_closing = true;
                    curtain_active = true;
                    curtain_t = 0;
                    curtain_dark = true;
                    armor = tmp_armor;
                    armor_index = tmp_armor_index;
                    selected_item_next = c;
                    G.player_character_armor[c] = armor;
                    G.player_character_armor_index[c] = armor_index;
                    menu_set_state(menu_states.player_select);
                break;
                case pl_btn.helmet:
                case pl_btn.body:
                case pl_btn.arms:
                case pl_btn.legs:
                case pl_btn.armors:
                    substates[0] = 1;
                    item_show[selected_item] = false;
                    var part_index = menu_get_armor_part_index(selected_item);
                    var index = tmp_armor_index[part_index];
                    var armor_names = G.character_armor_name[c];
                    item_string[selected_item] = string_ucfirst(armor_names[index]);
                break;
            }
        }
    } else {
        var b = buttons[|0];
        var pos = item_scroll_pos[selected_item];
        var ww = sprite_get_width(sprite_scroll_arrows);
        var hh = sprite_get_height(sprite_scroll_arrows);
        var xx = floor((pos[0] + sprite_get_width(sprite_scroll) / 2));
        var yy = floor((pos[1] + sprite_get_height(sprite_scroll) / 2));
        b[2] = xx;
        b[3] = yy;
        var inside = (abs(mouse_x - xx) <= ww / 2) && (abs(mouse_y - yy) <= hh / 2);
        if (inside) {
            if (mouse_check_button(mb_left)) vinput = (mouse_y > yy) ? 1 : -1;
            if (mouse_check_button_pressed(mb_left)) vinput_p = vinput;
        } else {
            enter |= mouse_check_button_pressed(mb_left);
        }
        b[1] = 1 + vinput;
        buttons[|0] = b;
        if (vinput_p != 0) {
            var unlocked = false;
            var part_index = menu_get_armor_part_index(selected_item);
            var new_index = tmp_armor_index[part_index];
            var armors_length = array_length(global.character_armor[c]);
            do {
                new_index += vinput_p;
                if (new_index < 0) new_index += armors_length;
                if (new_index >= armors_length) new_index = 0;
                var array_unlocked = global.character_armor_unlocked[c][new_index];
                unlocked = array_unlocked[part_index];
            } until (unlocked);
            var armors = G.character_armor[c];
            if (part_index == P_FULL) {
                for (var i = 0; i < P_FULL; i++) {
                    tmp_armor_index[i] = 0;
                    tmp_armor[i] = "";
                }
                menu_armor_update_colors();
            } else {
                tmp_armor[P_FULL] = "";
                tmp_armor_index[P_FULL] = 0;
            }
            tmp_armor_index[part_index] = new_index;
            tmp_armor[part_index] = armors[new_index];
            var armor_names = G.character_armor_name[c];
            item_string[selected_item] = string_ucfirst(armor_names[new_index]);
        }
        if (enter) {
            substates[0] = 0;
            item_show[selected_item] = true;
        }
    }
break;
#endregion

#region Option
case menu_states.option:
    menu_update_item_v();
    menu_update_item_click();
    var item = items[selected_item];
    var subitem = (array_length(item) > 2 ? item[2] : 0);
    switch(selected_item) {
        case 0:
            if (!G.mobile) {
                var new_value = clamp(global.settings[0] + hinput_p, 0, array_length(subitem) - 1);
                if (global.settings[0] != new_value) {
                    sound = true;
                    global.settings[0] = new_value;
                    global.center_screen = (new_value < global.fullscreen_index - 1);
                    custom_window_size(new_value + 1);
                }
            } else if (enter) {
                var new_value = (global.settings[0] == 0) ? 1 : 0;
                sound = true;
                global.settings[0] = new_value;
                custom_window_size(new_value + 1);
            }
        break;
        case 1:
            if (enter) {
                audio_play(snd_select_option);
                panel_closing = true;
                curtain_active = true;
                curtain_t = 0;
                curtain_dark = false;
                menu_set_state(menu_states.key_config, 0, 30, true);
            }
        break;
        case 2:
            if (enter) {
                audio_play(snd_select_option);
                panel_closing = true;
                curtain_active = true;
                curtain_t = 0;
                curtain_dark = false;
                menu_set_state(menu_states.audio_settings, 0, 30, true);
            }
        break;
       case 3: // EFECTO TV
    if (enter || hinput_p != 0) {
        global.tv_effect = !global.tv_effect;
        global.settings[2] = global.tv_effect ? 1 : 0;
        sound = true;
    }
break;
case 4: // ATRAS (antes era case 3)
    if (enter) {
        audio_play(snd_select_option);
        panel_closing = true;
        curtain_active = true;
        curtain_t = 0;
        curtain_dark = false;
        menu_set_state(menu_states.main, 0, 30, true);
        settings_save();
    }
break;
    }
break;
#endregion

#region Key Config
case menu_states.key_config:
    state_timer++;
    menu_update_item_click();
    for (var i = 0; i < btn_length; i++) {
        var b = buttons[|i];
        if (menu_button_pressed(b)) {
            global.settings[settings_types.input] = input_types.keyboard;
            if (i == input_types.gamepad) {
                global.gp_id = -1;
                if (!ds_list_empty(global.gamepad_list)) {
                    global.settings[settings_types.input] = input_types.gamepad;
                    global.gamepad_list_index = (global.gamepad_list_index + 1) mod ds_list_size(global.gamepad_list);
                    global.gp_id = global.gamepad_list[|global.gamepad_list_index];
                    global.gp_name = gamepad_get_description(global.gp_id);
                }
            }
        }
    }
    for (var i = 0; i < btn_length; i++) {
        var b = buttons[|i];
        b[1] = (global.settings[1] == i);
        buttons[|i] = b;
    }
    if (substates[0] == 0) menu_update_item_v(true);
    if (substates[0] == 1) {
        item_blink_t = ((item_blink_t + 1) mod 30);
        var item = items[selected_item];
        var subitem = item[2];
        var update_items = false;
        if (keyboard_check_pressed(vk_escape)) {
            update_items = true;
        } else if (global.settings[1] == input_types.keyboard) {
            if (keyboard_lastkey != -1) {
                var key_str = key_to_string(keyboard_lastkey);
                if (key_str != "") {
                    global.key_config[selected_item - 1] = keyboard_lastkey;
                    subitem[0] = key_str;
                    update_items = true;
                    state_timer = -1;
                }
            }
        } else {
            var k = gamepad_key(global.gp_id);
            if (global.gp_id != -1 && k != -1) {
                global.gamepad_config[selected_item - 1] = k;
                subitem[1] = gamepad_to_string(k);
                update_items = true;
            }
        }
        if (update_items) {
            item[2] = subitem;
            items[selected_item] = item;
            page_items[state] = items;
            substates[0] = 0;
            if (global.gp_id == -1) global.settings[1] = input_types.keyboard;
            keys_apply();
        }
    } else if (enter && state_timer > 0) {
        if (selected_item > 0 && selected_item < items_length - 1) {
            if (substates[0] == 0) {
                if (global.settings[1] == input_types.keyboard || (global.settings[1] == input_types.gamepad && global.gp_id != -1 && selected_item > 4)) {
                    substates[0] = 1;
                    keyboard_lastkey = -1;
                }
                if (global.settings[1] == input_types.gamepad) {
                    if (selected_item == 3) global.gp_movement = !global.gp_movement;
                }
            }
        } else if (selected_item != 0) {
            audio_play(snd_select_option);
            panel_closing = true;
            curtain_active = true;
            curtain_t = 0;
            curtain_dark = false;
            menu_set_state(menu_states.option, 0, 30, true);
            settings_save();
        }
    } else {
        if (selected_item == 0) {
            if (hinput_p != 0) {
                var new_value = clamp(global.settings[1] + hinput_p, 0, 1);
                if (new_value == input_types.gamepad) {
                    if (!ds_list_empty(global.gamepad_list)) {
                        global.gamepad_list_index = (global.gamepad_list_index + 1) mod ds_list_size(global.gamepad_list);
                        global.gp_id = global.gamepad_list[|global.gamepad_list_index];
                        global.gp_name = gamepad_get_description(global.gp_id);
                    } else {
                        new_value = global.settings[1];
                    }
                }
                if (global.settings[1] != new_value) {
                    global.settings[1] = new_value;
                    sound = true;
                }
            }
        }
    }
break;
#endregion

#region Stage Select
case menu_states.stage_select:
    if (selected_item < 10) {
        if (vinput_p != 0) {
            if (selected_item < 5) selected_item += 5;
            else selected_item -= 5;
        }
        for (var i = 0; i < 10; i++) {
            var pos = stage_select_positions[i];
            if (mouse_check_button_pressed(mb_left) && point_in_rectangle(mouse_x, mouse_y, pos[0], pos[1], pos[0] + 40, pos[1] + 40)) {
                selected_item = i;
            }
        }
        if (selected_item < 5) selected_item = menu_update_subitem(selected_item, hinput_p, [0, 4], true);
        else selected_item = menu_update_subitem(selected_item, hinput_p, [5, 9], true);
        var pos = [176, 85];
        var _boss = global.boss_slot[selected_item];
        var w = 69, h = 69;
        if (_boss != noone) enter |= (mouse_check_button_pressed(mb_left) && point_in_rectangle(mouse_x, mouse_y, pos[0], pos[1], pos[0] + w, pos[1] + h));
        if (enter) {
            var _boss = global.boss_slot[selected_item];
            if (_boss != noone) {
                var info = global.boss_info[_boss];
                boss_room = info[3];
                boss_object = info[4];
                boss_name = info[0];
                boss_defeated = global.boss_defeated[_boss];
                if (room_exists(boss_room)) {
                    var tran = transition_create(transition_types.blink);
                    tran.color = c_white;
                    tran.transition_limit = 16;
                    menu_set_state(menu_states.boss_intro, 16, 60);
                    audio_play(snd_player_success);
                }
            }
        }
    }
break;
#endregion

#region Boss Intro
case menu_states.boss_intro:
    script_try(boss_intro[0]);
break;
#endregion

#region Audio Settings
case menu_states.audio_settings:
    menu_update_item_v();
    menu_update_item_click();
    if (enter) {
        switch (selected_item) {
            case 0:
                audio_play(snd_select_option);
                panel_closing = true;
                curtain_active = true;
                curtain_t = 0;
                curtain_dark = false;
                menu_set_state(menu_states.voice_language, 0, 30, true);
            break;
            case 1:
                audio_play(snd_select_option);
                panel_closing = true;
                curtain_active = true;
                curtain_t = 0;
                curtain_dark = false;
                menu_set_state(menu_states.volume, 0, 30, true);
            break;
            case 2:
                audio_play(snd_select_option);
                panel_closing = true;
                curtain_active = true;
                curtain_t = 0;
                curtain_dark = false;
                menu_set_state(menu_states.option, 0, 30, true);
            break;
        }
    }
break;
#endregion

#region Volume Settings
case menu_states.volume:
    menu_update_item_v();
    menu_update_item_click();
    if (enter) {
        switch (selected_item) {
            case 2:
                audio_play(snd_select_option);
                panel_closing = true;
                curtain_active = true;
                curtain_t = 0;
                curtain_dark = false;
                menu_set_state(menu_states.audio_settings, 0, 30, true);
            break;
        }
    }
    if (key_right || key_left) {
        switch (selected_item) {
            case 0:
                global.sfx_volume = clamp(global.sfx_volume + hinput * 0.01, 0, 1);
                audio_group_set_gain(audiogroup_default, global.sfx_volume, 0);
                if (global.sfx_volume <= 0.9) {
                    audio_play(snd_item_changed);
                    sound = false;
                }
            break;
            case 1:
                global.bgm_volume = clamp(global.bgm_volume + hinput * 0.01, 0, 1);
                audio_sound_gain(global.music_playing_index, global.bgm_volume, 0);
            break;
        }
    }
break;
#endregion

#region Voice Language
case menu_states.voice_language:
    menu_update_item_v();
    menu_update_item_click();
    if (enter) {
        var item = items[selected_item];
        G.voice_language = item[0];
        G.voice_enabled = (G.voice_language != "NONE");
        audio_play(snd_select_option);
        panel_closing = true;
        curtain_active = true;
        curtain_t = 0;
        curtain_dark = false;
        menu_set_state(menu_states.audio_settings, 0, 30, true);
    }
break;
#endregion

#region Weapon Get
case menu_states.weapon_get:
    var t = state_timer++;
    weapon_get_props.player.visible = true;
    if (t == 0) music_play("WeaponGet");
    var move_to = weapon_get_props.player.move_to;
    var move_from = weapon_get_props.player.move_from;
    var interval = move_to.interval;
    var amount = (t - interval[0]) / (interval[1] - interval[0]);
    if (t >= interval[0] && t <= interval[1]) {
        weapon_get_props.player.x = lerp(move_from.x, move_to.x, amount);
        weapon_get_props.player.y = lerp(move_from.y, move_to.y, amount);
    } else if (t == weapon_get_props.blink_limit) {
        var tran = transition_create(transition_types.fade_out_and_fade_in);
        tran.color = c_white;
        tran.transition_limit = 30;
        audio_play(snd_player_success);
        break;
    } else if (t == weapon_get_props.blink_limit + 15) {
        background_index = 1;
        var player_inst = instance_create_depth(64, -64, depth - 20, global.character_selected[0]);
        weapon_get_props.instances[0] = player_inst;
        player_inst.armor = G.player_character_armor[G.character_selected_index[0]];
        with (player_inst) {
            state = states.intro;
            y = -64;
            weapon_demo = true;
            weapon_demo_limit = 210;
            player_load_armor(true);
            player_weapon_set(other.weapon_get_props.player.wp_slot, other.weapon_get_props.player.new_weapon);
            weapon[0] = other.weapon_get_props.player.new_weapon;
            plt_index = weapon_palettes[weapon[0]];
            other.weapon_get_props.player.palette_swap = true;
            if (!weapon_allow_pallete) {
                if (plt_index == weapon_palettes[weapon[0]]) plt_index = plt_index_default;
                other.weapon_get_props.player.palette_swap = false;
            }
        }
        weapon_get_props.player.palette_sprite = player_inst.plt_texture_sprite;
        weapon_get_props.player.palette_array = player_inst.armor_palette_index;
        weapon_get_props.player.palette_index = player_inst.plt_index;
        if (weapon_get_props.player.palette_swap == false) {
            weapon_get_props.player.palette_sprite = noone;
        }
        show_debug_message(weapon_get_props.player.palette_array);
    } else if (t == weapon_get_props.dark_limit) {
        var tran = transition_create(transition_types.fade_out, depth - 1);
        tran.transition_limit = 30;
        tran.alpha_end = 0.5;
        tran.auto_destroy = false;
        weapon_get_props.instances[1] = tran;
    } else if (t == weapon_get_props.dark_limit + 30) {
        var inst = instance_create_depth(0, -72, depth - 10, obj_weapon_get_bar);
        inst.interval = 30;
        inst.move_to = { x: 0, y: 84 };
        weapon_get_props.instances[2] = inst;
    } else if (t == weapon_get_props.dark_limit + 60) {
        var inst = instance_create_depth(0, 0, depth - 10, obj_weapon_get_text);
        weapon_get_props.instances[3] = inst;
        var block = instance_create_depth(0, obj_weapon_get_bar.y + 64, 0, obj_square_16);
        block.image_xscale = 20;
        weapon_get_props.instances[4] = block;
        var player_inst = weapon_get_props.instances[0];
        with (player_inst) {
            state = states.intro;
            y = -64;
            weapon_demo_t = 0;
            state_timer = 0;
        }
    } else {
        if (instance_exists(obj_player_parent)) {
            if (obj_player_parent.weapon_demo_finished) {
                menu_set_state(menu_states.stage_select, 16, 60);
                wait_t = 60;
            }
        }
    }
break;
#endregion

}

// Play Sound
if (previous_selected_item != selected_item || sound) {
    audio_play(snd_item_changed);
    sound = false;
}

// View
menu_update_view_pos();