x += speed_x;

// Destruir cuando salga de pantalla
if x < camera_get_view_x(view_camera[0]) - sprite_width {
    instance_destroy();
}