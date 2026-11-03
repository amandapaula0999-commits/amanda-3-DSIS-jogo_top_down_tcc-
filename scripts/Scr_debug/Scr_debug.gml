#region Debug avancar sala

function debug_avancar_sala(_sala = noone, _ponto = "") {
    var _destino = _sala;
    var _chegada = _ponto;
    if (_destino == noone) {
        var mapa = instance_find(Obj_mapa, 0);
        if (mapa == noone) return false;
        _destino = mapa.proxima_sala_debug;
        _chegada = mapa.ponto_debug;
    }
    // Limpa as travas temporárias sem apagar o progresso.
    global.interface.pause_aberto = false;
    global.interface.diario_aberto = false;
    global.interface.config_aberta = false;
    global.interface.dialogo_ativo = false;
    global.cena.ativa = false;
    global.cena.vitoria_ativa = false;
    global.interface.creditos_ativos = false;
    global.cena.vitoria_tempo = 0;
    global.interface.creditos_scroll = 0;
    global.camera.zoom = 1;
    global.transicao.duto_ativo = false;
    global.transicao.queda_pendente = false;
    global.checkpoint.gravar_na_entrada = false;

    // Salva vida e munição antes da troca de sala.
    var _j = instance_nearest(0, 0, Obj_jogador);
    if (_j != noone) {
        global.jogador.vida = _j.vida;
        global.inventario.caixas_municao = _j.caixas_mecanicas;
    }

    instance_activate_all();
    audio_resume_all();
    mapa_agendar_entrada(_destino,_chegada);
    room_goto(_destino);
    return true;
}

#endregion
