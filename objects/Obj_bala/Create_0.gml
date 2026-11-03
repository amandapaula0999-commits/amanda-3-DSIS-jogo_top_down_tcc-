#region Inicialização

// Movimento contínuo em End Step; sem deslocamento automático.
speed = 0;
velocidade = 12;
dano = 5;
em_voo = true;
impacto_registrado = false;
inicial_pendente = false;
inicial_x = x;
inicial_y = y;
rotacao_velocidade = 0;
image_xscale = 0.30;
image_yscale = 0.30;
raio_colisao = 2; // Mesma espessura usada na validação da saída.
bunker_alarme_definir(id, 60);

#endregion
