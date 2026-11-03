#region Cano impacto

function bunker_cano_impacto(_arma) {
    if (_arma.ataque_atingiu || floor(_arma.image_index) < 1) return;
    // Área frontal mais tolerante. Um único alvo por animação; paredes bloqueiam.
    var _j = _arma.dono;
    var _alcance = _arma.alcance_cano + _arma.raio_cano;
    var _melhor = noone;
    var _distancia = _alcance + 0.0001;
    var _tipos = [Obj_caracol, Obj_homem_lagarto, Obj_caracol_lab, Obj_boss_cobra, Obj_boss, Obj_barril];
    for (var _i = 0; _i < array_length(_tipos); _i++) {
        for (var _n = 0; _n < instance_number(_tipos[_i]); _n++) {
            var _alvo = instance_find(_tipos[_i], _n);
            if (!bunker_alvo_atingivel(_alvo)) continue;
            var _contato_x = _alvo.x;
            var _contato_y = _alvo.y;
            if (_alvo.object_index == Obj_boss) {
                // O boss é grande: o cano alcança a borda do corpo, não só sua origem.
                var _caixa = bunker_caixa_dano(_alvo);
                _contato_x = clamp(_j.x, _caixa.l, _caixa.r);
                _contato_y = clamp(_j.y, _caixa.t, _caixa.b);
            }
            var _dist = point_distance(_j.x, _j.y, _contato_x, _contato_y);
            if (_dist > _alcance || _dist >= _distancia) continue;
            var _dir = point_direction(_j.x, _j.y, _contato_x, _contato_y);
            if (_dist > 1 && abs(angle_difference(_arma.ataque_direcao, _dir)) > _arma.arco_cano) continue;
            if (bunker_varrer_paredes(_j.x, _j.y, _alvo.x, _alvo.y, 0).t <= 1) continue;
            if (_alvo.object_index == Obj_boss
            && bunker_varrer_paredes(_j.x, _j.y, _contato_x, _contato_y, 0).t <= 1) continue;
            _melhor = _alvo;
            _distancia = _dist;
        }
    }
    if (_melhor != noone) {
        _arma.ataque_atingiu = true;
        bunker_aplicar_impacto(_melhor, _arma.dano_cano, _j);
    }
}

#endregion

#region Cano pixels

function bunker_cano_pixels(_dir, _quadro) {
return global.recursos.cano_geometria[clamp(_dir, 0, 3)][clamp(_quadro, 0, 2)];
}

#endregion

#region Barril derramar

function bunker_barril_derramar(_barril) {
    if (!instance_exists(_barril) || !_barril.atingido || _barril.acido_criado) return false;
    var poca = instance_create_depth(_barril.x, _barril.y, 100, Obj_acido);
    poca.origem_barril = _barril;
    _barril.acido_id = poca;
    _barril.acido_criado = true;
    _barril.mostrar_chao = true;
    _barril.sumindo = true;
    _barril.image_speed = 0;
    _barril.image_index = max(0, sprite_get_number(Spr_barril_caindo) - 1);
    _barril.respawn_tempo = _barril.respawn_max;
    return true;
}

#endregion

#region Derrubar barril

function bunker_derrubar_barril(_barril) {
    if (!instance_exists(_barril) || _barril.atingido) return false;
    _barril.atingido = true;
    _barril.sprite_index = Spr_barril_caindo;
    _barril.image_index = 0;
    _barril.image_speed = 0; // Queda avançada explicitamente pelo tempo de simulação.
    bunker_audio_tocar_efeito(Snd_barril, 24, false);
    return true;
}

#endregion

#region Impacto

