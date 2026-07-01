if (global.paused && global.pause_type == pause_types.normal) {
    var _up   = keyboard_check_pressed(global.key_config[e_key.up]);
    var _down = keyboard_check_pressed(global.key_config[e_key.down]);
    var _left = keyboard_check_pressed(global.key_config[e_key.left]);
    var _right= keyboard_check_pressed(global.key_config[e_key.right]);
    var _enter= keyboard_check_pressed(global.key_config[e_key.shoot]);
    var _back = keyboard_check_pressed(global.key_config[e_key.dash]);

    if (pause_in_controls) {
        if (pause_controls_waiting) {
            pause_controls_blink_t = (pause_controls_blink_t + 1) mod 30;
            if (global.settings[1] == input_types.keyboard) {
                if (keyboard_lastkey != -1 && keyboard_lastkey != vk_escape) {
                    var _str = key_to_string(keyboard_lastkey);
                    if (_str != "") {
                        global.key_config[pause_controls_selected] = keyboard_lastkey;
                        keys_apply();
                        settings_save();
                        pause_controls_waiting = false;
                        keyboard_lastkey = -1;
                    }
                } else if (keyboard_check_pressed(vk_escape)) {
                    pause_controls_waiting = false;
                    keyboard_lastkey = -1;
                }
            } else {
                var _k = gamepad_key(global.gp_id);
                if (global.gp_id != -1 && _k != -1) {
                    global.gamepad_config[pause_controls_selected] = _k;
                    keys_apply();
                    settings_save();
                    pause_controls_waiting = false;
                }
            }
        } else {
            if (_up)   pause_controls_selected = max(0, pause_controls_selected - 1);
            if (_down) pause_controls_selected = min(pause_controls_length - 1, pause_controls_selected + 1);
            if (_enter) {
                if (pause_controls_selected == pause_controls_length - 1) {
                    pause_in_controls = false;
                    pause_in_options = true;
                    pause_option_selected = 1;
                } else {
                    pause_controls_waiting = true;
                    pause_controls_blink_t = 0;
                    keyboard_lastkey = -1;
                }
            }
            if (_back) {
                pause_in_controls = false;
                pause_in_options = true;
                pause_option_selected = 1;
            }
        }
    } else if (pause_in_audio) {
        if (_up)   pause_audio_selected = max(0, pause_audio_selected - 1);
        if (_down) pause_audio_selected = min(pause_audio_length - 1, pause_audio_selected + 1);
        if (_left || _right) {
            switch (pause_audio_selected) {
                case 0:
                    global.sfx_volume = clamp(global.sfx_volume + (_right ? 0.1 : -0.1), 0, 1);
                    audio_group_set_gain(audiogroup_default, global.sfx_volume, 0);
                break;
                case 1:
                    global.bgm_volume = clamp(global.bgm_volume + (_right ? 0.1 : -0.1), 0, 1);
                    audio_sound_gain(global.music_playing_index, global.bgm_volume, 0);
                break;
            }
        }
        if (_enter || _back) {
            if (pause_audio_selected == 2 || _back) {
                pause_in_audio = false;
                settings_save();
            }
        }
    } else if (pause_in_options) {
        if (_up)   pause_option_selected = max(0, pause_option_selected - 1);
        if (_down) pause_option_selected = min(pause_option_length - 1, pause_option_selected + 1);
        if (_left || _right) {
            switch (pause_option_selected) {
                case 0:
                    var _new = clamp(global.settings[0] + (_right ? 1 : -1), 0, array_length(global.wsize_options) - 1);
                    if (global.settings[0] != _new) {
                        global.settings[0] = _new;
                        custom_window_size(_new + 1);
                        settings_save();
                    }
                break;
                case 3:
                    global.tv_effect = !global.tv_effect;
                    global.settings[2] = global.tv_effect ? 1 : 0;
                    settings_save();
                break;
            }
        }
        if (_enter) {
            switch (pause_option_selected) {
                case 1:
                    pause_in_controls = true;
                    pause_in_options = false;
                    pause_controls_selected = 0;
                    pause_controls_waiting = false;
                break;
                case 2:
                    pause_in_audio = true;
                    pause_audio_selected = 0;
                break;
                case 4:
                    pause_in_options = false;
                    settings_save();
                break;
            }
        }
        if (_back) {
            pause_in_options = false;
            settings_save();
        }
    } else {
        if (_up)   pause_selected = max(0, pause_selected - 1);
        if (_down) pause_selected = min(pause_items_length - 1, pause_selected + 1);
        if (_enter) {
            switch (pause_selected) {
                case 0:
                    pause_set(false);
                break;
                case 1:
                    pause_in_options = true;
                    pause_option_selected = 0;
                break;
                case 2:
                    pause_set(false);
                    room_goto(rm_start_menu);
                break;
            }
        }
    }
}