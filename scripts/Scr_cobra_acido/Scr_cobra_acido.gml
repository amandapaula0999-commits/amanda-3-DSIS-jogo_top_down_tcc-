// Cuspe: animação estática pré-carregada; projétil independente.
function cobra_acido_iniciar(_e) {
    _e.acido_estado = "";
    _e.acido_tempo = 0;
    _e.acido_intervalo = 3.0;
    _e.acido_intervalo_max = 3.8;
    _e.acido_chance = 0.40;
    _e.acido_preparo = 0.75;
    _e.acido_recuperacao = 0.65;
    _e.acido_lado = 0;
    _e.acido_mira_x = 0;
    _e.acido_mira_y = 0;
    _e.acido_alcance_min = 80;
    _e.acido_alcance_max = 360;
}

function cobra_acido_animar(_e) {
    switch (_e.acido_lado) {
        case 0: _e.sprite_index = Spr_cobra_cuspir_direita; break;
        case 1: _e.sprite_index = Spr_cobra_cuspir_cima; break;
        case 2: _e.sprite_index = Spr_cobra_cuspir_esquerda; break;
        default: _e.sprite_index = Spr_cobra_cuspir_baixo; break;
    }
    _e.image_speed = 0;
    _e.image_blend = c_white;
    _e.image_index = _e.acido_estado == "PREPARANDO"
        ? clamp(floor(_e.acido_tempo / _e.acido_preparo * 3), 0, 2)
        : clamp(3 + floor(_e.acido_tempo / _e.acido_recuperacao * 3), 3, 5);
}

function cobra_acido_encerrar(_e) {
    _e.acido_estado = "";
    _e.acido_tempo = 0;
    _e.acido_intervalo = _e.acido_intervalo_max;
    _e.dash_intervalo = max(_e.dash_intervalo, 1.2);
    _e.ataque_tempo = 0;
    _e.ataque_espera = 35;
    _e.rota_tempo = 0;
    _e.sprite_index = cobra_sprite_movimento(_e.acido_lado);
    _e.image_index = 0;
    _e.image_blend = c_white;
}

function cobra_acido_disparar(_e) {
    // Coordenadas locais da boca no quadro de soltura, alinhadas na importação.
    var _boca = cobra_acido_boca(_e.acido_lado);
    var _mx = _e.x + _boca.x;
    var _my = _e.y + _boca.y;
    // Não materializa o ácido do outro lado de uma parede junto ao chefe.
    if (bunker_varrer_paredes(_e.x, _e.y, _mx, _my, 0).t <= 1) return;
    if (bunker_varrer_paredes(_mx, _my, _mx, _my, 4).t <= 1) return;
    var _p = instance_create_depth(_mx, _my, _e.depth - 1, Obj_acido_cobra);
    _p.dono = _e;
    _p.rumo = point_direction(_mx, _my, _e.acido_mira_x, _e.acido_mira_y);
    _p.image_angle = _p.rumo;
}

// true: cuspe controla o chefe. Sorteio único por oportunidade, não por quadro.
function cobra_acido_atualizar(_e, _j, _dt) {
    if (_e.acido_estado == "") {
        if (_e.dash_estado != "") return false;
        _e.acido_intervalo = max(0, _e.acido_intervalo - _dt);
        if (_e.acido_intervalo > 0 || _e.ataque_tempo > 0) return false;
        var _dist = point_distance(_e.x, _e.y, _j.x, _j.y);
        if (_dist < _e.acido_alcance_min || _dist > _e.acido_alcance_max) return false;
        if (!boss_trecho_livre(_e, _j.x, _j.y)) return false;
        _e.acido_intervalo = _e.acido_intervalo_max;
        if (random(1) >= _e.acido_chance) return false;
        var _caixa = bunker_caixa_dano(_j);
        _e.acido_mira_x = (_caixa.l + _caixa.r) * 0.5;
        _e.acido_mira_y = (_caixa.t + _caixa.b) * 0.5;
        _e.acido_lado = floor((point_direction(_e.x, _e.y, _j.x, _j.y) + 45) / 90) mod 4;
        _e.acido_estado = "PREPARANDO";
        _e.acido_tempo = 0;
        _e.ataque_tempo = 0;
        cobra_acido_animar(_e);
        return true;
    }
    var _restante = _dt;
    while (_restante > 0.000001 && _e.acido_estado != "") {
        var _duracao = _e.acido_estado == "PREPARANDO" ? _e.acido_preparo : _e.acido_recuperacao;
        var _fatia = min(_restante, max(0, _duracao - _e.acido_tempo));
        _e.acido_tempo += _fatia;
        _restante = max(0, _restante - _fatia);
        if (_e.acido_tempo >= _duracao - 0.000001) {
            if (_e.acido_estado == "PREPARANDO") {
                _e.acido_estado = "RECUPERANDO";
                _e.acido_tempo = 0;
                cobra_acido_animar(_e);
                cobra_acido_disparar(_e);
            } else cobra_acido_encerrar(_e);
        }
    }
    if (_e.acido_estado != "") cobra_acido_animar(_e);
    return true;
}

function cobra_projetil_atualizar(_p) {
    // Não deixa projéteis órfãos após morte do chefe, derrota ou troca de sala.
    if (!instance_exists(_p.dono)) { instance_destroy(_p); return; }
    if (_p.dono.vida <= 0) { instance_destroy(_p); return; }
    var _j = instance_find(Obj_jogador, 0);
    if (_j == noone || _j.vida <= 0) { instance_destroy(_p); return; }
    if (bunker_jogo_bloqueado()) return;
    var _dt = min(bunker_dt(), max(0, _p.duracao - _p.tempo));
    var _nx = _p.x + lengthdir_x(_p.velocidade * _dt, _p.rumo);
    var _ny = _p.y + lengthdir_y(_p.velocidade * _dt, _p.rumo);
    var _parede = bunker_varrer_paredes(_p.x, _p.y, _nx, _ny, _p.raio);
    var _c = bunker_caixa_dano(_j);
    var _contato = bunker_segmento_caixa(_p.x, _p.y, _nx, _ny,
        _c.l - _p.raio, _c.t - _p.raio, _c.r + _p.raio, _c.b + _p.raio);
    // Parede tem prioridade no empate. Colisão varrida evita atravessar alvos.
    if (_parede.t <= 1 && _parede.t <= _contato) { instance_destroy(_p); return; }
    if (_contato <= 1) {
        if (!_j.invulneravel) {
            _j.vida = max(0, _j.vida - _p.dano);
            global.jogador.vida = _j.vida;
            _j.invulneravel = true;
            _j.image_alpha = 0.2;
            bunker_alarme_definir(_j, 60);
            bunker_audio_tocar_efeito(Snd_impacto_boss, 12, false);
        }
        instance_destroy(_p);
        return;
    }
    _p.x = _nx;
    _p.y = _ny;
    _p.tempo += _dt;
    _p.image_alpha = clamp((_p.duracao - _p.tempo) / _p.desvanecer, 0, 1);
    if (_p.tempo >= _p.duracao - 0.000001) instance_destroy(_p);
}


// Boca local no frame 3 de cada sprite.
function cobra_acido_boca(_lado) {
    switch (_lado) {
        case 0: return {x: 41, y: -24};
        case 1: return {x: 8, y: -41};
        case 2: return {x: -41, y: -24};
        case 3: return {x: 5, y: -8};
    }
    return {x: 0, y: -30};
}
