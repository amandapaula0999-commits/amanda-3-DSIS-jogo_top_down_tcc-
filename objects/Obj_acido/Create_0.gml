#region Inicialização

// Poça de ácido de área ampla
alpha_acido = 0.78;
image_xscale = 1.0;
image_yscale = 1.0;
duracao = 540; // 9 segundos de simulação.
pulso = random(100);
origem_barril = noone;

// Desenha a poça sobre o piso e atrás dos personagens.
depth = 100;
image_speed = 0;

image_alpha = alpha_acido;

#endregion
