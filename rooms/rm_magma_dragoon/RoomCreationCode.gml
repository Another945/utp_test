var t = instance_create_depth(0, 0, -10000, obj_transition_effect);
t.transition_type = transition_types.clock_wipe_reverse;
t.transition_limit = 90; // ~1.5 seg de revelado — ajustable
t.color = c_black;
music_play("MagmaDragoon");
background_list_set(1, [new BGInfo(bg_magma_dragoon_2, 0.75)]);
background_list_set(2, [new BGInfo(bg_magma_dragoon)]);
background_list_set(3, [new BGInfo(bg_magma_dragoon_3, 0.5)]);
room_shader_init();