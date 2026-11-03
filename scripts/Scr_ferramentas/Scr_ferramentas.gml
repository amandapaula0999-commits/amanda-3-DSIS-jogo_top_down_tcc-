#region Sala10 entrar

function sala10_entrar(_m) {
    _m.ferramentas_mensagem_tempo=180;_m.ferramentas_mensagem_quadro=0;_m.ferramentas_suporte_examinado=false;
    _m.ferramentas_interacao_proxima="";_m.ferramentas_bloqueio_input=12;
    _m.ferramentas_observar_ambiente=!global.inventario.pe_cabra;
    sala10_sprites_atualizar();
}

#endregion

#region Sala10 sprites atualizar

function sala10_sprites_atualizar() {
    var suporte=instance_find(Obj_sala10_suporte,0);
    if(suporte!=noone) {suporte.image_speed=0;suporte.image_index=0;}
    var pe=instance_find(Obj_sala10_pe_cabra,0);
    if(pe!=noone) {pe.image_speed=0;pe.visible=!global.inventario.pe_cabra;}
}

#endregion

#region Sala10 step

function sala10_step(_m) {
    if(global.interface.pause_aberto || global.interface.config_aberta || global.interface.diario_aberto || global.cena.ativa || global.interface.dialogo_ativo) return;
    if(_m.ferramentas_bloqueio_input>0) _m.ferramentas_bloqueio_input = max(0,_m.ferramentas_bloqueio_input - bunker_passo());
    if(_m.ferramentas_mensagem_tempo>0) _m.ferramentas_mensagem_tempo = max(0,_m.ferramentas_mensagem_tempo - bunker_passo());
    // Primeira impressão comum; depois, o protagonista percebe a ferramenta na parede.
    if(_m.ferramentas_mensagem_tempo<=0 && _m.ferramentas_observar_ambiente) {
        _m.ferramentas_observar_ambiente=false;_m.ferramentas_mensagem_quadro=1;_m.ferramentas_mensagem_tempo=210;
    }
    _m.ferramentas_interacao_proxima="";
    var j=instance_find(Obj_jogador,0);
    if(j!=noone) {
        if(mapa_distancia(j,"suporte")<=28) _m.ferramentas_interacao_proxima="suporte";
        else if(mapa_distancia(j,"bancada")<=26) _m.ferramentas_interacao_proxima="bancada";
        else if(mapa_distancia(j,"prateleira")<=26) _m.ferramentas_interacao_proxima="prateleira";
        if(_m.ferramentas_bloqueio_input<=0 && _m.ferramentas_interacao_proxima!="" && bunker_interagir()) {
            _m.ferramentas_observar_ambiente=false;
            if(_m.ferramentas_interacao_proxima=="suporte") {
                if(global.inventario.pe_cabra) _m.ferramentas_mensagem_quadro=5;
                else if(!_m.ferramentas_suporte_examinado) {_m.ferramentas_suporte_examinado=true;_m.ferramentas_mensagem_quadro=3;}
                else {
                    global.inventario.pe_cabra=true;
                    sala10_sprites_atualizar();
                    _m.ferramentas_mensagem_quadro=4;
                    bunker_audio_tocar_efeito(Snd_item,9,false);
                }
            } else _m.ferramentas_mensagem_quadro=_m.ferramentas_interacao_proxima=="bancada" ? 7 : 9;
            _m.ferramentas_mensagem_tempo=210;_m.ferramentas_bloqueio_input=12;
        }
    }
    var feedback=instance_find(Obj_sala10_feedback,0);
    if(feedback!=noone) {
        feedback.visible=false;feedback.image_speed=0;
        if(_m.ferramentas_mensagem_tempo>0) {feedback.visible=true;feedback.image_index=_m.ferramentas_mensagem_quadro;}
        else if(_m.ferramentas_interacao_proxima!="") {
            feedback.visible=true;
            if(_m.ferramentas_interacao_proxima=="suporte") feedback.image_index=global.inventario.pe_cabra ? 5 : (_m.ferramentas_suporte_examinado ? 3 : 2);
            if(_m.ferramentas_interacao_proxima=="bancada") feedback.image_index=6;
            if(_m.ferramentas_interacao_proxima=="prateleira") feedback.image_index=8;
        }
    }
}

#endregion
