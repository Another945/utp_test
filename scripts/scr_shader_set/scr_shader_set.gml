function scr_shader_set() {
	if (global.support_shaders) {
		shader_set(argument[0]);	
	}
}

function room_shader_init() {
	var layers = layer_get_all();
	for (var i = array_length(layers) - 1; i >= 0; i--) {
		var t_layer = layers[i];
		var layer_name = layer_get_name(t_layer);
		if (string_lower(string_copy(layer_name, 1, 4)) == "tile"
		|| string_lower(string_copy(layer_name, 1, 10)) == "background"
		|| layer_name == "animated_tile") {
			layer_script_begin(t_layer, scr_tile_begin);
			layer_script_end(t_layer, scr_shader_reset);
	    }
	}
	global.tile_shader_u_multiplier = shader_get_uniform(shdr_tile, "Multiplier")
	global.tile_shader_multiplier = 1;
	shader_set_uniform_f(global.tile_shader_u_multiplier, global.tile_shader_multiplier);
}

function room_image_speed_set(spd) {
	var layers = layer_get_all();
	
	for (var i = array_length(layers) - 1; i >= 0; i--) {
		var t_layer = layers[i];
		var name = string_lower(layer_get_name(t_layer));
		
		if (string_copy(name, 1, 10) == "background") {
			
			var bg_id = layer_background_get_id(t_layer);
			if (bg_id == -1) continue;
			
			var spr_id = layer_background_get_sprite(bg_id);
			if (spr_id == -1) continue;
			
			var base_speed = sprite_get_speed(spr_id);
			layer_background_speed(bg_id, spd * base_speed);
		}
	}
}