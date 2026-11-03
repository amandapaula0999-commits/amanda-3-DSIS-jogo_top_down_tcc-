#region Porta em alcance

function bunker_porta_em_alcance(_porta, _jogador) {
    if (_jogador == noone) return false;
    if (_porta.usar_area_interacao) {
        return point_in_rectangle(_jogador.x, _jogador.y,
            _porta.x + _porta.area_esquerda, _porta.y + _porta.area_topo,
            _porta.x + _porta.area_direita, _porta.y + _porta.area_fundo);
    }
    var _raio = _porta.raio_interacao;
    if (variable_instance_exists(_porta, "tipo_passagem") && _porta.tipo_passagem != "porta") _raio = 82;
    return point_distance(_porta.x, _porta.y, _jogador.x, _jogador.y) <= _raio;
}

#endregion

#region Passagem liberada

function passagem_liberada(_p) {
    if (_p.chave_exigida == "fechada") return false;
    if (variable_instance_exists(_p,"chave_exigida")) {
        if (_p.chave_exigida == "laboratorio") return global.inventario.cartao_pesquisa;
    }
    // Sala 10 exige sua chave mesmo no modo de teste com portas livres.
    if(variable_instance_exists(_p,"chave_exigida") && _p.chave_exigida=="ferramentas") return global.inventario.chave_ferramentas;
    // Exige o pé de cabra para abrir a sala fria.
    if(variable_instance_exists(_p,"chave_exigida") && _p.chave_exigida=="pe_cabra") return global.inventario.pe_cabra;
    // A escadaria sempre exige a chave da contenção e a saída liberada pelo boss.
    if (_p.chave_exigida == "escadaria") return global.inventario.chave_escadaria && global.progresso.boss_derrotado;
    // As demais passagens podem ser liberadas explicitamente em builds de teste.
    if(global.config.portas_livres) return true;
    if(!variable_instance_exists(_p,"chave_exigida")) return true;
    if(_p.chave_exigida=="cientista") return global.inventario.chave_arquivo;
    return true;
}

#endregion

#region Passagem atualizar

function passagem_atualizar(_p) {
    if (variable_instance_exists(_p,"ativa") && !_p.ativa) return;
    if(global.interface.pause_aberto || global.interface.diario_aberto || global.interface.config_aberta) return;
    if(_p.mensagem_tempo>0) _p.mensagem_tempo = max(0,_p.mensagem_tempo - bunker_passo());
    if(_p.tempo_duto>0) {
        _p.tempo_duto=max(0,_p.tempo_duto-bunker_dt());
        if(_p.tempo_duto<=0) {
            if (_p.tipo_passagem == "duto") duto_registrar_travessia(_p.destino);
            room_goto(_p.destino);
        }
        return;
    }
    if(global.cena.ativa || global.interface.dialogo_ativo) return;
    var _j=instance_nearest(_p.x,_p.y,Obj_jogador);
    if(_j==noone || _j.vida<=0) return;
    var _fim_demo = global.config.encerrar_na_escadaria && room == Room_Corredor_Pos
        && _p.tipo_passagem == "escada" && _p.destino == Room_Corredor_N2;
    var _chegou = _fim_demo && point_distance(_p.x,_p.y,_j.x,_j.y)<=64;
    if (!bunker_porta_em_alcance(_p,_j)) return;
    // Não consome a tecla nas outras portas/dutos fora de alcance.
    var _usar = bunker_interagir();
    if (!_usar && !_chegou) return;
    if (!_usar && !passagem_liberada(_p)) return;
    if(_p.tipo_passagem=="elevador") {
        _p.mensagem_tempo=210;
        return;
    }
    // Passagens especiais também respeitam as chaves/restrições da progressão.
    if(variable_instance_exists(_p,"chave_exigida") && _p.chave_exigida!="" && !passagem_liberada(_p)) {
        _p.mensagem_tempo=180;
        _p.mensagem_bloqueio=_p.chave_exigida=="cientista" ? "PRECISO DA CHAVE DO CIENTISTA" : (global.inventario.chave_escadaria ? "PRECISO LIBERAR A SAÍDA DA ARENA" : "PRECISO DA CHAVE DA SALA DO BOSS");
        bunker_audio_tocar_efeito(Snd_luz_negada,15,false);
        return;
    }
    // Libera a grade somente após validar a chave e a derrota do boss.
    if (_p.chave_exigida == "escadaria") global.progresso.grade_escadaria_aberta = true;
    global.jogador.vida=_j.vida;
    global.inventario.caixas_municao=_j.caixas_mecanicas;
    if (_fim_demo) {
        // Não agenda troca de Room nem checkpoint para a fase seguinte.
        global.transicao.sala_destino=-1;
        global.transicao.duto_ativo=false;
        global.checkpoint.gravar_na_entrada=false;
        _p.tempo_duto=0;
        bunker_audio_tocar_efeito(Snd_porta,12,false);
        bunker_vitoria_iniciar(_p.x,_p.y);
        return;
    }
    mapa_agendar_entrada(_p.destino,_p.ponto_destino);
    // Salva o checkpoint da escada sem apagar o progresso.
    if(_p.tipo_passagem=="escada") global.checkpoint.gravar_na_entrada=true;
    global.transicao.duto_ativo=true;global.cena.ativa=true;
    _p.tempo_duto=(_p.tipo_passagem=="escada") ? 0.42 : 1.1;
    bunker_audio_tocar_efeito(Snd_porta,12,false);
}

#endregion

#region Orientação da recepção
function porta_orientacao_recepcao(_p) {
    if (room != Room_Recepcao || _p.destino != Room_Corredor_Recepcao || !_p.requer_orientacao) return false;
    if (_p.orientacao_falando) {
        if (bunker_dialogo_avancar()) {
            _p.orientacao_falando = false;
            global.interface.dialogo_ativo = false;
        }
        return true;
    }
    if (global.progresso.secretaria_orientou) return false;
    if (global.cena.ativa || global.interface.dialogo_ativo || global.cena.vitoria_ativa) return true;
    var _j = instance_nearest(_p.x, _p.y, Obj_jogador);
    if (_j == noone || _j.vida <= 0) return true;
    // Só repete a fala após o jogador recuar: segurar D não cria um ciclo de diálogos.
    var _limite = _p.x + _p.area_esquerda;
    if (_j.x < _limite - 20) _p.orientacao_aviso_armado = true;
    if (bunker_porta_em_alcance(_p, _j)) {
        _j.x = min(_j.x, _limite - 1);
        _j.velh = 0;
        _j.velv = 0;
        _j.speed = 0;
        _j.image_speed = 0;
        _j.image_index = 0;
        if (_p.orientacao_aviso_armado) {
            _p.orientacao_aviso_armado = false;
            _p.orientacao_falando = true;
            global.interface.dialogo_ativo = true;
        }
    }
    // Sem orientação, nunca agenda a troca para o corredor.
    return true;
}
#endregion
