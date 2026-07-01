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
    case pl_char.x:       music_play("O_S_X"); break;
    case pl_char.zero:    music_play("ChillPenguin"); break;
    case pl_char.axl:     music_play("ChillPenguin"); break;
    case pl_char.iris:    music_play("ChillPenguin"); break;
    case pl_char.vile:    music_play("ChillPenguin"); break;
    case pl_char.megaman: music_play("O_S_Rockman"); break;
    default:              music_play("ChillPenguin"); break;
}
