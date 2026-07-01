pages = [
    "BIENVENIDO A UTP CIRCUIT MASTERS.",
    "ESTE JUEGO FUE CREADO CON FINES EDUCATIVOS.",
    "FUE HECHO CON EL FIN DE REFRESCAR LA MEMORIA DE LOS ALUMNOS DE CIERTOS TEMAS.",
    "PERO AÑADIENDO UN NIVEL DE PLATAFORMEO Y CIERTOS ENEMIGOS.",
    "EL GAMEPLAY ES SIMPLE, RESPONDE CORRECTAMENTE LAS PREGUNTAS Y RECIBIRAS UN OBJETO AL AZAR.",
    "COMO AUMENTAR TU BARRA DE VIDA O RECUPERARLA EN CASO HAYAS RECIBIDO DAÑO.",
    "EN CASO FALLES RECIBIRAS DAÑO, SI LLEGA A CERO REPETIRAS EL NIVEL EN CASO NO HAYAS ALCANZADO ALGUN CHECKPOINT.",
    "BUENA SUERTE Y QUE TE DIVIERTAS.",
];

page_index   = 0;
text         = pages[0];
display_text = "";
text_index   = 0.0;
text_speed   = 0.2;
finished     = false;

// Caja de texto
box_w = 280;
box_h = 56;
box_x = (320 - box_w) * 0.5;
box_y = 240 - box_h - 8;

// Sprite del docente (grande, centrado arriba)
doc_x = 160;
doc_y = 100;
doc_scale = 0.18; // ajusta según el tamaño que quieras

// Sonido
text_sound_timer = 0;
fading    = false;
fade_alpha = 0;
fade_speed = 1/180; // 180 frames = 3 segundos a 60fps