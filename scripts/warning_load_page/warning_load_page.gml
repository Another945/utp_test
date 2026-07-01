function warning_load_page() {
    var page = dialog_pages[dialog_index];
    d_text = page.text;
    d_display_text = "";
    d_text_index = 0;
    d_finished = false;
    d_opened = false;
    d_open_t = 0;
    current_mugshot = page.mugshot;
    current_mugshot_idle = page.mugshot_idle;
    current_speaker = page.speaker;
    is_boss_speaking = page.is_boss;
}