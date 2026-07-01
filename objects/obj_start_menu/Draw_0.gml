draw_set_offset(0, 0);
// ── DIBUJAR FONDO CIRCUITO ──────────────────
draw_set_color(make_color_rgb(5, 3, 18));
draw_rectangle(0, 0, room_width, room_height, false);

for (var i = 0; i < circuit_seg_count; i++) {
    var _seg   = circuit_segs[i];
    var _alpha = _seg[2];
    if (_alpha < 0.01) continue;

    var _n1 = circuit_nodes[_seg[0]];
    var _n2 = circuit_nodes[_seg[1]];
    var _col = merge_color(
        make_color_rgb(30, 10, 80),
        make_color_rgb(80, 40, 200),
        _seg[3]
    );
    draw_set_color(_col);
    draw_set_alpha(_alpha * 0.7);
    draw_line(_n1[0], _n1[1], _n2[0], _n2[1]);
}

// Nodos
for (var i = 0; i < circuit_cols * circuit_rows; i++) {
    var _n = circuit_nodes[i];
    draw_set_color(make_color_rgb(60, 30, 140));
    draw_set_alpha(0.4);
    draw_rectangle(_n[0]-1, _n[1]-1, _n[0]+1, _n[1]+1, false);
}

// Pulsos viajando
for (var i = 0; i < circuit_pulse_count; i++) {
    var _p   = circuit_pulses[i];
    var _seg = circuit_segs[_p[0]];
    var _n1  = circuit_nodes[_seg[0]];
    var _n2  = circuit_nodes[_seg[1]];
    var _px  = lerp(_n1[0], _n2[0], _p[1]);
    var _py  = lerp(_n1[1], _n2[1], _p[1]);
    draw_set_color(make_color_rgb(180, 120, 255));
    draw_set_alpha(0.9);
    draw_rectangle(_px - 2, _py - 2, _px + 2, _py + 2, false);
}

draw_set_alpha(1);
draw_set_color(c_white);
// =========================
// LOGO — "CIRCUIT BOOT" ANIMATION
// =========================
var spr = spr_new_start_menu;
var w = sprite_get_width(spr);
var h = sprite_get_height(spr);
var scale = 1;
var draw_x = (320 - w * scale) / 2;
var draw_y = -8;

var _logo_alpha = (state == menu_states.main) ? 1 : 0.3;
var _phase = reveal;

// ── GLITCH CAÓTICO (fase 0..0.4) ─────────────────────
if (_phase < 0.35)
{
    var _t = _phase / 0.35;

    draw_set_alpha(_t);

    draw_sprite_ext(
        spr,
        floor(logo_frame),
        draw_x,
        draw_y - (1 - _t) * 40,
        scale,
        scale,
        0,
        c_white,
        1
    );

    draw_set_alpha(1);
}

// ── POWER SURGE (fase 0.4..0.65) ─────────────────────
else if (_phase < 0.65)
{
    var _t = (_phase - 0.35) / 0.30;

    draw_sprite_ext(
        spr,
        floor(logo_frame),
        draw_x,
        draw_y,
        scale,
        scale,
        0,
        c_white,
        _logo_alpha
    );

    var pulse = (1 - _t);

    draw_set_alpha(pulse * 0.35);

    draw_sprite_ext(
        spr,
        floor(logo_frame),
        draw_x,
        draw_y,
        scale * 1.03,
        scale * 1.03,
        0,
        make_color_rgb(100,220,255),
        1
    );

    draw_set_alpha(1);
}

// ── IDLE CON GLOW SUAVE (reveal >= 0.65) ─────────────
else
{
    var float_y = sin(current_time * 0.002) * 2;

    var glow =
        0.10 +
        (sin(current_time * 0.004) * 0.5 + 0.5) * 0.10;

    draw_set_alpha(glow);

    draw_sprite_ext(
        spr,
        floor(logo_frame),
        draw_x - 2,
        draw_y + float_y - 2,
        scale * 1.02,
        scale * 1.02,
        0,
        make_color_rgb(80,180,255),
        1
    );

    draw_set_alpha(glow * 0.5);

  

    draw_set_alpha(1);

    draw_sprite_ext(
        spr,
        floor(logo_frame),
        draw_x,
        draw_y + float_y,
        scale,
        scale,
        0,
        c_white,
        _logo_alpha
    );
}
var line_y = 122;

