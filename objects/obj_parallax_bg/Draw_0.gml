var cam_x = camera_get_view_x(view_camera[0]);
var cam_y = camera_get_view_y(view_camera[0]);
var vw = camera_get_view_width(view_camera[0]);
var vh = camera_get_view_height(view_camera[0]);

// =========================
// CAPA 1 - CIELO NOCTURNO
// =========================


// =========================
// CAPA 2 - NUBES CON CROSSFADE
// =========================
var cloud_speed = 50;
var cloud_frame = (current_time / cloud_speed) mod 100;
var frame_int = floor(cloud_frame);
var blend = frac(cloud_frame);
var frame_next = (frame_int + 1) mod 100;

// Siempre dibuja el frame actual
draw_sprite_ext(spr_nube, frame_int, cam_x, cam_y, 1, 1, 0, c_white, 1);

// Crossfade normal entre frames consecutivos
draw_sprite_ext(spr_nube, frame_next, cam_x, cam_y, 1, 1, 0, c_white, blend);

// Crossfade adicional hacia frame 0 cuando se acerca al final
var fade_start = 85;
if (frame_int >= fade_start) {
    var fade_alpha = (frame_int - fade_start) / (100 - fade_start);
    fade_alpha = ease_out_quad(fade_alpha);
    draw_sprite_ext(spr_nube, 0, cam_x, cam_y, 1, 1, 0, c_white, fade_alpha);
}