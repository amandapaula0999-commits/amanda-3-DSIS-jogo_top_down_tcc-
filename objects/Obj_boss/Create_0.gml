#region Movimentação e origem

velocidade_boss = 2; // Velocidade de perseguição.
velocidade_retorno = 3; // Velocidade de retorno.
alcance_aggro = 1600; // cobre toda a arena de contenção

// Aumenta o Boss para manter a proporção com a arena.
image_xscale = 3.0;
image_yscale = 3.0;
mask_index = Spr_mascara_boss; // Pés separados das antenas e ombros.
ataque_ativo = false;
ataque_tempo = 0;
ataque_quadro = 0;
ataque_intervalo = 150;
impacto_aplicado = false;
impacto_raio = 135;
impacto_x = x;
impacto_y = y;
onda_tempo = 0;
vulneravel_tempo = 0;
acido_recarga = 0;
acido_ultimo = noone;
contato_espera = 90;
fuga_etapa = 0;
fuga_preparo = 0;
// Preparada depois da introdução, quando as pedras já existem.
grade = -1;
caminho = path_add();
rota_tempo = 0;
rota_indice = 1;
pe_l = 30; pe_r = 29; pe_t = 0; pe_b = 47;
// Faixa de apoio dos pés sobre o chão, separada da colisão de movimento.
acido_pe_meia_largura = 18;
acido_pe_topo = 33;
acido_pe_base = 45;

x_inicial = x; // Posição inicial em X.
y_inicial = y; // Posição inicial em Y.

speed = 0; // Desativa o movimento automático.
dir_olhando = 270; // 270 graus aponta para baixo.

#endregion

#region Estados e visibilidade

visible = (room == Room1); // Na arena do chefe ele já começa visível

derrotado = false; // Indica se o ácido derrubou o Boss.
esperando_levantar = false; // Controla a recuperação após cair.

vida_max = 180;
vida = vida_max;
morto = false;
tomou_dano = false;
feedback_tempo = 0;
feedback_texto = "";
em_acido = false;
fugindo = false;
fuga_tempo = 0;
saida_impacto = false;
if (global.progresso.boss_derrotado) {
    vida = 0;
    morto = true;
    saida_impacto = true;
}

// Ao voltar para a arena depois da vitória, o chefe não renasce inteiro.
if (global.progresso.boss_derrotado) vida = 0;

#endregion

encontro_ativo=false;visible=false;
if(global.progresso.boss_derrotado) instance_destroy();
