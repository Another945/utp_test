var cam_x = camera_get_view_x(view_camera[0]);
var delta = cam_x - cam_x_prev;
cam_x_prev = cam_x;

layer_far_x -= delta * speed_far;
layer_near_x -= delta * speed_near;