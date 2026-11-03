#region Emitir ruido

function bunker_emitir_ruido(_x, _y, _raio, _duracao) {
    global.ruido.serial++;
    global.ruido.x = _x;
    global.ruido.y = _y;
    global.ruido.raio = _raio;
    global.ruido.tempo = _duracao;
}

#endregion

#region Visivel

function bunker_visivel(_x, _y, _direcao, _px, _py, _furtivo) {
    var dist = point_distance(_x, _y, _px, _py);
    var alcance = _furtivo ? 145 : 270;
    if (dist > alcance) return false;
    if (collision_line(_x, _y, _px, _py, Obj_parede, false, true) != noone) return false;
    if (dist <= 30) return true;
    return abs(angle_difference(_direcao, point_direction(_x, _y, _px, _py))) <= 58;
}

#endregion
