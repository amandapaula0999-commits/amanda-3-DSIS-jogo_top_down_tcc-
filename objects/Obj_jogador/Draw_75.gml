#region Cobertura da tela

// Cobertura integral durante o duto; termina no Create da sala de destino.
if(global.transicao.duto_ativo) {
    gpu_set_texfilter(false);draw_set_alpha(1);draw_set_color(c_black);
    draw_rectangle(0,0,display_get_gui_width(),display_get_gui_height(),false);
    draw_set_color(c_white);
}

#endregion
