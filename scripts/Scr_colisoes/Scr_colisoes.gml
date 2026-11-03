#region Segmento caixa

// Colisão contínua. A máscara dos pés é usada apenas no movimento.
function bunker_segmento_caixa(_x0, _y0, _x1, _y1, _l, _t, _r, _b) {
    var entrada = 0;
    var saida = 1;
    var dx = _x1 - _x0;
    var dy = _y1 - _y0;
    if (abs(dx) < 0.000001) {
        if (_x0 < _l || _x0 > _r) return 2;
    } else {
        var tx0 = (_l - _x0) / dx;
        var tx1 = (_r - _x0) / dx;
        entrada = max(entrada, min(tx0, tx1));
        saida = min(saida, max(tx0, tx1));
    }
    if (abs(dy) < 0.000001) {
        if (_y0 < _t || _y0 > _b) return 2;
    } else {
        var ty0 = (_t - _y0) / dy;
        var ty1 = (_b - _y0) / dy;
        entrada = max(entrada, min(ty0, ty1));
        saida = min(saida, max(ty0, ty1));
    }
    if (entrada > saida || saida < 0 || entrada > 1) return 2;
    return entrada;
}

#endregion

#region Parede configurar

function bunker_parede_configurar(_p, _w, _h) {
    _p.largura = max(1, round(_w));
    _p.altura = max(1, round(_h));
    _p.sprite_index = Spr_parede;
    _p.mask_index = Spr_parede;
    _p.image_angle = 0;
    _p.image_xscale = _p.largura / sprite_get_width(Spr_parede);
    _p.image_yscale = _p.altura / sprite_get_height(Spr_parede);
}

#endregion

#region Paredes candidatas

// Consulta espacial das paredes posicionadas no Room Editor.
function bunker_paredes_candidatas(_l, _t, _r, _b) {
    var lista = ds_list_create();
    var n = collision_rectangle_list(_l-2, _t-2, _r+2, _b+2,
        Obj_parede, false, false, lista, false);
    var paredes = array_create(n);
    for (var i = 0; i < n; i++) paredes[i] = lista[| i];
    ds_list_destroy(lista);
    return paredes;
}

#endregion

#region Varrer paredes

function bunker_varrer_paredes(_x0, _y0, _x1, _y1, _raio, _paredes = undefined) {
    var resultado = {alvo: noone, t: 2, parede: true};
    if (is_undefined(_paredes)) {
        _paredes = bunker_paredes_candidatas(min(_x0,_x1)-_raio, min(_y0,_y1)-_raio,
            max(_x0,_x1)+_raio, max(_y0,_y1)+_raio);
    }
    for (var indice = 0; indice < array_length(_paredes); indice++) {
        var p = _paredes[indice];
        if (!instance_exists(p)) continue;
        var contato = bunker_segmento_caixa(_x0, _y0, _x1, _y1,
            p.x - _raio, p.y - _raio, p.x + p.largura + _raio, p.y + p.altura + _raio);
        if (contato < resultado.t) {
            resultado.t = contato;
            resultado.alvo = p;
        }
    }
    return resultado;
}

#endregion

#region Deslocar seguro

// Move sem atravessar paredes, usando a máscara dos pés do ator.
function bunker_deslocar_seguro(_ator, _dx, _dy) {
    with (_ator) {
        var partes = max(1, ceil(max(abs(_dx), abs(_dy))));
        var sx = _dx / partes;
        var sy = _dy / partes;
        for (var i = 0; i < partes; i++) {
            if (sx != 0 && !place_meeting(x+sx, y, Obj_parede) && !inimigo_parede_bloqueado(id, x+sx, y) && !bunker_corpo_bloqueado(id, x+sx, y)) x += sx;
            else sx = 0;
            if (sy != 0 && !place_meeting(x, y+sy, Obj_parede) && !inimigo_parede_bloqueado(id, x, y+sy) && !bunker_corpo_bloqueado(id, x, y+sy)) y += sy;
            else sy = 0;
            if (sx == 0 && sy == 0) break;
        }
    }
}

#endregion

#region Tempo em segundos

// 60 unidades = 1 segundo; limita cada passo da simulação a 50 ms.
function bunker_dt() { return clamp(delta_time / 1000000, 0, 0.05); }

#endregion

#region Passo da simulação

function bunker_passo() { return bunker_dt() * 60; }

#endregion

#region Verificar bloqueio do jogo

