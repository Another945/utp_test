function dialog_get_player_info() {
    var _index = global.character_selected_index[0];
    var _armor = global.player_character_armor[_index];
    var _full = _armor[P_FULL];

    switch(_index) {
        case pl_char.x:
            // Verificar si tiene ultimate armor
            if (_full == "ult") {
                return { speaker: "X", mugshot: spr_ultimate_talk, mugshot_idle: spr_ultimate_look };
            }
            return { speaker: "X", mugshot: spr_x_talk, mugshot_idle: spr_x_look };
        case pl_char.zero:
            return { speaker: "ZERO", mugshot: spr_zero_talk, mugshot_idle: spr_zero_look };
        case pl_char.axl:
            return { speaker: "AXL", mugshot: spr_axl_talk, mugshot_idle: spr_axl_look };
        case pl_char.iris:
            return { speaker: "IRIS", mugshot: spr_iris_talk, mugshot_idle: spr_iris_look };
        case pl_char.vile:
            return { speaker: "VILE", mugshot: spr_vile_talk, mugshot_idle: spr_vile_look };
        case pl_char.megaman:
            return { speaker: "MEGAMAN", mugshot: spr_megaman_talk, mugshot_idle: spr_megaman_look };
        default:
            return { speaker: "X", mugshot: spr_x_talk, mugshot_idle: spr_x_look };
    }
}