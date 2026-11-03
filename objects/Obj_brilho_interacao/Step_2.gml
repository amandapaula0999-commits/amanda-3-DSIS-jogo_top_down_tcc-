// End Step: a coleta retira o brilho antes do próximo desenho.
if (!instance_exists(alvo)) { instance_destroy(); exit; }
visible = alvo.visible;
if (bunker_jogo_bloqueado()) exit;
fase_brilho += bunker_dt() * 3;
image_alpha = 0.78 + 0.18 * sin(fase_brilho);
