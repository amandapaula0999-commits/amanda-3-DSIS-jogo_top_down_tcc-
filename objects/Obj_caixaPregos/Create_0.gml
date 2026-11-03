#region Inicialização

if (coleta_id == "") coleta_id = room_get_name(room) + "@" + string(round(x)) + "," + string(round(y));
if (bunker_tem_id(global.progresso.coletas_municao,coleta_id)) instance_destroy();

#endregion
