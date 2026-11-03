interacao_iniciar(id);

#region Inicialização

// Controla os menus sem pausar a partida enquanto estiverem fechados.
pause_animacao_cartao = [0, 0, 0, 0];
pause_input_mouse = false;
pause_mouse_anterior_x = device_mouse_x_to_gui(0);
pause_mouse_anterior_y = device_mouse_y_to_gui(0);
pause_pad_anterior = -1;
pause_pad_eixo_x = 0;
pause_pad_eixo_y = 0;

mundo_pausado = false;
retomar_pendente = false;
acao_pendente = "";

congelar_mundo = function() {
    // Salva os valores atuais antes de o jogador ficar inativo.
    var jogador = instance_find(Obj_jogador, 0);
    if (jogador != noone) {
        global.jogador.vida = jogador.vida;
        global.inventario.caixas_municao = jogador.caixas_mecanicas;
    }
    mundo_pausado = true;
    instance_deactivate_all(true);
    audio_pause_all();
};

limpar_menus = function() {
    global.interface.pause_aberto = false;
    global.interface.diario_aberto = false;
    global.interface.config_aberta = false;
    global.interface.config_origem = "";
};

// O destino de P é lido no End Step, após reativar as instâncias da sala.

#endregion
