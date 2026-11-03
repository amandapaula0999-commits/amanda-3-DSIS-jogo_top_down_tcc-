#region Final da atualização

// End Step: troca de sala somente depois dos Steps, com o mundo congelado.
if (acao_pendente == "") exit;
var acao = acao_pendente;
acao_pendente = "";
retomar_pendente = false;
limpar_menus();
mundo_pausado = false;
instance_activate_all();
audio_resume_all();

if (acao == "avancar") {
    // Vida e munição já foram sincronizadas antes de congelar o jogador.
    debug_avancar_sala();
} else {
    global.cena.ativa = false;
    global.interface.dialogo_ativo = false;
    global.transicao.sala_destino = -1;
    if (acao == "reiniciar") checkpoint_reiniciar();
    else if (acao == "menu") room_goto(Room_Menu);
}

#endregion
