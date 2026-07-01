var scale_y = open_t;
var cx = box_x + box_w * 0.5;
var cy = box_y + box_h * 0.5;
draw_sprite_ext(
    spr_dialog_box_1, 0,
    cx, cy,
    box_scale, box_scale * scale_y,
    0, c_white, 0.75
);
if (open_t < 1) exit;

var mshot = (finished ? current_mugshot_idle : current_mugshot);
var _col = c_white;
switch(current_speaker) {
    case "X":             _col = make_color_rgb(100, 200, 255); break;
    case "ZERO":          _col = make_color_rgb(255, 80, 80);   break;
    case "AXL":           _col = make_color_rgb(80, 200, 255);  break;
    case "IRIS":          _col = make_color_rgb(255, 150, 200); break;
    case "VILE":          _col = make_color_rgb(180, 80, 255);  break;
    case "MEGAMAN":       _col = make_color_rgb(80, 150, 255);  break;
    case "CHILL PENGUIN": _col = make_color_rgb(150, 220, 255); break;
    default:              _col = c_white; break;
}

// ── Texto y mugshot ───────────────────────────────────
var text_x, text_y, text_w;
if (sprite_exists(mshot)) {
    var mshot_scale = (box_w * 0.20) / sprite_get_width(mshot);
    var mshot_w     = sprite_get_width(mshot)  * mshot_scale;
    var mshot_h     = sprite_get_height(mshot) * mshot_scale;
    var mshot_frame = floor((current_time / 80) mod sprite_get_number(mshot));
    draw_sprite_ext(mshot, mshot_frame, mugshot_x_pos, mugshot_y_pos, mshot_scale, mshot_scale, 0, c_white, 1);
    draw_set_font(fnt_dialog_snes);
    draw_set_colour(make_color_rgb(100, 220, 255));
    draw_set_halign(fa_center);
    draw_text_transformed(
        mugshot_x_pos + mshot_w * 0.5,
        mugshot_y_pos + mshot_h + 6,
        current_speaker, 0.7, 0.7, 0
    );
    draw_set_colour(_col);
    text_x = mugshot_x_pos + mshot_w + 8;
    text_y = box_y + 16;
    text_w = box_x + box_w - text_x - 8;
} else {
    text_x = box_x + 8;
    text_y = box_y + 16;
    text_w = box_w - 16;
}

draw_set_font(fnt_dialog_snes);
draw_set_halign(fa_left);
draw_set_colour(_col);
draw_text_ext(text_x, text_y, display_text, 14, text_w);

// ── Opciones ──────────────────────────────────────────
if (finished && has_options && (choosing || showing_result)) {
    var opt_count = array_length(options);
    var opt_x     = text_x;
    var opt_y     = text_y + 40; // debajo del texto
    var opt_pad_x = 8;
    var opt_pad_y = 3;
    for (var i = 0; i < opt_count; i++) {
        var _opt_text = options[i];
        var _sel      = showing_result ? (option_selected == i) : (option_index == i);
        var _ow       = string_width(_opt_text)  + opt_pad_x * 2;
        var _oh       = string_height(_opt_text) + opt_pad_y * 2;
        var _ox       = opt_x;
        var _oy       = opt_y + i * (_oh + 4);

        if (_sel) {
            // Fondo de opción seleccionada (color cambia según resultado)
            draw_set_alpha(0.85);
            if (showing_result) {
                draw_set_colour(result_correct ? make_color_rgb(30, 140, 60) : make_color_rgb(160, 30, 30));
            } else {
                draw_set_colour(make_color_rgb(30, 60, 180));
            }
            draw_rectangle(_ox, _oy, _ox + _ow, _oy + _oh, false);

            draw_set_alpha(0.5);
            if (showing_result) {
                draw_set_colour(result_correct ? make_color_rgb(120, 255, 150) : make_color_rgb(255, 120, 120));
            } else {
                draw_set_colour(make_color_rgb(100, 150, 255));
            }
            draw_rectangle(_ox + 1, _oy + 1, _ox + _ow - 1, _oy + _oh - 1, true);
            draw_set_alpha(1);

            // Flecha solo mientras se está eligiendo
            if (!showing_result) {
                draw_set_colour(c_yellow);
                draw_set_halign(fa_left);
                draw_text(_ox - 10, _oy + opt_pad_y, "▶");
            }
        }

        draw_set_colour(_sel ? c_white : make_color_rgb(160, 160, 160));
        draw_set_halign(fa_left);
        draw_text(_ox + opt_pad_x, _oy + opt_pad_y, _opt_text);

        // Ícono check/X al lado de la opción elegida
        if (showing_result && _sel) {
            draw_set_colour(result_correct ? make_color_rgb(120, 255, 150) : make_color_rgb(255, 120, 120));
            draw_set_halign(fa_left);
            draw_text(_ox + _ow + 6, _oy + opt_pad_y, result_correct ? "✅" : "X");
        }
    }
    draw_set_colour(c_white);
    draw_set_alpha(1);
} else if (finished && !choosing && !showing_result) {
    // Flecha "Next"
    var blink = (current_time mod 800) < 400;
    if (blink) {
        draw_set_colour(make_color_rgb(255, 200, 0));
        draw_set_halign(fa_right);
        draw_set_font(fnt_dialogue_next);
        draw_text(box_x + box_w - 24, box_y + box_h - 12, "Next ->");
    }
}

draw_set_halign(fa_left);
draw_set_colour(c_white);