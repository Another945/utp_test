// Parallax
bg_offset = 0;
bg_speed = 0.3;
cam_x_prev = camera_get_view_x(view_camera[0]);

// Glitch
glitch_timer = 0;
glitch_active = false;
glitch_t = 0;
glitch_duration = 0;
glitch_offset_x = 0;
glitch_color_shift = 0;

// Animacion
anim_frame = 0;
anim_speed = 50;