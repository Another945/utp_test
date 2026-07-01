if (text_index < string_length(text)) {
    var prev = floor(text_index);
    text_index += text_speed;
    display_text = string_copy(text, 1, floor(text_index));
    if (floor(text_index) > prev) {
        audio_play_sound(snd_text, 0, false);
    }
    finished = false;
} else {
    display_text = text;
    finished = true;
}

if (keyboard_check_pressed(global.key_config[e_key.shoot])) {
    if (!finished) {
        text_index   = string_length(text);
        display_text = text;
        finished     = true;
    } else {
        page_index++;
        if (page_index < array_length(pages)) {
            text         = pages[page_index];
            display_text = "";
            text_index   = 0;
            finished     = false;
        } else {
            fading = true;
        }
    }
}

if (fading) {
    fade_alpha += fade_speed;
    if (fade_alpha >= 1) {
        fade_alpha = 1;
        room_goto(rm_test_slopes);
    }
}