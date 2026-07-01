// ── Sprite del docente grande ──
var _spr = finished ? spr_docente_stand : spr_docente_talk;
var _frame = floor((current_time / 80) mod sprite_get_number(_spr));
var _sw = sprite_get_width(_spr)  * doc_scale;
var _sw = sprite_get_width(spr_docente_stand) * doc_scale;
draw_sprite_ext(_spr, _frame, (320 - _sw) * 0.5, 0, doc_scale, doc_scale, 0, c_white, 1);

// ── Caja de texto ──
draw_set_alpha(0.85);
draw_set_color(make_color_rgb(5, 10, 30));
draw_rectangle(box_x, box_y, box_x + box_w, box_y + box_h, false);
draw_set_alpha(0.5);
draw_set_color(make_color_rgb(100, 150, 255));
draw_rectangle(box_x + 1, box_y + 1, box_x + box_w - 1, box_y + box_h - 1, true);
draw_set_alpha(1);

// Nombre
draw_set_font(fnt_dialog_snes);
draw_set_halign(fa_left);
draw_set_color(make_color_rgb(100, 220, 255));
draw_text(box_x + 8, box_y - 14, "PROFESOR");

// Texto
draw_set_color(c_white);
draw_text_ext(box_x + 8, box_y + 6, display_text, 14, box_w - 16);

// Flecha next
if (finished) {
    var blink = (current_time mod 800) < 400;
    if (blink) {
        draw_set_color(make_color_rgb(255, 200, 0));
        draw_set_halign(fa_right);
        draw_set_font(fnt_dialogue_next);
        draw_text(box_x + box_w - 10, box_y + box_h - 14, "Next ->");
    }
}

draw_set_halign(fa_left);
draw_set_color(c_white);
if (fading) {
    draw_set_alpha(fade_alpha);
    draw_set_color(c_black);
    draw_rectangle(0, 0, 320, 240, false);
    draw_set_alpha(1);
}
draw_set_alpha(1);