function combate_mostrar_dano(_alvo, _dano) {
    var _caixa = bunker_caixa_dano(_alvo);
    var _n = instance_create_depth((_caixa.l + _caixa.r) * 0.5, _caixa.t - 8, -8500, Obj_numero_dano);
    _n.texto = "-" + string(_dano);
}

function combate_empurrar_inimigo(_alvo, _origem) {
    var _tipo = _alvo.object_index;
    if (_tipo != Obj_caracol && _tipo != Obj_caracol_lab && _tipo != Obj_homem_lagarto) return;
    var _dir = point_direction(_origem.x, _origem.y, _alvo.x, _alvo.y);
    var _sx = lengthdir_x(1, _dir);
    var _sy = lengthdir_y(1, _dir);
    // Doze subpassos de 1 px: nunca atravessa paredes finas nem outros corpos.
    for (var _i = 0; _i < 12; _i++) {
        var _nx = _alvo.x + _sx;
        var _ny = _alvo.y + _sy;
        var _bloqueado;
        if (_tipo == Obj_caracol) {
            _bloqueado = collision_rectangle(_alvo.bbox_left + _sx, _alvo.bbox_top + _sy,
                _alvo.bbox_right + _sx, _alvo.bbox_bottom + _sy, Obj_parede, false, true) != noone;
        } else _bloqueado = lagarto_pe_bloqueado(_alvo, _nx, _ny);
        if (_bloqueado || bunker_corpo_bloqueado(_alvo, _nx, _ny)) break;
        _alvo.x = _nx;
        _alvo.y = _ny;
    }
    if (_tipo != Obj_caracol) _alvo.rota_tempo = 0;
}
