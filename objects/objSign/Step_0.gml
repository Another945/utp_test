// Flotación
sinx += sinxAdd;
yspeed = -(cos(sinx) * sinxTimes);
y += yspeed;

var _player = instance_nearest(x, y, obj_player_parent);
if (instance_exists(_player)) {
    var _dist = point_distance(x, y, _player.x, _player.y);
    
    if (_dist < 40 && !instance_exists(obj_dialog)) {
        if (_player.key_p_up) {
            var d = instance_create_layer(0, 0, "GUI", obj_dialog);
            d.trigger = id;
            d.pages = [
                {
                    text:         text,
                    mugshot:      mugshot,
                    mugshot_idle: mugshot_idle,
                    speaker:      speaker
                }
            ];
        }
    }
}