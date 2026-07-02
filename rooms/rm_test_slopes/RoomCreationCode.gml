global.checkpoint_msg_timer = 0;
transition_create(transition_types.fade_in);
background_list_set(1, [
    new BGInfo(Sprite1178, 0.2)
]);
background_list_set(2, [
    new BGInfo(spr_fondo_cercano, 0.6)
]);
room_shader_init();
switch(global.character_selected_index[0]) {
    case pl_char.x:       global.stage_music = "O_S_X"; break;
    case pl_char.zero:    global.stage_music = "ChillPenguin"; break;
    case pl_char.axl:     global.stage_music = "ChillPenguin"; break;
    case pl_char.iris:    global.stage_music = "ChillPenguin"; break;
    case pl_char.vile:    global.stage_music = "ChillPenguin"; break;
    case pl_char.megaman: global.stage_music = "O_S_Rockman"; break;
    default:              global.stage_music = "ChillPenguin"; break;
}
music_play(global.stage_music);