// Inventário compartilhado entre rooms, como a reserva de pregos.
function kit_vida_coletar(_coleta_id) {
    if (bunker_tem_id(global.progresso.coletas_kits, _coleta_id)) return false;
    global.progresso.coletas_kits[array_length(global.progresso.coletas_kits)] = _coleta_id;
    global.inventario.kits_vida++;
    return true;
}

// Uma nova tentativa repõe os kits do cenário ao carregar as salas.
// Trocar de sala sem morrer continua preservando as coletas desta tentativa.
function kits_vida_repor_apos_morte() {
    global.progresso.coletas_kits = [];
}

function kit_vida_usar(_j) {
    if (bunker_jogo_bloqueado() || _j.vida <= 0 || global.inventario.kits_vida <= 0) return false;
    if (_j.vida >= _j.vida_max) {
        _j.kit_mensagem = "A vida já está cheia. Vou guardar o kit.";
        _j.kit_mensagem_tempo = 3;
        return false;
    }
    var _cura = min(_j.vida_max - _j.vida, _j.vida_max * 0.2);
    _j.vida += _cura;
    global.jogador.vida = _j.vida;
    global.inventario.kits_vida--;
    _j.kit_mensagem = "Kit usado: +" + string(round(_cura)) + " de vida.";
    _j.kit_mensagem_tempo = 3;
    bunker_audio_tocar_efeito(Snd_item, 10, false);
    return true;
}

function itens_vida_atualizar(_j) {
    _j.kit_perto = noone;
    if (bunker_jogo_bloqueado() || _j.vida <= 0) return;
    _j.kit_mensagem_tempo = max(0, _j.kit_mensagem_tempo - bunker_dt());
    if (keyboard_check_pressed(ord("Q"))) kit_vida_usar(_j);
    var _kit = instance_nearest(_j.x, _j.y, Obj_kit_vida);
    if (_kit == noone || point_distance(_j.x, _j.y, _kit.x, _kit.y) > 34) return;
    // Não permite recolher kits do outro lado de paredes ou móveis.
    if (bunker_varrer_paredes(_j.x, _j.y, _kit.x, _kit.y, 0).t <= 1) return;
    _j.kit_perto = _kit;
    if (bunker_interagir()) {
        if (kit_vida_coletar(_kit.coleta_id)) {
            _j.kit_mensagem = "Kit guardado. Aperte Q para se curar (+20% da vida máxima).";
            _j.kit_mensagem_tempo = 4;
            bunker_audio_tocar_efeito(Snd_item, 10, false);
        }
        instance_destroy(_kit);
        _j.kit_perto = noone;
    }
}

function itens_vida_desenhar_aviso() {
    if (bunker_jogo_bloqueado()) return false;
    var _j = instance_find(Obj_jogador, 0);
    if (_j == noone || _j.vida <= 0) return false;
    if (_j.kit_mensagem_tempo > 0) {
        bunker_aviso_gui(_j.kit_mensagem, "");
        return true;
    }
    if (instance_exists(_j.kit_perto)) {
        bunker_aviso_gui("", "[E] GUARDAR KIT DE VIDA");
        return true;
    }
    return false;
}
