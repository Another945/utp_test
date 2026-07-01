var cam_x = camera_get_view_x(view_camera[0]);
var delta = cam_x - cam_x_prev;
cam_x_prev = cam_x;
bg_offset -= delta * bg_speed;

// Glitch timer
glitch_timer++;
if (!glitch_active) {
    if (glitch_timer > irandom_range(180, 400)) {
        glitch_active = true;
        glitch_t = 0;
        glitch_duration = irandom_range(8, 25);
        glitch_offset_x = irandom_range(-6, 6);
        glitch_color_shift = irandom_range(0, 2);
        glitch_timer = 0;
    }
} else {
    glitch_t++;
    if (glitch_t >= glitch_duration) {
        glitch_active = false;
        glitch_offset_x = 0;
        glitch_color_shift = 0;
    }
}

// Animacion con crossfade
anim_frame = (current_time / anim_speed) mod 100;