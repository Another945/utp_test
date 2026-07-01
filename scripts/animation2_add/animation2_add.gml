function animation2_add() {
	animation2_sprite[animation2_num] = argument[0];
	animation2_index[animation2_num] = 0;
	animation2_speed[animation2_num] = argument[1];
	animation2_pos[animation2_num] = [0, 0];
	animation2_show[animation2_num] = false;

	// NUEVO
	animation2_scale[animation2_num] = [1, 1];

	if (argument_count > 3) {
		animation2_pos[animation2_num] = [argument[2], argument[3]];
		animation2_show[animation2_num] = true;
	}

	// NUEVO: escala opcional
	if (argument_count > 5) {
		animation2_scale[animation2_num] = [argument[4], argument[5]];
	}

	animation2_num++;
}