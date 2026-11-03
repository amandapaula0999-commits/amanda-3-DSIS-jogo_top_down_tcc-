#region Inicialização

// Barril ampliado com respawn para impedir bloqueio da luta na arena
atingido = false;
mostrar_chao = false;
sumindo = false;
alfa_caindo = 1;
acido_criado = false;
acido_id = noone;
respawn_tempo = -1;
respawn_max = 1200; // 20 segundos de simulação após derramar o ácido.
escala_barril = 0.8; // Escala proporcional ao jogador.
image_xscale = escala_barril;
image_yscale = escala_barril;

sprite_index = Spr_barril;
image_index = 0;
image_speed = 0;

#endregion
