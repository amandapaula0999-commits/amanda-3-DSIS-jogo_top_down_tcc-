#region Ativação do checkpoint

// Se o checkpoint salvo no jogador ainda não for este objeto
if (other.checkpoint_x != x || other.checkpoint_y != y) {

    // Salva este ponto para o jogador renascer.
    other.checkpoint_x = x;
    other.checkpoint_y = y;
    checkpoint_gravar(room,x,y);
    bunker_audio_tocar_efeito(Snd_checkpoint, 14, false);

}

#endregion
