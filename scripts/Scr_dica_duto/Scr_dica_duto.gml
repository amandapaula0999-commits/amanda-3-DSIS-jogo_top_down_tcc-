function duto_registrar_saida(_destino) {
    if (room == Room_Pesquisa && _destino == Room_Corredor
        && !global.progresso.duto_pesquisa_usado && !global.progresso.dica_duto_mostrada) {
        global.progresso.dica_duto_pendente = true;
    }
}

function duto_registrar_travessia(_destino) {
    if ((room == Room_Pesquisa && _destino == Room_Biblioteca)
        || (room == Room_Biblioteca && _destino == Room_Pesquisa)) {
        global.progresso.duto_pesquisa_usado = true;
        global.progresso.dica_duto_pendente = false;
    }
}

function duto_dica_iniciar(_m) {
    _m.dica_duto_ativa = false;
    if (global.progresso.dica_duto_pendente && room == Room_Corredor
        && !global.progresso.duto_pesquisa_usado && !global.progresso.dica_duto_mostrada) {
        _m.dica_duto_ativa = true;
        global.progresso.dica_duto_mostrada = true;
        global.interface.dialogo_ativo = true;
    }
    global.progresso.dica_duto_pendente = false;
}

function duto_dica_atualizar(_m) {
    if (_m.dica_duto_ativa && bunker_dialogo_avancar()) {
        _m.dica_duto_ativa = false;
        global.interface.dialogo_ativo = false;
    }
}

function duto_dica_desenhar(_m) {
    if (!_m.dica_duto_ativa || global.interface.pause_aberto
        || global.interface.config_aberta || global.interface.diario_aberto) return false;
    bunker_aviso_gui("Estou perdido... Havia um duto naquela sala. Talvez ele dê acesso à sala ao lado. É melhor voltar e conferir.", "E / ESPAÇO: CONTINUAR");
    return true;
}
