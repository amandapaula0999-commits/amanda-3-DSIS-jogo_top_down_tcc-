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
    if (point_distance(x, y, jogador.x, jogador.y) < 78) {
        bunker_painel(493, 596, 380, 48);
        draw_set_color(make_color_rgb(218, 218, 188));
        draw_text(521, 612, arquivo_liberado() ? "[E] FALAR COM O PESQUISADOR" : "AFASTE A CRIATURA PRIMEIRO");
    }
}
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

#endregion
