#region Escala inimigo

function bunker_escala_inimigo() { return 0.45; }

#endregion

#region Escala protagonista

function bunker_escala_protagonista() {
    var _altura_inimigo = sprite_get_bbox_bottom(Spr_inimigo_parado_baixo) + 1
        - sprite_get_bbox_top(Spr_inimigo_parado_baixo);
    var _altura_jogador = sprite_get_bbox_bottom(Spr_jogador_parado_baixo) + 1
        - sprite_get_bbox_top(Spr_jogador_parado_baixo);
    return (_altura_inimigo * 0.55 * 16 / 20) / max(1, _altura_jogador);
}

#endregion

#region Pose bracos

function bunker_pose_bracos(_arma, _direcao, _cano) {
    var _s = bunker_escala_protagonista();
    var _dir = floor((_direcao + 45) / 90) % 4;
    var _ang = 0;
    var _sx = _s;
    var _apoio_x = 0;
    var _apoio_y = 0;
    if (_cano) {
        var _sprites = [Spr_cano_direita, Spr_cano_cima, Spr_cano_esquerda, Spr_cano_baixo];
        var _quadro_cano = clamp(floor(_arma.image_index), 0, 2);
        _arma.sprite_index = _sprites[_dir];
        _arma.image_index = _quadro_cano;
        // Ombros dos quatro GIFs: nenhum giro ou escala negativa.
        var _ombros = [[12, 10], [16, 7], [20, 10], [16, 7]];
        _apoio_x = (_ombros[_dir][0] - 16) * _s;
        _apoio_y = (_ombros[_dir][1] - 16) * _s;
    } else {
        _arma.sprite_index = Spr_arma_pregos;
        var _quadros = [1, 2, 3, 0];
        _arma.image_index = _quadros[_dir];
        // Corrige a direção do quadro 2 pelo ombro do jogador.
        _ang = angle_difference(_direcao, _dir * 90) + (_dir == 1 ? 180 : 0);
        var _apoios = [[11, 11], [16, 6], [21, 11], [16, 6]];
        _apoio_x = (_apoios[_dir][0] - 16) * _s;
        _apoio_y = (_apoios[_dir][1] - 16) * _s;
    }
    _arma.direcao_mira = _direcao;
    _arma.direcao_arma = _dir;
    _arma.image_angle = _ang;
    _arma.image_xscale = _sx;
    _arma.image_yscale = _s;
    _arma.x = _arma.dono.x - lengthdir_x(_apoio_x, _ang) + lengthdir_y(_apoio_y, _ang);
    _arma.y = _arma.dono.y - 18 * _s - lengthdir_y(_apoio_x, _ang) - lengthdir_x(_apoio_y, _ang);
}

#endregion
