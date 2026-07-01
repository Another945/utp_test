function dialog_load_page(d) {
    var page  = d.pages[d.page_index];
    d.text         = page.text;
    d.display_text = "";
    d.text_index   = 0;
    d.finished     = false;
    d.current_mugshot      = page.mugshot;
    d.current_mugshot_idle = page.mugshot_idle;
    d.current_speaker      = page.speaker;
    
    // Opciones
    if (variable_struct_exists(page, "options") && array_length(page.options) > 0) {
        d.has_options     = true;
        d.choosing        = true;
        d.options         = page.options;
        d.option_index    = 0;
        d.option_selected = -1;
        d.correct_option  = variable_struct_exists(page, "correct_option") ? page.correct_option : -1;
    } else {
        d.has_options    = false;
        d.choosing       = false;
        d.options        = [];
        d.correct_option = -1;
    }
    
    // Resultado (check/X)
    d.showing_result = false;
    d.result_timer   = 0;
    d.result_correct = false;
}