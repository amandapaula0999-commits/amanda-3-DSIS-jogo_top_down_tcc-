#region Tempo da simulação

// Controla movimento, combate e coleta. Obj_pause cuida dos menus.
var passo_simulacao = bunker_passo();
if (!bunker_jogo_bloqueado() && bunker_alarme_passo(id, passo_simulacao)) event_perform(ev_alarm,0);

#endregion

#region Finalização furtiva

// Alinha o jogador e o alvo; bloqueia os outros comandos durante o golpe.
if (takedown_ativo) {
    takedown_tempo += passo_simulacao;
    if (instance_exists(takedown_alvo)) {
        var alvo_takedown = takedown_alvo;
        var aproximacao = clamp(takedown_tempo / 10, 0, 1);
        // Mantém o jogador atrás do alvo durante a finalização.
        var destino_takedown_x = alvo_takedown.x + lengthdir_x(24, takedown_direcao);
        var destino_takedown_y = alvo_takedown.y + lengthdir_y(24, takedown_direcao);
        var passo_takedown_x = clamp((destino_takedown_x - x) * aproximacao, -3 * passo_simulacao, 3 * passo_simulacao);
        var passo_takedown_y = clamp((destino_takedown_y - y) * aproximacao, -3 * passo_simulacao, 3 * passo_simulacao);
        bunker_deslocar_seguro(id, passo_takedown_x, passo_takedown_y);
        direcao_olhar = takedown_direcao;
        var lado_takedown = floor((takedown_direcao + 45) / 90) mod 4;
        if (lado_takedown == 0) sprite_index = Spr_jogador_andando_direita;
        if (lado_takedown == 1) sprite_index = Spr_jogador_andando_cima;
        if (lado_takedown == 2) sprite_index = Spr_jogador_andando_esquerda;
        if (lado_takedown == 3) sprite_index = Spr_jogador_andando_baixo;
        image_speed = 0;
        image_index = min(image_number - 1, floor(takedown_tempo / 7));
        global.camera.zoom = 1 + 0.34 * clamp(takedown_tempo / 12, 0, 1);
        global.camera.foco_x = (x + alvo_takedown.x) * 0.5;
        global.camera.foco_y = (y + alvo_takedown.y) * 0.5;
    }
    if (takedown_tempo >= takedown_duracao) {
        if (instance_exists(takedown_alvo)) {
            takedown_alvo.vida = 0;
            takedown_alvo.morrendo = true;
            takedown_alvo.estado = "DERROTADO";
            takedown_alvo.takedown_ativo = false;
            takedown_alvo.feedback_tempo = 34;
            takedown_alvo.feedback_texto = "FINALIZAÇÃO FURTIVA";
        }
        takedown_ativo = false;
        takedown_alvo = noone;
        takedown_tempo = 0;
        global.camera.zoom = 1;
    } else if (!instance_exists(takedown_alvo)) {
        takedown_ativo = false;
        takedown_alvo = noone;
        takedown_tempo = 0;
        global.camera.zoom = 1;
    }
    exit;
}

#endregion

#region Comandos e velocidade

var bloqueado = bunker_jogo_bloqueado();
furtivo = !bloqueado && keyboard_check(vk_shift);
var velocidade_atual = (furtivo ? 1.15 : max_vel) * passo_simulacao;
var vetor_x = 0;
var vetor_y = 0;

// Corrige a posição apenas se os pés estiverem dentro de uma parede.
if (!bloqueado && place_meeting(x, y, Obj_parede)) {
    // Volta ao último ponto livre, sem atravessar paredes.
    if (posicao_segura_valida && !place_meeting(posicao_segura_x,posicao_segura_y,Obj_parede)) {
        x = posicao_segura_x;
        y = posicao_segura_y;
    }

}

if (!bloqueado) {
    vetor_x = keyboard_check(ord("D")) - keyboard_check(ord("A"));
    vetor_y = keyboard_check(ord("S")) - keyboard_check(ord("W"));
}

var qud_hip = vetor_x * vetor_x + vetor_y * vetor_y;
if (qud_hip > 0) {
    var hip = sqrt(qud_hip);
    velh = (vetor_x / hip) * velocidade_atual;
    velv = (vetor_y / hip) * velocidade_atual;
} else {
    velh = 0;
    velv = 0;
}

#endregion

#region Movimento e colisão

// Move cada eixo em passos de até 1 px para não atravessar paredes.
var restante_x = velh;
repeat (ceil(abs(restante_x))) {
    var passo_x = clamp(restante_x, -1, 1);
    if (abs(passo_x) < 0.001) break;
    if (!place_meeting(x + passo_x, y, Obj_parede) && !bunker_corpo_bloqueado(id, x + passo_x, y)) {
        x += passo_x;
        restante_x -= passo_x;
    } else {
        velh = 0;
        break;
    }
}

var restante_y = velv;
repeat (ceil(abs(restante_y))) {
    var passo_y = clamp(restante_y, -1, 1);
    if (abs(passo_y) < 0.001) break;
    if (!place_meeting(x, y + passo_y, Obj_parede) && !bunker_corpo_bloqueado(id, x, y + passo_y)) {
        y += passo_y;
        restante_y -= passo_y;
    } else {
        velv = 0;
        break;
    }
}
// As passagens laterais precisam alcançar a borda do cenário.
var margem_lateral = (room == Room_Recepcao || room == Room_Corredor_Recepcao) ? 12 : 40;
x = clamp(x, margem_lateral, room_width - margem_lateral);
y = clamp(y, 40, room_height - 40);
ruido_passos = (abs(velh) + abs(velv) > 0) ? (furtivo ? 18 : 82) : 0;

