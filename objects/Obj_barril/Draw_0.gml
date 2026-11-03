#region Desenho

// Desenha o barril com escala constante durante a queda.
if (mostrar_chao) {
    draw_sprite_ext(Spr_barril_chao, 0, x, y, escala_barril, escala_barril, 0, c_white, 1);
} else if (atingido) {
    // Mantém o tempo da queda e desenha o barril girando.
    var queda = clamp(image_index / max(1, sprite_get_number(Spr_barril_caindo) - 1), 0, 1);
    draw_sprite_ext(Spr_barril, 0, x, y, escala_barril, escala_barril, -90 * queda, image_blend, 1);
} else {
    draw_sprite_ext(Spr_barril, 0, x, y, escala_barril, escala_barril, 0, image_blend, 1);
}

if (respawn_tempo > 0 && respawn_tempo <= 120) {
    var pisca = 0.25 + 0.25 * sin(respawn_tempo * 0.25);
    draw_set_alpha(pisca);
    draw_set_color(make_color_rgb(215, 179, 73));
    draw_circle(x, y, 22, true);
    draw_set_alpha(1);
    draw_set_font(Font_de_fala);
    draw_set_halign(fa_center);
    draw_set_color(make_color_rgb(231, 208, 139));
    draw_text(x, y - 34, "BARRIL EM " + string(ceil(respawn_tempo / 60)) + "s");
    draw_set_halign(fa_left);
    draw_set_font(-1);
}
draw_set_alpha(1);
draw_set_color(c_white);

#endregion
