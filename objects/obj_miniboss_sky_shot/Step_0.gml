event_inherited();
if (!can_move_x(h_speed)) {
	instance_destroy();
}
if (y < camera_get_view_y(view_camera[0]) - 32 || y > camera_get_view_y(view_camera[0]) + global.view_height + 32) {
	instance_destroy(); // se sale de pantalla verticalmente, se limpia solo
}