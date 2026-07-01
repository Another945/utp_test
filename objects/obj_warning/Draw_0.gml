// DRAW normal - solo el warning
if (phase < 3) {
    if (!blink_visible) exit;
    var _eased = 1 - (1 - scale_y) * (1 - scale_y);
    var _target_w = 200;
    var _target_h = 60;
    var _sx = _target_w / sprite_get_width(spr_warning);
    var _sy = (_target_h / sprite_get_height(spr_warning)) * _eased;
    draw_sprite_ext(
        spr_warning, floor(anim_frame),
        x, y,
        _sx, _sy,
        0, c_white, 1
    );
}