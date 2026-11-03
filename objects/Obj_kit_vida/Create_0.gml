image_speed = 0;
image_index = 0;
if (coleta_id == "") coleta_id = room_get_name(room) + "@" + string(round(x)) + "," + string(round(y));
if (bunker_tem_id(global.progresso.coletas_kits, coleta_id)) instance_destroy();
