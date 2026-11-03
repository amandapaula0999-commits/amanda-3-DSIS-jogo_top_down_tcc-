#region Interface

// HUD do jogador: condição, equipamento e contador do diário.
if (global.cena.ativa) exit;
var tem_equipamento = global.inventario.arma_pregos || global.inventario.cano;
bunker_painel(16, 16, 276, tem_equipamento ? 166 : 98);
draw_set_font(Font_de_fala);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(make_color_rgb(31, 42, 36));
draw_rectangle(30, 31, 274, 42, false);
draw_set_color(make_color_rgb(151, 68, 49));
draw_rectangle(30, 31, 30 + 244 * max(0, vida) / vida_max, 42, false);
draw_set_color(make_color_rgb(215, 208, 178));
draw_text(30, 51, "CONDIÇÃO " + string(max(0, floor(vida))) + "%");
// Mostra a munição somente depois de coletar a arma.
if (tem_equipamento) {
    var equipamento = global.inventario.arma_pregos ? "[2] PISTOLA DE PREGOS" : "[1] CANO";
    if (global.inventario.arma_pregos && global.inventario.equipamento_ativo == "cano") equipamento = "[1] CANO  |  [2] PISTOLA";
    draw_text(30, 73, equipamento);
    if (global.inventario.arma_pregos) {
        draw_set_color(make_color_rgb(161, 178, 155));
        draw_text(30, 96, "PENTE " + string(global.inventario.pregos_carregados) + "  /  RESERVA " + string(global.inventario.pregos_reserva));
    }
    draw_set_color(furtivo ? make_color_rgb(164, 190, 145) : make_color_rgb(184, 158, 106));
    draw_text(30, 122, furtivo ? "SHIFT: PASSOS LEVES" : "SHIFT: ANDAR EM SILÊNCIO");
}
draw_set_color(make_color_rgb(161, 178, 155));
draw_text(30, tem_equipamento ? 145 : 73, "[Q] KITS DE VIDA: " + string(global.inventario.kits_vida));
bunker_painel(1094, 16, 256, 60);
draw_set_color(make_color_rgb(214, 197, 148));
draw_text(1110, 37, "[J] DIÁRIO  " + string(array_length(global.progresso.evidencias)) + " / 7");
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_font(-1);

#endregion
