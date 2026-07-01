damage_hit_inst = noone;
wait_intro      = true;
intro_grace     = 0;
activated       = false;
dialog_inst     = noone;
option_selected = -1;
dialog_done     = false;
reward_item = [obj_pickup_heart, obj_pickup_life_2, obj_pickup_lifeup];
// Configuración de opciones correctas/incorrectas
correct_option  = 0;    // índice de la opción correcta
reward_item     = -1;   // item a dar si acierta (-1 = ninguno)
damage_amount   = 4;    // daño si falla

var _p = dialog_get_player_info();
pages = [
    {
        speaker: _p.speaker, mugshot: _p.mugshot, mugshot_idle: _p.mugshot_idle,
        text: "QUE OPCION DEBERIA ESCOGER?.",
        options: []
    },
    {
        speaker: _p.speaker, mugshot: _p.mugshot, mugshot_idle: _p.mugshot_idle,
        text: "ELIGE UNA OPCION:",
        options: ["IR A LA MISION", "NECESITO TIEMPO", "OLVIDALO"]
    },
];