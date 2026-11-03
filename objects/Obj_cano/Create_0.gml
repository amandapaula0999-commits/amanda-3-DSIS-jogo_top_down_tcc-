#region Inicialização

if (item_de_sala && global.inventario.cano) { instance_destroy(); exit; }
#region Configuração e status do cano

dono = noone; // Dono do cano.
atacando = false; // Controla a animação/estado do golpe
dano_cano = 4; // Valor de dano aplicado nos inimigos
escala_visual = bunker_escala_protagonista(); // Sprite próprio do item no chão.
escala_ataque = bunker_escala_protagonista(); // Mesmo fator dos novos quadros do protagonista.
ataque_tempo = 0;
ataque_recarga = 0;
ataque_buffer = 0;
alcance_cano = 40;
raio_cano = 12;
arco_cano = 75;
ataque_pixels_anteriores = [];
ataque_direcao = 0;
direcao_mira = 0;
direcao_arma = 0;
ataque_atingiu = false;
ataque_ponta_valida = false;
ataque_ponta_x = x;
ataque_ponta_y = y;
image_speed = 0;
visible = true;
image_xscale = escala_visual;
image_yscale = escala_visual;

#endregion

#endregion
