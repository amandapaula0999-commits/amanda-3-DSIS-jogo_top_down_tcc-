#region Fim da animação

// Animation End: salvaguarda se a animação alcançar o fim entre dois Steps.
if (atingido && sprite_index == Spr_barril_caindo) {
    image_speed = 0;
    image_index = max(0, sprite_get_number(Spr_barril_caindo) - 1);
    // Se um menu abriu neste mesmo frame, o Step concluirá após a retomada.
    if (!global.interface.pause_aberto && !global.interface.config_aberta && !global.cena.ativa
    && !global.interface.dialogo_ativo && !global.interface.diario_aberto && !global.cena.vitoria_ativa) {
        bunker_barril_derramar(id);
    }
}

#endregion
