var cam_x = camera_get_view_x(view_camera[0]);
var cam_y = camera_get_view_y(view_camera[0]);
var vw = camera_get_view_width(view_camera[0]);
var vh = camera_get_view_height(view_camera[0]);

var spr_w = sprite_get_width(spr_buildings_x3);
var spr_h = sprite_get_height(spr_buildings_x3);
var offset = bg_offset mod spr_w;

// Animacion con crossfade
var frame_int = floor(anim_frame);
var frame_next = (frame_int + 1) mod 100;
var blend = frac(anim_frame);

// Glitch values
var gx = glitch_active ? glitch_offset_x : 0;
var g_alpha = 1;
if (glitch_active && glitch_t mod 2 == 0) {
    g_alpha = 0.6;
}

// Repetir sprite horizontalmente
for (var rep = -1; rep <= 2; rep++) {
    var bx = cam_x + offset + rep * spr_w + gx;
    var by = cam_y + vh - spr_h - 50; // sube 30 pixels, ajusta al gusto

    // Frame actual
    draw_sprite_ext(
        spr_buildings_x3, frame_int,
        bx, by,
        1, 1, 0, c_white, g_alpha
    );

    // Crossfade con siguiente frame
    draw_sprite_ext(
        spr_buildings_x3, frame_next,
        bx, by,
        1, 1, 0, c_white, blend * g_alpha
    );

    // Glitch color - copia desplazada con color diferente
    if (glitch_active) {
        if (glitch_color_shift > 0) {
            draw_sprite_ext(
                spr_buildings_x3, frame_int,
                bx + irandom_range(-3, 3), by,
                1, 1, 0, make_color_rgb(80, 150, 255), 0.15
            );
        }
        // Scanline horizontal durante glitch
        if (glitch_t mod 3 == 0) {
            draw_set_alpha(0.3);
            draw_set_colour(make_color_rgb(100, 200, 255));
            var scan_y = by + irandom(spr_h);
            draw_rectangle(cam_x, scan_y, cam_x + vw, scan_y + 2, false);
            draw_set_alpha(1);
        }
    }
}

draw_set_alpha(1);
draw_set_colour(c_white);