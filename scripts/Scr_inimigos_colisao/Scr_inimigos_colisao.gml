// Limites estáveis do corpo: a máscara pequena dos pés não pode deixar a
// cabeça ou a carapaça atravessarem paredes e grades. Não muda a caixa de dano.
function inimigo_colisao_iniciar(_e, _caracol) {
    var _sprites = _caracol
        ? [Spr_inimigo_parado_baixo, Spr_inimigo_parado_cima,
           Spr_inimigo_parado_direita, Spr_inimigo_parado_esquerda,
           Spr_inimigo_andando_baixo, Spr_inimigo_andando_cima,
           Spr_inimigo_andando_direita, Spr_inimigo_andando_esquerda,
           Spr_caracol_ataque_baixo, Spr_caracol_ataque_cima,
           Spr_caracol_ataque_direita, Spr_caracol_ataque_esquerda]
        : [Spr_lagarto_parado_baixo, Spr_lagarto_parado_cima,
           Spr_lagarto_parado_direita, Spr_lagarto_parado_esquerda,
           Spr_lagarto_andando_baixo, Spr_lagarto_andando_cima,
           Spr_lagarto_andando_direita, Spr_lagarto_andando_esquerda];
    _e.pe_l = 11; _e.pe_r = 11; _e.pe_t = 6; _e.pe_b = 8;
    for (var _i = 0; _i < array_length(_sprites); _i++) {
        var _s = _sprites[_i];
        _e.pe_l = max(_e.pe_l, (sprite_get_xoffset(_s) - sprite_get_bbox_left(_s)) * abs(_e.image_xscale));
        _e.pe_r = max(_e.pe_r, (sprite_get_bbox_right(_s) + 1 - sprite_get_xoffset(_s)) * abs(_e.image_xscale));
        _e.pe_t = max(_e.pe_t, (sprite_get_yoffset(_s) - sprite_get_bbox_top(_s)) * abs(_e.image_yscale));
        _e.pe_b = max(_e.pe_b, (sprite_get_bbox_bottom(_s) + 1 - sprite_get_yoffset(_s)) * abs(_e.image_yscale));
    }
    _e.colisao_corpo_parede = true;
    _e.conferir_nascimento = true;
}

function inimigo_parede_bloqueado(_e, _x, _y) {
    if (!variable_instance_exists(_e, "colisao_corpo_parede")) return false;
    return collision_rectangle(_x - _e.pe_l, _y - _e.pe_t,
        _x + _e.pe_r, _y + _e.pe_b, Obj_parede, false, true) != noone;
}

// Somente no nascimento, depois que as paredes da Room já existem.
// Nunca é usado como resgate durante perseguições ou empurrões.
function inimigo_conferir_nascimento(_e) {
    if (!_e.conferir_nascimento) return;
    _e.conferir_nascimento = false;
    if (!inimigo_parede_bloqueado(_e, _e.x, _e.y)) return;
    for (var _r = 2; _r <= 128; _r += 2) {
        for (var _a = 0; _a < 360; _a += 45) {
            var _x = _e.x + lengthdir_x(_r, _a);
            var _y = _e.y + lengthdir_y(_r, _a);
            if (!inimigo_parede_bloqueado(_e, _x, _y)) {
                _e.x = _x; _e.y = _y;
                return;
            }
        }
    }
}
