// Entrada compartilhada, capturada uma vez no Begin Step do controlador existente.
// Cada pressão executa no máximo uma ação. Não repete enquanto E fica segurado.
function interacao_iniciar(_controle) {
    _controle.interacao_buffer = 0;
    _controle.dialogo_buffer = 0;
    _controle.interacao_dialogo_inicio = false;
}

function interacao_atualizar(_controle) {
    var _dt = bunker_dt();
    _controle.interacao_buffer = max(0, _controle.interacao_buffer - _dt);
    _controle.dialogo_buffer = max(0, _controle.dialogo_buffer - _dt);
    _controle.interacao_dialogo_inicio = global.interface.dialogo_ativo;
    if (global.interface.pause_aberto || global.interface.config_aberta
        || global.interface.diario_aberto || global.cena.ativa || global.cena.vitoria_ativa) {
        _controle.interacao_buffer = 0;
        _controle.dialogo_buffer = 0;
        return;
    }
    var _j = instance_find(Obj_jogador, 0);
    if (_j == noone || _j.vida <= 0 || _j.takedown_ativo) {
        _controle.interacao_buffer = 0;
        _controle.dialogo_buffer = 0;
        return;
    }
    var _e = keyboard_check_pressed(ord("E"));
    if (_controle.interacao_dialogo_inicio) {
        _controle.interacao_buffer = 0;
        if (_e || keyboard_check_pressed(vk_space)) _controle.dialogo_buffer = 0.25;
    } else {
        _controle.dialogo_buffer = 0;
        if (_e) _controle.interacao_buffer = 0.22;
    }
}

// Chamar somente depois de validar proximidade, ferramenta e alvo disponíveis.
function bunker_interagir() {
    var _controle = instance_find(Obj_pause, 0);
    if (_controle == noone || bunker_jogo_bloqueado()) return false;
    // Fechar uma conversa não reaproveita E em uma porta no mesmo quadro.
    if (_controle.interacao_dialogo_inicio || _controle.interacao_buffer <= 0) return false;
    _controle.interacao_buffer = 0;
    _controle.dialogo_buffer = 0;
    return true;
}

function bunker_dialogo_avancar() {
    var _controle = instance_find(Obj_pause, 0);
    if (_controle == noone || !_controle.interacao_dialogo_inicio
        || _controle.dialogo_buffer <= 0 || !global.interface.dialogo_ativo
        || global.interface.pause_aberto || global.interface.config_aberta
        || global.interface.diario_aberto || global.cena.ativa || global.cena.vitoria_ativa) return false;
    _controle.dialogo_buffer = 0;
    _controle.interacao_buffer = 0;
    return true;
}
