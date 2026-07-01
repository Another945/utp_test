visible = true;
display_set_gui_size(global.view_width, global.view_height);
// Pausa
pause_selected = 0;
pause_in_options = false;
pause_option_selected = 0;
pause_option_items = [
    ["TAMAÑO DE PANTALLA", global.wsize_options],
    ["CONTROLES"],
    ["AUDIO"],
    ["EFECTO TV", ["OFF", "ON"]],
    ["ATRAS"]
];
pause_option_length = array_length(pause_option_items);
pause_items = ["CONTINUAR", "OPCIONES", "SALIR AL MENU"];
pause_items_length = array_length(pause_items);

// Audio sub-menu
pause_in_audio = false;
pause_audio_selected = 0;
pause_audio_items = [
    ["EFECTOS"],
    ["MUSICA DE FONDO"],
    ["ATRAS"]
];
pause_audio_length = array_length(pause_audio_items);
// Controles en pausa
pause_in_controls = false;
pause_controls_selected = 0;
pause_controls_length = 13; // 12 teclas + ATRAS
pause_controls_waiting = false; // esperando input
pause_controls_blink_t = 0;