function bunker_impacto(_x, _y, _raio) {
    // Uma chamada por golpe. A onda é radial no chão; móveis bloqueiam sua passagem.
    for (var i = 0; i < instance_number(Obj_barril); i++) {
        var barril = instance_find(Obj_barril, i);
        if (point_distance(_x, _y, barril.x, barril.y) <= _raio
        && collision_line(_x, _y, barril.x, barril.y, Obj_parede, false, true) == noone) {
            bunker_derrubar_barril(barril);
        }
    }
    if (instance_exists(Obj_jogador)) {
        var jogador = instance_find(Obj_jogador, 0);
        if (!jogador.invulneravel && !global.cena.ativa && !global.interface.dialogo_ativo
        && !global.interface.diario_aberto && point_distance(_x, _y, jogador.x, jogador.y) <= _raio
        && collision_line(_x, _y, jogador.x, jogador.y, Obj_parede, false, true) == noone) {
            jogador.vida -= 24;
            jogador.invulneravel = true;
            bunker_alarme_definir(jogador, 75);
            global.jogador.vida = jogador.vida;
        }
    }
    bunker_audio_tocar_efeito(Snd_impacto_boss, 28, false);
    bunker_emitir_ruido(_x, _y, 620, 90);
}

#endregion

#region Ataque do caracol
function caracol_ataque_iniciar(_e) {
    _e.golpe_ativo = false;
    _e.golpe_quadro = 0;
    _e.golpe_aplicado = false;
    _e.golpe_intervalo = 0;
    _e.golpe_direcao = 270;
}

function caracol_ataque_atualizar(_e, _j, _passo) {
    if (_j.vida <= 0) return false;
    _e.golpe_intervalo = max(0, _e.golpe_intervalo - _passo);
    var _dist = point_distance(_e.x, _e.y, _j.x, _j.y);
    if (!_e.golpe_ativo) {
        if (_dist > 38 || _e.golpe_intervalo > 0) return false;
        if (collision_line(_e.x,_e.y,_j.x,_j.y,Obj_parede,false,true) != noone) return false;
        _e.golpe_ativo = true;
        _e.golpe_quadro = 0;
        _e.golpe_aplicado = false;
        _e.golpe_direcao = round(point_direction(_e.x,_e.y,_j.x,_j.y) / 90) * 90;
        _e.estado = "ATACANDO";
    }
    var _vel = max(0, _j.max_vel - 1) * 0.5;
    var _dir = point_direction(_e.x,_e.y,_j.x,_j.y);
    var _mov = min(max(0, _dist - 16), _vel * _passo);
    bunker_deslocar_seguro(_e, lengthdir_x(_mov,_dir), lengthdir_y(_mov,_dir));
    switch ((_e.golpe_direcao + 360) mod 360) {
        case 0: _e.sprite_index = Spr_caracol_ataque_direita; break;
        case 90: _e.sprite_index = Spr_caracol_ataque_cima; break;
        case 180: _e.sprite_index = Spr_caracol_ataque_esquerda; break;
        default: _e.sprite_index = Spr_caracol_ataque_baixo; break;
    }
    _e.image_speed = 0;
    _e.golpe_quadro += _passo * 8 / 60;
    _e.image_index = min(3, floor(_e.golpe_quadro));
    // A mão acerta somente no último quadro.
    if (_e.golpe_quadro >= 3 && !_e.golpe_aplicado) {
        _e.golpe_aplicado = true;
        var _alcance = point_distance(_e.x,_e.y,_j.x,_j.y) <= 42;
        var _frente = abs(angle_difference(_e.golpe_direcao, point_direction(_e.x,_e.y,_j.x,_j.y))) <= 75;
        if (_alcance && _frente && !_j.invulneravel
            && collision_line(_e.x,_e.y,_j.x,_j.y,Obj_parede,false,true) == noone) {
            _j.vida = max(0, _j.vida - 10);
            global.jogador.vida = _j.vida;
            _j.invulneravel = true;
            _j.image_alpha = 0.2;
            bunker_alarme_definir(_j,180);
        }
    }
    if (_e.golpe_quadro >= 4) {
        _e.golpe_ativo = false;
        _e.golpe_intervalo = 35;
        _e.estado = "PERSEGUINDO";
    }
    return true;
}
#endregion