draw_set_color(make_color_rgb(0,220,255));



draw_set_color(c_white);

// Flash general
if (flash > 0) {
    draw_set_alpha(flash);
    draw_set_color(c_white);
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_alpha(1);
}
// =========================
// PANEL DE SUBMENÚ
// =========================
var _in_submenu = (state != menu_states.main && 
                   state != menu_states.player_select &&
                   state != menu_states.armor_select &&
                   state != menu_states.stage_select &&
                   state != menu_states.boss_intro &&
                   state != menu_states.weapon_get);

var _show_panel = _in_submenu || curtain_active;

if (_show_panel && panel_scale_y > 0 || curtain_active) {

    var _pw = room_width;
    var _ph = room_height;
    var _px = 0;
    var _py = room_height / 2;

    var _eased = 1 - (1 - panel_scale_y) * (1 - panel_scale_y);

    draw_set_alpha(0.85 * _eased);
    draw_set_color(make_color_rgb(10, 15, 40));
    draw_rectangle(
        _px, _py - (_ph / 2) * _eased,
        _px + _pw, _py + (_ph / 2) * _eased,
        false
    );
    draw_set_alpha(1);

    var _spr_w = sprite_get_width(spr_menu_panel);
    var _spr_h = sprite_get_height(spr_menu_panel);
    var _sx = _pw / _spr_w;
    var _sy = (_ph / _spr_h) * _eased;

    draw_sprite_ext(
        spr_menu_panel, 0,
        _px + _pw / 2,
        _py,
        _sx, _sy,
        0, c_white, 1
    );

    draw_set_color(c_white);
    draw_set_alpha(1);
}

