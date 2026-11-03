#region Configuração alternar

function bunker_configuracao_alternar(_indice) {
    if (_indice == 0) global.config.musica_muda = !global.config.musica_muda;
    if (_indice == 1) global.config.efeitos_mudos = !global.config.efeitos_mudos;
    bunker_audio_aplicar_configuracao();
}

#endregion

#region Configurações desenhar

function bunker_configuracoes_desenhar(_selecionado) {
    var gw = display_get_gui_width();
    var gh = display_get_gui_height();
    var sx = gw / 1366;
    var sy = gh / 768;
    var ys = [270, 382, 494];
    var nomes = ["MÚSICA", "EFEITOS", "VOLTAR"];
    var estados = [global.config.musica_muda ? "SILENCIADA" : "ATIVADA",
        global.config.efeitos_mudos ? "SILENCIADOS" : "ATIVADOS", ""];

    draw_set_alpha(0.96);
    draw_set_color(make_color_rgb(12, 10, 8));
    draw_rectangle(154 * sx, 78 * sy, 1212 * sx, 690 * sy, false);
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(181, 112, 58));
    draw_rectangle(154 * sx, 78 * sy, 1212 * sx, 690 * sy, true);
    draw_set_color(make_color_rgb(61, 31, 19));
    draw_rectangle(172 * sx, 96 * sy, 1194 * sx, 672 * sy, false);

    draw_set_font(Font_de_fala);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(238, 205, 139));
    draw_text_transformed(gw * 0.5, 142 * sy, "CONFIGURAÇÕES", 3.0 * sx, 3.0 * sy, 0);
    draw_set_color(make_color_rgb(198, 168, 116));
    draw_text_transformed(gw * 0.5, 188 * sy, "ÁUDIO", 1.55 * sx, 1.55 * sy, 0);

    for (var i = 0; i < 3; i++) {
        var ativo = i == _selecionado;
        draw_set_color(ativo ? make_color_rgb(73, 117, 43) : make_color_rgb(83, 48, 29));
        draw_rectangle(330 * sx, (ys[i] - 38) * sy, 1036 * sx, (ys[i] + 38) * sy, false);
        draw_set_color(ativo ? make_color_rgb(136, 177, 65) : make_color_rgb(125, 73, 39));
        draw_rectangle(342 * sx, (ys[i] - 29) * sy, 1024 * sx, (ys[i] - 21) * sy, false);
        draw_set_color(make_color_rgb(244, 226, 190));
        draw_text_transformed(522 * sx, ys[i] * sy, nomes[i], 1.85 * sx, 1.85 * sy, 0);
        if (i < 2) {
            draw_set_color(make_color_rgb(35, 22, 14));
            draw_text_transformed(856 * sx, ys[i] * sy, estados[i], 1.55 * sx, 1.55 * sy, 0);
        }
    }

    draw_set_color(make_color_rgb(238, 205, 139));
    draw_text_transformed(gw * 0.5, 650 * sy, "W/S: SELECIONAR   A/D OU ENTER: ALTERAR   ESC: VOLTAR", 1.35 * sx, 1.35 * sy, 0);
    draw_set_font(-1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    draw_set_alpha(1);
}

#endregion
