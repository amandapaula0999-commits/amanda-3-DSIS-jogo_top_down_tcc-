// Ataque exclusivo do Homem-Cobra. Tempos em segundos; arte pré-carregada.
function cobra_combate_iniciar(_e) {
    cobra_acido_iniciar(_e);
    _e.dash_estado = "";
    _e.dash_tempo = 0;
    _e.dash_intervalo = 2.0;
    _e.dash_preparo = 0.60;
    _e.dash_duracao = 0.42;
    _e.dash_recuperacao = 0.70;
    _e.dash_intervalo_max = 2.40;
    _e.dash_velocidade = 450;
    _e.dash_dano = 24;
    _e.dash_alcance_min = 64;
    _e.dash_alcance_max = 260;
    _e.dash_direcao = 0;
    _e.dash_lado = 0;
    _e.dash_acertou = false;
}

function cobra_sprite_movimento(_lado) {
    switch (_lado) {
        case 0: return Spr_cobra_direita;
        case 1: return Spr_cobra_cima;
        case 2: return Spr_cobra_esquerda;
        default: return Spr_cobra_baixo;
    }
}

function cobra_dash_animar(_e) {
    switch (_e.dash_lado) {
        case 0: _e.sprite_index = Spr_cobra_dash_direita; break;
        case 1: _e.sprite_index = Spr_cobra_dash_cima; break;
        case 2: _e.sprite_index = Spr_cobra_dash_esquerda; break;
        default: _e.sprite_index = Spr_cobra_dash_baixo; break;
    }
    _e.image_speed = 0;
    _e.image_blend = c_white;
    if (_e.dash_estado == "PREPARANDO") {
        _e.image_index = clamp(floor(_e.dash_tempo / _e.dash_preparo * 3), 0, 2);
    } else if (_e.dash_estado == "INVESTINDO") {
        _e.image_index = _e.dash_tempo < _e.dash_duracao * 0.5 ? 3 : 4;
    } else _e.image_index = 5;
}

function cobra_dash_recuperar(_e) {
    _e.dash_estado = "RECUPERANDO";
    _e.dash_tempo = 0;
    _e.image_index = 5;
    // Descarta a rota anterior: depois da investida, calcula o caminho atual.
    _e.rota_tempo = 0;
    _e.rota_indice = 0;
    _e.ataque_tempo = 0;
}

function cobra_dash_encerrar(_e) {
    _e.dash_estado = "";
    _e.dash_tempo = 0;
    _e.dash_intervalo = _e.dash_intervalo_max;
    _e.ataque_tempo = 0;
    _e.ataque_espera = 35;
    _e.rota_tempo = 0;
    _e.sprite_index = cobra_sprite_movimento(_e.dash_lado);
    _e.image_index = 0;
    _e.image_blend = c_white;
}

function cobra_dash_acertar(_e, _j) {
    if (_e.dash_acertou) return;
    _e.dash_acertou = true;
    if (_j.invulneravel || _j.vida <= 0) return;
    _j.vida = max(0, _j.vida - _e.dash_dano);
    global.jogador.vida = _j.vida;
    _j.invulneravel = true;
    _j.image_alpha = 0.2;
    bunker_alarme_definir(_j, 60);
    // Usa o mesmo deslocamento seguro do jogador: nunca empurra pela parede.
    bunker_deslocar_seguro(_j, lengthdir_x(12, _e.dash_direcao), lengthdir_y(12, _e.dash_direcao));
    bunker_audio_tocar_efeito(Snd_impacto_boss, 12, false);
}

// O ataque alcança a frente do sprite, enquanto o movimento conserva a máscara dos pés.
function cobra_dash_contato(_e, _j, _nx, _ny) {
    var _golpe = bunker_caixa_dano(_e);
    var _alvo = bunker_caixa_dano(_j);
    // Exclui a cauda: o dano da investida vem do lado para onde o chefe avança.
    switch (_e.dash_lado) {
        case 0: _golpe.l = max(_golpe.l, _e.x); break;
        case 1: _golpe.b = min(_golpe.b, _e.y); break;
        case 2: _golpe.r = min(_golpe.r, _e.x); break;
        default: _golpe.t = max(_golpe.t, _e.y); break;
    }
    return bunker_segmento_caixa(_e.x, _e.y, _nx, _ny,
        _alvo.l - (_golpe.r - _e.x), _alvo.t - (_golpe.b - _e.y),
        _alvo.r - (_golpe.l - _e.x), _alvo.b - (_golpe.t - _e.y)) <= 1;
}