function bunker_jogo_bloqueado() {
    return global.interface.pause_aberto || global.interface.config_aberta || global.interface.diario_aberto
        || global.cena.ativa || global.interface.dialogo_ativo || global.cena.vitoria_ativa;
}

#endregion

#region Alarme definir

// Controla o tempo no Step; o Alarm 0 executa apenas a ação.
function bunker_alarme_definir(_ator, _tempo) {
    _ator.alarm[0] = -1;
    _ator.tempo_alarme0 = _tempo;
}

#endregion

#region Alarme passo

function bunker_alarme_passo(_ator, _passo) {
    if (!variable_instance_exists(_ator,"tempo_alarme0") || _ator.tempo_alarme0 < 0) return false;
    _ator.tempo_alarme0 = max(0, _ator.tempo_alarme0 - _passo);
    if (_ator.tempo_alarme0 > 0.000001) return false;
    _ator.tempo_alarme0 = -1;
    return true;
}

#endregion

#region Animação passo

// Avança a animação pelo tempo; ataques controlam seus próprios quadros.
function bunker_animacao_passo(_ator, _ritmo, _passo) {
    _ator.image_speed = 0;
    if (_ritmo <= 0 || _ator.sprite_index < 0) return;
    var taxa = sprite_get_speed(_ator.sprite_index);
    if (sprite_get_speed_type(_ator.sprite_index) == spritespeed_framespersecond) taxa /= 60;
    _ator.image_index = (_ator.image_index + taxa * _ritmo * _passo) mod max(1,_ator.image_number);
}

#endregion

#region Caracol mover

// mp_potential em subpassos: não aumenta o salto da IA quando o FPS cai.
function bunker_caracol_mover(_tx, _ty, _vel, _passo) {
    var distancia = _vel * _passo;
    var partes = max(1, ceil(distancia));
    for (var i = 0; i < partes; i++) {
        var _antes_x = x; var _antes_y = y;
        // A navegação sugere um passo; só o movimento validado o aplica.
        mp_potential_step_object(_tx, _ty, distancia / partes, Obj_parede);
        var _dx = x - _antes_x; var _dy = y - _antes_y;
        x = _antes_x; y = _antes_y;
        bunker_deslocar_seguro(id, _dx, _dy);
        if (point_distance(_antes_x, _antes_y, x, y) < 0.001) {
            // Contorna quinas também com a caixa maior do corpo.
            var _dir = point_direction(x, y, _tx, _ty);
            var _angulos = [45, -45, 90, -90, 135, -135];
            for (var _a = 0; _a < array_length(_angulos); _a++) {
                var _sx = lengthdir_x(distancia / partes, _dir + _angulos[_a]);
                var _sy = lengthdir_y(distancia / partes, _dir + _angulos[_a]);
                if (!inimigo_parede_bloqueado(id, x + _sx, y + _sy)) {
                    bunker_deslocar_seguro(id, _sx, _sy);
                    break;
                }
            }
        }
    }
}

#endregion

#region Caixa dano

function bunker_caixa_dano(_alvo) {
    var spr = _alvo.sprite_index;
    var origem_x = sprite_get_xoffset(spr);
    var origem_y = sprite_get_yoffset(spr);
    // O Draw do Boss ancora todos os sprites no centro original de 32x40.
    if (_alvo.object_index == Obj_boss) {
        origem_x = 16;
        origem_y = 20;
    }
    var x0 = (sprite_get_bbox_left(spr) - origem_x) * _alvo.image_xscale;
    var x1 = (sprite_get_bbox_right(spr) + 1 - origem_x) * _alvo.image_xscale;
    var y0 = (sprite_get_bbox_top(spr) - origem_y) * _alvo.image_yscale;
    var y1 = (sprite_get_bbox_bottom(spr) + 1 - origem_y) * _alvo.image_yscale;
    // Tolerância exclusiva para receber golpes; não altera o corpo físico nem o ácido.
    var margem = (_alvo.object_index == Obj_boss) ? 8 : 0;
    return {l: _alvo.x + min(x0, x1) - margem, r: _alvo.x + max(x0, x1) + margem,
        t: _alvo.y + min(y0, y1) - margem, b: _alvo.y + max(y0, y1) + margem};
}

#endregion

#region Alvo atingivel

