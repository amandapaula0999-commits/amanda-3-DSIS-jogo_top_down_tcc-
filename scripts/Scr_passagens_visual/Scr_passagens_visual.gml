#region Passagem desenhar

function passagem_desenhar(_p) {
    draw_set_alpha(1);
    if (room == Room_Corredor_Pos) {
        bunker_porta_rotulo_desenhar(_p);
        if (_p.mensagem_tempo > 0 && !global.interface.pause_aberto && !global.interface.diario_aberto
            && !global.interface.config_aberta && !global.cena.ativa && !global.interface.dialogo_ativo) {
            draw_set_font(Font_de_fala);draw_set_halign(fa_left);draw_set_color(c_white);
            draw_text_ext_transformed(472,232,_p.mensagem_bloqueio,20,290,0.65,0.65,0);
        }
        draw_set_font(-1);draw_set_halign(fa_left);draw_set_valign(fa_top);draw_set_color(c_white);
        return;
    }
    // O acesso à escada usa o mesmo nome branco das demais portas.
    if (bunker_interface_fase2()) {
        bunker_porta_rotulo_desenhar(_p);
        draw_set_font(-1);draw_set_halign(fa_left);draw_set_color(c_white);
        return;
    }
    var _j=instance_nearest(_p.x,_p.y,Obj_jogador);
    draw_set_font(Font_de_fala);draw_set_halign(fa_center);
    draw_set_color(make_color_rgb(224,208,162));
    var _texto_y=(_p.tipo_passagem=="escada") ? _p.y-140 : _p.y-65;
    if (room == Room_Corredor_N2) _texto_y = max(12, _p.y-62);
    if(_j!=noone && bunker_porta_em_alcance(_p,_j) && !global.interface.dialogo_ativo && !global.cena.ativa && !global.interface.pause_aberto && !global.interface.diario_aberto && !global.interface.config_aberta) {
        if (room == Room_Corredor_N2) draw_text_transformed(_p.x,_texto_y,"[E] SUBIR ESCADARIA",0.65,0.65,0);
        else draw_text(clamp(_p.x,280,room_width-280),_texto_y,"[E] "+_p.rotulo);
    }
    if(_p.mensagem_tempo>0) {
        var _msg=(_p.tipo_passagem=="elevador") ? "ELEVADOR QUEBRADO. NÃO HÁ ENERGIA." : _p.mensagem_bloqueio;
        draw_text(clamp(_p.x,280,room_width-280),_p.y+135,_msg);
    }
    draw_set_font(-1);draw_set_halign(fa_left);draw_set_color(c_white);
}

#endregion

#region Porta rotulo desenhar

function bunker_porta_rotulo_desenhar(_p) {
    if (!_p.ativa || _p.abrindo || global.interface.pause_aberto || global.interface.diario_aberto
        || global.interface.config_aberta || global.cena.ativa || global.interface.dialogo_ativo
        || global.cena.vitoria_ativa) return;
    var _j = instance_find(Obj_jogador, 0);
    if (_j == noone || !bunker_porta_em_alcance(_p, _j)) return;
    draw_set_font(Font_de_fala);
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_alpha(1);
    draw_set_color(c_white);
    var _texto = "[E] " + _p.rotulo;
    var _escala = 0.65;
    var _metade = string_width(_texto) * _escala * 0.5;
    var _tx = clamp(_p.x, _metade + 8, room_width - _metade - 8);
    var _ty = max(18, _p.y + _p.rotulo_deslocamento_y);
    draw_text_transformed(_tx, _ty, _texto, _escala, _escala, 0);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(-1);
    draw_set_color(c_white);
}

#endregion
