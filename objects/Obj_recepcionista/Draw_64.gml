#region Interface

// Interface comum de diálogo, com leitura em área protegida.
draw_set_alpha(1);
draw_set_font(Font_de_fala);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
if (global.interface.pause_aberto || global.interface.diario_aberto || global.interface.config_aberta || global.cena.vitoria_ativa) exit;
if (exibir_dialogo) {
    bunker_aviso_gui(texto_atual, "E / ESPAÇO: COMPLETAR / AVANÇAR", texto_completo);
} else if (!global.cena.ativa && !global.interface.dialogo_ativo && instance_exists(Obj_jogador)) {
    var jogador = instance_nearest(x, y, Obj_jogador);
    if (point_distance(interacao_x, interacao_y, jogador.x, jogador.y) < raio_interacao) {
        bunker_aviso_gui("", "[E] FALAR COM A SECRETARIA");
    }
}
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

#endregion
