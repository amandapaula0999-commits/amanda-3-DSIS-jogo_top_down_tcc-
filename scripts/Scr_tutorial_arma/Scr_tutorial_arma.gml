// Pensamento único ao obter a pistola. A sala controla a fala, não o jogador.
function tutorial_arma_iniciar(_m) {
    _m.pensamento_arma_ativo = false;
    _m.pensamento_arma_encerrando = false;
    _m.pensamento_arma_pagina = 0;
    _m.pensamento_arma_espera = 0;
    _m.pensamento_arma_falas = [
        "É melhor guardar alguns pregos. Se essas criaturas já são perigosas, não quero descobrir o que estão mantendo nos setores de contenção sem munição.",
        "Com a pistola equipada [2], miro com o mouse e atiro com o botão DIREITO. O botão ESQUERDO recarrega. O pente comporta até 15 pregos; cada caixa traz 14.",
        "Posso equipar o cano [1] e golpear com o botão DIREITO nos confrontos menores. Vou guardar a pistola para quando encontrar algo mais difícil de enfrentar."
    ];
}

function tutorial_arma_atualizar(_m) {
    if (global.interface.pause_aberto || global.interface.diario_aberto || global.interface.config_aberta) return;
    if (_m.pensamento_arma_encerrando) {
        _m.pensamento_arma_encerrando = false;
        global.interface.dialogo_ativo = false;
        return;
    }
    if (_m.pensamento_arma_ativo) {
        _m.pensamento_arma_espera = max(0, _m.pensamento_arma_espera - bunker_dt());
        if (_m.pensamento_arma_espera <= 0 && bunker_dialogo_avancar()) {
            _m.pensamento_arma_pagina++;
            _m.pensamento_arma_espera = 0.2;
            if (_m.pensamento_arma_pagina >= array_length(_m.pensamento_arma_falas)) {
                global.progresso.pensamento_municao_concluido = true;
                _m.pensamento_arma_ativo = false;
                _m.pensamento_arma_encerrando = true;
            }
        }
        return;
    }
    if (global.progresso.pensamento_municao_concluido || !global.inventario.arma_pregos
        || bunker_jogo_bloqueado()) return;
    var _j = instance_find(Obj_jogador, 0);
    if (_j == noone || _j.vida <= 0) return;
    _m.pensamento_arma_ativo = true;
    _m.pensamento_arma_pagina = 0;
    _m.pensamento_arma_espera = 0.2;
    global.interface.dialogo_ativo = true;
    _j.velh = 0;
    _j.velv = 0;
    _j.speed = 0;
    _j.image_speed = 0;
    _j.image_index = 0;
}

function tutorial_arma_desenhar(_m) {
    if (!_m.pensamento_arma_ativo || global.interface.pause_aberto
        || global.interface.diario_aberto || global.interface.config_aberta) return false;
    bunker_aviso_gui(_m.pensamento_arma_falas[_m.pensamento_arma_pagina], "E / ESPAÇO: CONTINUAR");
    return true;
}
