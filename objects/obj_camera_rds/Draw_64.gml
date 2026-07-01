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