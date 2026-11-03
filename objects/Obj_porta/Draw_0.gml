#region Desenho

if ((room == Room_Recepcao && destino == Room_Corredor_Recepcao)
    || (room == Room_Corredor_Recepcao && destino == Room_Recepcao && chave_exigida != "fechada")) exit;

if (variable_instance_exists(id,"tipo_passagem") && tipo_passagem!="porta") {
    passagem_desenhar(id);
    exit;
}
// Cenário pré-carregado: nenhuma forma geométrica de porta é desenhada.
if (!visual_estatico) {
    if (visual_bunker) {
        var spr=visual_restrita ? Spr_porta_bunker_restrita : Spr_porta_bunker_comum;
        var escala_x=room==Room_Funcionarios ? 1.2 : escala_visual;
        if(x<room_width*0.5) escala_x=-escala_x;
        draw_sprite_ext(spr,clamp(floor(quadro_porta),0,sprite_get_number(spr)-1),x,y,escala_x,escala_visual,0,c_white,1);
    } else draw_sprite(Spr_porta_fachada,0,x,y);
}

// Fase 2: nome branco acima da porta, sem painel de interação.
if (bunker_interface_fase2() || room == Room_Corredor_Pos) {
    bunker_porta_rotulo_desenhar(id);
    draw_set_halign(fa_left);
    draw_set_font(-1);
    draw_set_alpha(1);
    draw_set_color(c_white);
    exit;
}
var jogador = instance_nearest(x, y, Obj_jogador);
if (ativa && !abrindo && !global.interface.pause_aberto && !global.interface.diario_aberto && !global.interface.config_aberta && !global.cena.ativa && !global.interface.dialogo_ativo && bunker_porta_em_alcance(id, jogador)) {
    draw_set_font(Font_de_fala);
    draw_set_halign(fa_center);
    draw_set_color(c_white);
    if (room == Room_Funcionarios) {
        draw_text_transformed(125, y-60,"[E] " + rotulo,0.6,0.6,0);
    } else if (room == Room_Recepcao) {
        // Centraliza o texto na porta usando a largura da mensagem.
        var texto_porta = "[E] " + rotulo;
        var escala_texto = 0.60;
        var meia_largura = string_width(texto_porta) * escala_texto * 0.5;
        var texto_x = clamp(x, meia_largura + 4, room_width - meia_largura - 4);
        var texto_y = max(20, y - (destino == Room_Armadilha ? 60 : 44));
        draw_set_valign(fa_bottom);
        draw_text_transformed(texto_x,texto_y,texto_porta,escala_texto,escala_texto,0);
        draw_set_valign(fa_top);
    } else if (room == Room_Corredor_N2) {
        draw_text_transformed(x,max(12,y-64),"[E] " + rotulo,0.65,0.65,0);
    } else if (room == Room_Manutencao_N2 || room == Room_Ferramentas_N2) {
        draw_text_transformed(clamp(x,110,room_width-110),max(12,y-42),"[E] " + rotulo,0.75,0.75,0);
    } else draw_text(x, y - 64, "[E] " + rotulo);
}

if (mensagem_tempo > 0) {
    draw_set_font(Font_de_fala);
    draw_set_halign(fa_center);
    draw_set_color(make_color_rgb(135, 210, 146));
    if (room == Room_Recepcao) draw_text_transformed(clamp(x,160,room_width-160),max(12,y-70),mensagem_bloqueio,0.55,0.55,0);
    else if(chave_exigida=="ferramentas" || chave_exigida=="pe_cabra") draw_text_transformed(x,max(12,y-70),mensagem_bloqueio,0.55,0.55,0);
    else draw_text(x, y - 90, mensagem_bloqueio);
}
draw_set_halign(fa_left);
draw_set_font(-1);
draw_set_alpha(1);
draw_set_color(c_white);

#endregion
