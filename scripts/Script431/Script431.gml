function slope_get_surface_y(slope, world_x) {
    var _left  = slope.bbox_left;
    var _right = slope.bbox_right;
    var _top   = slope.bbox_top;
    var _bot   = slope.bbox_bottom;
    var _w     = _right - _left;
    var _h     = _bot - _top;
    
    // t = posición relativa dentro del slope (0 = izquierda, 1 = derecha)
    var t = clamp((world_x - _left) / _w, 0, 1);
    
    // image_xscale < 0 = slope sube de izquierda a derecha (left)
    // image_xscale > 0 = slope baja de izquierda a derecha (right)
    if (slope.image_xscale < 0) {
        return _top + t * _h;      // surface_y sube hacia la derecha
    } else {
        return _top + (1 - t) * _h; // surface_y baja hacia la derecha
    }
}