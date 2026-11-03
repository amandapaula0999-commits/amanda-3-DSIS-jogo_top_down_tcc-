#region Fim do temporizador

municao_atual = clamp(municao_atual, 0, municao_maxima);
var faltando = max(0, municao_maxima - municao_atual);
var transferir = min(faltando, global.inventario.pregos_reserva);
municao_atual += transferir;
global.inventario.pregos_reserva -= transferir;
global.inventario.caixas_municao = ceil(global.inventario.pregos_reserva / bunker_pregos_por_caixa());
if (dono != noone && instance_exists(dono)) dono.caixas_mecanicas = global.inventario.caixas_municao;
recarregando = false;
pode_atirar = (municao_atual > 0);
global.inventario.pregos_carregados = municao_atual;

#endregion
