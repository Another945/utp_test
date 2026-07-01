if global.glitch_state == 0 exit; // nada que hacer

if !shader_is_compiled(sh_glitch) exit;

shader_set(sh_glitch);

shader_set_uniform_f(
    shader_get_uniform(sh_glitch, "u_intensity"),
    global.glitch_intensity
);
shader_set_uniform_f(
    shader_get_uniform(sh_glitch, "u_time"),
    current_time / 1000.0
);

// Dibuja toda la pantalla con el shader encima
draw_surface_stretched(
    application_surface,
    0, 0,
    display_get_gui_width(),
    display_get_gui_height()
);

shader_reset();