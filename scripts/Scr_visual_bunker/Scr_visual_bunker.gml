#region Painel

// Painéis da interface, iluminação e animação do boss.
function bunker_painel(_x, _y, _w, _h) {
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(8, 13, 12));
    draw_rectangle(_x, _y, _x + _w, _y + _h, false);
    draw_set_color(make_color_rgb(79, 87, 72));
    draw_rectangle(_x, _y, _x + _w, _y + _h, true);
    draw_set_color(make_color_rgb(30, 40, 35));
    draw_rectangle(_x + 3, _y + 3, _x + _w - 3, _y + _h - 3, true);
    draw_set_color(make_color_rgb(178, 148, 86));
    draw_rectangle(_x + 9, _y + 8, _x + 12, _y + 11, false);
    draw_rectangle(_x + _w - 12, _y + 8, _x + _w - 9, _y + 11, false);
    draw_set_color(c_white);
}

#endregion

#region Sombra alpha

function bunker_sombra_alpha(_x, _y, _px, _py, _base) {
    return clamp(_base - 0.14 * max(0, 1 - point_distance(_x, _y, _px, _py) / 190), max(0, _base - 0.14), _base);
}

#endregion

#region Boss ataque

function bunker_boss_ataque(_x, _y, _s, _tempo, _cor) {
    // Anima o corpo e o braço usando recortes do sprite.
    var subida = clamp((_tempo - 12) / 28, 0, 1);
    var descida = clamp((_tempo - 54) / 12, 0, 1);
    var angulo = 155 * subida * (1 - descida);
    var agachar = (_tempo >= 66) ? 1 - clamp((_tempo - 82) / 24, 0, 1) : 0;
    var sy = _s * (1 - 0.13 * agachar);
    var oy = _y + 16 * (_s - sy);
    draw_sprite_part_ext(Spr_parado_baixo, 0, 0, 0, 32, 17, _x - 16 * _s, oy - 20 * sy, _s, sy, _cor, 1);
    draw_sprite_part_ext(Spr_parado_baixo, 0, 0, 17, 21, 23, _x - 16 * _s, oy - 3 * sy, _s, sy, _cor, 1);
    var ombro_x = _x + 6 * _s;
    var ombro_y = oy - 2 * sy;
    var dx = -1 * _s;
    var dy = -1 * sy;
    var rx = ombro_x + dx * dcos(angulo) + dy * dsin(angulo);
    var ry = ombro_y - dx * dsin(angulo) + dy * dcos(angulo);
    draw_sprite_general(Spr_parado_baixo, 0, 21, 17, 11, 23, rx, ry, _s, sy * (1 + 0.22 * agachar), angulo, _cor, _cor, _cor, _cor, 1);
}

#endregion
