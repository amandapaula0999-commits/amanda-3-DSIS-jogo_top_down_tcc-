#region Inicialização

// Porta do bloco central. Usa o mesmo colisor do restante do jogo.
image_speed = 0;
aberta = global.progresso.camara_fria_aberta;
bloqueio = instance_find(Obj_bloqueio_camara,0);
raio_interacao = 34;
mensagem_tempo = 0;
var cenario = instance_find(Obj_sala_manutencao_cenario,0);
if (cenario != noone) cenario.image_index = aberta ? 1 : 0;

// Estado local de esforço e fala; abertura e crachá persistem nas globais.
esforco = 0;
fala_etapa = 0;
fala_espera = 0;
fala_texto = "";
input_liberado = false;

#endregion