// =========================
// ESTADOS
// =========================
switch(state) {

#region Main

case menu_states.main:
    if (!intro_playing) {

        for (var i = 0; i < items_length; i++) {
            var item   = items[i];
            var _text  = item[0];
            var _sel   = (selected_item == i);

            draw_set_font(fnt_dialog);
            draw_set_halign(fa_center);

            var _x  = 130;  // ← corregido, antes 160 (textos corridos a la derecha)
           var _y  = 172 + 26 * i;
var _x     = 130;
var _x_box = 160;
var _tw    = string_width(_text);
var _th    = string_height(_text);

            if (_sel) {
               var _pw   = _tw + 24;
var _ph   = _th + 8;
var _x1   = _x_box - _pw * 0.5;  // ← usa _x_box, no _x
var _x2   = _x_box + _pw * 0.5;
var _y1   = _y - _ph * 0.5;
var _y2   = _y + _ph * 0.5;

                draw_set_alpha(1);
                draw_set_color(make_color_rgb(60, 60, 200));
                draw_rectangle(_x1, _y1, _x2, _y2, false);

                draw_set_color(make_color_rgb(120, 140, 255));
                draw_rectangle(_x1, _y1, _x2, _y2, true);

                draw_set_color(c_white);
                draw_string(_x, _y - _th * 0.5, _text);

                // Corchetes: rango más pequeño y frecuencia más lenta = más fluido
                var _breath = sin(current_time * 0.002) * 0.5 + 0.5;  // ← 0.003→0.002
             var _gap  = 3 + _breath * 3;  // ← restaurado
var _arm  = 6 + _breath * 2;  // ← restaurado
var _thk  = 1;

              var _l = _x1 - _gap;
var _r = _x2 + _gap;
                var _t = _y1 - _gap;
                var _b = _y2 + _gap;

                var _col = merge_color(c_white, make_color_rgb(140, 180, 255), _breath * 0.4);
                draw_set_color(_col);
                draw_set_alpha(1);

                draw_rectangle(_l,        _t,        _l + _arm, _t + _thk, false);
                draw_rectangle(_l,        _t,        _l + _thk, _t + _arm, false);
                draw_rectangle(_r - _arm, _t,        _r,        _t + _thk, false);
                draw_rectangle(_r - _thk, _t,        _r,        _t + _arm, false);
                draw_rectangle(_l,        _b - _thk, _l + _arm, _b,        false);
                draw_rectangle(_l,        _b - _arm, _l + _thk, _b,        false);
                draw_rectangle(_r - _arm, _b - _thk, _r,        _b,        false);
                draw_rectangle(_r - _thk, _b - _arm, _r,        _b,        false);

            } else {
                var _th = string_height(_text);
                draw_set_alpha(0.45);
                draw_set_color(make_color_rgb(180, 180, 200));
                draw_string(_x, _y - _th * 0.5, _text);
                draw_set_alpha(1);
            }
        }

        draw_set_halign(fa_left);
        draw_set_color(c_white);
        draw_set_alpha(1);
    }
    draw_string(252, 224, "v" + GM_version);
break;
#endregion

#region Game Mode
case menu_states.game_mode:
    if (panel_scale_y >= 1) {
        draw_string_center(160, 8, titles[state], colors.gray);
        for (var i = 0; i < items_length; i++) {
            var item = items[i];
            var _x = 112, _y = 92 + 24*i;
            draw_string(_x, _y, item[0], (selected_item == i ? colors.orange : colors.blue));
            if (selected_item == i) draw_string(_x - 16, _y, "▶", colors.orange);
        }
    }
break;
#endregion

#region Difficulty Mode
case menu_states.difficulty_mode:
    var _char_index = global.character_selected_index[0];
    
    draw_set_color(make_color_rgb(5, 10, 20));
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_color(c_white);
    draw_set_alpha(1);

    var _box_x = 0;
    var _box_y = 3;
    var _box_w = 320;
    var _box_h = 235;
    draw_set_alpha(0.8);
    draw_set_color(make_color_rgb(10, 20, 50));
    draw_rectangle(_box_x, _box_y, _box_x + _box_w, _box_y + _box_h, false);
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(80, 120, 200));
    draw_rectangle(_box_x, _box_y, _box_x + _box_w, _box_y + _box_h, true);
       
    var _char_scale = 1;
    var _char_cx = _box_x + _box_w * 0.5 + diff_slide_x - 70;
    var _char_cy = _box_y - 0;
    var _matrix = matrix_build(_char_cx, _char_cy, 0, 0, 0, 0, _char_scale, _char_scale, 1);
    var _old_matrix = matrix_get(matrix_world);
    matrix_set(matrix_world, matrix_multiply(_matrix, _old_matrix));
    menu_draw_player(0, 0, _char_index, armor_index);
    matrix_set(matrix_world, _old_matrix);

    var _panel_w = sprite_get_width(spr_menu_panel);
    var _panel_h = sprite_get_height(spr_menu_panel);
    var _panel_sx = room_width / _panel_w;
    var _panel_sy = room_height / _panel_h;
    draw_sprite_ext(spr_menu_panel, 0, 160, 120, _panel_sx, _panel_sy, 0, c_white, 1);

    draw_set_font(fnt_dialog);
    draw_set_halign(fa_center);
    draw_set_color(c_white);
    draw_string(_box_x + _box_w * 0.5, _box_y + _box_h + 4,
        page_items[menu_states.player_select][_char_index]);
    
    var _cs = 6;
    var _col = make_color_rgb(100, 180, 255);
    draw_set_color(_col);
    draw_rectangle(_box_x,              _box_y,              _box_x + _cs,        _box_y + 1,          false);
    draw_rectangle(_box_x,              _box_y,              _box_x + 1,          _box_y + _cs,        false);
    draw_rectangle(_box_x + _box_w - _cs, _box_y,            _box_x + _box_w,     _box_y + 1,          false);
    draw_rectangle(_box_x + _box_w - 1,  _box_y,            _box_x + _box_w,     _box_y + _cs,        false);
    draw_rectangle(_box_x,              _box_y + _box_h - 1, _box_x + _cs,        _box_y + _box_h,     false);
    draw_rectangle(_box_x,              _box_y + _box_h - _cs, _box_x + 1,        _box_y + _box_h,     false);
    draw_rectangle(_box_x + _box_w - _cs, _box_y + _box_h - 1, _box_x + _box_w,  _box_y + _box_h,     false);
    draw_rectangle(_box_x + _box_w - 1,  _box_y + _box_h - _cs, _box_x + _box_w, _box_y + _box_h,     false);

    if (panel_scale_y >= 1) {
        draw_set_color(c_white);
        draw_set_halign(fa_center);
        draw_string(room_width * 0.3, 6, diff_title);
        
        var _total = array_length(diff_classes);
        var _right_x = 165;
        var _right_w = room_width - _right_x - 8;
        var _spacing = _right_w / _total;
        var _cy = 40;
        
        for (var i = 0; i < _total; i++) {
            var _cx = _right_x + _spacing * i + _spacing * 0.5;
            var _is_selected = (diff_selected == i);
            
            if (_is_selected) {
                draw_set_alpha(0.9);
                draw_set_color(make_color_rgb(30, 60, 160));
                draw_rectangle(_cx - 12, _cy - 12, _cx + 12, _cy + 12, false);
                draw_set_alpha(1);
                draw_set_color(make_color_rgb(100, 160, 255));
                draw_rectangle(_cx - 12, _cy - 12, _cx + 12, _cy + 12, true);
            } else {
                draw_set_alpha(0.35);
                draw_set_color(c_white);
                draw_rectangle(_cx - 10, _cy - 10, _cx + 10, _cy + 10, true);
                draw_set_alpha(1);
            }
            
            draw_set_font(fnt_dialog);
            draw_set_halign(fa_center);
            draw_set_color(_is_selected ? make_color_rgb(255, 210, 50) : make_color_rgb(130, 130, 130));
            draw_string(_cx, _cy - 6, diff_classes[i]);
        }

        var bracket_t = sin(current_time * 0.004) * 3;
        var _sel_cx = _right_x + _spacing * diff_selected + _spacing * 0.5;
        var _sel_cy = _cy;
        var _bx1 = _sel_cx - 12 - bracket_t;
        var _bx2 = _sel_cx + 12 + bracket_t;
        var _by1 = _sel_cy - 12 - bracket_t * 0.6;
        var _by2 = _sel_cy + 12 + bracket_t * 0.6;
        var _cs2 = 4 + bracket_t;
        var _thk = 1;
        draw_set_color(c_white);
        draw_set_alpha(1);
        draw_rectangle(_bx1,        _by1,        _bx1 + _cs2, _by1 + _thk, false);
        draw_rectangle(_bx1,        _by1,        _bx1 + _thk, _by1 + _cs2, false);
        draw_rectangle(_bx2 - _cs2, _by1,        _bx2,        _by1 + _thk, false);
        draw_rectangle(_bx2 - _thk, _by1,        _bx2,        _by1 + _cs2, false);
        draw_rectangle(_bx1,        _by2 - _thk, _bx1 + _cs2, _by2,        false);
        draw_rectangle(_bx1,        _by2 - _cs2, _bx1 + _thk, _by2,        false);
        draw_rectangle(_bx2 - _cs2, _by2 - _thk, _bx2,        _by2,        false);
        draw_rectangle(_bx2 - _thk, _by2 - _cs2, _bx2,        _by2,        false);

        var _desc = diff_descriptions[diff_selected];
        var _lines = string_split(_desc, "\n");
        
        draw_set_color(make_color_rgb(255, 210, 50));
        draw_set_halign(fa_left);
        draw_string(_right_x, 70, _lines[0]);
        
        draw_set_color(c_white);
        draw_set_font(fnt_dialog_snes);
        var _desc_text = "";
        for (var i = 1; i < array_length(_lines); i++) {
            _desc_text += _lines[i];
            if (i < array_length(_lines) - 1) _desc_text += "\n";
        }
        draw_text_ext(_right_x, 90, _desc_text, 16, _right_w);
        
        draw_set_halign(fa_left);
        draw_set_color(c_white);
        draw_set_alpha(1);
    }
