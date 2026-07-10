var t = instance_create_depth(0, 0, -10000, obj_transition_effect);
t.transition_type = transition_types.clock_wipe_reverse;
t.transition_limit = 90; // ~1.5 seg de revelado — ajustable
t.color = c_black;
global.checkpoint_msg_timer = 0;
transition_create(transition_types.fade_in);
room_shader_init();
switch(global.character_selected_index[0]) {
    case pl_char.x:       global.stage_music = "O_S_X"; break;
    case pl_char.zero:    global.stage_music = "ChillPenguin"; break;
    case pl_char.axl:     global.stage_music = "ChillPenguin"; break;
    case pl_char.iris:    global.stage_music = "ChillPenguin"; break;
    case pl_char.vile:    global.stage_music = "ChillPenguin"; break;
    case pl_char.megaman: global.stage_music = choose("tengu", "tengusaturn"); break;
    default:              global.stage_music = "ChillPenguin"; break;
}
music_play(global.stage_music);
room_shader_init();
