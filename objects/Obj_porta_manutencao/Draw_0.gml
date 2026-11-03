#region Desenho

// Somente o texto de interação. Arte inteira em sprites pré-carregados.
if (global.interface.pause_aberto || global.interface.diario_aberto || global.interface.config_aberta
    || global.cena.ativa || global.interface.dialogo_ativo || global.cena.vitoria_ativa) exit;
var jogador = instance_nearest(x,y,Obj_jogador);
if (jogador == noone) exit;
var texto = "";
var tx = x;
var ty = y - 48;
if (!aberta && point_distance(x,y,jogador.x,jogador.y) <= raio_interacao)
    texto = global.inventario.pe_cabra ? "[SEGURE E / 3 s] ABRIR CÂMARA FRIA" : "[E] TENTAR ABRIR";
else if (aberta && jogador.y >= mapa_ponto("homem_camara").y + 11 && mapa_distancia(jogador,"homem_camara") <= 28) {
    texto = global.inventario.cartao_pesquisa ? "[E] FALAR" : "[E] PEGAR CRACHÁ";
    tx = mapa_ponto("homem_camara").x - 2;
    ty = mapa_ponto("homem_camara").y - 26;
}
if (texto != "") {
    draw_set_font(Font_de_fala);
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_text_transformed(tx,ty,texto,0.6,0.6,0);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(-1);
}

#endregion
