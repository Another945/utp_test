
// Draw de obj_checkpoint_msg (no Draw GUI)
if (global.tv_effect) {
    var _vx = __view_get(e__VW.XView, 0);
    var _vy = __view_get(e__VW.YView, 0);
    var _sw = global.view_width;
    var _sh = global.view_height;
    
    gpu_set_blendmode(bm_subtract);
    shader_set(shd_scanlines);
  shader_set_uniform_f(shader_get_uniform(shd_scanlines, "u_strength"), 0.9); // ← reduce de 0.4 a 0.2
    draw_set_color(c_white);
    draw_set_alpha(1);
    draw_rectangle(_vx, _vy, _vx + _sw, _vy + _sh, false);
    shader_reset();
    gpu_set_blendmode(bm_normal);
}