function cobra_dash_mover(_e, _j, _dt) {
    var _distancia = _e.dash_velocidade * _dt;
    var _partes = max(1, ceil(_distancia));
    var _vx = lengthdir_x(_distancia / _partes, _e.dash_direcao);
    var _vy = lengthdir_y(_distancia / _partes, _e.dash_direcao);
    for (var _i = 0; _i < _partes; _i++) {
        var _nx = _e.x + _vx;
        var _ny = _e.y + _vy;
        // Para na primeira barreira, sem deslizar pela quina ou atravessar móveis.
        if (lagarto_pe_bloqueado(_e, _nx, _ny)) {
            cobra_dash_recuperar(_e);
            return false;
        }
        var _corpo = bunker_corpo_bloqueado(_e, _nx, _ny);
        var _contato = cobra_dash_contato(_e, _j, _nx, _ny) || _corpo;
        if (_contato && collision_line(_e.x, _e.y, _j.x, _j.y, Obj_parede, false, true) == noone) {
            cobra_dash_acertar(_e, _j);
            cobra_dash_recuperar(_e);
            return false;
        }
        if (_corpo) {
            cobra_dash_recuperar(_e);
            return false;
        }
        _e.x = _nx;
        _e.y = _ny;
    }
    return true;
}

// Retorna true enquanto esta rotina controla o chefe, impedindo golpe duplo
// e perseguição simultânea. A preparação trava a mira e permite esquiva.
function cobra_combate_atualizar(_e) {
    if (bunker_jogo_bloqueado()) return true;
    var _j = instance_find(Obj_jogador, 0);
    if (_j == noone || _j.vida <= 0) {
        if (_e.dash_estado != "") cobra_dash_encerrar(_e);
        if (_e.acido_estado != "") cobra_acido_encerrar(_e);
        return true;
    }
    var _dt = bunker_dt();
    if (cobra_acido_atualizar(_e, _j, _dt)) return true;
    if (_e.dash_estado == "") {
        _e.dash_intervalo = max(0, _e.dash_intervalo - _dt);
        if (_e.dash_intervalo > 0 || _e.ataque_tempo > 0) return false;
        var _dist = point_distance(_e.x, _e.y, _j.x, _j.y);
        if (_dist < _e.dash_alcance_min || _dist > _e.dash_alcance_max) return false;
        if (!boss_trecho_livre(_e, _j.x, _j.y)) return false;
        _e.dash_direcao = point_direction(_e.x, _e.y, _j.x, _j.y);
        _e.dash_lado = floor((_e.dash_direcao + 45) / 90) mod 4;
        _e.dash_estado = "PREPARANDO";
        _e.dash_tempo = 0;
        _e.dash_acertou = false;
        _e.ataque_tempo = 0;
        cobra_dash_animar(_e);
        return true;
    }
    // Consome sobras de tempo ao trocar de estado para manter a distância em
    // taxas de quadros diferentes. O relógio para junto com pausa/diálogos.
    var _restante = _dt;
    while (_restante > 0.000001 && _e.dash_estado != "") {
        var _duracao = _e.dash_preparo;
        if (_e.dash_estado == "INVESTINDO") _duracao = _e.dash_duracao;
        else if (_e.dash_estado == "RECUPERANDO") _duracao = _e.dash_recuperacao;
        var _fatia = min(_restante, max(0, _duracao - _e.dash_tempo));
        _restante = max(0, _restante - _fatia);
        if (_e.dash_estado == "INVESTINDO" && !cobra_dash_mover(_e, _j, _fatia)) {
            // Colisão encerra a investida neste quadro; a recuperação começa agora.
            _restante = 0;
            break;
        }
        _e.dash_tempo += _fatia;
        if (_e.dash_tempo >= _duracao - 0.000001) {
            if (_e.dash_estado == "PREPARANDO") {
                _e.dash_estado = "INVESTINDO";
                _e.dash_tempo = 0;
            } else if (_e.dash_estado == "INVESTINDO") cobra_dash_recuperar(_e);
            else cobra_dash_encerrar(_e);
        }
    }
    if (_e.dash_estado != "") cobra_dash_animar(_e);
    return true;
}
