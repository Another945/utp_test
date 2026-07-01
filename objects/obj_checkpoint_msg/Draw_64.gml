// Mensaje checkpoint
if (global.checkpoint_msg_timer > 0) {
    global.checkpoint_msg_timer--;
    var _alpha = min(1, global.checkpoint_msg_timer / 60);
    draw_set_font(fnt_dialog_snes);
    draw_set_halign(fa_center);
    draw_set_alpha(_alpha);
    draw_set_color(make_color_rgb(100, 220, 255));
    draw_text(global.view_width * 0.5, global.view_height - 24, "CHECKPOINT ALCANZADO");
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
}

if (global.paused && global.pause_type == pause_types.normal) {
    var _sw = global.view_width;
    var _sh = global.view_height;
    var _cx = _sw * 0.5;
    var _cy = _sh * 0.5;
    var bracket_t = sin(current_time * 0.004) * 3;

    draw_set_alpha(0.7);
    draw_set_color(make_color_rgb(5, 10, 30));
    draw_rectangle(0, 0, _sw, _sh, false);
    draw_set_alpha(1);

    draw_set_font(fnt_dialog_snes);
    draw_set_halign(fa_center);

    if (pause_in_audio) {
        // ── AUDIO ──────────────────────────────────
        draw_set_color(make_color_rgb(100, 220, 255));
        draw_text(_cx, _cy - 60, "AUDIO");
        var _labels = ["EFECTOS", "MUSICA DE FONDO", "ATRAS"];
        var _values = [string(round(global.sfx_volume * 100)) + "%",
                       string(round(global.bgm_volume * 100)) + "%", ""];
        for (var i = 0; i < pause_audio_length; i++) {
            var _y   = _cy - 20 + i * 24;
            var _sel = (pause_audio_selected == i);
            draw_set_color(_sel ? c_white : make_color_rgb(160,160,160));
            draw_set_alpha(_sel ? 1 : 0.55);
            draw_text(_cx - 30, _y, _labels[i]);
            if (_values[i] != "") {
                draw_set_color(make_color_rgb(255, 200, 0));
                draw_text(_cx + 60, _y, _values[i]);
            }
            draw_set_alpha(1);
        }
    } else if (pause_in_options) {
        // ── OPCIONES ───────────────────────────────
        draw_set_color(make_color_rgb(100, 220, 255));
        draw_text(_cx, _cy - 60, "OPCIONES");
        var _opt_labels = ["TAMAÑO PANTALLA", "CONTROLES", "AUDIO", "EFECTO TV", "ATRAS"];
        var _opt_values = [
            global.wsize_options[global.settings[0]],
            "", "", 
            global.tv_effect ? "ON" : "OFF",
            ""
        ];
        for (var i = 0; i < pause_option_length; i++) {
            var _y   = _cy - 30 + i * 22;
            var _sel = (pause_option_selected == i);
            draw_set_color(_sel ? c_white : make_color_rgb(160,160,160));
            draw_set_alpha(_sel ? 1 : 0.55);
            draw_text(_cx - 40, _y, _opt_labels[i]);
            if (_opt_values[i] != "") {
                draw_set_color(make_color_rgb(255, 200, 0));
                draw_text(_cx + 60, _y, _opt_values[i]);
            }
            draw_set_alpha(1);
        }
    } else if (pause_in_controls) {
        // ── CONTROLES ──────────────────────────────
        draw_set_color(make_color_rgb(100, 220, 255));
        draw_text(_cx, _cy - 80, "CONTROLES");

        var _key_count = array_length(global.key_text);
        var _start_y = _cy - 65;
        var _spacing = 13;

        for (var i = 0; i <= _key_count; i++) {
            var _y   = _start_y + i * _spacing;
            var _sel = (pause_controls_selected == i);

            if (i == _key_count) {
                // ATRAS
                draw_set_color(_sel ? c_white : make_color_rgb(160,160,160));
                draw_set_alpha(_sel ? 1 : 0.55);
                draw_text(_cx, _y, "ATRAS");
                draw_set_alpha(1);
            } else {
                // Nombre de la tecla
                draw_set_color(_sel ? c_white : make_color_rgb(160,160,160));
                draw_set_alpha(_sel ? 1 : 0.55);
                draw_set_halign(fa_left);
                draw_text(_cx - 80, _y, global.key_text[i]);

                // Valor actual
                var _val = "";
                if (pause_controls_waiting && _sel) {
                    _val = (pause_controls_blink_t < 15) ? "-" : "";
                } else {
                    if (global.settings[1] == input_types.keyboard)
                        _val = key_to_string(global.key_config[i]);
                    else
                        _val = gamepad_to_string(global.gamepad_config[i]);
                }
                draw_set_color(_sel ? make_color_rgb(255,200,0) : make_color_rgb(160,160,160));
                draw_set_halign(fa_right);
                draw_text(_cx + 80, _y, _val);
                draw_set_alpha(1);
            }
        }
        draw_set_halign(fa_center);

    } else {
        // ── MENÚ PRINCIPAL DE PAUSA ────────────────
        draw_set_color(make_color_rgb(100, 220, 255));
        draw_text(_cx, _cy - 50, "PAUSA");
        for (var i = 0; i < pause_items_length; i++) {
            var _text     = pause_items[i];
            var _selected = (pause_selected == i);
            var _y        = _cy - 10 + i * 24;
            var _tw       = string_width(_text);
            var _th       = string_height(_text);
            var _pad_x    = 14;
            var _pad_y    = 3;
            var _bw       = _tw + _pad_x * 2;
            var _bh       = _th + _pad_y * 2;

            if (_selected) {
                var _pop = 1.0 + (sin(current_time * 0.008) * 0.5 + 0.5) * 0.04;
                var _bw2 = _bw * _pop;
                var _bh2 = _bh * _pop;
                var _py  = -((_pop - 1) * 6);
                var _x1  = _cx - _bw2 * 0.5;
                var _x2  = _cx + _bw2 * 0.5;
                var _y1  = _y + _py - _bh2 * 0.5;
                var _y2  = _y + _py + _bh2 * 0.5;

                draw_set_alpha(1);
                draw_set_color(make_color_rgb(90, 60, 200));
                draw_rectangle(_x1, _y1, _x2, _y2, false);
                draw_set_alpha(0.5);
                draw_set_color(make_color_rgb(160, 120, 255));
                draw_rectangle(_x1+1, _y1+1, _x2-1, _y2-1, true);
                draw_set_alpha(1);

                draw_set_color(c_white);
                draw_set_halign(fa_center);
                draw_text(_cx, _y + _py - _th * 0.5, _text);

                var _arm = 6 + bracket_t * 0.4;
                var _thk = 2;
                var _gap = 2 + bracket_t * 0.2;
                var _col = merge_color(c_white, make_color_rgb(180,140,255), 0.35 + sin(current_time * 0.005) * 0.2);
                draw_set_color(_col);
                var _l = _x1 - _gap;
                var _r = _x2 + _gap;
                var _t = _y1 - _gap;
                var _b = _y2 + _gap;
                draw_rectangle(_l,      _t,      _l+_arm, _t+_thk, false);
                draw_rectangle(_l,      _t,      _l+_thk, _t+_arm, false);
                draw_rectangle(_r-_arm, _t,      _r,      _t+_thk, false);
                draw_rectangle(_r-_thk, _t,      _r,      _t+_arm, false);
                draw_rectangle(_l,      _b-_thk, _l+_arm, _b,      false);
                draw_rectangle(_l,      _b-_arm, _l+_thk, _b,      false);
                draw_rectangle(_r-_arm, _b-_thk, _r,      _b,      false);
                draw_rectangle(_r-_thk, _b-_arm, _r,      _b,      false);
            } else {
                draw_set_alpha(0.55);
                draw_set_color(make_color_rgb(160,160,160));
                draw_set_halign(fa_center);
                draw_text(_cx, _y - _th * 0.5, _text);
                draw_set_alpha(1);
            }
        }
    }

    draw_set_halign(fa_left);
    draw_set_color(c_white);
    draw_set_alpha(1);
}
