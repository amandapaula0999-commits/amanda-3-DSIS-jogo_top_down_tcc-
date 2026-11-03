if (global.interface.pause_aberto || global.interface.diario_aberto || global.interface.config_aberta) exit;
var j = instance_find(Obj_jogador, 0);
if (j == noone) exit;
if (room == Room_Saida_Final) {
    if (retorno_falando) bunker_aviso_gui("Não quero voltar para aquele lugar horrível.", "E / ESPAÇO: CONTINUAR");
    else if (!bunker_jogo_bloqueado() && mapa_distancia(j, "entrada") <= 40)
        bunker_aviso_gui("", "[E] VOLTAR PELO BURACO");
    exit;
}
if (room != Room_Laboratorio_N2 || !global.progresso.cobra_derrotado) exit;
if (falando) bunker_aviso_gui("Tem alguma coisa do outro lado... Parece uma possível saída. Vou passar por esse buraco.", "E / ESPAÇO: ATRAVESSAR");
else if (!bunker_jogo_bloqueado() && point_distance(j.x,j.y,x+35,y+35) <= 45)
    bunker_aviso_gui("", "[E] EXAMINAR O BURACO");
