// Flotación suave
y = y_base + sin(current_time * 0.002) * 6;
if (!triggered && place_meeting(x, y, obj_player_parent)) {
	triggered = true;
	audio_play(snd_book_pickup);
	with (obj_player_parent) {
		locked = true; // se queda quieto, sin caminar todavía
	}
	alarm[0] = 60; // 1 segundo quieto antes de empezar a caminar
}