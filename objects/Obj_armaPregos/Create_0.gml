#region Inicialização

if (item_de_sala && global.inventario.arma_pregos) { instance_destroy(); exit; }
#region Posse e configuração da arma

dono = noone; // Começa no chão (sem dono)
escala_visual = bunker_escala_protagonista();
comprimento_cano = 13 * escala_visual;
image_speed = 0; // Os quatro quadros são direções, não um loop automático.
image_index = 0;
sprite_index = Spr_arma_pregos_chao;
direcao_arma = 0;
direcao_mira = 0;

#endregion

#region Sistema de munição e recarga

municao_maxima = bunker_capacidade_pregos();
municao_atual = 4;
if (global.inventario.arma_pregos) {
    municao_atual = clamp(global.inventario.pregos_carregados, 0, municao_maxima);
    global.inventario.pregos_carregados = municao_atual;
}

recarregando = false; // Indica se está no tempo de recarga
pode_atirar = (municao_atual > 0);
visible = true;
image_xscale = escala_visual;
image_yscale = escala_visual;

#endregion

#endregion
