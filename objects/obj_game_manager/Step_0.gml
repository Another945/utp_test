switch (global.glitch_state) {

  case 0: // Normal — sin efectos
    global.glitch_intensity = 0;
    global.shake_mag = 0;
  break;

  case 1: // Glitch activo — intensidad crece con el tiempo
    global.glitch_intensity = min(
        global.glitch_intensity + 0.004, 1.0
    );
    global.shake_mag = 0;
  break;

  case 2: // Shake — glitch al máximo + ventana tiembla
    global.glitch_intensity = 1.0;

    // Aumenta el temblor gradualmente
    global.shake_mag = min(global.shake_mag + 0.3, 12);

    // Desplaza la ventana del OS de forma aleatoria
    var _sx = irandom_range(-global.shake_mag, global.shake_mag);
    var _sy = irandom_range(-global.shake_mag, global.shake_mag);
    window_set_position(win_x + _sx, win_y + _sy);
  break;
}