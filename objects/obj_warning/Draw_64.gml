// DRAW GUI de obj_warning
if (phase == 3 || phase == 4) {
    var _eased = 1 - (1 - d_open_t) * (1 - d_open_t);
    var cx = box_x + box_w * 0.5;
    var cy = box_y + box_h * 0.5;
    var _xscale = is_boss_speaking ? -box_scale : box_scale;
    var _mug_x = is_boss_speaking ? (box_x + box_w - 15.5) : mugshot_x_pos;

    draw_sprite_ext(
        spr_dialog_box, 0,
        cx, cy,
        _xscale, box_scale * _eased,
        0, c_white, 1
    );

    if (d_open_t >= 1) {
        var mshot = (d_finished ? current_mugshot_idle : current_mugshot);

        // Color según speaker
        var _col = c_white;
        switch(current_speaker) {
            case "X":             _col = make_color_rgb(100, 200, 255); break;
            case "ZERO":          _col = make_color_rgb(255, 80, 80); break;
            case "AXL":           _col = make_color_rgb(80, 200, 255); break;
            case "IRIS":          _col = make_color_rgb(255, 150, 200); break;
            case "VILE":          _col = make_color_rgb(180, 80, 255); break;
            case "MEGAMAN":       _col = make_color_rgb(80, 150, 255); break;
            case "CHILL PENGUIN": _col = make_color_rgb(150, 220, 255); break;
            default:              _col = c_white; break;
        }

        if (sprite_exists(mshot)) {
            var mshot_scale = (box_w * 0.20) / sprite_get_width(mshot);
            var mshot_w = sprite_get_width(mshot) * mshot_scale;
            var mshot_h = sprite_get_height(mshot) * mshot_scale;
            var mshot_frame = floor((current_time / 80) mod sprite_get_number(mshot));
            var _ms = is_boss_speaking ? -mshot_scale : mshot_scale;

            draw_sprite_ext(mshot, mshot_frame, _mug_x, mugshot_y_pos, _ms, mshot_scale, 0, c_white, 1);

            // Nombre del speaker
            draw_set_font(fnt_dialog_snes);
            draw_set_colour(make_color_rgb(100, 220, 255));
            draw_set_halign(fa_center);
            draw_text_transformed(
                _mug_x + (is_boss_speaking ? -mshot_w * 0.5 : mshot_w * 0.5),
                mugshot_y_pos + mshot_h + 6,
                current_speaker,
                0.7, 0.7, 0
            );

            // Resetear y aplicar color del dialogo
            draw_set_colour(c_white);
            draw_set_font(fnt_dialog_snes);
            draw_set_halign(fa_left);
            var text_x = is_boss_speaking ? (box_x + 8) : (mugshot_x_pos + mshot_w + 8);
            var text_y = box_y + 8;
            var text_w = is_boss_speaking ? (_mug_x - box_x - mshot_w - 16) : (box_x + box_w - text_x - 8);
            draw_set_colour(_col);
            draw_text_ext(text_x, text_y, d_display_text, 14, text_w);

        } else {
            draw_set_font(fnt_dialog_snes);
            draw_set_halign(fa_left);
            draw_set_colour(_col);
            draw_text_ext(box_x + 8, box_y + 8, d_display_text, 14, box_w - 16);
        }

        if (d_finished) {
            var blink = (current_time mod 800) < 400;
            if (blink) {
                draw_set_colour(make_color_rgb(255, 200, 0));
                draw_set_font(fnt_dialogue_next);
                if (is_boss_speaking) {
                    draw_set_halign(fa_left);
                    draw_text(box_x + 24, box_y + box_h - 12, "<- Next");
                } else {
                    draw_set_halign(fa_right);
                    draw_text(box_x + box_w - 24, box_y + box_h - 12, "Next ->");
                }
            }
        }

        draw_set_halign(fa_left);
        draw_set_colour(c_white);
    }
}