function bunker_alvo_atingivel(_alvo) {
    if (_alvo.object_index == Obj_boss_cobra && _alvo.estagio != 2) return false;
    if (_alvo.object_index==Obj_boss && !_alvo.encontro_ativo) return false;
    if (_alvo.object_index == Obj_boss_cobra || _alvo.object_index == Obj_caracol || _alvo.object_index == Obj_homem_lagarto || _alvo.object_index == Obj_caracol_lab) return !_alvo.morrendo && _alvo.vida > 0;
    if (_alvo.object_index == Obj_boss) return !_alvo.morto && !_alvo.fugindo && _alvo.vida > 0;
    if (_alvo.object_index == Obj_barril) return !_alvo.atingido;
    return false;
}

#endregion

#region Varrer impacto

function bunker_varrer_impacto(_x0, _y0, _x1, _y1, _raio, _paredes = undefined) {
    var resultado = bunker_varrer_paredes(_x0, _y0, _x1, _y1, _raio, _paredes);
    var tipos = [Obj_boss_cobra, Obj_caracol, Obj_homem_lagarto, Obj_caracol_lab, Obj_boss, Obj_barril];
    for (var tipo_indice = 0; tipo_indice < array_length(tipos); tipo_indice++) {
        for (var indice = 0; indice < instance_number(tipos[tipo_indice]); indice++) {
            var alvo = instance_find(tipos[tipo_indice], indice);
            if (!bunker_alvo_atingivel(alvo)) continue;
            var caixa = bunker_caixa_dano(alvo);
            var contato = bunker_segmento_caixa(_x0, _y0, _x1, _y1,
                caixa.l - _raio, caixa.t - _raio, caixa.r + _raio, caixa.b + _raio);
            // Parede vence o empate. A ordem de criação nunca escolhe o alvo.
            if (contato < resultado.t - 0.000001) {
                resultado.t = contato;
                resultado.alvo = alvo;
                resultado.parede = false;
            }
        }
    }
    return resultado;
}

#endregion

#region Aplicar impacto

function bunker_aplicar_impacto(_alvo, _dano, _origem = noone) {
    if (!instance_exists(_alvo) || !bunker_alvo_atingivel(_alvo)) return;
    if (_alvo.object_index == Obj_barril) {
        bunker_derrubar_barril(_alvo);
        return;
    }
    if (_alvo.object_index == Obj_boss && !_alvo.derrotado) {
        _alvo.feedback_tempo = 34;
        _alvo.feedback_texto = "CARAPAÇA BLOQUEOU";
        return;
    }
    var _dano_real = min(_alvo.vida, max(0, _dano));
    if (_dano_real <= 0) return;
    _alvo.vida = max(0, _alvo.vida - _dano_real);
    _alvo.tomou_dano = true;
    _alvo.feedback_tempo = 28;
    _alvo.feedback_texto = "-" + string(_dano_real);
    if (_alvo.object_index == Obj_homem_lagarto || _alvo.object_index == Obj_caracol_lab
        || _alvo.object_index == Obj_boss_cobra) combate_mostrar_dano(_alvo, _dano_real);
    if (instance_exists(_origem)) combate_empurrar_inimigo(_alvo, _origem);
    if (_alvo.object_index == Obj_caracol) {
        bunker_alarme_definir(_alvo, 5);
        // Um golpe letal nunca fica preso no estado de finalização.
        if (_alvo.vida <= 0) _alvo.takedown_ativo = false;
    }
}

#endregion



#region Projetil mover

function bunker_projetil_mover(_proj, _destino_x, _destino_y) {
    if (!_proj.em_voo || _proj.impacto_registrado) return false;
    var impacto = bunker_varrer_impacto(_proj.x, _proj.y, _destino_x, _destino_y, _proj.raio_colisao);
    var distancia = point_distance(_proj.x, _proj.y, _destino_x, _destino_y);
    var fracao = impacto.t <= 1 ? max(0, impacto.t - 0.25 / max(0.25, distancia)) : 1;
    _proj.x = lerp(_proj.x, _destino_x, fracao);
    _proj.y = lerp(_proj.y, _destino_y, fracao);
    if (impacto.t > 1) return true;
    _proj.impacto_registrado = true;
    _proj.em_voo = false;
    _proj.velocidade = 0;
    _proj.speed = 0;
    if (!impacto.parede) bunker_aplicar_impacto(impacto.alvo, _proj.dano, _proj);
    instance_destroy(_proj);
    return false;
}

#endregion

#region Projetil passo

