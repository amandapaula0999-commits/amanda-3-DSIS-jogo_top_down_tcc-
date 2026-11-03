#region Inicialização
lagarto_iniciar(id);
cobra_combate_iniciar(id);
lab11_slot = -1;
vida_max = 240; vida = vida_max;
velocidade_caca = 1.55; dano_ataque = 18;
estagio = 0; surgimento = 0;
visible = false;
sprite_index = Spr_cobra_direita;
if (global.progresso.cobra_derrotado) instance_destroy();
#endregion

cam_x = 0; cam_y = 0; cam_w = 960; cam_h = 540;