break;
#endregion

#region Player Select
case menu_states.player_select:
    var item = items[selected_item];
    draw_sprite(spr_player_select_backgrounds, background_index, 0, 0);
    menu_draw_player(0, 0, selected_item, armor_index);
    draw_string_center(270, 13, item);
    menu_draw_buttons();
break;
#endregion

#region Armor Select
case menu_states.armor_select:
    menu_draw_player(0, 0, G.character_selected_index[0], tmp_armor_index);
    for (var i = 0; i <= pl_btn.confirm; i++) {
        if (item_show[i]) {
            var pos = item_pos[i];
            draw_sprite(item_sprite[i], item_image_index[i], pos[0], pos[1]);
        }
    }
    if (substates[0] == 1) {
        var pos = item_scroll_pos[selected_item];
        var text = item_string[selected_item];
        draw_sprite(sprite_scroll, 0, pos[0], pos[1]);
        var xx = floor(pos[0] + sprite_get_width(sprite_scroll) / 2) - 2;
        draw_string_center(xx, pos[1] + 1, text);
        menu_draw_buttons();
    }
break;
#endregion

#region Options
case menu_states.option:
    if (panel_scale_y >= 1) {
        draw_string_center(160, 8, titles[state], colors.gray);
        for (var i = 0; i < items_length; i++) {
            var item = items[i];
            var _x = 64;
            var _y = 64 + 24*i;
            draw_string(_x, _y, item[0],
                (selected_item == i ? colors.pink : colors.dark_blue)
            );
            if (selected_item == i)
                draw_string(_x - 16, _y, "▶", colors.pink);
            if (array_length(item) > 2) {
                var subitem = item[2];
                var txt = "";
                var index = (i == 3) ? global.settings[2] : global.settings[i];
                if (index < array_length(subitem)) {
                    txt = subitem[index];
                }
                draw_string_center(_x + 176, _y, txt, colors.orange);
                menu_item_draw_arrows(_x + 176, _y, index, subitem, colors.orange);
            }
        }
    }