function bunker_projetil_passo(_proj, _passo = undefined) {
    if (is_undefined(_passo)) _passo = bunker_passo();
    if (!_proj.em_voo) return;
    // Verifica o caminho dos pés à arma para evitar disparos através de obstáculos.
    if (_proj.inicial_pendente) {
        _proj.inicial_pendente = false;
        if (!bunker_projetil_mover(_proj, _proj.inicial_x, _proj.inicial_y)) return;
    }
    if (!bunker_projetil_mover(_proj,
        _proj.x + lengthdir_x(_proj.velocidade * _passo, _proj.direction),
        _proj.y + lengthdir_y(_proj.velocidade * _passo, _proj.direction))) return;
    _proj.image_angle += _proj.rotacao_velocidade * _passo;
}

#endregion

#region Projetil desenhar

function bunker_projetil_desenhar(_proj) {
    var spr = _proj.sprite_index;
    var centro_x = (sprite_get_bbox_left(spr) + sprite_get_bbox_right(spr) + 1) * 0.5;
    var centro_y = (sprite_get_bbox_top(spr) + sprite_get_bbox_bottom(spr) + 1) * 0.5;
    var dx = (sprite_get_xoffset(spr) - centro_x) * _proj.image_xscale;
    var dy = (sprite_get_yoffset(spr) - centro_y) * _proj.image_yscale;
    var ang = _proj.image_angle;
    draw_sprite_ext(spr, _proj.image_index,
        _proj.x + lengthdir_x(dx, ang) - lengthdir_y(dy, ang),
        _proj.y + lengthdir_y(dx, ang) + lengthdir_x(dy, ang),
        _proj.image_xscale, _proj.image_yscale, ang, c_white, 1);
}

#endregion

#region Contato entre personagens

function bunker_area_contato(_a, _b, _dx, _dy) {
    var _w = max(0, min(_a.bbox_right + 1 + _dx, _b.bbox_right + 1)
        - max(_a.bbox_left + _dx, _b.bbox_left));
    var _h = max(0, min(_a.bbox_bottom + 1 + _dy, _b.bbox_bottom + 1)
        - max(_a.bbox_top + _dy, _b.bbox_top));
    return _w * _h;
}

function bunker_contato_bloqueia(_a, _b, _x, _y) {
    var _antes = bunker_area_contato(_a, _b, 0, 0);
    var _depois = bunker_area_contato(_a, _b, _x - _a.x, _y - _a.y);
    // Se já estiverem sobrepostos, deixa sair sem aprofundar o contato.
    return _depois > _antes + 0.001;
}

function bunker_corpo_bloqueado(_ator, _x, _y) {
    if (_ator.object_index == Obj_jogador) {
        var _tipos = [Obj_homem_lagarto, Obj_caracol_lab, Obj_boss_cobra];
        for (var _i = 0; _i < array_length(_tipos); _i++) {
            for (var _n = 0; _n < instance_number(_tipos[_i]); _n++) {
                var _alvo = instance_find(_tipos[_i], _n);
                if (!bunker_alvo_atingivel(_alvo)) continue;
                if (bunker_contato_bloqueia(_ator, _alvo, _x, _y)) return true;
            }
        }
    } else if (_ator.object_index == Obj_homem_lagarto
        || _ator.object_index == Obj_caracol_lab || _ator.object_index == Obj_boss_cobra) {
        var _j = instance_find(Obj_jogador, 0);
        if (instance_exists(_j) && _j.vida > 0) {
            return bunker_contato_bloqueia(_ator, _j, _x, _y);
        }
    }
    return false;
}

#endregion

// Valida TODO o trecho de saída antes de criar o prego e consumir munição.
function bunker_lancar_prego(_dono, _boca_x, _boca_y, _direcao, _raio) {
    if (!instance_exists(_dono) || _dono.vida <= 0) return noone;
    if (bunker_varrer_paredes(_dono.x, _dono.y, _boca_x, _boca_y, _raio).t <= 1) return noone;
    var _proj = instance_create_depth(_dono.x, _dono.y, _dono.depth - 1, Obj_bala);
    _proj.direction = _direcao;
    _proj.image_angle = _direcao;
    _proj.raio_colisao = _raio;
    // Mantém varredura de alvos muito próximos: não teletransporta por um inimigo
    // que esteja entre o jogador e a boca. Paredes já foram validadas acima.
    _proj.inicial_pendente = true;
    _proj.inicial_x = _boca_x;
    _proj.inicial_y = _boca_y;
    return _proj;
}
