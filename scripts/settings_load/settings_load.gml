function settings_load() {
    ini_open("Settings/savedata.ini");
    global.settings[0] = ini_read_real("SETTINGS", "Window", G.mobile ? 0 : 1);
    if (G.mobile && global.settings[0] > 1) {
        global.settings[0] = 0;
    }
    global.settings[1] = ini_read_real("SETTINGS", "Input", input_types.keyboard);
    global.settings[2] = ini_read_real("SETTINGS", "TVEffect", 0); // ← nuevo
    global.tv_effect = (global.settings[2] == 1);                  // ← nuevo
    G.voice_language = ini_read_string("AUDIO", "Voice Language", "SNES");
    global.sfx_volume = ini_read_real("AUDIO", "Sound Volume", 1);
    global.bgm_volume = ini_read_real("AUDIO", "Music Volume", 1);
    for (var i = 0; i < array_length(global.key_config); i++) {
        global.key_config[i] = ini_read_real("KEYS", global.key_text[i], global.key_config_default[i]);
        if (i > e_key.right)
            global.gamepad_config[i] = ini_read_real("GAMEPAD", global.key_text[i], global.gamepad_config_default[i]);
    }
    ini_close();
    settings_apply();
}