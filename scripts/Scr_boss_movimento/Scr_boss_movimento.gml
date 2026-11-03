#region Boss mover

function boss_mover(_e, _tx, _ty, _vel, _passo) {
    if (_e.grade == -1) {
        _e.grade = mp_grid_create(0,0,ceil(room_width/8),ceil(room_height/8),8,8);
        for (var _i=0; _i<instance_number(Obj_parede); _i++) {
            var _w = instance_find(Obj_parede,_i);
            if(variable_instance_exists(_w,"colisao_ativa") && !_w.colisao_ativa) continue;
            mp_grid_add_rectangle(_e.grade,_w.x-_e.pe_r,_w.y-_e.pe_b,
                _w.x+_w.largura+_e.pe_l,_w.y+_w.altura+_e.pe_t);
        }
    }
    // Busca uma célula livre antes de calcular a rota, sem teletransportar.
    if (mp_grid_get_cell(_e.grade,floor(_e.x/8),floor(_e.y/8)) < 0) {
        for (var _raio=8; _raio<=160; _raio+=8) {
            for (var _ang=0; _ang<360; _ang+=45) {
                var _sx=_e.x+lengthdir_x(_raio,_ang);
                var _sy=_e.y+lengthdir_y(_raio,_ang);
                if (mp_grid_get_cell(_e.grade,floor(_sx/8),floor(_sy/8)) >= 0
                && boss_trecho_livre(_e,_sx,_sy)) {
                    boss_deslocar(_e,_sx,_sy,_vel);
                    _e.rota_tempo=0;
                    return;
                }
            }
        }
    }
    _e.rota_tempo -= _passo;
    if (_e.rota_tempo <= 0) {
        _e.rota_tempo = 24;
        _e.rota_indice = 1;
        path_clear_points(_e.caminho);
        var _gx = clamp(_tx,66,room_width-66);
        var _gy = clamp(_ty,54,room_height-90);
        // Jogador encostado na parede: a máscara maior busca uma célula próxima.
        if (mp_grid_get_cell(_e.grade,floor(_gx/8),floor(_gy/8)) < 0) {
            var _achou = false;
            for (var _r=12; _r<=96 && !_achou; _r+=12) {
                for (var _a=0; _a<360 && !_achou; _a+=45) {
                    var _cx=clamp(_gx+lengthdir_x(_r,_a),66,room_width-66);
                    var _cy=clamp(_gy+lengthdir_y(_r,_a),54,room_height-90);
                    if (mp_grid_get_cell(_e.grade,floor(_cx/8),floor(_cy/8)) >= 0) {
                        _gx=_cx; _gy=_cy; _achou=true;
                    }
                }
            }
        }
        mp_grid_path(_e.grade,_e.caminho,_e.x,_e.y,_gx,_gy,false);
    }
    var _n=path_get_number(_e.caminho);
    while (_e.rota_indice < _n
    && point_distance(_e.x,_e.y,path_get_point_x(_e.caminho,_e.rota_indice),path_get_point_y(_e.caminho,_e.rota_indice)) <= 3) {
        _e.rota_indice++;
    }
    if (_e.rota_indice < _n) {
        _tx=path_get_point_x(_e.caminho,_e.rota_indice);
        _ty=path_get_point_y(_e.caminho,_e.rota_indice);
    }
    boss_deslocar(_e,_tx,_ty,_vel);
}

#endregion

#region Boss deslocar

function boss_deslocar(_e, _tx, _ty, _vel) {
    var _d=point_distance(_e.x,_e.y,_tx,_ty);
    if (_d <= 0.01) return;
    var _dir=point_direction(_e.x,_e.y,_tx,_ty);
    var _dist=min(_d,_vel);
    var _partes=max(1,ceil(_dist/3));
    var _vx=lengthdir_x(_dist/_partes,_dir);
    var _vy=lengthdir_y(_dist/_partes,_dir);
    for (var _i=0; _i<_partes; _i++) {
        if (!lagarto_pe_bloqueado(_e,_e.x+_vx,_e.y) && !bunker_corpo_bloqueado(_e,_e.x+_vx,_e.y)) _e.x+=_vx;
        if (!lagarto_pe_bloqueado(_e,_e.x,_e.y+_vy) && !bunker_corpo_bloqueado(_e,_e.x,_e.y+_vy)) _e.y+=_vy;
    }
}

#endregion

#region Boss animar

function boss_animar(_e, _dx, _dy, _passo) {
    var _movendo=abs(_dx)+abs(_dy)>0.01;
    if (_movendo) _e.dir_olhando=point_direction(0,0,_dx,_dy);
    var _dir=floor((_e.dir_olhando+45)/90) mod 4;
    var _spr=Spr_andando_baixo;
    switch (_dir) {
        case 0: _spr=Spr_andando_direita; break;
        case 1: _spr=Spr_andando_cima; break;
        case 2: _spr=Spr_andando_esquerda; break;
    }
    if (_e.sprite_index != _spr) { _e.sprite_index=_spr; _e.image_index=0; }
    bunker_animacao_passo(_e, _movendo ? 0.85 : 0, _passo);
    if (!_movendo) _e.image_index=0;
}

#endregion

#region Boss trecho livre

function boss_trecho_livre(_e,_tx,_ty) {
    for (var _i=0; _i<instance_number(Obj_parede); _i++) {
        var _w=instance_find(Obj_parede,_i);
        if(variable_instance_exists(_w,"colisao_ativa") && !_w.colisao_ativa) continue;
        if (bunker_segmento_caixa(_e.x,_e.y,_tx,_ty,
            _w.x-_e.pe_r,_w.y-_e.pe_b,
            _w.x+_w.largura+_e.pe_l-0.01,_w.y+_w.altura+_e.pe_t-0.01) <= 1) return false;
    }
    return true;
}

#endregion