break;
#endregion

#region Key Config
case menu_states.key_config:
    if (panel_scale_y >= 1) {
        draw_string_center(160, 8, titles[state], colors.gray);
        for (var i = 1; i < items_length; i++) {
            var item = items[i];
            var _x = 64;
            var _y = 32 + 14*i;
            if (i == items_length - 1) _x = 144;
            var item_name = item[0];
            var _color = (selected_item == i ? colors.pink : colors.dark_blue);
            var show_subitem = array_length(item) > 2;
            var sub_text = "";
            if (i >= 1 && i <= 4 && global.settings[1] == 1) {
                sub_text = " ";
                switch(i) {
                    case 1:
                        item_name = "GAMEPAD INDEX ";
                        sub_text = global.gamepad_list_index;
                    break;
                    case 2:
                        item_name = global.gp_name;
                        _color = colors.orange;
                    break;
                    case 3:
                        item_name = "MOVEMENT";
                        sub_text = gamepad_movement_mode_text[global.gp_movement];
                    break;
                    case 4:
                        item_name = "----------------";
                    break;
                }
            }
            draw_string(_x, _y, item_name, _color);
            if (selected_item == i)
                draw_string(_x - 16, _y, "▶", colors.pink);
            if (show_subitem) {
                var subitems = item[2];
                var txt = "";
                if (sub_text == "")
                    txt = (global.settings[1] == input_types.keyboard) ? subitems[0] : subitems[1];
                else
                    txt = sub_text;
                if (selected_item == i && substates[0] == 1) {
                    txt = " ";
                    if (item_blink_t < 15) txt = "-";
                }
                draw_string(_x + 144, _y, txt, colors.orange);
            }
        }
        menu_draw_buttons();
    }
break;
#endregion

