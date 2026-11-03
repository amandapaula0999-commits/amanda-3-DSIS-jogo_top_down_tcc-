#region Coletar chave (obj_chave)

// Verifica se o jogador existe no jogo
if (instance_exists(Obj_jogador)) {

    // Calcula a distância entre a chave e o jogador
    var _distancia = point_distance(x, y, Obj_jogador.x, Obj_jogador.y);

    // Se estiver perto o suficiente E o jogador pressionar a tecla "E"
    if (_distancia <= 42 && bunker_interagir()) {

        // Registra a chave no inventário.
        global.inventario.chave_coletada = true;
        bunker_audio_tocar_efeito(Snd_item, 10, false);

        // Destrói a chave do mapa
        instance_destroy();
    }
}

#endregion