#endregion

#region Animação e direção

image_speed = 0;

if (abs(velh) + abs(velv) <= 0.01) {
    // Avança a caminhada pelo tempo da simulação.
    idle_tempo += (furtivo ? 0.07 : 0.105) * passo_simulacao;
    // Mantém os pés no chão durante a respiração.
    idle_bob = 0; // Origem permanece nos pés durante a respiração.
    idle_breath = sin(idle_tempo * 0.72) * 0.008;
    image_speed = 0;
    image_index = 0;
} else {
    idle_tempo = 0;
    idle_bob = 0;
    idle_breath = 0;
}

if (velh > 0) lado = 2;
if (velh < 0) lado = 3;
if (velv > 0) lado = 0;
if (velv < 0) lado = 1;
if (abs(velh) + abs(velv) > 0.01) direcao_olhar = point_direction(0, 0, velh, velv);

if (velh != 0 || velv != 0) {
    if (lado == 0) sprite_index = Spr_jogador_andando_baixo;
    if (lado == 1) sprite_index = Spr_jogador_andando_cima;
    if (lado == 2) sprite_index = Spr_jogador_andando_direita;
    if (lado == 3) sprite_index = Spr_jogador_andando_esquerda;
} else {
    if (lado == 0) sprite_index = Spr_jogador_idle_baixo;
    if (lado == 1) sprite_index = Spr_jogador_idle_cima;
    if (lado == 2) sprite_index = Spr_jogador_idle_direita;
    if (lado == 3) sprite_index = Spr_jogador_idle_esquerda;
}

bunker_animacao_passo(id, (abs(velh)+abs(velv)>0.01) ? (furtivo ? 0.48 : 1) : 0, passo_simulacao);
if (!place_meeting(x,y,Obj_parede)) {
    posicao_segura_x=x; posicao_segura_y=y; posicao_segura_valida=true;
}

#endregion

#region Equipamento e morte

// Troca rápida: 1 = cano, 2 = pistola de pregos.
if (!bloqueado && keyboard_check_pressed(ord("1")) && global.inventario.cano) global.inventario.equipamento_ativo = "cano";
if (!bloqueado && keyboard_check_pressed(ord("2")) && global.inventario.arma_pregos) global.inventario.equipamento_ativo = "pistola";

if (vida <= 0) {
    bunker_coletas_repor_apos_morte();
    checkpoint_reiniciar();
    exit;
}
image_alpha = invulneravel ? 0.25 : 1.0;

#endregion

#region Coleta e interação

itens_vida_atualizar(id);

if (!bloqueado) {
    var arma_perto = instance_nearest(x, y, Obj_armaPregos);
    if (arma_perto != noone && arma_perto.dono == noone) {
        if (point_distance(x, y, arma_perto.x, arma_perto.y) <= 90 && bunker_interagir()) {
            arma_perto.dono = id;
            global.inventario.arma_pregos = true;
            global.inventario.equipamento_ativo = "pistola";
            global.inventario.pregos_carregados = arma_perto.municao_atual;
            bunker_audio_tocar_efeito(Snd_item, 10, false);
        }
    }

    var caixa_perto = instance_nearest(x, y, Obj_caixaPregos);
    if (caixa_perto != noone && point_distance(x, y, caixa_perto.x, caixa_perto.y) <= 60) {
        if (bunker_interagir()) {
            // Coleta única por identificador, inclusive após voltar ou reiniciar a sala.
            if (!bunker_coletar_municao(caixa_perto.coleta_id, caixa_perto.quantidade)) {
                instance_destroy(caixa_perto);
                exit;
            }

            // Se a arma estiver vazia, recarrega e libera o disparo ao coletar.
            if (global.inventario.arma_pregos && global.inventario.pregos_carregados <= 0) {
                var recarga_coleta = min(bunker_capacidade_pregos(), global.inventario.pregos_reserva);
                global.inventario.pregos_carregados += recarga_coleta;
                global.inventario.pregos_reserva -= recarga_coleta;

                with (Obj_armaPregos) {
                    if (dono == other.id) {
                        municao_atual = global.inventario.pregos_carregados;
                        recarregando = false;
                        pode_atirar = (municao_atual > 0);
                        bunker_alarme_definir(id, -1);
                    }
                }
            }

            caixas_mecanicas = ceil(global.inventario.pregos_reserva / bunker_pregos_por_caixa());
            global.inventario.caixas_municao = caixas_mecanicas;
            bunker_audio_tocar_efeito(Snd_item, 10, false);
            instance_destroy(caixa_perto);
        }
    }

    var cano_perto = instance_nearest(x, y, Obj_cano);
    if (cano_perto != noone && cano_perto.dono == noone) {
        if (point_distance(x, y, cano_perto.x, cano_perto.y) <= 90 && bunker_interagir()) {
            cano_perto.dono = id;
            global.inventario.cano = true;
            global.inventario.equipamento_ativo = "cano";
            bunker_audio_tocar_efeito(Snd_item, 10, false);
        }
    }
}

#endregion

#region Salvar vida e munição

global.jogador.vida = vida;
caixas_mecanicas = ceil(global.inventario.pregos_reserva / bunker_pregos_por_caixa());
global.inventario.caixas_municao = caixas_mecanicas;

#endregion
