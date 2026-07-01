function is_on_slope(_x = 0, _y = 1) {
    var _slope = instance_place(x + _x, y + _y, obj_slope_parent);
    if (!_slope) _slope = instance_place(x + _x, y + _y + 2, obj_slope_parent);
    if (!_slope) return false;
    if (_x == 0 && _y > 0) {
        if (x < _slope.bbox_left || x > _slope.bbox_right) return false;
    }
    return bbox_bottom <= _slope.bbox_bottom + 2;
}