wait_intro      = true;
intro_grace     = 0;
activated       = false;
dialog_inst     = noone;
option_selected = -1;
dialog_done     = false;

correct_option  = 2;
reward_item     = [obj_pickup_heart, obj_pickup_life_2, obj_pickup_lifeup];
damage_amount   = 4;

var _p = dialog_get_player_info();
pages = [
    {
        speaker: _p.speaker, mugshot: _p.mugshot, mugshot_idle: _p.mugshot_idle,
        text: "Cuál es la respuesta, responde correctamente?",
        options: []
    },
    {
        speaker: _p.speaker, mugshot: _p.mugshot, mugshot_idle: _p.mugshot_idle,
        text: "ELIGE UNA OPCIÓN:",
        options: ["4", "2", "8"],
		correct_option: correct_option
    },
];