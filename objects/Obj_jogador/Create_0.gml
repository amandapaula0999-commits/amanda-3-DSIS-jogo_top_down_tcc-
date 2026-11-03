#region Movimento e aparência

// Configura movimento, vida e inventário do jogador.
max_vel = 2.65;
// Escala visual separada da máscara dos pés, preservando corredores e portas.
escala_personagem = bunker_escala_protagonista();
furtivo = false;
ruido_passos = 0;
velh = 0;
velv = 0;
lado = 0;
mask_index = Spr_mascara_jogador;
idle_tempo = 0;
idle_bob = 0;
idle_breath = 0;
direcao_olhar = 90;

#endregion

#region Finalização furtiva

takedown_ativo = false;
takedown_alvo = noone;
takedown_alvo_pronto = noone;
takedown_pronto = false;
takedown_tempo = 0;
takedown_duracao = 44;
takedown_direcao = 90;

#endregion

#region Vida e munição

kit_mensagem = "";
kit_mensagem_tempo = 0;
kit_perto = noone;
vida_max = 100;
vida = clamp(global.jogador.vida, 1, vida_max);
invulneravel = false;

caixas_mecanicas = ceil(global.inventario.pregos_reserva / bunker_pregos_por_caixa());
global.inventario.caixas_municao = caixas_mecanicas;

#endregion

#region Entrada na sala

if (!window_get_fullscreen()) window_set_fullscreen(true);
// Obj_mapa e os pontos de chegada estão na própria Room.

// Recebe a posição da porta ou do evento da sala anterior.
if (global.transicao.sala_destino == room) {
    if (global.transicao.ponto != "") {
        var chegada=mapa_ponto(global.transicao.ponto);
        x=chegada.x;y=chegada.y;
    } else { x=global.transicao.x;y=global.transicao.y; }
    global.transicao.ponto="";
    global.transicao.sala_destino = -1;
}

// Procura um ponto livre próximo se o jogador nascer dentro de uma parede.
if (place_meeting(x, y, Obj_parede)) {
    var spawn_liberado = false;
    for (var tentativa_spawn = 0; tentativa_spawn < 80 && !spawn_liberado; tentativa_spawn++) {
        var raio_spawn = 8 + floor(tentativa_spawn / 8) * 8;
        var angulo_spawn = (tentativa_spawn mod 8) * 45;
        var candidato_x = clamp(x + lengthdir_x(raio_spawn, angulo_spawn), 40, room_width - 40);
        var candidato_y = clamp(y + lengthdir_y(raio_spawn, angulo_spawn), 40, room_height - 40);
        if (!place_meeting(candidato_x, candidato_y, Obj_parede)) {
            x = candidato_x;
            y = candidato_y;
            spawn_liberado = true;
        }
    }
}

#endregion

#region Checkpoint

checkpoint_x = x;
checkpoint_y = y;
var mapa=instance_find(Obj_mapa,0);
if(mapa!=noone && mapa.ponto_checkpoint!="") {
    var ponto=mapa_ponto(mapa.ponto_checkpoint);
    checkpoint_gravar(room,ponto.x,ponto.y);
    checkpoint_x=ponto.x;checkpoint_y=ponto.y;
}
// Grava o checkpoint após corrigir a posição de chegada.
if(global.checkpoint.gravar_na_entrada) {
    checkpoint_gravar(room,x,y);
    checkpoint_x=x;checkpoint_y=y;
    global.checkpoint.gravar_na_entrada=false;
}
if(global.checkpoint.respawn_pendente) {
    invulneravel=true;bunker_alarme_definir(id, 120);global.checkpoint.respawn_pendente=false;
}
if (room==Room_Desmoronada && global.transicao.queda_pendente) {
    checkpoint_gravar(room,x,y);
    global.transicao.queda_pendente=false;
}

#endregion

#region Restaurar equipamento

// Restaura na mão os itens que já estão no inventário.
if (global.inventario.cano) {
    var cano_salvo = instance_create_layer(x, y, "Instances", Obj_cano);
    cano_salvo.dono = id;
}
if (global.inventario.arma_pregos) {
    var arma_salva = instance_create_layer(x, y, "Instances", Obj_armaPregos);
    arma_salva.dono = id;
    arma_salva.municao_atual = global.inventario.pregos_carregados;
}

#endregion

#region Posição segura e interface

// Posição livre confirmada para resgate, nunca o outro lado de uma parede.
posicao_segura_x = x;
posicao_segura_y = y;
posicao_segura_valida = !place_meeting(x,y,Obj_parede);

// Cria a interface em profundidade válida e mantém seu controle durante a pausa.
if (!instance_exists(Obj_pause)) instance_create_depth(0, 0, -10000, Obj_pause);

#endregion
