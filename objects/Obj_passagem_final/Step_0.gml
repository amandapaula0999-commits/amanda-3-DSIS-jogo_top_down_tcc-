if (room == Room_Laboratorio_N2 && !global.progresso.cobra_derrotado) exit;
#region Saída final
if (global.interface.pause_aberto || global.interface.diario_aberto || global.interface.config_aberta) exit;
var j = instance_find(Obj_jogador,0);
if (j == noone) exit;
if (retorno_falando) {
    if (bunker_dialogo_avancar()) {
        retorno_falando = false;
        global.interface.dialogo_ativo = false;
    }
    exit;
}
if (falando) {
    if (bunker_dialogo_avancar()) {
        falando = false;
        global.interface.dialogo_ativo = false;
        global.jogador.vida = j.vida;
        global.inventario.caixas_municao = j.caixas_mecanicas;
        mapa_agendar_entrada(Room_Saida_Final,"entrada");
        room_goto(Room_Saida_Final);
    }
    exit;
}
if (global.cena.vitoria_ativa) exit;
if (subindo) {
    j.x = max(50,j.x - bunker_passo() * 0.85);
    j.y = lerp(278,348,clamp((j.x-50)/160,0,1));
    if (j.x <= 50) bunker_vitoria_iniciar(j.x,j.y);
    exit;
}
if (bunker_jogo_bloqueado()) exit;
if (room == Room_Saida_Final && mapa_distancia(j, "entrada") <= 40 && bunker_interagir()) {
    retorno_falando = true;
    global.interface.dialogo_ativo = true;
    j.velh = 0; j.velv = 0;
    exit;
}
if (room == Room_Laboratorio_N2) {
    if (point_distance(j.x,j.y,x+35,y+35) <= 45 && bunker_interagir()) {
        falando = true;
        global.interface.dialogo_ativo = true;
    }
} else if (room == Room_Saida_Final && j.x <= 210 && j.x >= 194 && j.y >= 332 && j.y <= 360) {
    subindo = true;
    global.cena.ativa = true;
    j.x = 210;
    j.y = 348;
    j.velh = 0; j.velv = 0;
    j.lado = 2;
    j.sprite_index = Spr_jogador_andando_esquerda;
}
#endregion
