draw_set_alpha(alpha);

// Circulo exterior
draw_set_color(col);
draw_circle(x, y, radius + 4, false);

// Circulo interior mas brillante
draw_set_alpha(alpha * 1.2);
draw_set_color(c_white);
draw_circle(x, y, radius * 0.6, false);

// Rayos diagonales (4 esquinas)
draw_set_alpha(alpha);
draw_set_color(col);

var _dirs = [45, 135, 225, 315];
for (var i = 0; i < 4; i++) {
    var _angle = _dirs[i];
    var _x1 = x + lengthdir_x(radius * 0.8, _angle);
    var _y1 = y + lengthdir_y(radius * 0.8, _angle);
    var _x2 = x + lengthdir_x(radius * 0.8 + ray_length, _angle);
    var _y2 = y + lengthdir_y(radius * 0.8 + ray_length, _angle);
    draw_line_width(_x1, _y1, _x2, _y2, 2);
}

// Rayos en cruz (horizontal y vertical) mas cortos
draw_set_alpha(alpha * 0.6);
var _dirs2 = [0, 90, 180, 270];
for (var i = 0; i < 4; i++) {
    var _angle = _dirs2[i];
    var _x1 = x + lengthdir_x(radius * 0.8, _angle);
    var _y1 = y + lengthdir_y(radius * 0.8, _angle);
    var _x2 = x + lengthdir_x(radius * 0.8 + ray_length * 0.6, _angle);
    var _y2 = y + lengthdir_y(radius * 0.8 + ray_length * 0.6, _angle);
    draw_line_width(_x1, _y1, _x2, _y2, 1);
}

draw_set_alpha(1);
draw_set_color(c_white);