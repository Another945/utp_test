x = __view_get(e__VW.XView, 0);
y = __view_get(e__VW.YView, 0);
draw_set_alpha(alpha);

draw_rectangle_color(
	x, y, x + global.view_width, y + global.view_height,
	color, color, color, color, false
);
draw_set_alpha(1);

if (back_sprite != noone) {
	draw_sprite(back_sprite, back_index, x, y);
}
x = __view_get(e__VW.XView, 0);
y = __view_get(e__VW.YView, 0);

if (transition_type == transition_types.clock_wipe || transition_type == transition_types.clock_wipe_reverse) {
	var cx = x + global.view_width / 2;
	var cy = y + global.view_height / 2;
	var radius = sqrt(sqr(global.view_width) + sqr(global.view_height));
	draw_set_color(color);
	draw_primitive_begin(pr_trianglefan);
	draw_vertex(cx, cy);
	var steps = 32;
	for (var i = 0; i <= steps; i++) {
		var a = -90 + (sweep_angle * i / steps); // empieza en las 12, gira — invierte el signo si gira al revés
		draw_vertex(cx + lengthdir_x(radius, a), cy + lengthdir_y(radius, a));
	}
	draw_primitive_end();
} else {
	draw_set_alpha(alpha);
	draw_rectangle_color(x, y, x + global.view_width, y + global.view_height, color, color, color, color, false);
	draw_set_alpha(1);
	if (back_sprite != noone) draw_sprite(back_sprite, back_index, x, y);
}