#region Stage Select
case menu_states.stage_select:
    draw_sprite(spr_new_stage_select, image_index, 0, 0);
    for (var i = 0; i < 10; i++) {
        var pos = stage_select_positions[i];
        var _boss = global.boss_slot[i];
        if (_boss != noone) {
            var info = global.boss_info[_boss];
            draw_sprite(info[1], image_index, pos[0], pos[1]);
        }
    }
    if (selected_item < 10) {
        var pos = stage_select_positions[selected_item];
        var _boss = global.boss_slot[selected_item];
        animation2_pos[0] = pos;
        if (_boss != noone) {
            var info = global.boss_info[_boss];
            if (sprite_exists(info[2])) {
                draw_sprite(info[2], image_index, 176, 85);
            }
        }
    }
    animation2_draw();
break;
#endregion

#region Boss Intro
case menu_states.boss_intro:
    if (sprite_exists(boss_intro_sprite))
        draw_sprite(boss_intro_sprite, boss_intro_index, 0, 0);
    if (boss_name_show) {
        text_set_font(text_fonts.big);
        draw_string_center(160, 196, boss_name);
        text_set_font(text_fonts.normal);
    }
    draw_string(16, 220, loading_text);
break;
#endregion

#region Audio Settings
case menu_states.audio_settings:
    if (panel_scale_y >= 1) {
        draw_string_center(160, 8, titles[state], colors.gray);
        for (var i = 0; i < items_length; i++) {
            var item = items[i];
            var _x = 64;
            var _y = 64 + 24*i;
            draw_string(_x, _y, item[0],
                (selected_item == i ? colors.pink : colors.dark_blue)
            );
            if (selected_item == i)
                draw_string(_x - 16, _y, "▶", colors.pink);
            var value = "";
            switch (i) {
                case 0: value = G.voice_language; break;
            }
            draw_string_center(_x + 176, _y, value, colors.orange);
        }
    }
break;
#endregion

#region Volume
case menu_states.volume:
    if (panel_scale_y >= 1) {
        draw_string_center(160, 8, titles[state], colors.gray);
        draw_string(176, 64, string_hash_to_newline(string(global.sfx_volume)), colors.dark_blue);
        draw_string(176, 88, string_hash_to_newline(string(global.bgm_volume)), colors.dark_blue);
        for (var i = 0; i < items_length; i++) {
            var item = items[i];
            var _x = 64;
            var _y = 64 + 24*i;
            draw_string(_x, _y, item[0],
                (selected_item == i ? colors.pink : colors.dark_blue)
            );
            if (selected_item == i)
                draw_string(_x - 16, _y, "▶", colors.pink);
        }
    }
break;
#endregion

#region Voice Language
case menu_states.voice_language:
    if (panel_scale_y >= 1) {
        draw_string_center(160, 8, titles[state], colors.gray);
        for (var i = 0; i < items_length; i++) {
            var item = items[i];
            var _x = 112;
            var _y = 68 + 24*i;
            draw_string(_x, _y, item[0],
                (selected_item == i ? colors.orange : colors.blue)
            );
            if (selected_item == i)
                draw_string(_x - 16, _y, "▶", colors.orange);
        }
    }
break;
#endregion

#region Weapon Get
case menu_states.weapon_get:
    var p = weapon_get_props.player;
    draw_sprite(spr_weapon_get_background, background_index, 0, 0);
    var index = global.character_selected_index[0];
    if (p.visible) {
        menu_draw_player(
            p.x, p.y, index,
            global.player_character_armor_index[index],
            p.palette_sprite,
            p.palette_index,
            p.palette_array
        );
    }
break;
#endregion

}

// =========================
// SCANLINE TRANSITION
// =========================
if (scan_active) {
    draw_set_alpha(scan_alpha);
    draw_set_color(make_color_rgb(180, 80, 255));
    draw_rectangle(0, scan_y - 1, room_width, scan_y + 2, false);
    draw_set_alpha(scan_alpha * 0.3);
    draw_rectangle(0, scan_y - 4, room_width, scan_y - 1, false);
    draw_rectangle(0, scan_y + 2, room_width, scan_y + 6, false);
    draw_set_alpha(1);
    draw_set_color(c_white);
}

draw_set_alpha(1);
draw_set_color(c_white);
