#region Inicialização

if (guarda_arquivo && global.progresso.arquivo_livre) { instance_destroy(); exit; }
// Criatura comum: menor que o chefe, percepção gradual e busca localizada.
vida_max = 30;
vida = vida_max;
tomou_dano = false;
morrendo = false;
feedback_tempo = 0;
feedback_texto = "";
morte_frame = 0;
morte_espera = 0;
mask_index = Spr_mascara_inimigo;
image_xscale = bunker_escala_inimigo();
image_yscale = image_xscale;
image_speed = 0;
estado = "PATRULHA";
alerta = 0;
memoria_visual = 0;
busca_tempo = 0;
ultimo_ruido = -1;
alvo_x = x;
alvo_y = y;
posicao_inicial_x = x;
posicao_inicial_y = y;
direcao_atual = 180;
passos_dados = 0;
tempo_parado = 60;
patrulha_alvo_x = x;
patrulha_alvo_y = y;
patrulha_tempo = 0;
patrulha_indice = floor(abs(x * 3 + y * 5)) mod 8;
inimigo_colisao_iniciar(id, true);

// A rota inicial deve acompanhar a posição corrigida, nunca o ponto preso.
alvo_x = x;
alvo_y = y;
posicao_inicial_x = x;
posicao_inicial_y = y;
patrulha_alvo_x = x;
patrulha_alvo_y = y;

velocidade = 1.65;
velocidade_chase = 1.65;
lado_anim = 2;
takedown_ativo = false;

#endregion

caracol_ataque_iniciar(id);
