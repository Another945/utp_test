if !activated && global.glitch_state == 1 {
    // Solo activa si el glitch ya está encendido
    activated = true;
    global.glitch_state = 2; // Pasa a fase shake
    instance_destroy();
}

if global.glitch_state == 0 {
    // El jugador llegó aquí sin pasar por obj_glitch_col
    // Activa ambas fases de golpe (opcional)
    global.glitch_state = 2;
    global.glitch_intensity = 1.0;
    instance_destroy();
}