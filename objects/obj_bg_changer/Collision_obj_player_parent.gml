var bg_info = global.background_list[| z_index][| phase];
layer_background_sprite(back_id, bg_info.sprite);

// Asignar directamente sin necesitar obj_background_area
obj_camera_rds.background_object[z_index] = id;
obj_camera_rds.background_far[z_index] = bg_info.far;