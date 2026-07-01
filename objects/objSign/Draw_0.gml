draw_self();

var _player = instance_nearest(x, y, obj_player_parent);
if (instance_exists(_player)) {
    var _dist = point_distance(x, y, _player.x, _player.y);
    
    if (_dist < 40 && !instance_exists(obj_dialog)) {
        var _float_y = -(cos(sinx) * sinxTimes) * 6;
        
        draw_set_font(fnt_dialog_snes);
        draw_set_halign(fa_center);
        
        draw_set_alpha(0.5);
        draw_set_color(c_black);
        draw_text_transformed(x + 1, bbox_top - 14 + _float_y + 1, "▲ Presiona Arriba", 0.7, 0.7, 0);
        draw_set_alpha(1);
        
        draw_set_color(make_color_rgb(255, 220, 50));
        draw_text_transformed(x, bbox_top - 14 + _float_y, "▲ Presiona Arriba", 0.7, 0.7, 0);
        
        draw_set_halign(fa_left);
        draw_set_color(c_white);
        draw_set_alpha(1);
    }
}