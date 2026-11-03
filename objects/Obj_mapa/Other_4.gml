#region Entrada na sala

// Room Start: todas as instâncias do editor já existem.
mapa_reunir_indicios(id);
if(room==Room_Ferramentas_N2) sala10_entrar(id);
if(room==Room_Laboratorio_N2) lab11_entrar(id);
if(room==Room1) {
    global.inventario.chave_coletada=true;
    global.cena.saida_aberta=global.progresso.boss_derrotado;
    if(global.inventario.chave_escadaria && !global.progresso.boss_derrotado) boss_iniciar();
}

#endregion

#region Entrada na sala de espera
if (room == Room_Armadilha) {
    var visitante = instance_find(Obj_jogador, 0);
    if (visitante != noone) {
        var entrada = mapa_ponto("entrada_recepcao_1");
        visitante.x = entrada.x;
        visitante.y = entrada.y;
        visitante.visible = true;
        visitante.image_alpha = 1;
        visitante.depth = -100;
        visitante.velh = 0;
        visitante.velv = 0;
    }
    espera_segundos = 0;
    armadilha_tempo = -1;
    global.cena.ativa = false;
}
#endregion

duto_dica_iniciar(id);
