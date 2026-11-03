#region Atualização

// Queda -> poça -> barril deitado -> reposição. Usa o último quadro real.
if (global.interface.pause_aberto || global.interface.config_aberta || global.cena.ativa
|| global.interface.dialogo_ativo || global.interface.diario_aberto || global.cena.vitoria_ativa) {
    image_speed = 0;
    exit;
}
var passo = bunker_passo();
if (atingido && !acido_criado && sprite_index == Spr_barril_caindo) {
    var ultimo_quadro = max(0, sprite_get_number(Spr_barril_caindo) - 1);
    image_speed = 0;
    var taxa_queda = sprite_get_speed(Spr_barril_caindo);
    if (sprite_get_speed_type(Spr_barril_caindo) == spritespeed_framespersecond) taxa_queda /= 60;
    image_index = min(ultimo_quadro,image_index + taxa_queda * passo);
    if (image_index >= ultimo_quadro) {
        bunker_barril_derramar(id);
    }
}
if (sumindo) {
    alfa_caindo = max(0, alfa_caindo - 0.018 * passo);
    if (alfa_caindo <= 0) sumindo = false;
}
if (respawn_tempo >= 0) {
    respawn_tempo = max(0, respawn_tempo - passo);
    if (respawn_tempo <= 0) {
        if (instance_exists(acido_id)) instance_destroy(acido_id);
        atingido = false;
        mostrar_chao = false;
        sumindo = false;
        alfa_caindo = 1;
        acido_criado = false;
        acido_id = noone;
        respawn_tempo = -1;
        sprite_index = Spr_barril;
        image_index = 0;
        image_speed = 0;
        image_xscale = escala_barril;
        image_yscale = escala_barril;
    }
}

#endregion
