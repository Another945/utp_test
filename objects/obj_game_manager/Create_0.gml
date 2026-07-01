// Estado global del sistema de glitch
global.glitch_state = 0;      // 0=normal 1=glitch 2=shake
global.glitch_intensity = 0; // 0.0 a 1.0
global.shake_mag = 0;        // píxeles de desplazamiento

// Posición original de la ventana
win_x = window_get_x();
win_y = window_get_y();