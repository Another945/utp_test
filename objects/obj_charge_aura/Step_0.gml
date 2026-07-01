if (!instance_exists(owner)) {
    instance_destroy();
    exit;
}

x = owner.x;
y = owner.y - 8; // centrar en el cuerpo

switch(phase) {
    case 0: // EXPANDIENDO
        radius += expand_speed;
        ray_length += ray_speed;
        if (radius >= 12) {
            phase = 1;
        }
    break;

    case 1: // DESVANECIENDOSE
        alpha -= fade_speed;
        radius += expand_speed * 0.5;
        ray_length += ray_speed * 0.5;
        if (alpha <= 0) {
            instance_destroy();
        }
    break;
}

// Color segun paleta
switch(owner.charge_palette) {
    case 1: col = make_color_rgb(80, 160, 255); break; // azul
    case 2: col = make_color_rgb(160, 80, 255); break; // morado
    case 3: col = make_color_rgb(255, 80, 80);  break; // rojo
    case 7: col = make_color_rgb(255, 200, 0);  break; // dorado
}