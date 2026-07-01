if (wait_intro) {
    if (instance_exists(obj_player_parent)) {
        var p = obj_player_parent;
        if (p.state != states.intro && p.state != states.ready && p.state_timer > 5) {
            intro_grace++;
            if (intro_grace >= 10) {
                wait_intro = false;
            }
        }
    }
    exit;
}

if (!activated) {
    if (place_meeting(x, y, obj_player_parent)) {
        activated = true;
        if (instance_exists(obj_player_parent))
            obj_player_parent.locked = true;
        var d = instance_create_layer(0, 0, "triggers", obj_dialog);
        d.pages      = pages;
        d.page_index = 0;
        d.trigger    = id;
        dialog_inst  = d;
    }
}

// Reaccionar cuando el diálogo cierra
if (activated && dialog_done) {
    dialog_done = false;
    
    if (option_selected == -1) exit;
    
    if (option_selected == correct_option) {
        // ── CORRECTO ──────────────────────────────
        if (reward_item != -1) {
            var _pool   = reward_item;
            var _chosen = _pool[irandom(array_length(_pool) - 1)];
            instance_create_layer(obj_player_parent.x, obj_player_parent.y, "triggers", _chosen);
        }
        audio_play_sound(snd_player_success, 0, false);
    } else {
        // ── INCORRECTO ────────────────────────────
        if (instance_exists(obj_player_parent)) {
            with (obj_player_parent) {
                dolor_damage = max(1, floor(other.damage_amount * (1 - damage_reduction)));
                player_state_set(states.dolor, 0, [hp - dolor_damage > 0 && state == states.wall_slide, 0, 0, 0, 0]);
                audio_play_sound(dolor_sound, 0, false);
            }
        }
    }
}
    