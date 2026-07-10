var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

draw_set_color(c_black);
draw_rectangle(0, 0, gui_w, gui_h, false); // negro siempre, en ambas fases

if (phase == loading_phase.showing) {
	var cx = gui_w / 2;
	var cy = gui_h / 2;
	draw_set_color(c_white);
	var radius = 20;
	for (var i = 0; i < 8; i++) {
		var a = spin_angle + (i * 45);
		var alpha = 0.3 + (i / 8) * 0.7;
		draw_set_alpha(alpha);
		draw_circle(cx + lengthdir_x(radius, a), cy + lengthdir_y(radius, a), 4, false);
	}
	draw_set_alpha(1);
	draw_set_halign(fa_center);
	draw_text(cx, cy + 40, "Cargando...");
	draw_set_halign(fa_left);
}