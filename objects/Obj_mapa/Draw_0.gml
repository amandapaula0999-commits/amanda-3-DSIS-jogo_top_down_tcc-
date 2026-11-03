#region Desenho

// Desenha a abertura no piso durante a explosão.
if (room == Room_Armadilha) {
    gpu_set_texfilter(false);
    if (armadilha_tempo >= 48) {
        var raio = clamp((armadilha_tempo - 48) * 1.25, 4, 104);
        draw_set_alpha(1);
        draw_set_color(make_color_rgb(18,16,15));
        // Blocos de 4 pixels mantêm o efeito compatível com a arte.
        for (var dy = -104; dy <= 104; dy += 4) {
            for (var dx = -104; dx <= 104; dx += 4) {
                if (dx*dx + dy*dy <= raio*raio) {
                    draw_rectangle(queda_x+dx,queda_y+dy,queda_x+4+dx,queda_y+4+dy,false);
                }
            }
        }
    }
    draw_set_color(c_white);
    draw_set_alpha(1);
    exit;
}

#endregion
